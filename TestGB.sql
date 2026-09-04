CREATE DATABASE IF NOT EXISTS ocean_view_resort;
USE ocean_view_resort;

DROP TABLE IF EXISTS reservations;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS packages;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  phone VARCHAR(30) NOT NULL,
  address VARCHAR(255) NOT NULL,
  username VARCHAR(50) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  role VARCHAR(20) NOT NULL
);

CREATE TABLE packages (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(80) NOT NULL,
  description VARCHAR(255),
  price_per_night DECIMAL(10,2) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
);

CREATE TABLE rooms (
  id INT AUTO_INCREMENT PRIMARY KEY,
  room_no VARCHAR(20) UNIQUE NOT NULL,
  room_type VARCHAR(40) NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'AVAILABLE',
  package_id INT,
  CONSTRAINT fk_room_package FOREIGN KEY (package_id) REFERENCES packages(id)
);

CREATE TABLE reservations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  reservation_no VARCHAR(40) NOT NULL,
  user_id INT NOT NULL,
  room_id INT NOT NULL,
  check_in DATE NOT NULL,
  check_out DATE NOT NULL,
  total_amount DECIMAL(10,2) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'CONFIRMED',
  CONSTRAINT fk_res_user FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT fk_res_room FOREIGN KEY (room_id) REFERENCES rooms(id)
);

INSERT INTO users(full_name, phone, address, username, password, role) VALUES
('System Administrator', '0771234567', 'Ocean View Resort, Colombo', 'admin', 'admin123', 'ADMIN'),
('Nimal Perera', '0712345678', 'Staff Quarters, Galle Road', 'staff1', 'staff123', 'STAFF_L1'),
('Guest Client', '0759876543', '12 Palm Grove, Colombo 03', 'client1', 'client123', 'CLIENT');

INSERT INTO packages(name, description, price_per_night, status) VALUES
('Deluxe', 'Sea-view deluxe room with breakfast', 12000.00, 'ACTIVE'),
('Luxury', 'Luxury suite with balcony and spa access', 20000.00, 'ACTIVE'),
('Standard', 'Comfortable garden-view room', 8000.00, 'ACTIVE');

INSERT INTO rooms(room_no, room_type, price, status, package_id) VALUES
('101', 'Deluxe', 12000.00, 'AVAILABLE', 1),
('102', 'Deluxe', 12000.00, 'AVAILABLE', 1),
('201', 'Luxury', 20000.00, 'AVAILABLE', 2),
('202', 'Luxury', 20000.00, 'AVAILABLE', 2),
('301', 'Standard', 8000.00, 'AVAILABLE', 3);
