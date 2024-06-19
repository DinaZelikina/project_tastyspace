from flask import Blueprint, request, jsonify
from flask_jwt_extended import create_access_token, jwt_required, get_jwt_identity, get_jwt
from psycopg2.extras import RealDictCursor
from db import get_db

auth_bp = Blueprint('auth', __name__)

# Login and create token for current user
@auth_bp.route("/login", methods=["POST"])
def login() -> dict:
    data = request.get_json()
    db = get_db()
    cursor = db.cursor(cursor_factory=RealDictCursor)
    cursor.execute(
        "SELECT id FROM users WHERE username = %s AND password = %s",
        (data["username"], data["password"]),
    )
    user = cursor.fetchone()
    if user is None:
        return {"error": "Invalid username or password"}
    else:
        access_token = create_access_token(identity=user["id"])
        try:
            cursor.execute(
                "UPDATE users SET last = CURRENT_TIMESTAMP WHERE id = %s",
                (user["id"],)
            )
            db.commit()
        except Exception as e:
            db.rollback()
            return {"error": str(e)}
        return {"access_token": access_token}

# Check username for login or registration user
@auth_bp.route("/check_username", methods=["POST"])
def check_username():
    data = request.get_json()
    db = get_db()
    cursor = db.cursor(cursor_factory=RealDictCursor)
    
    cursor.execute("SELECT id FROM users WHERE username = %s", (data["username"],))
    user = cursor.fetchone()
    if user is None:
        return jsonify({"valid": False})
    return jsonify({"valid": True})

# Save new user data to database
@auth_bp.route("/register", methods=["POST"])
def register():
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')
    email = data.get('email')
    role = data.get('role')  

    db = get_db()
    cursor = db.cursor(cursor_factory=RealDictCursor)
    
    try:
        cursor.execute(
            "INSERT INTO users (username, password, email, role) VALUES (%s, %s, %s, %s) RETURNING id",
            (username, password, email, role)
        )
        user = cursor.fetchone()
        db.commit()
        access_token = create_access_token(identity=user["id"])
        return jsonify(access_token=access_token, message="User registered successfully"), 201
    except Exception as e:
        db.rollback()
        return jsonify({"error": str(e)}), 400

# Get from database current user data and save changes
@auth_bp.route("/users/me", methods=["GET", "PUT"])
@jwt_required()
def get_me() -> dict:
    token_data = get_jwt()
    user_id = token_data["sub"]
    db = get_db()
    cursor = db.cursor(cursor_factory=RealDictCursor)
    
    if request.method == "GET":
        cursor.execute("SELECT id, username, role, email, created, password FROM users WHERE id = %s", (user_id,))
        user = cursor.fetchone()
        
        if user is None:
            return {"error": "User not found"}
        
        cursor.execute("SELECT COUNT(*) FROM menus WHERE user_id = %s AND removed IS NULL", (user_id,))
        saved_menus_count = cursor.fetchone()['count']
        
        if user['role'] == 'author':
            cursor.execute("SELECT COUNT(*) FROM dishes WHERE author_id = %s", (user_id,))
            recipes_count = cursor.fetchone()['count']
        
        elif user['role'] == 'moderator':
            cursor.execute("SELECT COUNT(*) FROM moderation WHERE moderator_id = %s", (user_id,))
            recipes_count = cursor.fetchone()['count']
        
        else:
            recipes_count = 0
        
        return {
            "id": user["id"],
            "username": user["username"],
            "role": user["role"],
            "email": user["email"],
            "created": user["created"],
            "password": user["password"],
            "saved_menus_count": saved_menus_count,
            "recipes_count": recipes_count
        }
    
    if request.method == "PUT":
        data = request.get_json()
        update_fields = []
        update_values = []
        
        if "username" in data:
            update_fields.append("username = %s")
            update_values.append(data["username"])
        
        if "password" in data:
            update_fields.append("password = %s")
            update_values.append(data["password"])
        
        if "email" in data:
            update_fields.append("email = %s")
            update_values.append(data["email"])
        
        if not update_fields:
            return jsonify({"error": "No valid fields provided for update"}), 400
        
        update_values.append(user_id)
        
        try:
            cursor.execute(f'''
                UPDATE users
                SET {', '.join(update_fields)}, edited = CURRENT_TIMESTAMP
                WHERE id = %s
            ''', tuple(update_values))
            db.commit()
            return jsonify({"message": "User information updated successfully"}), 200
        except Exception as e:
            db.rollback()
            return jsonify({"error": str(e)}), 500
