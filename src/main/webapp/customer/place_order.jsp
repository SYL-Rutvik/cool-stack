<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="java.sql.*" %>
        <%@ page import="com.coolstack.util.DBConnection" %>
            <%@ page import="java.util.*" %>
                <%@ page import="java.math.BigDecimal" %>
                    <% Integer userId=(Integer) session.getAttribute("loggedUserId"); if (userId==null) {
                        response.sendRedirect("../login.jsp"); return; } int customerId=0; String shopName="" ; String
                        address="" ; List<Map<String, Object>> products = new ArrayList<>();
                            String successMsg = null;
                            String errorMsg = null;
                            String newOrderIdStr = null;

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

                            String getProdSql = "SELECT id, name, category, price, stock_quantity ";
                            getProdSql += "FROM products WHERE stock_quantity > 0 ";
                            getProdSql += "ORDER BY category DESC, name ASC";

                            Statement st = conn.createStatement();
                            ResultSet prs = st.executeQuery(getProdSql);
                            while (prs.next()) {
                            Map<String, Object> p = new HashMap<>();
                                    p.put("id", prs.getInt("id"));
                                    p.put("name", prs.getString("name"));
                                    p.put("category", prs.getString("category"));
                                    p.put("price", prs.getBigDecimal("price"));
                                    p.put("stock_quantity", prs.getInt("stock_quantity"));
                                    products.add(p);
                                    }
                                    prs.close();
                                    st.close();

                                    String reqMethod = request.getMethod();
                                    String action = request.getParameter("action");

                                    if ("POST".equalsIgnoreCase(reqMethod) && "placeOrder".equals(action)) {
                                    conn.setAutoCommit(false);
                                    try {
                                    BigDecimal totalAmount = BigDecimal.ZERO;
                                    List<Integer> orderProdIds = new ArrayList<>();
                                            List<Integer> orderQtys = new ArrayList<>();
                                                    List<BigDecimal> orderPrices = new ArrayList<>();

                                                            for (Map<String, Object> p : products) {
                                                                int pid = (Integer) p.get("id");
                                                                String qtyStr = request.getParameter("qty_" + pid);
                                                                if (qtyStr != null && !qtyStr.trim().isEmpty()) {
                                                                int qty = Integer.parseInt(qtyStr);
                                                                if (qty > 0) {
                                                                BigDecimal price = (BigDecimal) p.get("price");
                                                                totalAmount = totalAmount.add(price.multiply(new
                                                                BigDecimal(qty)));

                                                                orderProdIds.add(pid);
                                                                orderQtys.add(qty);
                                                                orderPrices.add(price);
                                                                }
                                                                }
                                                                }

                                                                if (totalAmount.compareTo(BigDecimal.ZERO) > 0) {
                                                                int finalOrdId = 0;
                                                                String insOrdSql = "INSERT INTO orders (customer_id,total_amount, status) VALUES (?, ?, 'Pending')";
                                                                PreparedStatement inPs =
                                                                conn.prepareStatement(insOrdSql,
                                                                Statement.RETURN_GENERATED_KEYS);
                                                                inPs.setInt(1, customerId);
                                                                inPs.setBigDecimal(2, totalAmount);
                                                                inPs.executeUpdate();

                                                                ResultSet keysRs = inPs.getGeneratedKeys();
                                                                if (keysRs.next()) {
                                                                finalOrdId = keysRs.getInt(1);
                                                                }
                                                                keysRs.close();
                                                                inPs.close();

                                                                if (finalOrdId > 0) {
                                                                String insItemSql = "INSERT INTO order_items (order_id,product_id, quantity, unit_price, subtotal) ";
                                                                insItemSql += "VALUES (?, ?, ?, ?, ?)";

                                                                PreparedStatement inItemPs =
                                                                conn.prepareStatement(insItemSql);
                                                                for (int i = 0; i < orderProdIds.size(); i++) {
                                                                    inItemPs.setInt(1, finalOrdId); inItemPs.setInt(2,
                                                                    orderProdIds.get(i)); inItemPs.setInt(3,
                                                                    orderQtys.get(i)); inItemPs.setBigDecimal(4,
                                                                    orderPrices.get(i)); inItemPs.setBigDecimal(5,
                                                                    orderPrices.get(i).multiply(new
                                                                    BigDecimal(orderQtys.get(i))));
                                                                    inItemPs.executeUpdate(); } inItemPs.close();
                                                                    conn.commit();
                                                                    successMsg="Order placed successfully!" ;
                                                                    newOrderIdStr="#ORD-" + finalOrdId; } else {
                                                                    conn.rollback();
                                                                    errorMsg="Failed to create order tracking ID." ; } }
                                                                    else { errorMsg="Your cart is empty." ; } } catch
                                                                    (Exception ex) { conn.rollback();
                                                                    errorMsg="Database error while placing order." ;
                                                                    ex.printStackTrace(); } finally {
                                                                    conn.setAutoCommit(true); } } conn.close(); } catch
                                                                    (Exception e) { errorMsg="System Error: " +
                                                                    e.getMessage(); } %>

                                                                    <!DOCTYPE html>
                                                                    <html>

                                                                    <head>
                                                                        <meta charset="UTF-8">
                                                                        <title>Place Bulk Order | CoolStock</title>
                                                                        <script
                                                                            src="https://cdn.tailwindcss.com"></script>
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
                                                                                <div><span
                                                                                        class="text-xl font-black text-gray-800">CoolStock</span><span
                                                                                        class="text-xs text-gray-400 ml-2">Customer</span>
                                                                                </div>
                                                                            </div>
                                                                            <div
                                                                                class="flex gap-4 text-sm font-semibold">
                                                                                <a href="place_order.jsp"
                                                                                    class="text-purple-600 border-b-2 border-purple-600 pb-0.5">📦
                                                                                    Place Order</a>
                                                                                <a href="track_order.jsp"
                                                                                    class="text-gray-500 hover:text-purple-600 transition">📍
                                                                                    Track Orders</a>
                                                                                <a href="profile.jsp"
                                                                                    class="text-gray-500 hover:text-purple-600 transition">👤
                                                                                    My Profile</a>
                                                                            </div>
                                                                            <a href="../logout.jsp"
                                                                                class="bg-red-100 text-red-600 px-4 py-2 rounded-xl font-semibold text-sm">🚪
                                                                                Logout</a>
                                                                        </nav>

                                                                        <div
                                                                            class="max-w-6xl mx-auto px-6 py-8 flex gap-8">
                                                                            <div class="w-2/3">
                                                                                <div
                                                                                    class="bg-gradient-to-r from-purple-600 to-pink-500 text-white p-7 rounded-2xl mb-8 shadow-lg">
                                                                                    <h1 class="text-3xl font-black">📦
                                                                                        Buy Wholesale</h1>
                                                                                    <p class="opacity-80 mt-1">Order
                                                                                        your shop's inventory below.
                                                                                        Prices dynamically fetch from
                                                                                        CoolStock.</p>
                                                                                </div>

                                                                                <% if (errorMsg !=null) { %>
                                                                                    <div
                                                                                        class="bg-red-100 border border-red-300 text-red-700 px-6 py-4 rounded-2xl mb-6 font-bold flex justify-between shadow-sm">
                                                                                        <span>⚠️ <%= errorMsg %></span>
                                                                                        <button
                                                                                            onclick="this.parentElement.style.display='none'">✖</button>
                                                                                    </div>
                                                                                    <% } %>

                                                                                        <form id="orderForm"
                                                                                            method="POST"
                                                                                            action="place_order.jsp">
                                                                                            <input type="hidden"
                                                                                                name="action"
                                                                                                value="placeOrder">

                                                                                            <div
                                                                                                class="flex justify-between items-center mb-6">
                                                                                                <h2
                                                                                                    class="text-2xl font-black text-gray-800">
                                                                                                    Wholesale Catalog
                                                                                                </h2>
                                                                                                <span
                                                                                                    class="bg-purple-100 text-purple-700 px-4 py-2 rounded-xl text-sm font-bold">🏪
                                                                                                    <%= shopName %>
                                                                                                </span>
                                                                                            </div>

                                                                                            <div
                                                                                                class="grid grid-cols-2 gap-4">
                                                                                                <% for (Map<String,
                                                                                                    Object> p :
                                                                                                    products) {
                                                                                                    int pId = (Integer)
                                                                                                    p.get("id");
                                                                                                    String pName =
                                                                                                    (String)
                                                                                                    p.get("name");
                                                                                                    String pCat =
                                                                                                    (String)
                                                                                                    p.get("category");
                                                                                                    BigDecimal pPrice =
                                                                                                    (BigDecimal)
                                                                                                    p.get("price");
                                                                                                    int stock =
                                                                                                    (Integer)
                                                                                                    p.get("stock_quantity");

                                                                                                    String bgCol =
                                                                                                    "bg-white";
                                                                                                    String icn = "🍦";
                                                                                                    if
                                                                                                    ("Cone".equals(pCat))
                                                                                                    icn = "🍦";
                                                                                                    else if
                                                                                                    ("Cup".equals(pCat))
                                                                                                    icn = "🍧";
                                                                                                    else if ("FamilyPack".equals(pCat))
                                                                                                    icn = "🍨";
                                                                                                    else if
                                                                                                    ("Stick".equals(pCat))
                                                                                                    icn = "🍭";
                                                                                                    %>
                                                                                                    <div
                                                                                                        class="<%= bgCol %> p-5 rounded-2xl shadow-sm border border-gray-100 flex gap-4 hover:shadow-md transition">
                                                                                                        <div
                                                                                                            class="w-16 h-16 bg-purple-50 rounded-2xl flex items-center justify-center text-3xl flex-shrink-0">
                                                                                                            <%= icn %>
                                                                                                        </div>
                                                                                                        <div
                                                                                                            class="flex-1">
                                                                                                            <h3
                                                                                                                class="font-black text-gray-800 text-lg leading-tight">
                                                                                                                <%= pName
                                                                                                                    %>
                                                                                                            </h3>
                                                                                                            <p
                                                                                                                class="text-xs text-gray-400 mb-2 font-semibold uppercase tracking-wider">
                                                                                                                <%= pCat
                                                                                                                    %>
                                                                                                            </p>
                                                                                                            <div
                                                                                                                class="flex justify-between items-end mt-3">
                                                                                                                <div>
                                                                                                                    <p
                                                                                                                        class="font-black text-purple-700 text-xl">
                                                                                                                        ₹
                                                                                                                        <%= pPrice
                                                                                                                            %>
                                                                                                                    </p>
                                                                                                                    <p
                                                                                                                        class="text-[10px] text-gray-400">
                                                                                                                        Stock:
                                                                                                                        <span
                                                                                                                            class="font-bold text-gray-600">
                                                                                                                            <%= stock
                                                                                                                                %>
                                                                                                                        </span>
                                                                                                                        left
                                                                                                                    </p>
                                                                                                                </div>
                                                                                                                <div
                                                                                                                    class="flex items-center gap-2 bg-gray-50 rounded-xl p-1 border border-gray-200">
                                                                                                                    <button
                                                                                                                        type="button"
                                                                                                                        onclick="changeQty(<%= pId %>, -1, <%= stock %>, <%= pPrice %>)"
                                                                                                                        class="w-7 h-7 bg-white rounded-lg shadow-sm text-gray-600 font-bold hover:bg-gray-100">-</button>
                                                                                                                    <input
                                                                                                                        type="number"
                                                                                                                        id="qty_<%= pId %>"
                                                                                                                        name="qty_<%= pId %>"
                                                                                                                        value="0"
                                                                                                                        min="0"
                                                                                                                        max="<%= stock %>"
                                                                                                                        readonly
                                                                                                                        class="w-10 text-center bg-transparent font-black text-gray-800 outline-none text-sm">
                                                                                                                    <button
                                                                                                                        type="button"
                                                                                                                        onclick="changeQty(<%= pId %>, 1, <%= stock %>, <%= pPrice %>)"
                                                                                                                        class="w-7 h-7 bg-white rounded-lg shadow-sm text-gray-600 font-bold hover:bg-gray-100">+</button>
                                                                                                                </div>
                                                                                                            </div>
                                                                                                        </div>
                                                                                                    </div>
                                                                                                    <% } %>
                                                                                            </div>
                                                                                        </form>
                                                                            </div>

                                                                            <div class="w-1/3">
                                                                                <div
                                                                                    class="bg-white rounded-3xl shadow-2xl p-6 sticky top-24 border border-purple-100">
                                                                                    <h3
                                                                                        class="text-xl font-black text-gray-800 mb-6">
                                                                                        Order Summary</h3>
                                                                                    <div id="cartItems"
                                                                                        class="space-y-3 mb-6 min-h-[150px] max-h-[300px] overflow-y-auto pr-2">
                                                                                        <p
                                                                                            class="text-gray-400 text-sm italic text-center py-6">
                                                                                            Add items to view summary.
                                                                                        </p>
                                                                                    </div>

                                                                                    <div
                                                                                        class="border-t border-gray-100 pt-5 space-y-3">
                                                                                        <div
                                                                                            class="flex justify-between text-gray-500 text-sm font-semibold">
                                                                                            <span>Delivery
                                                                                                Address:</span>
                                                                                            <span
                                                                                                class="text-right max-w-[150px] truncate"
                                                                                                title="<%= address %>">
                                                                                                <%= address %>
                                                                                            </span>
                                                                                        </div>
                                                                                        <div
                                                                                            class="flex justify-between items-center text-lg mt-4">
                                                                                            <span
                                                                                                class="font-bold text-gray-800">Total
                                                                                                Price</span>
                                                                                            <span
                                                                                                class="font-black text-3xl text-purple-700">₹<span
                                                                                                    id="grandTotal">0.00</span></span>
                                                                                        </div>
                                                                                    </div>

                                                                                    <div class="mt-6">
                                                                                        <button type="button"
                                                                                            onclick="submitOrder()"
                                                                                            id="checkoutBtn"
                                                                                            class="w-full py-4 bg-purple-600 text-white font-black text-lg rounded-2xl shadow-lg shadow-purple-200 hover:bg-purple-700 transition opacity-50 cursor-not-allowed">
                                                                                            Place Order (Cash on
                                                                                            Delivery)
                                                                                        </button>
                                                                                    </div>
                                                                                    <div
                                                                                        class="bg-orange-50 text-orange-700 p-3 rounded-xl text-xs font-semibold text-center mt-4">
                                                                                        📦 All payments are strictly
                                                                                        collected by assigning delivery
                                                                                        boys.
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                        </div>

                                                                        <% if (successMsg !=null) { %>
                                                                            <div id="successModal"
                                                                                class="fixed inset-0 bg-black/60 z-50 flex items-center justify-center p-4">
                                                                                <div
                                                                                    class="bg-white rounded-3xl shadow-2xl p-8 max-w-sm w-full text-center transform scale-100 transition-all">
                                                                                    <div
                                                                                        class="w-20 h-20 bg-green-100 text-green-600 rounded-full flex items-center justify-center text-4xl mx-auto mb-6">
                                                                                        ✅</div>
                                                                                    <h2
                                                                                        class="text-2xl font-black text-gray-800 mb-2">
                                                                                        Order Confirmed!</h2>
                                                                                    <p class="text-gray-500 mb-1">Your
                                                                                        wholesale order has been placed.
                                                                                    </p>
                                                                                    <p
                                                                                        class="font-bold text-purple-700 text-xl py-3 bg-purple-50 rounded-xl my-4">
                                                                                        <%= newOrderIdStr %>
                                                                                    </p>
                                                                                    <a href="track_order.jsp"
                                                                                        class="block w-full py-3 bg-purple-600 text-white font-bold rounded-xl mt-2 hover:bg-purple-700">Track
                                                                                        Order</a>
                                                                                </div>
                                                                            </div>
                                                                            <% } %>

                                                                                <script>
                                                                                    var itemNames = {
            <% for (Map < String, Object > p : products) { %>
                <%= p.get("id") %>: "<%= ((String) p.get("name")).replace("\"", "\\\"") %> ",
                                                                                            <% } %>
        };

                                                                                    function changeQty(pid, delta, max, price) {
                                                                                        var input = document.getElementById("qty_" + pid);
                                                                                        var current = parseInt(input.value);
                                                                                        var limit = parseInt(max);
                                                                                        var nw = current + delta;
                                                                                        if (nw < 0) nw = 0;
                                                                                        if (nw > limit) nw = limit;
                                                                                        input.value = nw;
                                                                                        updateSummary();
                                                                                    }

                                                                                    function updateSummary() {
                                                                                        var total = 0;
                                                                                        var cartHtml = "";
                                                                                        var hasItems = false;

            <% for (Map < String, Object > p : products) { %>
                                                                                            (function () {
                                                                                                var pid = <%= p.get("id") %>;
                                                                                                var prc = <%= p.get("price") %>;
                                                                                                var nm = itemNames[pid];
                                                                                                var el = document.getElementById("qty_" + pid);
                                                                                                if (el) {
                                                                                                    var q = parseInt(el.value);
                                                                                                    if (q > 0) {
                                                                                                        hasItems = true;
                                                                                                        var lineTot = q * prc;
                                                                                                        total += lineTot;
                                                                                                        cartHtml += '<div class="flex justify-between items-center text-sm">' +
                                                                                                            '<div class="flex-1 pr-2"><p class="font-bold text-gray-800 leading-tight">' + nm + '</p><p class="text-[10px] text-gray-400 uppercase font-semibold">Qty: ' + q + ' x ₹' + prc + '</p></div>' +
                                                                                                            '<span class="font-black text-gray-800">₹' + lineTot.toFixed(2) + '</span>' +
                                                                                                            '</div>';
                                                                                                    }
                                                                                                }
                                                                                            })();
            <% } %>

            var cont = document.getElementById("cartItems");
                                                                                        if (hasItems) {
                                                                                            cont.innerHTML = cartHtml;
                                                                                        } else {
                                                                                            cont.innerHTML = '<p class="text-gray-400 text-sm italic text-center py-6">Add items to view summary.</p>';
                                                                                        }

                                                                                        document.getElementById("grandTotal").innerText = total.toFixed(2);

                                                                                        var btn = document.getElementById("checkoutBtn");
                                                                                        if (hasItems) {
                                                                                            btn.classList.remove('opacity-50', 'cursor-not-allowed');
                                                                                            btn.classList.add('shadow-purple-400');
                                                                                        } else {
                                                                                            btn.classList.add('opacity-50', 'cursor-not-allowed');
                                                                                            btn.classList.remove('shadow-purple-400');
                                                                                        }
                                                                                    }

                                                                                    function submitOrder() {
                                                                                        var btn = document.getElementById("checkoutBtn");
                                                                                        if (!btn.classList.contains('cursor-not-allowed')) {
                                                                                            btn.innerText = "Placing Order...";
                                                                                            btn.classList.add('opacity-70', 'cursor-not-allowed');
                                                                                            document.getElementById("orderForm").submit();
                                                                                        }
                                                                                    }
                                                                                </script>
                                                                    </body>

                                                                    </html>