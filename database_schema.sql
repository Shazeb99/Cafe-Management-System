-- Café Management System Database Schema (MySQL Version)
-- Save this as schema_mysql.sql and import in MySQL

CREATE DATABASE IF NOT EXISTS cafe_manager CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE cafe_manager;

-- Drop tables if they already exist
DROP TABLE IF EXISTS invoices;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS menu_items;
DROP TABLE IF EXISTS users;

-- =========================
-- Users Table
-- =========================
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('Manager', 'Cashier', 'Waiter') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- Menu Items Table
-- =========================
CREATE TABLE menu_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    category VARCHAR(50) NOT NULL,
    stock_quantity INT DEFAULT 0,
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- Orders Table
-- =========================
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    table_no VARCHAR(10) NOT NULL,
    status ENUM('Placed', 'Preparing', 'Completed', 'Cancelled') DEFAULT 'Placed',
    total_amount DECIMAL(10, 2) DEFAULT 0,
    waiter_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (waiter_id) REFERENCES users(id)
);

-- =========================
-- Order Items Table
-- =========================
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL,
    price_each DECIMAL(10, 2) NOT NULL,
    line_total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES menu_items(id)
);

-- =========================
-- Invoices Table
-- =========================
CREATE TABLE invoices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL UNIQUE,
    subtotal DECIMAL(10, 2) NOT NULL,
    tax DECIMAL(10, 2) DEFAULT 0,
    discount DECIMAL(10, 2) DEFAULT 0,
    total DECIMAL(10, 2) NOT NULL,
    payment_status ENUM('Pending', 'Paid', 'Failed') DEFAULT 'Pending',
    paid_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

-- =========================
-- Default Users
-- =========================
INSERT INTO users (name, email, password, role) VALUES
('Imran Manager', 'manager@cafe.com', 'manager123', 'Manager'),
('Anuj Cashier', 'cashier@cafe.com', 'cashier123', 'Cashier'),
('Jatin Waiter', 'waiter@cafe.com', 'waiter123', 'Waiter');

-- =========================
-- Menu Items
-- =========================
INSERT INTO menu_items (name, description, price, category, stock_quantity) VALUES
('Cappuccino', 'Classic Italian coffee', 150.00, 'Beverages', 50),
('Espresso', 'Strong black coffee', 100.00, 'Beverages', 50),
('Latte', 'Milk coffee', 180.00, 'Beverages', 50),
('Sandwich', 'Veg sandwich with cheese', 120.00, 'Food', 30),
('Burger', 'Veg/Chicken burger', 200.00, 'Food', 25),
('Pasta', 'Italian pasta', 250.00, 'Food', 20),
('Cake', 'Chocolate cake slice', 150.00, 'Dessert', 15),
('Ice Cream', 'Vanilla ice cream', 80.00, 'Dessert', 40);
