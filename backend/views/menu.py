from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from psycopg2.extras import RealDictCursor
from db import get_db
from models.matching_dishes import Menu
from models.aggregate_ingredients import IngredientAggregator

menu_bp = Blueprint('menu', __name__) 

# Find matching dishes to users criteria
@menu_bp.route('/createMenu', methods=['POST'])
def create_menu():
    data = request.get_json()
    db = get_db()
    dinner_category = data.get('dinnerCategory')
    dinner_time = data.get('dinnerTime')
    cooking_time = data.get('cookingTime')

    try:
        menu = Menu(dinner_category, dinner_time, cooking_time)
        dishes = menu.find_matching_dishes(db)
        if not dishes:
            return jsonify({'error': 'No dishes found matching the criteria'}), 404
        return jsonify(dishes), 200
    except Exception as e:
        repr(e)
        return jsonify({'error': str(e)}), 500

# Count all ingredients for all dishes in menu
@menu_bp.route('/aggregateIngredients', methods=['POST'])
def get_aggregated_ingredients():
    data = request.get_json()
    dish_ids = data.get('recipes', [])
    
    if not dish_ids:
        return jsonify({'error': 'No dish IDs provided'}), 400

    db = get_db()
    try:
        aggregator = IngredientAggregator()
        ingredients = aggregator.aggregate_ingredients(db, dish_ids)
        return jsonify(ingredients), 200
    except Exception as e:
        repr(e)
        return jsonify({'error': str(e)}), 500

# Select from database recipe details
@menu_bp.route('/recipeDetails', methods=['POST'])
def get_recipe_details():
    data = request.get_json()
    dish_id = data.get('recipeId')

    if not dish_id:
        return jsonify({'error': 'No recipe ID provided'}), 400

    db = get_db()
    try:
        cursor = db.cursor(cursor_factory=RealDictCursor)
        cursor.execute("SELECT title, description, image_url FROM dishes WHERE id = %s", (dish_id,))
        dish = cursor.fetchone()

        if dish is None:
            return jsonify({"error": "Recipe not found"}), 404

        cursor.execute("SELECT index, description FROM steps WHERE dish_id = %s ORDER BY index", (dish_id,))
        steps = cursor.fetchall()

        cursor.execute("SELECT name, amount, measurement FROM ingredients WHERE dish_id = %s ORDER BY index", (dish_id,))
        ingredients = cursor.fetchall()

        recipe = {
            'id': dish_id,
            'title': dish['title'],
            'description': dish['description'],
            'steps': steps,
            'ingredients': ingredients,
            'image_url': f'/images/{dish["image_url"]}'
        }

        return jsonify(recipe), 200
    except Exception as e:
        repr(e)
        return jsonify({'error': str(e)}), 500

# Save created menu to database
@menu_bp.route('/saveMenu', methods=['POST'])
@jwt_required()
def save_menu():
    data = request.get_json()
    user_id = get_jwt_identity()
    title = data.get('title')
    dishes = data.get('dishes')
    dinner_category = data.get('dinnerCategory')
    dinner_time = data.get('dinnerTime')
    cooking_time = data.get('cookingTime')

    if not all([title, dishes, dinner_category, dinner_time, cooking_time]):
        return jsonify({'error': 'Missing data'}), 400

    db = get_db()
    cursor = db.cursor()
    try:
        cursor.execute('''
            INSERT INTO menus (user_id, title, dishes, dinner_category, dinner_time, cooking_time)
            VALUES (%s, %s, %s, %s, %s, %s)
            RETURNING id;
        ''', (user_id, title, dishes, dinner_category, dinner_time, cooking_time))
        menu_id = cursor.fetchone()[0]
        db.commit()
        return jsonify({'message': 'Menu saved successfully', 'menu_id': menu_id}), 201
    except Exception as e:
        db.rollback()
        return jsonify({'error': str(e)}), 500

# Select users saved menu from database 
@menu_bp.route('/savedMenus', methods=['GET'])
@jwt_required()
def get_saved_menus():
    user_id = get_jwt_identity()
    db = get_db()
    cursor = db.cursor(cursor_factory=RealDictCursor)
    try:
        cursor.execute('''
            SELECT id, title, dinner_category, dinner_time, cooking_time, saved, dishes 
            FROM menus 
            WHERE user_id = %s AND removed IS NULL
        ''', (user_id,))
        menus = cursor.fetchall()
        
        for menu in menus:
            cursor.execute('''
                SELECT id, title, image_url, description, type
                FROM dishes
                WHERE id = ANY(string_to_array(%s, ',')::int[])
            ''', (menu['dishes'],))
            dishes = cursor.fetchall()
            
            type_order = {
                'appetizer': 1,
                'salad': 2,
                'starter': 3,
                'hot starter': 4,
                'soup': 5,
                'main dish': 6,
                'side dish': 7,
                'desert': 8
            }
            sorted_dishes = sorted(dishes, key=lambda d: type_order.get(d['type'], float('inf')))
            
            menu['recipes'] = sorted_dishes
        
        return jsonify(menus)
    except Exception as e:
        repr(e)
        return jsonify({'error': str(e)}), 500

# Remove menu from saved menus
@menu_bp.route('/removeMenu', methods=['POST'])
@jwt_required()
def remove_menu():
    user_id = get_jwt_identity()
    data = request.get_json()
    menu_id = data.get('menuId')
    
    if not menu_id:
        return jsonify({'error': 'Menu ID is required'}), 400

    db = get_db()
    cursor = db.cursor()
    try:
        cursor.execute('''
            UPDATE menus
            SET removed = CURRENT_TIMESTAMP
            WHERE id = %s AND user_id = %s
        ''', (menu_id, user_id))
        db.commit()
        return jsonify({'message': 'Menu removed successfully'}), 200
    except Exception as e:
        db.rollback()
        return jsonify({'error': str(e)}), 500
