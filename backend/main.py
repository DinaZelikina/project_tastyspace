from flask import Flask
from flask_cors import CORS
from flask_jwt_extended import JWTManager
from datetime import timedelta
from db import init_empty_db
import os
from dotenv import load_dotenv

load_dotenv()

from views.auth import auth_bp
from views.recipes import recipes_bp
from views.menu import menu_bp
from views.admin import admin_bp

app = Flask(__name__)

app.config.from_prefixed_env()
app.config['JWT_ACCESS_TOKEN_EXPIRES'] = timedelta(days=1)
FRONTEND_URL = app.config.get("FRONTEND_URL", "http://localhost:5173")
cors = CORS(app, origins=FRONTEND_URL, methods=["GET", "POST", "DELETE", "PUT"], allow_headers=["Authorization", "Content-Type"])
jwt = JWTManager(app)
BASE_DIR = os.path.abspath(os.path.dirname(__file__)) 
relative_path = os.getenv('FLASK_UPLOAD_FOLDER', 'default/path') 
app.config['UPLOAD_FOLDER'] = os.path.join(BASE_DIR, relative_path) 

app.register_blueprint(auth_bp)
app.register_blueprint(recipes_bp)
app.register_blueprint(menu_bp)
app.register_blueprint(admin_bp)

@app.cli.command("init-db")
def init_db_command():
    """Initialize the empty database."""
    init_empty_db()

if __name__ == "__main__":
    app.run()
