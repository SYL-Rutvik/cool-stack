<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ page import="java.sql.*, java.util.*, java.math.*, java.text.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Recent Orders | CoolStock Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Outfit', sans-serif; }
    </style>
</head>

<body class="bg-gray-100 min-h-screen">
    <div class="flex">
        <%@ include file="sidebar.jsp" %>
        
        <div class="ml-64 p-8 w-full">
            <div class="bg-gradient-to-r from-emerald-700 to-teal-600 text-white p-7 rounded-2xl mb-8 flex justify-between items-center shadow-lg">
                <div>
                    <h1 class="text-3xl font-black">&#x1F9FE; Recent Orders</h1>
                    <p class="opacity-70 mt-1">Track and manage recent customer orders</p>
                </div>
                <div class="flex gap-4 items-center">
                    <select id="statusFilter" onchange="filterOrders()"
                        class="bg-white/20 border border-white/30 text-white rounded-xl px-4 py-2 text-sm font-semibold outline-none w-40">
                        <option value="all" class="text-gray-800">All Statuses</option>
                        <option value="Processing" class="text-gray-800">Processing</option>
                        <option value="Shipped" class="text-gray-800">Shipped</option>
                        <option value="Delivered" class="text-gray-800">Delivered</option>
                        <option value="Cancelled" class="text-gray-800">Cancelled</option>
                    </select>
                    <input id="searchInput" type="text" placeholder="Search order ID..." oninput="filterOrders()"
                        class="bg-white/20 border border-white/30 text-white placeholder-white/60 rounded-xl px-4 py-2 text-sm font-semibold outline-none w-52">
                </div>
            </div>

            <% 
                // Initialization
                int totalOrdersToday = 0; 
                BigDecimal revenueToday = BigDecimal.ZERO;
                int processingCount = 0;
                int shippingCount = 0;
                NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));

                try (Connection conn = com.coolstack.util.DBConnection.getConnection();
                     Statement stmt = conn.createStatement()) {
                    
                    // 1. Total Orders Today
                    ResultSet rs1 = stmt.executeQuery("SELECT COUNT(*) FROM orders WHERE DATE(order_date) = CURRENT_DATE()");
                    if (rs1.next()) totalOrdersToday = rs1.getInt(1);

                    // 2. Revenue Today
                    ResultSet rs2 = stmt.executeQuery("SELECT SUM(total_amount) FROM orders WHERE DATE(order_date) = CURRENT_DATE()");
                    if (rs2.next() && rs2.getBigDecimal(1) != null) revenueToday = rs2.getBigDecimal(1);

                    // 3. Processing Count
                    ResultSet rs3 = stmt.executeQuery("SELECT COUNT(*) FROM orders WHERE status IN ('Processing', 'Pending')");
                    if (rs3.next()) processingCount = rs3.getInt(1);

                    // 4. Shipping Count
                    ResultSet rs4 = stmt.executeQuery("SELECT COUNT(*) FROM orders WHERE status IN ('Out for Delivery', 'Shipped')");
                    if (rs4.next()) shippingCount = rs4.getInt(1);
                    
                } catch (Exception e) { 
                    e.printStackTrace(); 
                } 
            %>

            <div class="grid grid-cols-4 gap-6 mb-8">
                <div class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition">
                    <p class="text-gray-400 text-sm">Total Orders (Today)</p>
                    <p class="text-3xl font-black text-emerald-700 mt-1"><%= totalOrdersToday %></p>
                </div>
                <div class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition">
                    <p class="text-gray-400 text-sm">Revenue (Today)</p>
                    <p class="text-3xl font-black text-teal-600 mt-1"><%= nf.format(revenueToday) %></p>
                </div>
                <div class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition border-l-4 border-orange-400">
                    <p class="text-gray-400 text-sm">Processing</p>
                    <p class="text-3xl font-black text-orange-500 mt-1"><%= processingCount %></p>
                </div>
                <div class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition border-l-4 border-blue-400">
                    <p class="text-gray-400 text-sm">In Transit</p>
                    <p class="text-3xl font-black text-blue-500 mt-1"><%= shippingCount %></p>
                </div>
            </div>

            <div class="bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden">
                <div class="p-6 border-b border-gray-100 bg-gray-50 flex justify-between items-center">
                    <h2 class="text-xl font-black text-gray-800">Order Logs</h2>
                    <button class="bg-emerald-100 text-emerald-700 px-4 py-1.5 rounded-full text-xs font-bold hover:bg-emerald-200 transition">
                        📥 Export CSV
                    </button>
                </div>
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="text-xs uppercase text-gray-400 border-b border-gray-100 bg-white">
                                <th class="px-6 py-4 font-bold tracking-wider">Order ID</th>
                                <th class="px-6 py-4 font-bold tracking-wider">Customer</th>
                                <th class="px-6 py-4 font-bold tracking-wider">Date & Time</th>
                                <th class="px-6 py-4 font-bold tracking-wider">Items Summary</th>
                                <th class="px-6 py-4 font-bold tracking-wider">Amount</th>
                                <th class="px-6 py-4 font-bold tracking-wider">Status</th>
                                <th class="px-6 py-4 font-bold tracking-wider text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody id="orderTableBody" class="text-sm">
                            </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script>
        var orders = [
            <% 
                try (Connection conn = com.coolstack.util.DBConnection.getConnection();
                     Statement stmt = conn.createStatement()) {
                    String query = "SELECT o.id, c.shop_name, o.order_date, o.total_amount, o.status " +
                                   "FROM orders o JOIN customers c ON o.customer_id = c.id " +
                                   "ORDER BY o.order_date DESC";
                    ResultSet rsOrd = stmt.executeQuery(query);
                    while (rsOrd.next()) {
                        String status = rsOrd.getString("status");
                        String color = "bg-gray-100 text-gray-600";
                        if (status.equals("Processing") || status.equals("Pending")) color = "bg-orange-100 text-orange-600";
                        else if (status.equals("Shipped") || status.equals("Out for Delivery")) color = "bg-blue-100 text-blue-600";
                        else if (status.equals("Delivered")) color = "bg-green-100 text-green-600";
                        else color = "bg-red-100 text-red-600";

                        // Escape single quotes in shop names to prevent JS breaks
                        String shopName = rsOrd.getString("shop_name").replace("'", "\\'");
            %>
                { 
                    id: '#ORD-<%= rsOrd.getInt("id") %>', 
                    customer: '<%= shopName %>', 
                    date: '<%= rsOrd.getTimestamp("order_date") %>', 
                    items: 'Check Details', 
                    amount: '₹<%= rsOrd.getBigDecimal("total_amount") %>', 
                    status: '<%= status %>', 
                    statusColor: '<%= color %>' 
                },
            <% 
                    }
                } catch (Exception e) { e.printStackTrace(); }
            %>
        ];

        function buildOrderTable(data) {
            var tbody = document.getElementById('orderTableBody');
            tbody.innerHTML = '';
            data.forEach(function(o) {
                var tr = document.createElement('tr');
                tr.className = 'border-b border-gray-50 hover:bg-gray-50/50 transition';
                tr.setAttribute('data-status', o.status);
                tr.setAttribute('data-id', o.id.toLowerCase());

                tr.innerHTML = `
                    <td class="px-6 py-4 font-black text-gray-800">\${o.id}</td>
                    <td class="px-6 py-4 font-semibold text-gray-700">\${o.customer}</td>
                    <td class="px-6 py-4 text-gray-500 text-xs">\${o.date}</td>
                    <td class="px-6 py-4 text-gray-500 text-xs truncate max-w-[150px]" title="\${o.items}">\${o.items}</td>
                    <td class="px-6 py-4 font-black text-emerald-600">\${o.amount}</td>
                    <td class="px-6 py-4">
                        <span class="px-3 py-1 rounded-full text-xs font-bold \${o.statusColor}">\${o.status}</span>
                    </td>
                    <td class="px-6 py-4 text-center">
                        <button class="text-gray-400 hover:text-emerald-600 transition p-2 bg-white rounded-full shadow-sm border border-gray-100" title="View Details">👁️</button>
                    </td>
                `;
                tbody.appendChild(tr);
            });
        }

        function filterOrders() {
            var q = document.getElementById('searchInput').value.toLowerCase();
            var status = document.getElementById('statusFilter').value;
            var rows = document.querySelectorAll('#orderTableBody tr');

            rows.forEach(function(row) {
                var matchId = row.getAttribute('data-id').indexOf(q) !== -1;
                var matchStatus = status === 'all' || row.getAttribute('data-status') === status;
                row.style.display = (matchId && matchStatus) ? '' : 'none';
            });
        }

        buildOrderTable(orders);
    </script>
</body>
</html>