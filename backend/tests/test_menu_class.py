import pytest
from datetime import datetime
from unittest.mock import patch, MagicMock
from main import app
from models.matching_dishes import Menu
from psycopg2.extras import RealDictRow
from db import get_db

# Test for get_current_season method
def test_get_current_season():
    menu = Menu(dinner_category='family', dinner_time='today', cooking_time=2)
    with patch('models.matching_dishes.datetime') as mock_datetime:
        mock_datetime.now.return_value = datetime(2023, 4, 15)
        assert menu.get_current_season() == 'spring'
        mock_datetime.now.return_value = datetime(2023, 7, 15)
        assert menu.get_current_season() == 'summer'
        mock_datetime.now.return_value = datetime(2023, 10, 15)
        assert menu.get_current_season() == 'autumn'
        mock_datetime.now.return_value = datetime(2023, 12, 15)
        assert menu.get_current_season() == 'winter'

# Test for get_main_ingredient_categories method
def test_get_main_ingredient_categories():
    menu = Menu(dinner_category='family', dinner_time='today', cooking_time=2)
    with app.app_context():
        mock_cursor = MagicMock()
        mock_cursor.fetchall.return_value = [{'category': 'meat'}, {'category': 'vegetable'}]

        mock_db = MagicMock()
        mock_db.cursor.return_value = mock_cursor

        with patch('models.matching_dishes.get_db', return_value=mock_db):
            db = mock_db  
            categories = menu.get_main_ingredient_categories(dish_id=1, db=db)
            print("Expected categories: ['meat', 'vegetable']")
            print(f"Actual categories: {categories}")
            assert categories == ['meat', 'vegetable']

# Test for add_dish method
def test_add_dish():
    menu = Menu(dinner_category='weeknight', dinner_time='today', cooking_time=1)
    with app.app_context():
        mock_cursor = MagicMock()
        mock_cursor.fetchall.side_effect = [
            [],  
            [RealDictRow({'id': 1, 'type': 'main dish', 'cuisine': 'european', 'side_dish': False})],  
            [{'category': 'meat'}, {'category': 'vegetable'}] 
        ]

        mock_db = MagicMock()
        mock_db.cursor.return_value = mock_cursor

        with patch('db.get_db', return_value=mock_db):
            db = get_db()
            current_cuisines = {'european', 'central asian', 'east asian', 'mediterranean', 'slavic', 'italian', 'tex-mex'}
            menu_list = []
            main_ingredient_categories = []

            menu.add_dish(('main dish',), db, current_cuisines, menu_list, main_ingredient_categories)
            print(f"Menu after adding a dish: {menu_list}")

            expected_dishes = [
                RealDictRow({'id': 1, 'type': 'main dish', 'cuisine': 'european', 'side_dish': False})
            ]

            assert len(menu_list) > 0, "Menu list should contain at least one dish"
            assert menu_list[0]['type'] == 'main dish', f"Expected 'main dish', but got {menu_list[0]['type']}"
            assert 'european' in menu_list[0]['cuisine'], f"Expected 'european', but got {menu_list[0]['cuisine']}"
