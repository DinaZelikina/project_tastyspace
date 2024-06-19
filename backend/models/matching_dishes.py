from datetime import datetime
from psycopg2.extras import RealDictCursor
from db import get_db

class Menu:
    def __init__(self, dinner_category, dinner_time, cooking_time):
        self.dinner_category = dinner_category
        self.dinner_time = dinner_time
        self.cooking_time = cooking_time

    def get_current_season(self):
        month = datetime.now().month
        if month in (3, 4, 5):
            return 'spring'
        elif month in (6, 7, 8):
            return 'summer'
        elif month in (9, 10, 11):
            return 'autumn'
        else:
            return 'winter'

    def get_main_ingredient_categories(self, dish_id, db):
        cursor = db.cursor(cursor_factory=RealDictCursor)
        query = """
            SELECT category FROM ingredients
            WHERE dish_id = %s AND is_main = true
        """
        cursor.execute(query, (dish_id,))
        ingredients = cursor.fetchall()
        return [ingredient['category'] for ingredient in ingredients]

    def select_dish(self, types, db, current_cuisines, menu, main_ingredient_categories, allow_repeats=False):
        cursor = db.cursor(cursor_factory=RealDictCursor)
        current_season = self.get_current_season()
        if self.dinner_time == 'later':
            self.dinner_time = 'tomorrow'
        query = """
            SELECT * FROM dishes
            WHERE type IN %s 
            AND category LIKE %s 
            AND dinner_time LIKE %s 
            AND cooking_time <= %s 
            AND (season LIKE %s OR season = 'all seasons')
            AND (
                cuisine = 'universal'  
                OR EXISTS (            
                    SELECT 1 
                    FROM unnest(string_to_array(cuisine, ', ')) AS c
                    WHERE c = ANY(%s)
                )
            )
            ORDER BY RANDOM() LIMIT 1
        """
        selected_dish_ids = {dish['id'] for dish in menu}
        cursor.execute(query, (types, '%' + self.dinner_category + '%', '%' + self.dinner_time + '%', self.cooking_time, '%' + current_season + '%', list(current_cuisines)))
        dishes = cursor.fetchall()

        for dish in dishes:
            if dish['id'] in selected_dish_ids:
                continue

            dish_main_categories = self.get_main_ingredient_categories(dish['id'], db)

            if allow_repeats:
                main_ingredient_categories.extend(dish_main_categories)
                return dish

            category_counts = {category: main_ingredient_categories.count(category) for category in dish_main_categories}

            is_allowed = True
            for count in category_counts.values():
                if count != 0:
                    is_allowed = False
                    break

            if is_allowed:
                main_ingredient_categories.extend(dish_main_categories)
                return dish

        if not allow_repeats:
            return self.select_dish(types, db, current_cuisines, menu, main_ingredient_categories, allow_repeats=True)

        return None

    def update_current_cuisines(self, dish, current_cuisines):
        if dish['cuisine'] != 'universal':
            dish_cuisines = set(dish['cuisine'].split(', '))
            current_cuisines.intersection_update(dish_cuisines)

    def add_dish(self, types, db, current_cuisines, menu, main_ingredient_categories):
        dish = self.select_dish(types, db, current_cuisines, menu, main_ingredient_categories, allow_repeats=False)
        if dish is None:
            dish = self.select_dish(types, db, current_cuisines, menu, main_ingredient_categories, allow_repeats=True)
        if dish is not None:
            menu.append(dish)
            self.update_current_cuisines(dish, current_cuisines)

    def sort_menu_by_type(self, menu):
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
        return sorted(menu, key=lambda dish: type_order.get(dish['type'], float('inf')))

    def find_matching_dishes(self, db):
        menu = []
        current_cuisines = {'european', 'central asian', 'east asian', 'mediterranean', 'slavic', 'italian', 'tex-mex'}
        main_ingredient_categories = []

        try:
            if self.dinner_category == 'weeknight':
                self.add_dish(('main dish',), db, current_cuisines, menu, main_ingredient_categories)
                if menu and menu[-1]['side_dish']:
                    self.add_dish(('side dish',), db, current_cuisines, menu, main_ingredient_categories)

                if self.cooking_time == 1:
                    self.add_dish(('salad', 'soup'), db, current_cuisines, menu, main_ingredient_categories)

                if self.cooking_time == 2:
                    self.add_dish(('salad',), db, current_cuisines, menu, main_ingredient_categories)
                    self.add_dish(('soup',), db, current_cuisines, menu, main_ingredient_categories)

            elif self.dinner_category == 'family':
                self.add_dish(('main dish',), db, current_cuisines, menu, main_ingredient_categories)
                if menu and menu[-1]['side_dish']:
                    self.add_dish(('side dish',), db, current_cuisines, menu, main_ingredient_categories)

                self.add_dish(('salad',), db, current_cuisines, menu, main_ingredient_categories)
                self.add_dish(('soup',), db, current_cuisines, menu, main_ingredient_categories)

                if self.cooking_time == 3:
                    self.add_dish(('starter', 'desert'), db, current_cuisines, menu, main_ingredient_categories)

                if self.cooking_time == 4:
                    self.add_dish(('starter',), db, current_cuisines, menu, main_ingredient_categories)
                    self.add_dish(('desert',), db, current_cuisines, menu, main_ingredient_categories)

            elif self.dinner_category == 'guest':
                self.add_dish(('soup', 'main dish'), db, current_cuisines, menu, main_ingredient_categories)
                if menu and menu[-1]['side_dish']:
                    self.add_dish(('side dish',), db, current_cuisines, menu, main_ingredient_categories)

                self.add_dish(('salad',), db, current_cuisines, menu, main_ingredient_categories)
                self.add_dish(('salad',), db, current_cuisines, menu, main_ingredient_categories)
                self.add_dish(('starter',), db, current_cuisines, menu, main_ingredient_categories)

                if self.cooking_time >= 3:
                    self.add_dish(('desert',), db, current_cuisines, menu, main_ingredient_categories)

                    if self.dinner_time != 'today':
                        self.add_dish(('salad', 'starter'), db, current_cuisines, menu, main_ingredient_categories)

                        if self.dinner_time == 'later':
                            self.add_dish(('hot starter', 'starter'), db, current_cuisines, menu, main_ingredient_categories)

            elif self.dinner_category == 'festive':
                self.add_dish(('main dish',), db, current_cuisines, menu, main_ingredient_categories)
                if menu and menu[-1]['side_dish']:
                    self.add_dish(('side dish',), db, current_cuisines, menu, main_ingredient_categories)

                for i in range(2):
                    self.add_dish(('appetizer',), db, current_cuisines, menu, main_ingredient_categories)
                    self.add_dish(('salad',), db, current_cuisines, menu, main_ingredient_categories)

                self.add_dish(('appetizer',), db, current_cuisines, menu, main_ingredient_categories)
                self.add_dish(('salad',), db, current_cuisines, menu, main_ingredient_categories)
                self.add_dish(('desert',), db, current_cuisines, menu, main_ingredient_categories)

                if self.cooking_time == 4:
                    self.add_dish(('appetizer', 'starter'), db, current_cuisines, menu, main_ingredient_categories)
                    self.add_dish(('starter', 'hot starter'), db, current_cuisines, menu, main_ingredient_categories)

                if self.dinner_time == 'later':
                    self.add_dish(('salad', 'starter'), db, current_cuisines, menu, main_ingredient_categories)

            elif self.dinner_category == 'romantic':
                for i in range(3):
                    self.add_dish(('appetizer',), db, current_cuisines, menu, main_ingredient_categories)

                self.add_dish(('salad',), db, current_cuisines, menu, main_ingredient_categories)
                self.add_dish(('desert',), db, current_cuisines, menu, main_ingredient_categories)

                if self.cooking_time == 2:
                    self.add_dish(('appetizer',), db, current_cuisines, menu, main_ingredient_categories)

                elif self.cooking_time == 3:
                    self.add_dish(('main dish', 'soup', 'hot starter'), db, current_cuisines, menu, main_ingredient_categories)
                    if menu and menu[-1]['side_dish']:
                        self.add_dish(('side dish',), db, current_cuisines, menu, main_ingredient_categories)

                else:
                    self.add_dish(('main dish', 'soup'), db, current_cuisines, menu, main_ingredient_categories)
                    if menu and menu[-1]['side_dish']:
                        self.add_dish(('side dish',), db, current_cuisines, menu, main_ingredient_categories)

                    self.add_dish(('starter', 'hot starter'), db, current_cuisines, menu, main_ingredient_categories)

                    if self.dinner_time == 'later':
                        self.add_dish(('appetizer', 'starter'), db, current_cuisines, menu, main_ingredient_categories)

            return self.sort_menu_by_type(menu)
        except Exception as e:
            print(f"Error in find_matching_dishes: {e}")
            return []
