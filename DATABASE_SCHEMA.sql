-- ==========================================================
-- COOLSTOCK: ICE CREAM WHOLESALE MANAGEMENT DATABASE SCHEMA
-- ==========================================================

-- Create the Database
CREATE DATABASE IF NOT EXISTS cool_stack_db;
USE cool_stack_db;

-- --------------------------------------------------------
-- 1. CENTRALIZED USERS TABLE (The "Super Table")
-- --------------------------------------------------------

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) NOT NULL,
    password VARCHAR(255) NOT NULL DEFAULT '1234',
    role ENUM('admin', 'manager', 'customer', 'delivery', 'cashier') NOT NULL,
    profile_photo VARCHAR(255) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- --------------------------------------------------------
-- 2. ROLE-SPECIFIC EXTENSION TABLES
-- --------------------------------------------------------

CREATE TABLE admins_details (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE managers_details (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    branch_location VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE customers_details (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    shop_name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE delivery_boys_details (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    vehicle_number VARCHAR(20),
    current_status ENUM('Available', 'On Delivery', 'Offline') DEFAULT 'Available',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE cashiers_details (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    counter_number VARCHAR(10),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- --------------------------------------------------------
-- 3. BACKWARD COMPATIBILITY VIEWS
--    (Allows existing JSPs to work without modifying queries)
-- --------------------------------------------------------

CREATE VIEW admins AS 
SELECT u.* FROM users u JOIN admins_details d ON u.id = d.user_id;

CREATE VIEW managers AS 
SELECT u.*, d.branch_location FROM users u JOIN managers_details d ON u.id = d.user_id;

CREATE VIEW customers AS 
SELECT u.*, d.shop_name, d.address FROM users u JOIN customers_details d ON u.id = d.user_id;

CREATE VIEW delivery_boys AS 
SELECT u.*, d.vehicle_number, d.current_status FROM users u JOIN delivery_boys_details d ON u.id = d.user_id;

CREATE VIEW cashiers AS 
SELECT u.*, d.counter_number FROM users u JOIN cashiers_details d ON u.id = d.user_id;

-- --------------------------------------------------------
-- 4. INVENTORY & PRODUCT TABLES
-- --------------------------------------------------------

CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    category VARCHAR(50), 
    flavor VARCHAR(100),
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- --------------------------------------------------------
-- 5. ORDERS & TRANSACTIONS TABLES
-- --------------------------------------------------------

CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL, -- Points to users(id) via customers view logic
    manager_id INT, -- Points to users(id)
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    status ENUM('Pending', 'Processing', 'Out for Delivery', 'Delivered', 'Paid', 'Cancelled') DEFAULT 'Pending',
    delivery_boy_id INT, -- Points to users(id)
    cashier_id INT, -- Points to users(id)
    
    FOREIGN KEY (customer_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (manager_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (delivery_boy_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (cashier_id) REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL, 
    
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- --------------------------------------------------------
-- 6. INITIAL SEED DATA
-- --------------------------------------------------------

INSERT INTO users (name, username, email, phone, password, role) VALUES 
('System Admin', 'admin', 'admin@coolstock.in', '9999900001', '1234', 'admin'),
('Amit Manager', 'manager', 'manager@coolstock.in', '9800111111', '1234', 'manager'),
('Ramesh Customer', 'customer', 'customer@coolstock.in', '9400111111', '1234', 'customer'),
('Raju Delivery', 'delivery', 'delivery@coolstock.in', '9100011111', '1234', 'delivery'),
('Suresh Cashier', 'cashier', 'cashier@coolstock.in', '9300011111', '1234', 'cashier');

INSERT INTO admins_details (user_id) VALUES (1);
INSERT INTO managers_details (user_id, branch_location) VALUES (2, 'Main Warehouse');
INSERT INTO customers_details (user_id, shop_name, address) VALUES (3, 'Ramesh General Store', 'Village Khari');
INSERT INTO delivery_boys_details (user_id, vehicle_number) VALUES (4, 'GJ-01-XX-1234');
INSERT INTO cashiers_details (user_id, counter_number) VALUES (5, 'Counter 1');
