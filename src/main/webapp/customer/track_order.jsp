<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="java.sql.*" %>
        <%@ page import="com.coolstack.util.DBConnection" %>
            <%@ page import="java.util.*" %>
                <%@ page import="java.math.BigDecimal" %>
                    <%@ page import="java.text.SimpleDateFormat" %>
                        <% Integer userId=(Integer) session.getAttribute("loggedUserId"); if (userId==null) {
                            response.sendRedirect("../login.jsp"); return; } int customerId=0; String shopName="" ;
                            String address="" ; List<Map<String, Object>> userOrders = new ArrayList<>();
                                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy hh:mm a");

                                try {
                                Connection conn = DBConnection.getConnection();

                                String sqlCust = "SELECT id, shop_name, address FROM customers WHERE id = ?";
                                PreparedStatement ps = conn.prepareStatement(sqlCust);
                                ps.setInt(1, userId);
                                ResultSet rs = ps.executeQuery();
                                if (rs.next()) {
                                customerId = rs.getInt("id");
                                shopName = rs.getString("shop_name");
                                address = rs.getString("address");
                                }
                                rs.close();
                                ps.close();

                                String sqlOrd = "SELECT id, total_amount, status, order_date ";
                                sqlOrd += "FROM orders WHERE customer_id = ? ";
                                sqlOrd += "ORDER BY order_date DESC";
                                PreparedStatement psOrd = conn.prepareStatement(sqlOrd);
                                psOrd.setInt(1, customerId);
                                ResultSet rsOrd = psOrd.executeQuery();
                                while (rsOrd.next()) {
                                Map<String, Object> ord = new HashMap<>();
                                        int orderId = rsOrd.getInt("id");
                                        ord.put("id", orderId);
                                        ord.put("total_amount", rsOrd.getBigDecimal("total_amount"));
                                        ord.put("status", rsOrd.getString("status"));

                                        Timestamp ts = rsOrd.getTimestamp("order_date");
                                        ord.put("order_date", ts != null ? sdf.format(ts) : "");
                                        ord.put("shop_name", shopName);
                                        ord.put("address", address);

                                        StringBuilder itemsStr = new StringBuilder();

                                        String sqlItems = "SELECT p.name, oi.quantity FROM order_items oi ";
                                        sqlItems += "JOIN products p ON oi.product_id = p.id ";
                                        sqlItems += "WHERE oi.order_id = ?";
                                        PreparedStatement psItems = conn.prepareStatement(sqlItems);
                                        psItems.setInt(1, orderId);
                                        ResultSet rsItems = psItems.executeQuery();
                                        while (rsItems.next()) {
                                        if (itemsStr.length() > 0) {
                                        itemsStr.append(" | ");
                                        }
                                        itemsStr.append("📦 ")
                                        .append(rsItems.getString("name"))
                                        .append(" x ")
                                        .append(rsItems.getInt("quantity"));
                                        }
                                        rsItems.close();
                                        psItems.close();

                                        ord.put("items_desc", itemsStr.toString());
                                        userOrders.add(ord);
                                        }
                                        rsOrd.close();
                                        psOrd.close();

                                        conn.close();
                                        } catch(Exception e) {
                                        e.printStackTrace();
                                        }
                                        %>

                                        <!DOCTYPE html>
                                        <html>

                                        <head>
                                            <meta charset="UTF-8">
                                            <title>Track Orders | CoolStock</title>
                                            <script src="https://cdn.tailwindcss.com"></script>
                                            <link
                                                href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&display=swap"
                                                rel="stylesheet">
                                            <style>
                                                body {
                                                    font-family: 'Outfit', sans-serif;
                                                }
                                            </style>
                                        </head>

                                        <body class="bg-gray-100 min-h-screen">
                                            <nav
                                                class="bg-white shadow-sm sticky top-0 z-40 px-6 py-3 flex justify-between items-center">
                                                <div class="flex items-center gap-2">
                                                    <span class="text-3xl">🍦</span>
                                                    <div>
                                                        <span class="text-xl font-black text-gray-800">CoolStock</span>
                                                        <span class="text-xs text-gray-400 ml-2">Customer</span>
                                                    </div>
                                                </div>
                                                <div class="flex gap-4 text-sm font-semibold">
                                                    <a href="place_order.jsp"
                                                        class="text-gray-500 hover:text-purple-600 transition">📦 Place
                                                        Order</a>
                                                    <a href="track_order.jsp"
                                                        class="text-purple-600 border-b-2 border-purple-600 pb-0.5">📍
                                                        Track Orders</a>
                                                    <a href="profile.jsp"
                                                        class="text-gray-500 hover:text-purple-600 transition">👤 My
                                                        Profile</a>
                                                </div>
                                                <a href="../logout.jsp"
                                                    class="bg-red-100 text-red-600 px-4 py-2 rounded-xl text-sm font-semibold">🚪
                                                    Logout</a>
                                            </nav>

                                            <div class="max-w-4xl mx-auto px-6 py-8">
                                                <div
                                                    class="bg-gradient-to-r from-purple-600 to-pink-500 text-white p-7 rounded-2xl mb-8 shadow-lg">
                                                    <h1 class="text-3xl font-black">📍 Track My Orders</h1>
                                                    <p class="opacity-80 mt-1">Live status of your bulk orders.</p>
                                                </div>

                                                <div id="ordersContainer" class="space-y-6">
                                                    <% if(userOrders.isEmpty()) { %>
                                                        <div class="text-center py-16 bg-white rounded-2xl shadow">
                                                            <div class="text-7xl mb-4">📦</div>
                                                            <h2 class="text-2xl font-bold text-gray-700 mb-2">No Orders
                                                                Yet</h2>
                                                            <p class="text-gray-400 mb-6">Place your first bulk order
                                                                for your shop.</p>
                                                            <a href="place_order.jsp"
                                                                class="px-8 py-3 bg-purple-600 text-white font-bold rounded-2xl">Place
                                                                Order</a>
                                                        </div>
                                                        <% } else { for (Map<String, Object> ord : userOrders) {
                                                            int orderId = (Integer) ord.get("id");
                                                            String statusStr = (String) ord.get("status");
                                                            BigDecimal amt = (BigDecimal) ord.get("total_amount");
                                                            String dateStr = (String) ord.get("order_date");
                                                            String itemsDesc = (String) ord.get("items_desc");

                                                            String s = statusStr != null ? statusStr.toUpperCase() : "";
                                                            String color = "bg-orange-100 text-orange-700";
                                                            String icon = "⏳";
                                                            int step = 0;

                                                            if (s.equals("PENDING")) {
                                                            color = "bg-orange-100 text-orange-700"; icon = "⏳"; step =
                                                            0;
                                                            } else if (s.equals("PROCESSING") || s.equals("ASSIGNED")) {
                                                            color = "bg-blue-100 text-blue-700"; icon = "📌"; step = 1;
                                                            } else if (s.equals("SHIPPED") || s.equals("IN TRANSIT") ||
                                                            s.equals("OUT FOR DELIVERY")) {
                                                            color = "bg-indigo-100 text-indigo-700"; icon = "🛵"; step =
                                                            2;
                                                            } else if (s.equals("DELIVERED")) {
                                                            color = "bg-teal-100 text-teal-700"; icon = "📦"; step = 3;
                                                            } else if (s.equals("PAID")) {
                                                            color = "bg-green-100 text-green-700"; icon = "✅"; step = 4;
                                                            }

                                                            String cleanItems = itemsDesc.replace("\"", "&quot;");
                                                            String cleanShop = shopName.replace("\"", "&quot;");
                                                            String cleanAddr = address.replace("\"", "&quot;");
                                                            %>
                                                            <div class="bg-white rounded-2xl shadow-lg p-6">
                                                                <div class="flex justify-between items-start mb-4">
                                                                    <div>
                                                                        <span
                                                                            class="font-black text-xl text-gray-800">#ORD-
                                                                            <%= orderId %>
                                                                        </span>
                                                                        <span
                                                                            class="<%= color %> ml-2 px-3 py-0.5 rounded-full text-xs font-bold">
                                                                            <%= icon %>
                                                                                <%= statusStr %>
                                                                        </span>
                                                                        <p class="text-gray-400 text-xs mt-1">📅 <%=
                                                                                dateStr %>
                                                                        </p>
                                                                    </div>
                                                                    <p class="font-black text-2xl text-purple-700">₹<%=
                                                                            amt %>
                                                                    </p>
                                                                </div>
                                                                <p class="text-sm text-gray-600 mb-1">🏪 <strong>
                                                                        <%= shopName %>
                                                                    </strong> — <%= address %>
                                                                </p>
                                                                <div
                                                                    class="bg-gray-50 rounded-xl p-3 my-4 border border-gray-100">
                                                                    <p class="text-sm font-semibold text-gray-700">
                                                                        <%= itemsDesc %>
                                                                    </p>
                                                                </div>

                                                                <div
                                                                    class="flex w-full items-start mb-5 mt-6 border-t pt-5">
                                                                    <% String[] steps={"Order Placed", "Assigned"
                                                                        , "In Transit" , "Delivered" , "Paid" }; for(int
                                                                        i=0; i<steps.length; i++) { String circleBg=(i
                                                                        <=step) ? "bg-purple-600 text-white"
                                                                        : "bg-gray-100 text-gray-400" ; String
                                                                        strCheck=(i <=step) ? "Y" : "" +(i+1); String
                                                                        textColor=(i <=step) ? "text-purple-700"
                                                                        : "text-gray-400" ; %>
                                                                        <div class="flex flex-col items-center">
                                                                            <div
                                                                                class="w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold mb-1 <%= circleBg %>">
                                                                                <%= strCheck %>
                                                                            </div>
                                                                            <span
                                                                                class="text-[10px] text-center <%= textColor %> font-bold leading-tight"
                                                                                style="max-width:55px;">
                                                                                <%= steps[i] %>
                                                                            </span>
                                                                        </div>
                                                                        <% if(i < steps.length - 1) { String lineBg=(i <
                                                                            step) ? "bg-purple-600" : "bg-gray-100" ; %>
                                                                            <div
                                                                                class="flex-1 mt-4 h-1 <%= lineBg %> mx-1">
                                                                            </div>
                                                                            <% } %>
                                                                                <% } %>
                                                                </div>

                                                                <% if (s.equals("PAID")) { %>
                                                                    <button
                                                                        class="inv-btn w-full py-2.5 bg-emerald-600 text-white font-bold rounded-xl"
                                                                        data-oid="<%= orderId %>"
                                                                        data-shop="<%= cleanShop %>"
                                                                        data-addr="<%= cleanAddr %>"
                                                                        data-items="<%= cleanItems %>"
                                                                        data-amt="<%= amt %>">
                                                                        📄 Download Invoice
                                                                    </button>
                                                                    <% } else { %>
                                                                        <p
                                                                            class="text-center text-xs text-gray-400 bg-gray-50 rounded-xl py-2">
                                                                            Invoice available after payment</p>
                                                                        <% } %>
                                                            </div>
                                                            <% } } %>
                                                </div>
                                            </div>

                                            <!-- Invoice Modal -->
                                            <div id="invModal"
                                                class="hidden fixed inset-0 bg-black/60 flex items-center justify-center z-50 p-4">
                                                <div
                                                    class="bg-white rounded-3xl shadow-2xl w-full max-w-xl overflow-hidden border border-emerald-100">
                                                    <div
                                                        class="bg-emerald-600 text-white p-8 flex justify-between items-center">
                                                        <div>
                                                            <h1 class="text-3xl font-black">🍦 CoolStock</h1>
                                                            <p class="text-sm font-semibold uppercase">Official Invoice
                                                            </p>
                                                        </div>
                                                        <div class="text-right">
                                                            <p id="mi-id" class="font-black text-2xl">INV-000</p>
                                                            <p id="mi-date" class="text-sm"></p>
                                                        </div>
                                                    </div>
                                                    <div class="p-8">
                                                        <div class="flex justify-between mb-6">
                                                            <div>
                                                                <p
                                                                    class="text-[10px] text-gray-400 uppercase font-bold mb-1">
                                                                    Billed To</p>
                                                                <p class="font-black text-lg text-gray-800"
                                                                    id="mi-shop">—</p>
                                                                <p class="text-gray-500 text-xs w-2/3" id="mi-addr">—
                                                                </p>
                                                            </div>
                                                            <div class="text-right">
                                                                <span
                                                                    class="bg-green-100 text-green-700 px-4 py-1.5 rounded-full font-black text-sm border border-green-200">PAID
                                                                    ✅</span>
                                                            </div>
                                                        </div>

                                                        <div
                                                            class="bg-gray-50 border border-gray-100 rounded-xl p-4 mb-5">
                                                            <p class="text-xs font-bold text-gray-500 mb-2 uppercase">
                                                                Authorized Products</p>
                                                            <p class="text-sm font-semibold text-gray-700" id="mi-items"
                                                                style="white-space:pre-wrap">—</p>
                                                        </div>

                                                        <div
                                                            class="bg-emerald-50 border border-emerald-100 rounded-2xl p-5 flex justify-between items-center mb-6">
                                                            <span
                                                                class="font-bold text-gray-700 uppercase text-xs">Total
                                                                Amount Paid</span>
                                                            <span class="text-3xl font-black text-emerald-700">₹<span
                                                                    id="mi-total">0</span></span>
                                                        </div>

                                                        <div class="flex gap-3">
                                                            <button onclick="window.print()"
                                                                class="flex-1 py-3 bg-emerald-600 text-white font-bold rounded-2xl shadow-lg">🖨️
                                                                Print</button>
                                                            <button
                                                                onclick="document.getElementById('invModal').classList.add('hidden')"
                                                                class="px-6 py-3 bg-gray-100 text-gray-700 font-bold rounded-2xl border border-gray-200">Close</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <script>
                                                document.querySelectorAll('.inv-btn').forEach(function (btn) {
                                                    btn.addEventListener('click', function () {
                                                        var d = new Date();
                                                        document.getElementById('mi-id').innerText = 'INV-' + this.getAttribute('data-oid');
                                                        document.getElementById('mi-date').innerText = d.toLocaleDateString();
                                                        document.getElementById('mi-shop').innerText = this.getAttribute('data-shop');
                                                        document.getElementById('mi-addr').innerText = this.getAttribute('data-addr');

                                                        var items = this.getAttribute('data-items').replace(/ \| /g, '\n');
                                                        document.getElementById('mi-items').innerText = items;
                                                        document.getElementById('mi-total').innerText = this.getAttribute('data-amt');

                                                        document.getElementById('invModal').classList.remove('hidden');
                                                    });
                                                });
                                            </script>
                                        </body>

                                        </html>