<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Previous Orders | CoolStock</title>
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
                            class="flex items-center gap-3 py-2.5 px-4 rounded-xl hover:bg-orange-600 transition font-semibold text-sm"><span>🏠</span>
                            My Orders</a>
                        <a href="previous_orders.jsp"
                            class="flex items-center gap-3 py-2.5 px-4 rounded-xl bg-orange-600 font-semibold text-sm"><span>📜</span>
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
                        <h1 class="text-3xl font-black">📜 Previous Orders</h1>
                        <p class="opacity-80 mt-1">History of your completed deliveries</p>
                    </div>
                    <div class="text-right">
                        <a href="dashboard.jsp"
                            class="bg-white/20 px-4 py-2 rounded-xl text-sm font-semibold hover:bg-white/30 transition">←
                            Dashboard</a>
                    </div>
                </div>

                <% Integer deliveryBoyIdObj=(Integer) session.getAttribute("loggedUserId"); if (deliveryBoyIdObj==null)
                    { response.sendRedirect(request.getContextPath() + "/login.jsp?error=Session Expired" ); return; }
                    int deliveryBoyId=deliveryBoyIdObj; java.util.List<String[]> previousOrders = new
                    java.util.ArrayList<>();

                        try (java.sql.Connection conn = com.coolstack.util.DBConnection.getConnection()) {
                        String sql = "SELECT o.id, o.order_date, o.total_amount, c.shop_name, c.address FROM orders o JOIN customers c ON o.customer_id = c.id WHERE o.delivery_boy_id = ? AND o.status = 'Paid' ORDER BY o.order_date DESC";
                        java.sql.PreparedStatement st = conn.prepareStatement(sql);
                        st.setInt(1, deliveryBoyId);
                        java.sql.ResultSet rs = st.executeQuery();
                        while(rs.next()) {
                        previousOrders.add(new String[]{
                        String.valueOf(rs.getInt("id")),
                        rs.getTimestamp("order_date").toString(),
                        String.valueOf(rs.getBigDecimal("total_amount")),
                        rs.getString("shop_name"),
                        rs.getString("address")
                        });
                        }
                        } catch (Exception e) { e.printStackTrace(); }
                        %>

                        <div class="bg-white rounded-2xl shadow-lg overflow-hidden">
                            <div class="p-6 border-b bg-gray-50 flex justify-between items-center">
                                <h2 class="text-xl font-bold text-gray-800">Completed Deliveries</h2>
                                <span class="bg-green-100 text-green-700 text-sm font-bold px-4 py-1 rounded-full">
                                    <%= previousOrders.size() %> Total
                                </span>
                            </div>
                            <div class="overflow-x-auto">
                                <table class="w-full text-left border-collapse">
                                    <thead>
                                        <tr class="bg-gray-50 text-gray-400 text-xs uppercase font-bold">
                                            <th class="px-6 py-4">Order ID</th>
                                            <th class="px-6 py-4">Date</th>
                                            <th class="px-6 py-4">Customer / Shop</th>
                                            <th class="px-6 py-4 text-right">Amount</th>
                                            <th class="px-6 py-4 text-center">Status</th>
                                        </tr>
                                    </thead>
                                    <tbody class="divide-y divide-gray-100">
                                        <% for(String[] o : previousOrders) { %>
                                            <tr class="hover:bg-gray-50 transition">
                                                <td class="px-6 py-4 font-black text-gray-700">#ORD-<%= o[0] %>
                                                </td>
                                                <td class="px-6 py-4 text-sm text-gray-500">
                                                    <%= o[1].substring(0, 16) %>
                                                </td>
                                                <td class="px-6 py-4">
                                                    <p class="font-bold text-gray-800 text-sm">
                                                        <%= o[3] %>
                                                    </p>
                                                    <p class="text-xs text-gray-400">
                                                        <%= o[4] %>
                                                    </p>
                                                </td>
                                                <td class="px-6 py-4 text-right font-bold text-indigo-600">₹<%= o[2] %>
                                                </td>
                                                <td class="px-6 py-4 text-center">
                                                    <span
                                                        class="bg-green-100 text-green-700 text-xs font-bold px-3 py-1 rounded-full">Paid
                                                        ✅</span>
                                                </td>
                                            </tr>
                                            <% } %>
                                                <% if (previousOrders.isEmpty()) { %>
                                                    <tr>
                                                        <td colspan="5"
                                                            class="px-6 py-10 text-center text-gray-400 italic">
                                                            No previous orders found.
                                                        </td>
                                                    </tr>
                                                    <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
            </div>
        </div>

        <script>
            // No custom logic needed for this history view
        </script>
    </body>

    </html>