# Project Documentation (Combined)

This document contains the merged contents of `project_context.md`, `role_based_folder_structure.md`, and `landing_page_requirements.md`.

---

# Cool-Stack / Ice Cream POS Project Context

> **IMPORTANT:** This document must be updated after each major update cycle to reflect the current state of the architecture, design, and routing.

## 1. Overview
This is a Java-based web application (WAR package) designed for an Ice Cream shop/POS system. It currently features distinct dashboards for **Administrators** and **Employees**, showcasing statistics, order management, and stock levels.

## 2. File Structure
The project follows a standard Maven directory structue:
- `pom.xml`: Maven build and dependency configuration.
- `src/main/webapp/`: Contains all frontend assets and views (JSP files).
  - `admin_dashboard.jsp`, `emp_dashboard.jsp`: Primary views for their respective roles.
  - `sidebar.jsp`, `emp_sidebar.jsp`: Reusable sidebar navigation components.
  - `login.jsp`: The entry point and authentication logic.
  - `WEB-INF/web.xml`: Deployment descriptor.

*Note: Currently, backend logic like authentication is handled directly within JSP scriptlets (e.g., `login.jsp`). No separate Java servlets or Spring controllers are present in `src/main/java`.*

## 3. Theme & Color Scheme
The application uses **Tailwind CSS** (via CDN) for styling and **Chart.js** for analytics visualizations.

- **Global Backgrounds**: Primarily `bg-gray-100` for a clean, modern look.
- **Login Page**: A vibrant gradient background (`bg-gradient-to-r from-purple-500 to-pink-500`).
- **Admin Dashboard**:
  - Main header area uses `bg-gradient-to-r from-blue-600 to-indigo-600`.
  - Statistics cards use distinct accent colors (`text-blue-600`, `text-green-600`, `text-purple-600`, `text-red-600`, `text-indigo-600`).
- **Components**: Heavy use of rounded corners (`rounded-2xl`, `rounded`), box shadows (`shadow-lg`, `shadow-xl`), and hover transition effects (`hover:scale-105 transition duration-300`).

## 4. Redirection & Navigation
Routing is purely file-based using direct JSP links and scriptlet redirects:
- **Default Entry**: `web.xml` defines `login.jsp` as the welcome file.
- **Login Flow**: `login.jsp` verifies hardcoded credentials and uses `response.sendRedirect()` to forward the user to either `admin_dashboard.jsp` or `emp_dashboard.jsp` based on the selected role.
- **Sidebars**: Navigation is managed via anchor tags in `sidebar.jsp` (e.g., `<a href="show_orders.jsp">`) and `emp_sidebar.jsp`, loaded via `<%@ include file="..." %>`.

## 5. Major Imports & Dependencies
- **Maven Dependencies**:
  - `javax.servlet-api` (4.0.1)
  - `javax.servlet.jsp-api` (2.3.3)
- **Frontend CDNs**:
  - Tailwind CSS (`https://cdn.tailwindcss.com`)
  - Chart.js (`https://cdn.jsdelivr.net/npm/chart.js`)

## 6. Missing Functionality & Technical Debt
Currently, the project is a simplified prototype. The following critical systems are missing or incomplete:
- **Backend & Database:** No persistent database integration (e.g., MySQL, JDBC) or ORM (e.g., Hibernate). Data is static.
- **Authentication & Security:** Hardcoded credentials in JSPs. Missing secure session management, password hashing, and proper role-based access control (RBAC) via Servlets or Filters.
- **MVC Architecture:** Business logic is mixed with presentation logic inside JSP scriptlets. Lacks a dedicated Controller layer (e.g., Spring MVC, pure Servlets) and Service layer.
- **API Layer:** No RESTful API for external integrations or dynamic frontend table updates (currently relying on full page reloads).

## 7. Planned Roles & Dashboards
To scale from a prototype to a fully-fledged POS system, the application requires expanding beyond the current Admin/Employee binary. The following roles and respective dashboards are needed:
- **Manager Dashboard:** 
  - *Functionality:* Store overview, employee management (scheduling/payroll), advanced sales analytics, inventory ordering, and supplier management.
  - *Purpose:* Bridges the gap between high-level Admin and day-to-day operations.
- **Cashier / POS Dashboard:**
  - *Functionality:* Fast checkout interface, touch-friendly grid of products, real-time cart calculation, receipt generation, and payment gateway integration.
  - *Purpose:* Streamline in-store customer checkouts.
- **Delivery Dashboard:**
  - *Functionality:* Active order assignment, route mapping/tracking, updating order status ("Out for Delivery", "Delivered"), and customer contact info.
  - *Purpose:* Manage external deliveries efficiently.
