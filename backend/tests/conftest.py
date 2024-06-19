import sys
import os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
import pytest
from main import app as flask_app
from db import get_db

@pytest.fixture
def app():
    flask_app.config['JWT_SECRET_KEY'] = 'test_jwt_secret_key'
    flask_app.config['SECRET_KEY'] = 'test_secret_key'
    with flask_app.app_context():
        yield flask_app

@pytest.fixture
def client(app):
    return app.test_client()

@pytest.fixture
def db(app):
    with app.app_context():
        db = get_db()
        yield db
        db.close()

@pytest.fixture(autouse=True)
def setup_and_teardown_db(db):
    cursor = db.cursor()
    cursor.execute("DELETE FROM users WHERE username IN ('testuser', 'existinguser', 'newuser')")
    cursor.execute("DELETE FROM dishes WHERE title = 'Existing Recipe'")
    db.commit()
    cursor.execute("INSERT INTO users (username, password, email, role) VALUES ('testuser', 'testpassword', 'testuser@example.com', 'user') ON CONFLICT (username) DO NOTHING")
    cursor.execute("INSERT INTO users (username, password, email, role) VALUES ('existinguser', 'existingpassword', 'existinguser@example.com', 'user') ON CONFLICT (username) DO NOTHING")
    cursor.execute("INSERT INTO dishes (title, description, author_id, image_url) VALUES ('Existing Recipe', 'Test description', 1, 'default_img.jpg') ON CONFLICT (title) DO NOTHING")
    db.commit()
    yield
    cursor.execute("DELETE FROM users WHERE username IN ('testuser', 'existinguser', 'newuser')")
    cursor.execute("DELETE FROM dishes WHERE title = 'Existing Recipe'")
    db.commit()

