def test_create_menu(client, db):
    response = client.post('/createMenu', json={
        'dinnerCategory': 'weeknight',
        'dinnerTime': 'today',
        'cookingTime': 1
    })
    assert response.status_code == 200
    data = response.get_json()
    assert 'error' not in data

def test_aggregate_ingredients(client, db):
    response = client.post('/aggregateIngredients', json={
        'recipes': [1]
    })
    assert response.status_code == 200
    data = response.get_json()
    assert 'error' not in data