- **Customer Portal:**
  - *Functionality:* Self-service menu browsing, cart management, online ordering, order history, loyalty points tracking, and profile management.
  - *Purpose:* Direct consumer engagement and online sales.

---

# Role-Based Folder Structure & Flow

Based on the current implementation of the Cool-Stack / Ice Cream POS project, here is the breakdown of the application files organized by user role. This outlines the flow for different types of users within the system.

Currently, all frontend views reside in `src/main/webapp/`. Concrete implementations only exist for **Admin** and **Employee** roles, while other roles are planned.

## 1. General flow (Authentication)
These files apply to all users entering the system and manage session state.
- `login.jsp` - The entry point of the app. It handles authentication and redirects users to either the Admin or Employee dashboard based on their role credentials.
- `logout.jsp` - Ends the user's session and sends them back to the login page.

## 2. Admin Flow
The Admin has the highest level of access including system management, employee management, and overall statistics.
- `admin_dashboard.jsp` - The main landing page for administrators after logging in. Displays high-level stats.
- `sidebar.jsp` - The navigation menu included in the admin views.
- `admin_bill_preview.jsp` - Allows the admin to view/preview detailed bills.
- `add_emp.jsp` - Interface for the admin to add new employees to the system.
- `show_orders.jsp` - The admin's view of all system orders.
- `view_product.jsp` - Interface to view, and likely manage, the product inventory.

## 3. Employee Flow
Employees handle day-to-day operations like taking and managing active orders.
- `emp_dashboard.jsp` - The main landing page for employees after logging in.
- `emp_sidebar.jsp` - The specific navigation menu restricted to employee features.
- `emp_order.jsp` - Interface for employees to create new orders.
- `emp_show_orders.jsp` - The employee's view of active/past orders they need to handle.
- `bill_preview.jsp` - Used by employees to generate and preview a customer's bill before finalizing the transaction.

## 4. Planned Roles
As noted in `project_context.md`, these roles **do not currently have files** in the application. When implemented, they will likely follow a similar pattern:

### Manager
Bridges the gap between high-level Admin and day-to-day operations.
- `manager_dashboard.jsp`
- `manager_sidebar.jsp`
- `inventory_report.jsp` (for store overview, scheduling, advanced analytics, stock ordering)

### Cashier / POS
Focuses on fast, touch-friendly interactions for checking out customers.
- `pos_terminal.jsp`
- `checkout.jsp` (for fast touch-friendly product grids, cart calculations, and payment gateways)

### Delivery
Manages external deliveries efficiently.
- `delivery_dashboard.jsp`
- `active_routes.jsp` (for viewing assigned orders, mapping, and updating delivery status)

### Customer Portal
Direct consumer engagement and online sales.
- `index.jsp` (landing page)
- `menu.jsp`
- `cart.jsp`
- `order_history.jsp` (for self-service browsing, cart management, and online ordering)

---

# Landing Page (`index.jsp`) Structure & Requirements

The project currently lacks a public-facing entry point. This document outlines the proposed structure for a new landing page (`index.jsp`) that describes the overall website and includes a career section for job applications.

## 1. Overview
The landing page will serve as the welcome screen for all visitors (customers, potential employees, and staff). It will provide a high-level overview of the Ice Cream shop and offer pathways to different parts of the system (Customer Portal, Staff Login, and Careers).

## 2. Key Sections of the Landing Page

### A. Hero Section
- **Headline**: A welcoming and catchy title (e.g., "Welcome to Cool-Stack Ice Cream").
- **Description**: A brief summary of the shop and its online ordering system.
- **Call to Action (CTA) Buttons**: 
  - "Order Now" (Directs to the planned Customer Portal / Menu).
  - "Staff Login" (Directs to the existing `login.jsp`).

### B. About Us / Website Overview
- A section describing the overall website's purpose.
- Highlights the convenience of online ordering, fast delivery, and the modern POS system powering the shop.

### C. Careers & Job Application Section
- **Purpose**: A dedicated section or modal for hiring new staff.
- **Job Application Form**:
  - **Personal Details**: Full Name, Email, Phone Number.
  - **Role Selection (Dropdown/Radio options)**:
    - Manager
    - Cashier / POS Operator
    - Delivery Person
  - **Additional Details**: Brief cover letter or experience description.
  - **Submit Button**: "Apply for Job".

### D. Footer
- Contact information, store location, and quick links to other pages (Login, Terms of Service, etc.).

## 3. Implementation Flow
- Create `index.jsp` in the `src/main/webapp/` directory.
- Update `WEB-INF/web.xml` so that the `<welcome-file>` points to `index.jsp` instead of `login.jsp`.
- The job application form will need backend logic (or at least a placeholder) to handle form submissions and notify the Admin.
