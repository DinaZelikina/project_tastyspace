# TASTYSPACE

## Description

TASTYSPACE is a recipe management and menu creation application that allows users to create, save, and manage recipes. The application supports various roles such as administrator, moderator, author, user, and guest, providing each with access to specific functions. The types of menus include daily, family, guest, festive, and romantic.

## Features

- **Menu Creation:** Users can create menus based on various parameters such as dinner type, planning time, and cooking duration. The application automatically considers the seasonality of dishes and their alignment with different national cuisines.
- **Recipe Management:** Users with the appropriate rights can add, edit, and moderate recipes.
- **Authentication:** Supports user registration and login with different roles. Users and authors can register themselves, while moderators are added by the administrator.
- **Shopping List Generation:** Creates a detailed shopping list based on selected recipes, including ingredient quantities and categories for easier shopping.
- **User Interface:** Intuitive interface using React and Bootstrap.

## Installation

Follow these steps to run the project locally:

### Backend API Server (Flask)

1. Clone the repository and navigate to the project directory:
    ```bash
    git clone https://github.com/DinaZelikina/project_tastyspace
    cd project_tastyspace
    ```

2. Navigate to the backend directory and install the dependencies. It's recommended to use a virtual environment:
    ```bash
    cd backend
    pip install -r requirements.txt
    ```

3. Copy the example environment file and configure it as needed:
    ```bash
    cp example.env .env
    ```

4. If you need to run the backend tests, first install the test/dev dependencies:
    ```bash
    pip install -r requirements-dev.txt
    pytest
    ```

### Database

To ensure the application works correctly, load the recipe database. In the backend directory, run the following command:
```bash
psql -U postgres -h localhost -d postgres -f db.sql
```
Enter the postgres password when prompted.

The default admin login credentials are:
- **Username:** admin
- **Password:** admin


### Frontend (React / Vite / TypeScript)

1. Navigate to the frontend directory and install the dependencies:
    ```bash
    cd ../frontend
    npm install
    ```

2. Start the development server:
    ```bash
    npm run dev
    ```

3. You should be able to access the project at [http://localhost:5173](http://localhost:5173) in your browser.

4. You can also run the frontend tests:
    ```bash
    npm run test
    ```
