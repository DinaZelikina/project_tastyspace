from flask import Blueprint, request, jsonify, send_from_directory, current_app
from flask_jwt_extended import jwt_required, get_jwt
from psycopg2.extras import RealDictCursor
from db import get_db
from werkzeug.utils import secure_filename
import os
import uuid

recipes_bp = Blueprint('recipes', __name__)

@recipes_bp.route('/images/<filename>')
def uploaded_file(filename):
    return send_from_directory(current_app.config['UPLOAD_FOLDER'], filename) 

# Save to database new recipe with ingredients and instruction
@recipes_bp.route('/addRecipe', methods=['POST'])
@jwt_required()
def add_recipe():
    token_data = get_jwt()
    user_id = token_data["sub"]
    title = request.form.get('title', '')
    description = request.form.get('description', '')
    
    image_file = request.files.get('image')
    image_url = 'default_img.jpg'  

    if image_file:
        ext = image_file.filename.rsplit('.', 1)[1].lower() if '.' in image_file.filename else ''
        unique_filename = secure_filename(f"{uuid.uuid4()}.{ext}")
        file_path = os.path.join(current_app.config['UPLOAD_FOLDER'], unique_filename)
        image_file.save(file_path)
        image_url = unique_filename  
    
    db = get_db()
    cursor = db.cursor()

    try:
        cursor.execute('''
            INSERT INTO dishes (title, description, author_id, image_url) 
            VALUES (%s, %s, %s, %s) RETURNING id;
        ''', (title, description, user_id, image_url))
        dish_id = cursor.fetchone()[0]

        num_ingredients = len([key for key in request.form.keys() if key.startswith('ingredients[') and key.endswith('][name]')])
        for i in range(num_ingredients):
            name = request.form.get(f'ingredients[{i}][name]')
            amount = request.form.get(f'ingredients[{i}][amount]')
            measurement = request.form.get(f'ingredients[{i}][measurement]', '')
            if measurement == '-':
                measurement = ''
            index = request.form.get(f'ingredients[{i}][index]', type=int) + 1
            cursor.execute('''
                INSERT INTO ingredients (index, name, amount, measurement, dish_id) 
                VALUES (%s, %s, %s, %s, %s);
            ''', (index, name, amount, measurement, dish_id))

        steps_count = len([key for key in request.form.keys() if key.startswith('instructions[') and key.endswith('][description]')])
        for i in range(steps_count):
            description = request.form.get(f'instructions[{i}][description]')
            index = i + 1
            cursor.execute('''
                INSERT INTO steps (dish_id, index, description) 
                VALUES (%s, %s, %s);
            ''', (dish_id, index, description))

        db.commit()
        return jsonify({'message': 'Recipe added successfully', 'dish_id': dish_id}), 201
    except Exception as e:
        db.rollback()
        return jsonify({'error': str(e)}), 400

# Check in database if recipe title already exists
@recipes_bp.route("/check_recipe_title", methods=["POST"])
def check_recipe_title():
    data = request.get_json()
    db = get_db()
    cursor = db.cursor(cursor_factory=RealDictCursor)
    
    cursor.execute("SELECT id FROM dishes WHERE title = %s", (data["title"],))
    recipe = cursor.fetchone()
    if recipe is None:
        return jsonify({"exists": False})
    return jsonify({"exists": True})

# Select from database new recipes for moderation
@recipes_bp.route('/newRecipes', methods=['GET'])
@jwt_required()
def get_new_recipes():
    db = get_db()
    cursor = db.cursor(cursor_factory=RealDictCursor)
    try:
        cursor.execute('''
            SELECT d.id, d.title, d.image_url, 
                    to_char(d.created, 'DD.MM.YYYY') as created, 
                    to_char(d.edited, 'DD.MM.YYYY') as edited, 
                    u.username AS author
            FROM dishes d
            JOIN users u ON d.author_id = u.id
            WHERE d.is_moderated = FALSE
        ''')
        recipes = cursor.fetchall()
        return jsonify(recipes)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# Select from database new recipe with ingredients and instruction
