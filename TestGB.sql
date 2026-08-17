CREATE DATABASE ocean_view_resort;
USE ocean_view_resort;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  role VARCHAR(20) NOT NULL
);

CREATE TABLE room_rates (
  room_type VARCHAR(20) PRIMARY KEY,
  rate_per_night DECIMAL(10,2) NOT NULL
);

CREATE TABLE reservations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  reservation_no VARCHAR(30) UNIQUE NOT NULL,
  guest_name VARCHAR(100) NOT NULL,
  address VARCHAR(255),
  contact_number VARCHAR(30) NOT NULL,
  room_type VARCHAR(20) NOT NULL,
  check_in DATE NOT NULL,
  check_out DATE NOT NULL
);

INSERT INTO room_rates(room_type, rate_per_night) VALUES
('SINGLE', 5000.00),
('DOUBLE', 8000.00),
('DELUXE', 12000.00);