Project Overview: Multi-User Supply Chain Management System
1. User Roles & Hierarchy
System mein main 3 types ke users hain:

Admin: Full system controller (Root user).

Employee: Sub-divided into 3 categories:

Manager: Order management & assignment.

Delivery Boy: Order fulfillment & cash handling.

Cashier: Payment verification & invoicing.

Customer: B2B Clients (Shop owners) who place bulk orders in cartons.

2. Detailed User Responsibilities
A. Admin (The Observer)
Monitoring: Pura system observe karna (Total customers, total employees).

Recruitment: "New Join Request" section ko manage karna.

Approval: New applicants ka contact details dekhna, interview/baat karna, aur profile approve karke unhe system ka part banana.

B. Manager (The Coordinator)
Order Intake: Naye orders receive karna.

Task Assignment: Orders ko available Delivery Boys ko assign karna.

Dashboard View: Sirf wahi orders dikhenge jo assign karne ke liye pending hain ya ongoing hain.

C. Delivery Boy (The Executor)
Status Tracking: Order pick karke status "Start Order" karna.

Completion: Customer tak pahunchane par "Order Completed" mark karna.

Cash Flow: Customer se payment leke Cashier ko dena.

Dashboard View: Apne assigned orders, delivery status, aur "Pending Cash to Deposit" ki list dekhna.

D. Cashier (The Accountant)
Payment Verification: Delivery boy jab paise jama kare, toh payment status ko "Approved" karna.

Invoicing: Payment approve hote hi automatic Invoice/Bill generate karna.

System Update: Bill generate hote hi status update karna taki Customer apna bill download kar sake.

E. Customer (The Buyer)
Bulk Ordering: Cartons mein bulk order place karna.

Tracking: Order ka live status dekhna.

Billing: Payment complete hone ke baad dashboard se invoice download karna.

3. Order Workflow (Step-by-Step)
Customer bulk order place karta hai.

Manager dashboard par order dekh kar use Delivery Boy ko assign karta hai.

Delivery Boy order start karta hai aur deliver karne ke baad "Complete" mark karta hai.

Delivery Boy cash lekar Cashier ke paas jata hai.

Cashier payment confirm karta hai.

System automatically Invoice generate karta hai.

Customer, Admin, Manager, aur Cashier sabhi final bill aur payment status dekh sakte hain.

4. Technical Requirements for AI
Access Control: Role-based Access Control (RBAC) implementation.

Database: Relationships between Orders, Users, and Transactions.

Frontend: Alag-alag users ke liye specific dashboard views.

Real-time Updates: Status changes (Pending -> Assigned -> Started -> Delivered -> Paid).


Update: Profile Management & Admin Control Panel
1. Global Profile System (For All Users)
Sabhi 5 types ke users (Admin, Manager, Cashier, Delivery Boy, Customer) ke dashboard mein ek dedicated Profile Page hoga.

Profile Dashboard Features:
View Profile: User apni saari details (Name, Role, Contact, Email) dekh sakega.

Edit Profile Button: Ek button jo "Edit Mode" open karega.

Photo Management: * Naya profile photo upload karne ka option.

Existing photo ko change/update karne ka option.

Purpose: Taaki Admin har employee aur customer ko unke face (photo) se pehchan sake aur system authentic lage.

2. Admin Sidebar: Management Modules
Admin ke sidebar mein do naye main sections add honge taaki wo data ko filter karke dekh sake:

A. Manage Staff (Employee View)
Dedicated Page: View Employees

Data Display: Is page par sirf Manager, Cashier, aur Delivery Boys ki list hogi.

Details: Unka naam, unka specific role, aur unki Profile Photo highlight hogi.

Actions: Admin yahan se kisi bhi employee ki performance ya status track kar sakta hai.

B. Manage Customers (Client View)
Dedicated Page: View Customers

Data Display: Isme sirf wahi shop owners (B2B customers) honge jo bulk orders dete hain.

Details: Customer ka naam, unki shop ki details, profile photo, aur unka order history link.

4. User Experience (UX) Flow
User apne dashboard par "Profile" par click karta hai.

Wo apni picture upload karta hai aur "Save" karta hai.

Admin jab Manage Staff page kholta hai, toh use saare employees ki grid ya list dikhti hai jisme unki uploaded photos saaf nazar aati hain.