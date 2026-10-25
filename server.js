require("dotenv").config();
const express = require("express");
const cors = require("cors");
const mysql = require("mysql2/promise");

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors({ origin: true }));
app.use(express.json());

const demoMovies = [
  { id: 1, title: "The Last Horizon", genre: "Sci-Fi · Adventure", rating: "8.7", language: "English", duration: "2h 18m", color: "poster-purple", emoji: "🚀", description: "A crew travels beyond the edge of the known universe." },
  { id: 2, title: "Midnight Run", genre: "Action · Thriller", rating: "8.2", language: "Hindi", duration: "2h 06m", color: "poster-red", emoji: "🏎️", description: "One night. One city. One impossible mission." },
  { id: 3, title: "Monsoon Letters", genre: "Romance · Drama", rating: "8.9", language: "Hindi", duration: "2h 12m", color: "poster-green", emoji: "🌧️", description: "Two strangers find each other in a city of rain." },
  { id: 4, title: "The Hidden Kingdom", genre: "Fantasy · Family", rating: "7.9", language: "English", duration: "1h 54m", color: "poster-blue", emoji: "🐉", description: "A forgotten world awakens beneath the mountains." },
  { id: 5, title: "Laugh Out Loud", genre: "Comedy", rating: "8.1", language: "Hindi", duration: "1h 48m", color: "poster-yellow", emoji: "🎭", description: "A chaotic family reunion becomes a hilarious adventure." },
  { id: 6, title: "Code Black", genre: "Mystery · Crime", rating: "8.5", language: "English", duration: "2h 09m", color: "poster-dark", emoji: "🕵️", description: "A detective follows a trail of secrets hidden in plain sight." }
];

let memoryBookings = [];
let pool = null;

async function getPool() {
  if (!process.env.DB_HOST || !process.env.DB_NAME || !process.env.DB_USER) return null;
  if (!pool) {
    pool = mysql.createPool({
      host: process.env.DB_HOST,
      port: Number(process.env.DB_PORT || 3306),
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD || "",
      database: process.env.DB_NAME,
      waitForConnections: true,
      connectionLimit: 10
    });
  }
  return pool;
}

app.get("/api/health", async (_req, res) => {
  let database = "demo mode";
  try {
    const db = await getPool();
    if (db) {
      await db.query("SELECT 1");
      database = "connected";
    }
  } catch (_error) {
    database = "configured but unavailable";
  }
  res.json({ ok: true, service: "Moviez API", database });
});

app.get("/api/movies", async (_req, res) => {
  try {
    const db = await getPool();
    if (db) {
      const [rows] = await db.query(
        "SELECT id, title, genre, rating, language, duration, description FROM movies WHERE is_active = 1 ORDER BY id DESC"
      );
      if (rows.length) return res.json(rows);
    }
  } catch (error) {
    console.error("Database movie query failed:", error.message);
  }
  res.json(demoMovies);
});

app.get("/api/bookings", (_req, res) => {
  res.json(memoryBookings);
});

app.post("/api/bookings", async (req, res) => {
  const { movieId, movieTitle, showTime, seats, total } = req.body || {};
  if (!movieTitle || !showTime || !Array.isArray(seats) || seats.length === 0) {
    return res.status(400).json({ error: "movieTitle, showTime and at least one seat are required." });
  }
  const booking = {
    id: Date.now(),
    movieId: movieId || null,
    movieTitle: String(movieTitle),
    showTime: String(showTime),
    seats: seats.map(String),
    total: Number(total) || seats.length * 220,
    createdAt: new Date().toISOString()
  };

  try {
    const db = await getPool();
    if (db) {
      // This starter endpoint persists to MySQL once the matching tables are created.
      // Booking/seat locking is a later enhancement; do not treat this demo as concurrency-safe.
      const [result] = await db.execute(
        "INSERT INTO bookings (movie_id, customer_name, show_time, seat_numbers, total_amount, status) VALUES (?, ?, ?, ?, ?, ?)",
        [booking.movieId, "Guest", booking.showTime, booking.seats.join(","), booking.total, "CONFIRMED"]
      );
      booking.id = result.insertId;
    } else {
      memoryBookings.unshift(booking);
    }
    return res.status(201).json({ booking });
  } catch (error) {
    console.error("Booking save failed:", error.message);
    return res.status(500).json({ error: "Could not save booking. Check database setup and schema." });
  }
});

app.listen(PORT, () => {
  console.log(`Moviez backend running at http://localhost:${PORT}`);
});