@recipes_bp.route('/recipes/<int:dish_id>', methods=['GET'])
@jwt_required()
def get_recipe(dish_id):
    db = get_db()
    cursor = db.cursor(cursor_factory=RealDictCursor)

    try:
        cursor.execute('''
            SELECT * FROM dishes WHERE id = %s;
        ''', (dish_id,))
        dish = cursor.fetchone()
        
        if dish is None:
            return jsonify({"error": "Recipe not found"}), 404

        cursor.execute('''
            SELECT * FROM ingredients WHERE dish_id = %s ORDER BY index;
        ''', (dish_id,))
        ingredients = cursor.fetchall()

        cursor.execute('''
            SELECT * FROM steps WHERE dish_id = %s ORDER BY index;
        ''', (dish_id,))
        steps = cursor.fetchall()

        full_recipe_info = {
            **dish,
            "ingredients": ingredients,
            "steps": steps
        }
        print("Response data:", full_recipe_info) 

        return jsonify(full_recipe_info)
    except Exception as e:
        db.rollback()
        return jsonify({"error": str(e)}), 500

# Update in database recipe with ingredients and instruction
@recipes_bp.route('/recipes/<int:dish_id>', methods=['PUT'])
@jwt_required()
def update_recipe(dish_id):
    data = request.get_json()
    db = get_db()
    cursor = db.cursor()
    try:
        cursor.execute('''
            UPDATE dishes SET title=%s, description=%s, edited=CURRENT_TIMESTAMP WHERE id=%s;
        ''', (data['title'], data['description'], dish_id))

        for ingredient in data['ingredients']:
            cursor.execute('''
                UPDATE ingredients SET name=%s, amount=%s, measurement=%s, category=%s, is_main=%s WHERE id=%s AND dish_id=%s;
            ''', (ingredient['name'], ingredient['amount'], ingredient['measurement'], ingredient['category'], ingredient.get('isMain', False), ingredient['id'], dish_id))

        for step in data['steps']:
            cursor.execute('''
                UPDATE steps SET description=%s WHERE id=%s AND dish_id=%s;
            ''', (step['description'], step['id'], dish_id))

        db.commit()
        return jsonify({"message": "Recipe updated successfully"}), 200
    except Exception as e:
        db.rollback()
        return jsonify({"error": str(e)}), 500

# Save to database moderator actions with recipe
@recipes_bp.route('/recipes/publish/<int:dish_id>', methods=['PUT'])
@jwt_required()
def publish_recipe(dish_id):
    data = request.get_json()
    db = get_db()
    cursor = db.cursor()

    token_data = get_jwt()
    moderator_id = token_data['sub']
    try:
        cursor.execute('''
            UPDATE dishes SET type=%s, side_dish=%s, cuisine=%s, cooking_time=%s, category=%s, dinner_time=%s, season=%s, is_moderated=TRUE
            WHERE id=%s;
        ''', (data['dishType'], data['needSideDish'], data['cuisine'], data['cookingTime'], data['dinnerCategories'], data['dinnerTimes'], data['seasons'], dish_id))

        cursor.execute('''
            INSERT INTO moderation (dish_id, moderator_id)
            VALUES (%s, %s);
        ''', (dish_id, moderator_id))

        db.commit()
        return jsonify({"message": "Recipe published successfully"}), 200
    except Exception as e:
        db.rollback()
        return jsonify({"error": str(e)}), 500

# Delete recipe from database    
@recipes_bp.route('/recipes/<int:dish_id>', methods=['DELETE'])
@jwt_required()
def delete_recipe(dish_id):
    db = get_db()
    cursor = db.cursor()
    try:
        cursor.execute('''
            DELETE FROM steps WHERE dish_id = %s;
        ''', (dish_id,))

        cursor.execute('''
            DELETE FROM ingredients WHERE dish_id = %s;
        ''', (dish_id,))

        cursor.execute('''
            DELETE FROM moderation WHERE dish_id = %s;
        ''', (dish_id,))

        cursor.execute('''
            DELETE FROM dishes WHERE id = %s;
        ''', (dish_id,))

        db.commit()
        return jsonify({'message': 'Recipe and all related data have been deleted'}), 200
    except Exception as e:
        db.rollback()
        return jsonify({'error': str(e)}), 500
