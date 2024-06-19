from flask import Blueprint, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from psycopg2.extras import RealDictCursor
from db import get_db

admin_bp = Blueprint('admin', __name__)

# Select data for recipes history
@admin_bp.route('/recipesHistory', methods=['GET'])
@jwt_required()
def get_recipes_history():
    user_id = get_jwt_identity()
    db = get_db()
    cursor = db.cursor(cursor_factory=RealDictCursor)

    try: 
        cursor.execute('''
            SELECT d.id, d.title, u.username AS author, d.created AS created_date,
                   m.moderator_id, m.published AS published_date
            FROM dishes d
            JOIN users u ON d.author_id = u.id
            LEFT JOIN moderation m ON d.id = m.dish_id
            ORDER BY d.id ASC
        ''')
        recipes = cursor.fetchall()

        for recipe in recipes:
            if recipe['moderator_id']:
                cursor.execute('SELECT username FROM users WHERE id = %s', (recipe['moderator_id'],))
                moderator = cursor.fetchone()
                recipe['moderator'] = moderator['username'] if moderator else '-'
            else:
                recipe['moderator'] = '-'

            recipe['published_date'] = recipe['published_date'].strftime("%d.%m.%Y") if recipe['published_date'] else '-'
            recipe['created_date'] = recipe['created_date'].strftime("%d.%m.%Y") if recipe['created_date'] else '-'

        return jsonify(recipes)
    except Exception as e:
        print("Error in get_recipes_history:", e) 
        return jsonify({'error': str(e)}), 500

# Select data for users history
@admin_bp.route('/usersHistory', methods=['GET'])
@jwt_required()
def get_users_history():
    db = get_db()
    cursor = db.cursor(cursor_factory=RealDictCursor)

    try:
        cursor.execute('''
            SELECT id, username, role, created, edited, last
            FROM users
            ORDER BY id ASC
        ''')
        users = cursor.fetchall()

        for user in users:
            user['created'] = user['created'].strftime("%d.%m.%Y") if user['created'] else '-'
            user['edited'] = user['edited'].strftime("%d.%m.%Y") if user['edited'] else '-'
            user['last'] = user['last'].strftime("%d.%m.%Y") if user['last'] else '-'

            cursor.execute("SELECT COUNT(*) FROM menus WHERE user_id = %s AND removed IS NULL", (user['id'],))
            saved_menus_count = cursor.fetchone()['count']
            user['saved_menus_count'] = saved_menus_count

            if user['role'] == 'author':
                cursor.execute("SELECT COUNT(*) FROM dishes WHERE author_id = %s", (user['id'],))
                recipes_count = cursor.fetchone()['count']
                user['recipes_count'] = recipes_count
            else:
                user['recipes_count'] = '-'

            if user['role'] == 'moderator':
                cursor.execute("SELECT COUNT(*) FROM moderation WHERE moderator_id = %s", (user['id'],))
                moderated_recipes_count = cursor.fetchone()['count']
                user['moderated_recipes_count'] = moderated_recipes_count
            else:
                user['moderated_recipes_count'] = '-'

        return jsonify(users)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# Select data for menus history
@admin_bp.route('/menusHistory', methods=['GET'])
@jwt_required()
def get_menus_history():
    user_id = get_jwt_identity()
    db = get_db()
    cursor = db.cursor(cursor_factory=RealDictCursor)
    try:
        cursor.execute('''
            SELECT m.id, m.title, u.username, m.dinner_category, m.cooking_time, m.saved AS saved_date, m.removed AS removed_date, m.dishes
            FROM menus m
            JOIN users u ON m.user_id = u.id
            ORDER BY m.id ASC
        ''')
        menus = cursor.fetchall()

        for menu in menus:
            menu['saved_date'] = menu['saved_date'].strftime("%d.%m.%Y") if menu['saved_date'] else '-'
            menu['removed_date'] = menu['removed_date'].strftime("%d.%m.%Y") if menu['removed_date'] else '-'
            
            cursor.execute('''
                SELECT id, title FROM dishes WHERE id = ANY(string_to_array(%s, ',')::int[])
            ''', (menu['dishes'],))
            recipes = cursor.fetchall()
            menu['recipes'] = recipes

        return jsonify(menus)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# Select current administrator email for contacts
@admin_bp.route('/admin_email', methods=['GET'])
def get_admin_email():
    db = get_db()
    cursor = db.cursor(cursor_factory=RealDictCursor)
    try:
        cursor.execute("SELECT email FROM users WHERE role = 'admin' LIMIT 1")
        admin = cursor.fetchone()
        if admin is None:
            return jsonify({"error": "Admin email not found"}), 404
        return jsonify({"email": admin['email']}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
