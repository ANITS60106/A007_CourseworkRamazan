# ClearLoan Backend (Django, prototype)

## Setup
```bash
cd backend
python -m venv .venv
# Windows:
.venv\Scripts\activate
# macOS/Linux:
source .venv/bin/activate

pip install -r requirements.txt
python manage.py makemigrations
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver 8000
```

## Seed demo offers
```bash
# In another terminal (or via Postman):
curl -X POST http://127.0.0.1:8000/api/seed/
```

## API (minimal)
- `POST /api/auth/register/`  -> `{ token, user }`
- `POST /api/auth/login/`     -> `{ token, user }`
- `GET  /api/offers/`         -> public list of offers
- `GET/POST /api/loans/`      -> user's active loans (token required)
- `GET/POST /api/requests/`   -> user's loan requests (token required)
