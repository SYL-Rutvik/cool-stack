# CoolStock - Ice Cream Wholesale Management System

## Project Overview
**CoolStock** is a comprehensive, multi-role Ice Cream Wholesale Management System. It is designed to modernize and streamline the entire supply chain and daily operations of a wholesale ice cream distributor. The platform successfully bridges the communication gap between administrators, branch managers, delivery personnel, cashiers, and the retail shop owners (customers) who purchase the stock.

## Project Goals
- **Centralize Operations:** Provide a centralized platform to manage warehouse inventory, sales invoices, and employee activities.
- **Role-Based Access Control:** Ensure highly secure and tailored interactive dashboards for each specific user type, eliminating data overlap.
- **Real-Time Tracking & Logistics:** Enable shop owners to place orders remotely and track delivery dispatch statuses seamlessly.
- **Streamlined Workflow:** Automate order assignments from Managers to Delivery Boys, and simplify the checkout processes for Cashiers.

## Technology Stack
- **Framework:** Spring Boot (Java)
- **Build Tool:** Maven
- **Database:** MySQL
- **Frontend Template Engine:** JSP (JavaServer Pages) with Tailwind CSS

## Architecture & Project Flow
The system operates on an efficient execution lifecycle bridging the Spring Boot backend to the MySQL database.
1. **Authentication:** Users interact with a centralized `login.jsp` portal. Based on their verified credentials and assigned role via the Database, they are redirected uniquely to their specialized, role-locked dashboard.
2. **The Order Lifecycle:** 
   - A **Customer** logs in, browses the catalog, and places a wholesale order.
   - A **Manager** immediately receives the pending order, processes the stock from the inventory, and explicitly assigns it.
   - The **Delivery Boy** checks their mobile-friendly portal, picks up the assigned dispatch, and updates the status to "Out for Delivery" or "Delivered".
3. **In-House Sales:** Walk-in or direct manual purchases at the local warehouse are handled instantly by the **Cashier** via a dedicated point-of-sale reporting interface.

## User Roles and Features

### 1. Admin (⚙️)
The system administrators have unrestricted, top-level access to the entire application logic.
- **Manage Staff:** Securely add, edit, or remove Managers, Cashiers, and Delivery personnel.
- **Analytics & Reports:** View overarching overarching business reports, recent orders, and aggregate customer data.
- **Manage Inventory:** Oversee the master list of ice cream products, flavor categories, and enforce stock limits.
- **Profile Settings:** Safely update their administrative profile data.

### 2. Manager (📊)
Branch or Warehouse Managers oversee daily workflow logistics.
- **Order Processing:** Monitor incoming orders from Customers and approve/reject them.
- **Assign Deliveries:** Easily allocate processed orders specifically to available Delivery Boys.
- **Inventory Tracking:** Monitor global stock levels so physical inventories match database quantities.
- **Target Orders:** Monitor daily/weekly business benchmark targets.
- **Profile Management:** Seamlessly update their personal details seamlessly linking back to the MySQL DB.

### 3. Customer / Shop Owner (🏪)
Retail shop owners who purchase ice cream in bulk to sell locally.
- **Place Order:** Interactively browse available products and initiate a wholesale order list.
- **Track Order:** View real-time GPS/Step tracking statuses of their active orders (Processing, Out for Delivery, etc.).
- **Order History:** Audit past invoices and purchase histories.
- **Profile Management:** Update their personal shop address, contact details, and owner information dynamically.

### 4. Delivery Boy (🛵)
The physical dispatch personnel handling logistics.
- **View Assignments:** See only the specific orders assigned to them directly by the Manager.
- **Update Order Status:** Quickly change an order status over to "Delivered" once successfully dropped off at the Customer's shop.
- **Route Details:** Rapidly access the specific Customer's shop address and phone number for navigation.

### 5. Cashier (💳)
Warehouse point-of-sale operators handling direct financial interaction.
- **Billing:** Rapidly generate bills for direct walk-in wholesale buyers without needing dispatch logic.
- **Payment Processing:** Record transactions and update the overall daily cash-drawer records.

## Database Highlights (MySQL)
The backbone of CoolStock relies heavily on relational **MySQL** mapping.
- **Auth Entities:** Standardized rows including unique `username`, `email`, and securely structured tables for `admins`, `managers`, `customers`, `delivery_boys`, `cashiers`.
- **Inventory Engine:** Fully relational `products` tables.
- **Transaction Engine:** `orders` heavily relying on primary-to-foreign key mappings dynamically linking together Customers, Assigning Managers, and delivering personnel alongside an `order_items` subtotal tracker array.
