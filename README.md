# Moviez — Movie Reservation and Management System starter

This starter contains:
- `frontend/`: React + Vite movie listing, search, showtime selection, seat selection and demo booking UI.
- `backend/`: Node.js + Express API, demo data, optional MySQL connection.
- `database/schema.sql`: MySQL database and starter tables/data.

## 1. Start the backend

Open a terminal in `backend`:

```bash
npm install
```

Copy `.env.example` to `.env`. If you have not configured MySQL yet, you can leave the database variables blank and the API will run in demo mode.

```bash
npm run dev
```

Backend health check: `http://localhost:5000/api/health`

## 2. Start the frontend

Open a second terminal in `frontend`:

```bash
npm install
npm run dev
```

Open the exact local URL Vite prints, usually `http://localhost:5173`.

## 3. Enable MySQL (optional for initial UI test)

1. Start MySQL Server.
2. Open MySQL Workbench or the MySQL command line.
3. Run the complete `database/schema.sql` script.
4. Copy `backend/.env.example` to `backend/.env`.
5. Fill in the actual MySQL password and database values.
6. Restart the backend.

Example `.env`:

```env
PORT=5000
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_actual_password
DB_NAME=moviez_db
```

Never upload your real `.env` or database password to GitHub.

## Notes

- Initial bookings use a simple starter flow, not payment processing.
- In demo mode, bookings are held in server memory and will disappear when the backend restarts.
- The MySQL booking endpoint requires the schema in `database/schema.sql`.
- This is a college-project starter, not a production-ready ticketing system. Production seat locking, authentication, payments and concurrency protection must be added before real users can book.
