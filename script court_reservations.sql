CREATE DATABASE court_reservations;
USE court_reservations;

-- USERS table 
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    status ENUM('active','inactive') NOT NULL,
    profile ENUM('client','administrator','vendor','owner') NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    last_login DATETIME,
    is_owner BOOLEAN DEFAULT FALSE,
    phone VARCHAR(20)
);

-- ESTABLISHMENTS table
CREATE TABLE establishments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(150) NOT NULL,
    num_courts INT NOT NULL,
    owner_id BIGINT NOT NULL,
    phone VARCHAR(20) NOT NULL,
    capacity INT NOT NULL,
    description VARCHAR(255),   
    email VARCHAR(100),         
    CONSTRAINT fk_establishment_owner FOREIGN KEY (owner_id) REFERENCES users(id)
);

-- COURTS table
CREATE TABLE courts (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    fee DECIMAL(10,2) NOT NULL,
    capacity INT NOT NULL,
    establishment_id BIGINT NOT NULL,
    CONSTRAINT fk_court_establishment FOREIGN KEY (establishment_id) REFERENCES establishments(id)
);

-- SPORTS table
CREATE TABLE sports (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    type VARCHAR(50) NOT NULL,
    image VARCHAR(255),
    icon VARCHAR(255),
    classification VARCHAR(50),
    court_id BIGINT,
    CONSTRAINT fk_sport_court FOREIGN KEY (court_id) REFERENCES courts(id)
);

-- FAVORITE_SPORTS table
CREATE TABLE favorite_sports (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    sport_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    description TEXT,
    CONSTRAINT fk_favorite_sport FOREIGN KEY (sport_id) REFERENCES sports(id),
    CONSTRAINT fk_favorite_user FOREIGN KEY (user_id) REFERENCES users(id)
);

-- PAYMENT_METHODS table
CREATE TABLE payment_methods (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    user_id BIGINT NOT NULL,
    establishment_id BIGINT NOT NULL,
    court_id BIGINT NOT NULL,
    CONSTRAINT fk_payment_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_payment_establishment FOREIGN KEY (establishment_id) REFERENCES establishments(id),
    CONSTRAINT fk_payment_court FOREIGN KEY (court_id) REFERENCES courts(id)
);

-- RESERVATIONS table
CREATE TABLE reservations (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    establishment_id BIGINT NOT NULL,
    court_id BIGINT NOT NULL,
    sport_id BIGINT NOT NULL,
    reservation_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    CONSTRAINT fk_reservation_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_reservation_establishment FOREIGN KEY (establishment_id) REFERENCES establishments(id),
    CONSTRAINT fk_reservation_court FOREIGN KEY (court_id) REFERENCES courts(id),
    CONSTRAINT fk_reservation_sport FOREIGN KEY (sport_id) REFERENCES sports(id)
);
-- Create a user 
INSERT INTO users (name, username, password, status, profile, email, last_login, is_owner, phone)
VALUES ('rigoberto zelayandia', 'rzelayandia', 'password123', 'active', 'owner', 'rzelayandia@example.com', NOW(), TRUE, '6666-2645');

-- Create an establishment
INSERT INTO establishments (name, location, num_courts, owner_id, phone, capacity, description, email)
VALUES ('rod carew', 'cenntenial', 5, 1, '666-5678', 100, 'Main stadium of the city', 'info@rodcarew.com');

-- Create a court for the establishment
INSERT INTO courts (name, fee, capacity, establishment_id)
VALUES ('Court 1', 50.00, 10, 1);

--  Create a client user
INSERT INTO users (name, username, password, status, profile, email, last_login, is_owner, phone)
VALUES ('abdul rodriguez', 'arodriguez', 'pass123', 'active', 'client', 'arodriguez@example.com', NOW(), FALSE, '6570-6789');

-- Query all users
SELECT * FROM users;

-- Create a sport associated with a court
INSERT INTO sports (name, type, image, icon, classification, court_id)
VALUES ('baseball', 'Team', 'baseball.jpg', 'baseball_icon.png', 'A', 1);

-- Modify the sport 
UPDATE sports
SET classification = 'C'
WHERE id = 1;

-- Associate a user with an establishment, sport, and court
INSERT INTO reservations (user_id, establishment_id, court_id, sport_id, reservation_date, start_time, end_time)
VALUES (2, 1, 1, 1, '2025-02-21', '10:00:00', '12:00:00');

-- Add a favorite sport for the user
INSERT INTO favorite_sports (name, sport_id, user_id, description)
VALUES ('Ana''s Favorite', 1, 2, 'I love baseball');

-- Query favorite sports
SELECT * FROM favorite_sports;

-- Record a payment for a court
INSERT INTO payment_methods (name, user_id, establishment_id, court_id)
VALUES ('Credit Card', 2, 1, 1);

-- Query the payment methods
SELECT * FROM payment_methods;