CREATE DATABASE IF NOT EXISTS moviez_db
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE moviez_db;

CREATE TABLE IF NOT EXISTS movies (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(150) NOT NULL,
  genre VARCHAR(120) NOT NULL,
  rating DECIMAL(3,1) DEFAULT 0.0,
  language VARCHAR(50) NOT NULL DEFAULT 'Hindi',
  duration VARCHAR(30) NOT NULL DEFAULT '2h 00m',
  description TEXT,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS cinemas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  city VARCHAR(100) NOT NULL,
  address VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS screens (
  id INT AUTO_INCREMENT PRIMARY KEY,
  cinema_id INT NOT NULL,
  screen_name VARCHAR(80) NOT NULL,
  total_seats INT NOT NULL DEFAULT 60,
  FOREIGN KEY (cinema_id) REFERENCES cinemas(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS seats (
  id INT AUTO_INCREMENT PRIMARY KEY,
  screen_id INT NOT NULL,
  seat_row CHAR(2) NOT NULL,
  seat_number INT NOT NULL,
  seat_type ENUM('REGULAR','PREMIUM','RECLINER') NOT NULL DEFAULT 'REGULAR',
  UNIQUE KEY unique_screen_seat (screen_id, seat_row, seat_number),
  FOREIGN KEY (screen_id) REFERENCES screens(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS shows (
  id INT AUTO_INCREMENT PRIMARY KEY,
  movie_id INT NOT NULL,
  screen_id INT NOT NULL,
  show_datetime DATETIME NOT NULL,
  ticket_price DECIMAL(8,2) NOT NULL DEFAULT 220.00,
  FOREIGN KEY (movie_id) REFERENCES movies(id),
  FOREIGN KEY (screen_id) REFERENCES screens(id)
);

CREATE TABLE IF NOT EXISTS bookings (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  movie_id INT NULL,
  customer_name VARCHAR(150) NOT NULL,
  show_time VARCHAR(40) NOT NULL,
  seat_numbers VARCHAR(255) NOT NULL,
  total_amount DECIMAL(10,2) NOT NULL,
  status ENUM('PENDING','CONFIRMED','CANCELLED') NOT NULL DEFAULT 'CONFIRMED',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (movie_id) REFERENCES movies(id) ON DELETE SET NULL
);

INSERT INTO movies (title, genre, rating, language, duration, description)
SELECT 'The Last Horizon', 'Sci-Fi · Adventure', 8.7, 'English', '2h 18m', 'A crew travels beyond the edge of the known universe.'
WHERE NOT EXISTS (SELECT 1 FROM movies WHERE title = 'The Last Horizon');
INSERT INTO movies (title, genre, rating, language, duration, description)
SELECT 'Midnight Run', 'Action · Thriller', 8.2, 'Hindi', '2h 06m', 'One night. One city. One impossible mission.'
WHERE NOT EXISTS (SELECT 1 FROM movies WHERE title = 'Midnight Run');
INSERT INTO movies (title, genre, rating, language, duration, description)
SELECT 'Monsoon Letters', 'Romance · Drama', 8.9, 'Hindi', '2h 12m', 'Two strangers find each other in a city of rain.'
WHERE NOT EXISTS (SELECT 1 FROM movies WHERE title = 'Monsoon Letters');
INSERT INTO movies (title, genre, rating, language, duration, description)
SELECT 'The Hidden Kingdom', 'Fantasy · Family', 7.9, 'English', '1h 54m', 'A forgotten world awakens beneath the mountains.'
WHERE NOT EXISTS (SELECT 1 FROM movies WHERE title = 'The Hidden Kingdom');
INSERT INTO movies (title, genre, rating, language, duration, description)
SELECT 'Laugh Out Loud', 'Comedy', 8.1, 'Hindi', '1h 48m', 'A chaotic family reunion becomes a hilarious adventure.'
WHERE NOT EXISTS (SELECT 1 FROM movies WHERE title = 'Laugh Out Loud');
INSERT INTO movies (title, genre, rating, language, duration, description)
SELECT 'Code Black', 'Mystery · Crime', 8.5, 'English', '2h 09m', 'A detective follows a trail of secrets hidden in plain sight.'
WHERE NOT EXISTS (SELECT 1 FROM movies WHERE title = 'Code Black');
