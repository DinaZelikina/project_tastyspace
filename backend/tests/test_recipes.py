def test_check_recipe_title_exists(client, db):
    response = client.post('/check_recipe_title', json={
        'title': 'Existing Recipe'
    })
    assert response.status_code == 200
    data = response.get_json()
    assert data['exists'] == True
