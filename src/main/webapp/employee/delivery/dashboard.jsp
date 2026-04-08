<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Delivery Dashboard | CoolStock</title>
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

            <!-- Delivery Sidebar -->
            <div class="w-64 h-screen bg-orange-700 text-white fixed flex flex-col justify-between">
                <div>
                    <div class="p-5 border-b border-orange-600 flex items-center gap-3">
                        <span class="text-2xl">🛵</span>
                        <div>
                            <h2 class="text-lg font-black">CoolStock</h2>
                            <p class="text-xs text-orange-200">Delivery Panel</p>
                        </div>
                    </div>
                    <nav class="mt-4 space-y-1 px-3">
                        <a href="dashboard.jsp"
                            class="flex items-center gap-3 py-2.5 px-4 rounded-xl bg-orange-600 font-semibold text-sm"><span>🏠</span>
                            My Orders</a>
                        <a href="previous_orders.jsp"
                            class="flex items-center gap-3 py-2.5 px-4 rounded-xl hover:bg-orange-600 transition font-semibold text-sm"><span>📜</span>
                            Previous Orders</a>
                        <a href="profile.jsp"
                            class="flex items-center gap-3 py-2.5 px-4 rounded-xl hover:bg-orange-600 transition font-semibold text-sm"><span>👤</span>
                            My Profile</a>
                    </nav>
                </div>
                <div class="mb-5 px-4">
                    <a href="../../logout.jsp"
                        class="block py-3 px-4 bg-red-600 rounded-xl hover:bg-red-700 transition text-center font-bold text-sm">🚪
                        Logout</a>
                </div>
            </div>

            <div class="ml-64 p-8 w-full">

                <!-- Header -->
                <div
                    class="bg-gradient-to-r from-orange-500 to-red-500 text-white p-7 rounded-2xl mb-8 flex justify-between items-center shadow-lg">
                    <div>
                        <h1 class="text-3xl font-black">🛵 Delivery Dashboard</h1>
                        <p class="opacity-80 mt-1">Your assigned orders for today</p>
                    </div>
                    <div class="text-right">
                        <div id="liveDate" class="text-sm opacity-70"></div>
                        <div id="liveClock" class="text-2xl font-bold mt-1"></div>
                    </div>
                </div>

                <% Integer deliveryBoyIdObj=(Integer) session.getAttribute("loggedUserId"); if (deliveryBoyIdObj==null)
                    { response.sendRedirect(request.getContextPath()
                    + "/login.jsp?error=Session Expired, Please Login Again" ); return; } int
                    deliveryBoyId=deliveryBoyIdObj; int assignedMe=0, deliveredCount=0, transitCount=0;
                    java.math.BigDecimal cashToDeposit=java.math.BigDecimal.ZERO; java.util.List<String[]>
                    assignedOrders = new java.util.ArrayList<>();
                        java.util.List<String[]> cashDepositList = new java.util.ArrayList<>();
                                java.util.List<String[]> cashierList = new java.util.ArrayList<>();

                                        try (java.sql.Connection conn = com.coolstack.util.DBConnection.getConnection())
                                        {
                                        // Stats queries
                                        java.sql.PreparedStatement st1 = conn.prepareStatement("SELECT COUNT(*) FROM orders WHERE delivery_boy_id = ? AND status != 'Paid' AND status != 'Cancelled'");
                                        st1.setInt(1, deliveryBoyId);
                                        java.sql.ResultSet rs1 = st1.executeQuery();
                                        if(rs1.next()) assignedMe = rs1.getInt(1);

                                        java.sql.PreparedStatement st2 = conn.prepareStatement("SELECT COUNT(*) FROM orders WHERE delivery_boy_id = ? AND status = 'Delivered'");
                                        st2.setInt(1, deliveryBoyId);
                                        java.sql.ResultSet rs2 = st2.executeQuery();
                                        if(rs2.next()) deliveredCount = rs2.getInt(1);

                                        java.sql.PreparedStatement st3 = conn.prepareStatement("SELECT COUNT(*) FROM orders WHERE delivery_boy_id = ? AND status = 'Out for Delivery'");
                                        st3.setInt(1, deliveryBoyId);
                                        java.sql.ResultSet rs3 = st3.executeQuery();
                                        if(rs3.next()) transitCount = rs3.getInt(1);

                                        java.sql.PreparedStatement st4 = conn.prepareStatement("SELECT SUM(total_amount) FROM orders WHERE delivery_boy_id = ? AND status = 'Delivered'");
                                        st4.setInt(1, deliveryBoyId);
                                        java.sql.ResultSet rs4 = st4.executeQuery();
                                        if(rs4.next()) cashToDeposit = rs4.getBigDecimal(1) != null ?
                                        rs4.getBigDecimal(1) : java.math.BigDecimal.ZERO;

                                        // Fetch orders list
                                        java.sql.PreparedStatement stO = conn.prepareStatement("SELECT o.id, o.status,o.total_amount, c.shop_name, c.address FROM orders o JOIN customers c ON o.customer_id = c.id WHERE o.delivery_boy_id = ? AND o.status != 'Paid' AND o.status != 'Cancelled' ORDER BY o.id DESC");
                                        stO.setInt(1, deliveryBoyId);
                                        java.sql.ResultSet rsO = stO.executeQuery();
                                        while(rsO.next()) {
                                        assignedOrders.add(new String[]{String.valueOf(rsO.getInt("id")),
                                        rsO.getString("status"), String.valueOf(rsO.getBigDecimal("total_amount")),
                                        rsO.getString("shop_name"), rsO.getString("address")});
                                        if("Delivered".equals(rsO.getString("status"))) {
                                        cashDepositList.add(new String[]{String.valueOf(rsO.getInt("id")),
                                        String.valueOf(rsO.getBigDecimal("total_amount"))});
                                        }
                                        }

                                        // Fetch Cashiers
                                        java.sql.ResultSet rsC = conn.createStatement().executeQuery("SELECT id, name FROM cashiers");
                                        while(rsC.next()) {
                                        cashierList.add(new String[]{String.valueOf(rsC.getInt("id")),
                                        rsC.getString("name")});
                                        }
                                        } catch (Exception e) { e.printStackTrace(); }
                                        %>

                                        <!-- Stats -->
                                        <div class="grid grid-cols-4 gap-6 mb-8">
                                            <div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
                                                <p class="text-gray-400 text-sm">Assigned to Me</p>
                                                <p class="text-3xl font-black text-orange-500 mt-2">
                                                    <%= assignedMe %>
                                                </p>
                                            </div>
                                            <div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
                                                <p class="text-gray-400 text-sm">Delivered</p>
                                                <p class="text-3xl font-black text-green-600 mt-2" id="deliveredCount">
                                                    <%= deliveredCount %>
                                                </p>
                                            </div>
                                            <div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
                                                <p class="text-gray-400 text-sm">In Transit</p>
                                                <p class="text-3xl font-black text-blue-600 mt-2" id="transitCount">
                                                    <%= transitCount %>
                                                </p>
                                            </div>
                                            <div
                                                class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition border-2 border-red-200">
                                                <p class="text-red-500 text-sm font-semibold">Cash to Deposit</p>
                                                <p class="text-3xl font-black text-red-600 mt-2" id="cashCount">₹<%=
                                                        cashToDeposit %>
                                                </p>
                                                <p class="text-red-400 text-xs mt-1">Give to Cashier</p>
                                            </div>
                                        </div>

                                        <!-- ASSIGNED ORDERS -->
                                        <div class="bg-white rounded-2xl shadow-lg overflow-hidden mb-8">
                                            <div class="p-6 border-b bg-orange-50">
                                                <h2 class="text-xl font-bold text-gray-800">📋 My Assigned Orders</h2>
                                                <p class="text-gray-400 text-sm mt-0.5">Pick up, deliver, and mark each
                                                    order complete</p>
                                            </div>
                                            <div class="p-6 space-y-4">

                                                <% if (assignedOrders.isEmpty()) { %>
                                                    <div class="p-10 text-center text-gray-400">
                                                        <div class="text-5xl mb-3">🎉</div>
                                                        <p class="font-semibold text-lg">No assigned orders right now!
                                                        </p>
                                                    </div>
                                                    <% } %>

                                                        <% for(String[] o : assignedOrders) { String status=o[1]; String
                                                            borderClass="border-gray-100" ; String bgClass="" ; String
                                                            statusBadgeClass="bg-gray-100 text-gray-600" ; if ("Out for Delivery".equals(status)) { borderClass="border-blue-200" ;
                                                            bgClass="bg-blue-50" ;
                                                            statusBadgeClass="bg-blue-100 text-blue-700" ; } else
                                                            if("Delivered".equals(status)) {
                                                            borderClass="border-green-200" ; bgClass="bg-green-50" ;
                                                            statusBadgeClass="bg-green-100 text-green-700" ; } %>
                                                            <div class="border-2 <%= borderClass %> rounded-2xl p-5 <%= bgClass %>"
                                                                id="dord-<%= o[0] %>">
                                                                <div class="flex justify-between items-start gap-4">
                                                                    <div>
                                                                        <div class="flex items-center gap-2 mb-1">
                                                                            <span
                                                                                class="font-black text-lg text-gray-800">#ORD-
                                                                                <%= o[0] %>
                                                                            </span>
                                                                            <span
                                                                                class="<%= statusBadgeClass %> text-xs font-bold px-2 py-0.5 rounded-full"
                                                                                id="status-dord-<%= o[0] %>">
                                                                                <%= status %>
                                                                                    <%= "Out for Delivery"
                                                                                        .equals(status) ? "🛵" :
                                                                                        ("Delivered".equals(status)
                                                                                        ? "✅" : "" ) %>
                                                                            </span>
                                                                        </div>
                                                                        <p class="text-sm text-gray-600">🏪 <strong>
                                                                                <%= o[3] %>
                                                                            </strong> — <%= o[4] %>
                                                                        </p>
                                                                        <p
                                                                            class="text-sm font-bold text-indigo-600 mt-1">
                                                                            💰 Collect: ₹<%= o[2] %>
                                                                        </p>
                                                                    </div>
                                                                    <div class="flex flex-col gap-2 min-w-[160px]">
                                                                        <% if ("Processing".equals(status)) { %>
                                                                            <button id="btn-dord-<%= o[0] %>"
                                                                                onclick="startDelivery('<%= o[0] %>')"
                                                                                class="bg-orange-500 text-white py-2 px-4 rounded-xl font-bold text-sm hover:bg-orange-600 transition">
                                                                                🚀 Start Delivery
                                                                            </button>
                                                                            <% } else if ("Out for Delivery".equals(status)) { %>
                                                                                <button id="btn-dord-<%= o[0] %>"
                                                                                    onclick="markDelivered('<%= o[0] %>')"
                                                                                    class="bg-green-500 text-white py-2 px-4 rounded-xl font-bold text-sm hover:bg-green-600 transition">
                                                                                    ✅ Mark Delivered
                                                                                </button>
                                                                                <% } else if
                                                                                    ("Delivered".equals(status)) { %>
                                                                                    <span
                                                                                        class="text-green-600 font-semibold text-sm">✓
                                                                                        Delivered</span>
                                                                                    <% } %>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <% } %>

                                            </div>
                                        </div>

                                        <!-- PENDING CASH TO DEPOSIT -->
                                        <div
                                            class="bg-white rounded-2xl shadow-lg overflow-hidden border-2 border-red-100">
                                            <div class="p-6 border-b bg-red-50 flex justify-between items-center">
                                                <div>
                                                    <h2 class="text-xl font-bold text-red-700">💰 Pending Cash to
                                                        Deposit to Cashier</h2>
                                                    <p class="text-gray-400 text-sm mt-0.5">Hand over all collected cash
                                                        and click "Cash
                                                        Deposited"</p>
                                                </div>
                                                <span
                                                    class="bg-red-500 text-white text-sm font-bold px-4 py-1.5 rounded-full"
                                                    id="cashBadge">
                                                    <%= cashDepositList.size() %>
                                                        Pending
                                                </span>
                                            </div>
                                            <div class="p-6">
                                                <div id="cashList" class="space-y-3">
                                                    <% for(String[] c : cashDepositList) { %>
                                                        <div class="flex justify-between items-center bg-red-50 border border-red-200 rounded-xl p-4"
                                                            id="cash-item-<%= c[0] %>">
                                                            <div>
                                                                <p class="font-bold text-gray-800">#ORD-<%= c[0] %>
                                                                </p>
                                                                <p class="text-red-600 font-black text-lg">₹<%= c[1] %>
                                                                        to deposit</p>
                                                            </div>
                                                            <div class="flex gap-2">
                                                                <select id="cashier-<%= c[0] %>"
                                                                    class="border p-2 rounded-xl text-sm outline-none">
                                                                    <option value="">— Select Cashier —</option>
                                                                    <% for(String[] cashier : cashierList) { %>
                                                                        <option value="<%= cashier[0] %>">
                                                                            <%= cashier[1] %>
                                                                        </option>
                                                                        <% } %>
                                                                </select>
                                                                <button onclick="depositCash('<%= c[0] %>')"
                                                                    class="bg-red-500 text-white px-5 py-2 rounded-xl font-bold hover:bg-red-600 transition text-sm">
                                                                    💵 Cash Deposited
                                                                </button>
                                                            </div>
                                                        </div>
                                                        <% } %>
                                                </div>
                                                <% if (cashDepositList.isEmpty()) { %>
                                                    <div id="noCash" class="text-center py-8 text-gray-400">
                                                        <div class="text-4xl mb-2">💼</div>
                                                        <p class="font-semibold">No cash pending. Deliver orders first!
                                                        </p>
                                                    </div>
                                                    <% } %>
                                            </div>
                                        </div>

            </div>
        </div>

        <div id="toast"
            class="hidden fixed bottom-6 right-6 bg-green-500 text-white px-6 py-3 rounded-2xl shadow-2xl font-semibold z-50">
        </div>

        <script>
            let cashItems = [];
            let deliveredCount = 1;
            let transitCount = 1;

            function showToast(msg, color = 'bg-green-500') {
                const t = document.getElementById('toast');
                t.className = `fixed bottom-6 right-6 text-white px-6 py-3 rounded-2xl shadow-2xl font-semibold z-50 ${color}`;
                t.innerText = msg;
                t.classList.remove('hidden');
                setTimeout(() => t.classList.add('hidden'), 3500);
            }

            function startDelivery(orderId) {
                fetch('<%=request.getContextPath()%>/DeliveryServlet', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'action=start&orderId=' + encodeURIComponent(orderId)
                }).then(async response => {
                    if (response.ok) {
                        showToast('🛵 Delivery started!');
                        setTimeout(() => location.reload(), 1000);
                    } else {
                        const errorMsg = await response.text();
                        alert("Error starting delivery: " + errorMsg);
                    }
                }).catch(err => alert("Network Error: " + err));
            }

            function markDelivered(orderId) {
                fetch('<%=request.getContextPath()%>/DeliveryServlet', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'action=deliver&orderId=' + encodeURIComponent(orderId)
                }).then(async response => {
                    if (response.ok) {
                        showToast('✅ Order marked as Delivered!', 'bg-green-500');
                        setTimeout(() => location.reload(), 1000);
                    } else {
                        const errorMsg = await response.text();
                        alert("Error marking as delivered: " + errorMsg);
                    }
                }).catch(err => alert("Network Error: " + err));
            }

            function depositCash(orderId) {
                const cashierId = document.getElementById('cashier-' + orderId).value;
                if (!cashierId) {
                    alert("Please select a cashier first!");
                    return;
                }
                fetch('<%=request.getContextPath()%>/DeliveryServlet', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'action=deposit&orderId=' + encodeURIComponent(orderId) + '&cashierId=' + encodeURIComponent(cashierId)
                }).then(async response => {
                    if (response.ok) {
                        showToast('💰 Cash deposited to Cashier!', 'bg-blue-500');
                        setTimeout(() => location.reload(), 1000);
                    } else {
                        const errorMsg = await response.text();
                        alert("Error depositing cash: " + errorMsg);
                    }
                }).catch(err => alert("Network Error: " + err));
            }

            setInterval(() => {
                const now = new Date();
                const clock = document.getElementById('liveClock');
                if (clock) clock.innerText = String(now.getHours()).padStart(2, '0') + ':' + String(now.getMinutes()).padStart(2, '0') + ':' + String(now.getSeconds()).padStart(2, '0');
                const date = document.getElementById('liveDate');
                if (date) date.innerText = now.toDateString();
            }, 1000);
        </script>
    </body>

    </html>