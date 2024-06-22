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
