<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Manager Dashboard | CoolStock</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&display=swap" rel="stylesheet">
        <style>
            body {
                font-family: 'Outfit', sans-serif;
            }
        </style>
    </head>

    <body class="bg-gray-100 min-h-screen">
        <div class="flex">

            <%@ include file="sidebar.jsp" %>

                <div class="ml-64 p-8 w-full">

                    <!-- Header -->
                    <div
                        class="bg-gradient-to-r from-indigo-600 to-purple-600 text-white p-7 rounded-2xl mb-8 flex justify-between items-center shadow-lg">
                        <div>
                            <h1 class="text-3xl font-black">📊 Manager Dashboard</h1>
                            <p class="opacity-80 mt-1">Receive orders and assign them to Delivery Boys</p>
                        </div>
                        <div class="text-right">
                            <div id="liveDate" class="text-sm opacity-70"></div>
                            <div id="liveClock" class="text-2xl font-bold mt-1"></div>
                        </div>
                    </div>

                    <% int tNew=0, tAsn=0, tDelTody=0, tTotToday=0; java.util.List<String[]> deliveryBoysList = new
                        java.util.ArrayList<>();
                            try (java.sql.Connection conn=com.coolstack.util.DBConnection.getConnection();
                            java.sql.Statement stmt=conn.createStatement()) {
                            java.sql.ResultSet rs=stmt.executeQuery("select count(*) from orders where status='Pending'" );
                            if(rs.next()) tNew=rs.getInt(1);
                            rs=stmt.executeQuery( "SELECT COUNT(*) FROM orders WHERE status='Processing' OR status='Shipped' OR status='Out for Delivery'" );
                            if(rs.next()) tAsn=rs.getInt(1);
                            rs=stmt.executeQuery( "SELECT COUNT(*) FROM orders WHERE status='Delivered' AND DATE(order_date)=CURDATE()" );
                            if(rs.next()) tDelTody=rs.getInt(1);
                            rs=stmt.executeQuery( "SELECT COUNT(*) FROM orders WHERE DATE(order_date)=CURDATE()" );
                            if(rs.next()) tTotToday=rs.getInt(1);

                            rs=stmt.executeQuery("SELECT id, name FROM delivery_boys");
                            while(rs.next()) {
                            deliveryBoysList.add(new String[]{String.valueOf(rs.getInt("id")), rs.getString("name")});
                            }
                            } catch(Exception e) { e.printStackTrace(); } %>

                            <!-- Stats -->
                            <div class="grid grid-cols-4 gap-6 mb-8">
                                <div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
                                    <p class="text-gray-400 text-sm">New Orders</p>
                                    <p class="text-3xl font-black text-orange-500 mt-2" id="stat-new">
                                        <%= tNew %>
                                    </p>
                                    <p class="text-orange-400 text-xs mt-1">Not yet assigned</p>
                                </div>
                                <div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
                                    <p class="text-gray-400 text-sm">Assigned</p>
                                    <p class="text-3xl font-black text-blue-600 mt-2">
                                        <%= tAsn %>
                                    </p>
                                    <p class="text-blue-400 text-xs mt-1">Delivery in progress</p>
                                </div>
                                <div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
                                    <p class="text-gray-400 text-sm">Delivered Today</p>
                                    <p class="text-3xl font-black text-green-600 mt-2">
                                        <%= tDelTody %>
                                    </p>
                                    <p class="text-green-400 text-xs mt-1">Cash collection pending</p>
                                </div>
                                <div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
                                    <p class="text-gray-400 text-sm">Total Orders Today</p>
                                    <p class="text-3xl font-black text-indigo-600 mt-2">
                                        <%= tTotToday %>
                                    </p>
                                </div>
                            </div>

                            <!-- PENDING ORDERS — ASSIGN TO DELIVERY BOY -->
                            <div class="bg-white rounded-2xl shadow-lg overflow-hidden mb-8">
                                <div class="flex justify-between items-center p-6 border-b bg-orange-50">
                                    <div>
                                        <h2 class="text-xl font-bold text-gray-800">⏳ Pending Orders — Assign to
                                            Delivery
                                            Boy</h2>
                                        <p class="text-gray-400 text-sm mt-0.5">These orders are placed by customers and
                                            need to be assigned</p>
                                    </div>
                                    <span class="bg-gray-500 text-white text-sm font-bold px-4 py-1.5 rounded-full"
                                        id="pendingBadge">
                                        Will Auto-populate
                                    </span>
                                </div>

                                <% int pCount=0; try (java.sql.Connection
                                    conn=com.coolstack.util.DBConnection.getConnection(); java.sql.Statement
                                    stmt=conn.createStatement(); java.sql.ResultSet
                                    rs=stmt.executeQuery( "SELECT o.id, c.shop_name, o.total_amount, o.order_date "
                                    + "FROM orders o JOIN customers c ON o.customer_id = c.id "
                                    + "WHERE o.status = 'Pending'" )) { %>
                                    <div class='p-6 space-y-4' id='pendingOrdersList'>
                                        <% while(rs.next()) { pCount++; int orderId=rs.getInt("id"); String
                                            shopName=rs.getString("shop_name"); java.math.BigDecimal
                                            totalAmt=rs.getBigDecimal("total_amount"); java.sql.Timestamp
                                            ordDate=rs.getTimestamp("order_date"); %>
                                            <div class="border-2 border-orange-100 rounded-2xl p-5 hover:border-orange-300 transition"
                                                id="order-<%= orderId %>">
                                                <div class="flex justify-between items-start gap-4">
                                                    <div>
                                                        <div class="flex items-center gap-2 mb-1">
                                                            <span class="font-black text-gray-800 text-lg">#ORD-<%=
                                                                    orderId %></span>
                                                            <span
                                                                class="bg-orange-100 text-orange-700 text-xs font-bold px-2 py-0.5 rounded-full">Pending</span>
                                                        </div>
                                                        <p class="text-sm text-gray-600">🏪 <span class="font-semibold">
                                                                <%= shopName %>
                                                            </span></p>
                                                        <p class="text-sm text-indigo-600 font-semibold mt-1">💰 Total:
                                                            ₹<%= totalAmt %>
                                                        </p>
                                                        <p class="text-xs text-gray-400 mt-1">📅 Placed: <%= ordDate %>
                                                        </p>
                                                    </div>
                                                    <div class="flex flex-col gap-2 min-w-[200px]">
                                                        <select id="delivery-<%= orderId %>"
                                                            class="border-2 border-gray-200 p-2 rounded-xl text-sm focus:border-indigo-400 outline-none">
                                                            <option value="">— Select Delivery Boy —</option>
                                                            <% for(String[] d : deliveryBoysList) { %>
                                                                <option value="<%= d[0] %>">🛵 <%= d[1] %>
                                                                </option>
                                                                <% } %>
                                                        </select>
                                                        <button
                                                            onclick="assignOrder('order-<%= orderId %>', '#ORD-<%= orderId %>', 'delivery-<%= orderId %>')"
                                                            class="bg-indigo-600 text-white py-2 rounded-xl font-bold text-sm hover:bg-indigo-700 transition">
                                                            📌 Assign Order
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                            <% } %>
                                    </div>

                                    <% if (pCount==0) { %>
                                        <div id='allAssigned' class='p-10 text-center text-gray-400'>
                                            <div class='text-5xl mb-3'>🎉</div>
                                            <p class='font-semibold text-lg'>All orders have been assigned!</p>
                                        </div>
                                        <% } else { %>
                                            <div id='allAssigned' class='hidden p-10 text-center text-gray-400'>
                                                <div class='text-5xl mb-3'>🎉</div>
                                                <p class='font-semibold text-lg'>All orders have been assigned!</p>
                                            </div>
                                            <% } %>

                                                <% } catch(Exception e) { e.printStackTrace(); } %>
                            </div>

                            <!-- ONGOING ASSIGNED ORDERS -->
                            <div class="bg-white rounded-2xl shadow-lg overflow-hidden">
                                <div class="p-6 border-b">
                                    <h2 class="text-xl font-bold text-gray-800">🛵 Ongoing Assigned Orders</h2>
                                </div>
                                <table class="w-full text-sm" id="assignedTable">
                                    <thead class="bg-gray-50 text-gray-500 uppercase text-xs">
                                        <tr>
                                            <th class="py-3 px-6 text-left">Order ID</th>
                                            <th class="px-6 text-left">Customer</th>
                                            <th class="px-6 text-left">Amount</th>
                                            <th class="px-6 text-left">Assigned To</th>
                                            <th class="px-6 text-left">Status</th>
                                        </tr>
                                    </thead>
                                    <tbody class="text-gray-700" id="assignedBody">
                                        <% try (java.sql.Connection
                                            conn=com.coolstack.util.DBConnection.getConnection(); java.sql.Statement
                                            stmt=conn.createStatement(); java.sql.ResultSet
                                            rs=stmt.executeQuery( "SELECT o.id, c.shop_name, o.total_amount, o.status "
                                            + "FROM orders o JOIN customers c ON o.customer_id = c.id "
                                            + "WHERE o.status IN ('Processing', 'Shipped', 'Out for Delivery')" )) {
                                            while(rs.next()) { %>
                                            <tr class="border-b hover:bg-gray-50">
                                                <td class="py-3 px-6 font-bold">#ORD-<%= rs.getInt("id") %>
                                                </td>
                                                <td class="px-6">
                                                    <%= rs.getString("shop_name") %>
                                                </td>
                                                <td class="px-6 font-semibold text-indigo-600">₹<%=
                                                        rs.getBigDecimal("total_amount") %>
                                                </td>
                                                <td class="px-6">🛵 Auto Assigned</td>
                                                <td class="px-6"><span
                                                        class="bg-blue-100 text-blue-700 px-2 py-0.5 rounded-full text-xs font-bold">
                                                        <%= rs.getString("status") %>
                                                    </span></td>
                                            </tr>
                                            <% } } catch(Exception e) { e.printStackTrace(); } %>
                                    </tbody>
                                </table>
                            </div>

                </div>
        </div>

        <div id="toast"
            class="hidden fixed bottom-6 right-6 bg-green-500 text-white px-6 py-3 rounded-2xl shadow-2xl font-semibold z-50">
        </div>

        <script>
            let pendingCount = -1;

            function assignOrder(cardId, orderId, selectId) {
                const sel = document.getElementById(selectId);
                const deliveryBoyId = sel.value;
                const deliveryBoyName = sel.options[sel.selectedIndex].text;
                if (!deliveryBoyId) { alert('Please select a Delivery Boy first!'); return; }

                if (pendingCount === -1) {
                    pendingCount = document.querySelectorAll("[id^='order-']").length;
                }

                const actualOrderIdStr = orderId.replace('#ORD-', '');

                fetch('<%=request.getContextPath()%>/AssignOrderServlet', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'orderId=' + encodeURIComponent(actualOrderIdStr) + '&deliveryBoyId=' + encodeURIComponent(deliveryBoyId)
                }).then(response => {
                    if (response.ok) {
                        // Hide the pending card
                        document.getElementById(cardId).style.display = 'none';
                        pendingCount--;
                        document.getElementById('stat-new').innerText = pendingCount;
                        document.getElementById('pendingBadge').innerText = pendingCount + ' Unassigned';
                        if (pendingCount <= 0) document.getElementById('allAssigned').classList.remove('hidden');

                        // Add to assigned table
                        const tbody = document.getElementById('assignedBody');
                        const row = document.createElement('tr');
                        row.className = 'border-b hover:bg-gray-50 bg-green-50';
                        row.innerHTML = `
                            <td class="py-3 px-6 font-bold">${orderId}</td>
                            <td class="px-6">—</td><td class="px-6 font-semibold text-indigo-600">—</td>
                            <td class="px-6">${deliveryBoyName}</td>
                            <td class="px-6"><span class="bg-blue-100 text-blue-700 px-2 py-0.5 rounded-full text-xs font-bold">Processing</span></td>
                        `;
                        tbody.prepend(row);

                        showToast('📌 ' + orderId + ' assigned successfully!');
                    } else {
                        alert("Failed to assign order due to server error");
                    }
                }).catch(err => {
                    alert("Network error: " + err);
                });
            }

            function showToast(msg) {
                const t = document.getElementById('toast');
                t.innerText = msg; t.classList.remove('hidden');
                setTimeout(() => t.classList.add('hidden'), 3500);
            }

            setInterval(() => {
                const now = new Date();
                document.getElementById('liveClock').innerText = String(now.getHours()).padStart(2, '0') + ':' + String(now.getMinutes()).padStart(2, '0') + ':' + String(now.getSeconds()).padStart(2, '0');
                document.getElementById('liveDate').innerText = now.toDateString();
            }, 1000);
        </script>
    </body>

    </html>