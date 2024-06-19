def test_login(client, db):
    response = client.post('/login', json={
        'username': 'testuser',
        'password': 'testpassword'
    })
    assert response.status_code == 200
    data = response.get_json()
    assert 'access_token' in data

def test_check_username_exists(client, db):
    response = client.post('/check_username', json={
        'username': 'existinguser'
    })
    assert response.status_code == 200
    data = response.get_json()
    assert data['valid'] == True

def test_register(client, db):
    response = client.post('/register', json={
        'username': 'newuser',
        'password': 'newpassword',
        'email': 'newuser@example.com',
        'role': 'user'
    })
    data = response.get_json()
    assert response.status_code == 201, f"Expected 201, got {response.status_code}. Response data: {data}"

