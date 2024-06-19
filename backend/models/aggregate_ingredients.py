from psycopg2.extras import RealDictCursor
import inflect

class IngredientAggregator:
    category_headings = {
        'meat': "Meat & Chicken",
        'chicken': "Meat & Chicken",
        'turkey': "Meat & Chicken",
        'liver': "Meat & Chicken",
        'fish': "Fish & Seafood",
        'seafood': "Fish & Seafood",
        'deli meats': "Deli meats",
        'eggs': "Eggs & Dairy",
        'dairy': "Eggs & Dairy",
        'cheese': "Dairy",
        'pasta': "Pasta, Beans & Cereal",
        'beans': "Pasta, Beans & Cereal",
        'rice': "Pasta, Beans & Cereal",
        'cereal': "Pasta, Beans & Cereal",
        'canned fish': "Canned Goods",
        'canned beans': "Canned Goods",
        'canned goods': "Canned Goods",
        'dry food': "Dry food",
        'sweets': "Sweets",
        'mushrooms': "Vegetables & Mushrooms",
        'potato': "Vegetables & Mushrooms",
        'carrot': "Vegetables & Mushrooms",
        'tomato': "Vegetables & Mushrooms",
        'vegetables': "Vegetables & Mushrooms",
        'fruits': "Fruits",
        'greenery': "Greenery",
        'sauces': "Sauces",
        'seasoning': "Seasoning",
        'baking supplies': "Baking supplies",
        'other': "Other"
    }

    def __init__(self):
        self.p = inflect.engine()

    def normalize_name(self, name):
        words = name.lower().split()
        normalized_words = [self.p.singular_noun(word) or word for word in words]
        return ' '.join(normalized_words)

    def format_amount(self, amount):
        return '{:.2f}'.format(amount).rstrip('0').rstrip('.')

    def aggregate_ingredients(self, db, dish_ids):
        cursor = db.cursor(cursor_factory=RealDictCursor)
        
        query = """
            SELECT LOWER(name) as name, SUM(amount) as amount, measurement, category
            FROM ingredients
            WHERE dish_id = ANY(%s)
            GROUP BY LOWER(name), measurement, category
        """
        try:
            cursor.execute(query, (dish_ids,))
            ingredients = cursor.fetchall()
            print("Ingredients fetched from DB:", ingredients)
        except Exception as e:
            print(f"Error executing query: {e}")
            return {"error": "Error executing query"}

        grouped_ingredients = {}
        for ingredient in ingredients:
            try:
                ingredient_name = self.normalize_name(ingredient['name'])
                category_heading = self.category_headings.get(ingredient['category'], "Other")
                if category_heading not in grouped_ingredients:
                    grouped_ingredients[category_heading] = []

                existing = next((item for item in grouped_ingredients[category_heading] if item['name'] == ingredient_name and item['measurement'] == ingredient['measurement']), None)

                if existing:
                    existing_amount_before = existing['amount']
                    existing['amount'] += ingredient['amount']
                    print(f"Updated ingredient: {ingredient['name']}, measurement: {ingredient['measurement']}, from {existing_amount_before} to {existing['amount']}")
                else:
                    grouped_ingredients[category_heading].append({
                        'name': ingredient_name,
                        'amount': ingredient['amount'],
                        'measurement': ingredient['measurement'],
                        'category': ingredient['category']
                    })
                    print(f"Added new ingredient: {ingredient['name']}, measurement: {ingredient['measurement']}, amount: {ingredient['amount']}")
            except Exception as e:
                print(f"Error processing ingredient {ingredient['name']}: {e}")

        for category in grouped_ingredients:
            for ingredient in grouped_ingredients[category]:
                ingredient['amount'] = self.format_amount(ingredient['amount'])

        for category in grouped_ingredients:
            grouped_ingredients[category].sort(key=lambda x: (x['name'], x['measurement']))

        print("Grouped ingredients:", grouped_ingredients)
        return grouped_ingredients
