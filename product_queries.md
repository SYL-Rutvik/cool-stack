# Product Management Queries

This document contains the SQL queries required to add new inventory items to the `products` table.

## Add New Product Query

Use the following SQL statement to insert a new ice cream product into the catalog:

```sql
INSERT INTO products (name, category, flavor, price, stock_quantity) 
VALUES ('Choco Fudge Tub', 'Tubs', 'Double Chocolate', 250.00, 100);
```

### Parameterized Version (for Java/DAOs)

```sql
INSERT INTO products (name, category, flavor, price, stock_quantity) 
VALUES (?, ?, ?, ?, ?);
```

### Table Structure Reference

| Column | Type | Description |
| :--- | :--- | :--- |
| `name` | `VARCHAR(150)` | Product display name (e.g., 'Vanilla Cone') |
| `category` | `VARCHAR(50)` | Category like 'Tubs', 'Cones', 'Sticks' |
| `flavor` | `VARCHAR(100)` | Primary flavor profile |
| `price` | `DECIMAL(10,2)` | Unit price in INR |
| `stock_quantity` | `INT` | Initial warehouse stock |

---
**Note:** The `id` is auto-incremented and `created_at` is automatically set to the current timestamp.