<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Manage Customers | CoolStock Admin</title>
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

                    <div
                        class="bg-gradient-to-r from-purple-700 to-pink-600 text-white p-7 rounded-2xl mb-8 flex justify-between items-center shadow-lg">
                        <div>
                            <h1 class="text-3xl font-black">&#x1F3EA; Manage Customers</h1>
                            <p class="opacity-70 mt-1">B2B wholesale shop owners who place bulk orders</p>
                        </div>
                        <div class="flex gap-4 items-center">
                            <input id="searchInput" type="text" placeholder="Search customer..."
                                oninput="filterCustomers()"
                                class="bg-white/20 border border-white/30 text-white placeholder-white/60 rounded-xl px-4 py-2 text-sm font-semibold outline-none w-52">
                            <button onclick="openCustomerModal()"
                                class="bg-purple-900 hover:bg-purple-800 text-white px-5 py-2 rounded-xl font-bold transition shadow-md">
                                ➕ Add Customer
                            </button>
                        </div>
                    </div>

                    <!-- Dynamic Stats -->
                    <% int totalCustomers=0; int activeThisMonth=0; int ordersThisMonth=0; try (java.sql.Connection
                        conn=com.coolstack.util.DBConnection.getConnection(); java.sql.Statement
                        stmt=conn.createStatement()) { java.sql.ResultSet rs=stmt.executeQuery("SELECT COUNT(*) FROM users WHERE role='customer'");
                            if (rs.next()) totalCustomers = rs.getInt(1);
                            
                            rs = stmt.executeQuery(" SELECT COUNT(DISTINCT customer_id) FROM orders WHERE MONTH(order_date)=MONTH(CURRENT_DATE()) AND YEAR(order_date)=YEAR(CURRENT_DATE())");
                            if(rs.next()) activeThisMonth=rs.getInt(1);
                            rs=stmt.executeQuery("SELECT COUNT(*) FROM orders WHERE MONTH(order_date)=MONTH(CURRENT_DATE()) AND YEAR(order_date)=YEAR(CURRENT_DATE())");
                            if(rs.next()) ordersThisMonth=rs.getInt(1); 
                            } 
                    catch (Exception e) { e.printStackTrace(); } %>
                        <div class="grid grid-cols-3 gap-6 mb-8">
                            <div class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition">
                                <p class="text-gray-400 text-sm">Total Customers</p>
                                <p class="text-3xl font-black text-purple-700 mt-1">
                                    <%= totalCustomers %>
                                </p>
                            </div>
                            <div class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition">
                                <p class="text-gray-400 text-sm">Active This Month</p>
                                <p class="text-3xl font-black text-green-600 mt-1">
                                    <%= activeThisMonth %>
                                </p>
                            </div>
                            <div class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition">
                                <p class="text-gray-400 text-sm">Total Orders This Month</p>
                                <p class="text-3xl font-black text-indigo-600 mt-1">
                                    <%= ordersThisMonth %>
                                </p>
                            </div>
                        </div>

                        <div class="grid grid-cols-3 gap-6" id="customerGrid"></div>
                </div>
        </div>

        <!-- Add Customer Modal -->
        <div id="customerModal"
            class="hidden fixed inset-0 bg-black/50 z-50 flex items-center justify-center backdrop-blur-sm">
            <div class="bg-white rounded-2xl shadow-2xl w-[500px] overflow-hidden transform transition-all">
                <div class="p-6 border-b border-gray-100 flex justify-between items-center bg-purple-50">
                    <h2 class="text-xl font-black text-gray-800">Add New Customer</h2>
                    <button onclick="closeCustomerModal()"
                        class="text-gray-400 hover:text-red-500 text-2xl leading-none">&times;</button>
                </div>
                <form id="addCustomerForm" onsubmit="handleAddCustomer(event)" class="p-6 space-y-4">
                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-1">Shop/Business Name</label>
                        <input type="text" id="custName" required
                            class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-purple-500 focus:ring-2 focus:ring-purple-200 transition">
                    </div>
                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-1">Owner Name</label>
                        <input type="text" id="custOwner" required
                            class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-purple-500 focus:ring-2 focus:ring-purple-200 transition">
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Phone</label>
                            <input type="text" id="custPhone" required
                                class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-purple-500 focus:ring-2 focus:ring-purple-200 transition">
                        </div>
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Area / Location</label>
                            <input type="text" id="custArea" required
                                class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-purple-500 focus:ring-2 focus:ring-purple-200 transition">
                        </div>
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Email Address (Optional)</label>
                            <input type="email" id="custEmail"
                                class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-purple-500 focus:ring-2 focus:ring-purple-200 transition">
                        </div>
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Password</label>
                            <input type="password" id="custPassword" required
                                class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-purple-500 focus:ring-2 focus:ring-purple-200 transition">
                        </div>
                    </div>
                    <div class="pt-4 flex justify-end gap-3 border-t border-gray-100 mt-6">
                        <button type="button" onclick="closeCustomerModal()"
                            class="px-5 py-2 text-gray-500 font-bold hover:bg-gray-100 rounded-xl transition">Cancel</button>
                        <button type="submit"
                            class="px-5 py-2 bg-purple-600 text-white font-bold rounded-xl hover:bg-purple-700 transition shadow-md">Add
                            Customer</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            var customers = [
                <% 
                    try (java.sql.Connection conn = com.coolstack.util.DBConnection.getConnection()) {
                java.sql.Statement stmt = conn.createStatement();
                java.sql.ResultSet rsCust = stmt.executeQuery("SELECT id, shop_name, name, address, phone, email FROM customers");
                while (rsCust.next()) {
                    out.print("{ key: 'db_customer_" + rsCust.getInt("id") + "', name: '" + rsCust.getString("shop_name").replace("'", "\\'") + "', owner: '" + rsCust.getString("name").replace("'", "\\'") + "', area: '" + rsCust.getString("address").replace("'", "\\'") + "', phone: '" + rsCust.getString("phone").replace("'", "\\'") + "', email: '" + rsCust.getString("email").replace("'", "\\'") + "', orders: 0, spend: '0', joined: 'Current' },");
                }
            } catch (Exception e) { e.printStackTrace(); }
                %>
            ];

            var defaultCustSvg = 'data:image/svg+xml,%3Csvg xmlns%3D%22http%3A//www.w3.org/2000/svg%22 width%3D%22120%22 height%3D%22120%22 viewBox%3D%220 0 120 120%22%3E%3Ccircle cx%3D%2260%22 cy%3D%2260%22 r%3D%2260%22 fill%3D%22%23f3e8ff%22/%3E%3Ctext x%3D%2260%22 y%3D%2276%22 font-size%3D%2240%22 text-anchor%3D%22middle%22 fill%3D%22%239333ea%22%3E%F0%9F%8F%AA%3C/text%3E%3C/svg%3E';

            function buildCustomerCards(data) {
                var grid = document.getElementById('customerGrid');
                grid.innerHTML = '';
                for (var i = 0; i < data.length; i++) {
                    var c = data[i];
                    var profile = JSON.parse(localStorage.getItem(c.key) || '{}');
                    var photo = profile.photo || defaultCustSvg;
                    var ownerName = profile.name || c.owner;

                    var card = document.createElement('div');
                    card.className = 'cust-card bg-white rounded-2xl shadow-lg overflow-hidden hover:-translate-y-1 transition duration-300';
                    card.setAttribute('data-search', (c.name + ' ' + c.owner + ' ' + c.area).toLowerCase());

                    var html = '';
                    html += '<div class="h-20 bg-gradient-to-r from-purple-600 to-pink-500 relative">';
                    html += '<img src="' + photo + '" alt="' + ownerName + '" onerror="this.src=\'' + defaultCustSvg + '\'" ';
                    html += 'class="absolute -bottom-8 left-6 w-20 h-20 rounded-2xl border-4 border-white shadow-lg object-cover">';
                    html += '</div>';
                    html += '<div class="pt-12 px-6 pb-6">';
                    html += '<div class="flex justify-between items-start mb-1">';
                    html += '<div><h3 class="font-black text-gray-800 text-base leading-tight">' + c.name + '</h3>';
                    html += '<p class="text-gray-500 text-xs">&#x1F464; ' + ownerName + '</p></div>';
                    html += '<span class="text-xs text-gray-400">Since ' + c.joined + '</span>';
                    html += '</div>';
                    html += '<div class="space-y-1 text-xs text-gray-500 mt-3 mb-4">';
                    html += '<p>&#x1F4CD; ' + c.area + '</p>';
                    html += '<p>&#x1F4DE; ' + c.phone + '</p>';
                    html += '<p>&#x1F4E7; ' + c.email + '</p>';
                    html += '</div>';
                    html += '<div class="grid grid-cols-2 gap-2 bg-gray-50 rounded-xl p-3 text-center">';
                    html += '<div><p class="text-xs text-gray-400">Orders</p><p class="font-black text-purple-700">' + c.orders + '</p></div>';
                    html += '<div><p class="text-xs text-gray-400">Total Spend</p><p class="font-black text-green-600 text-xs">&#x20B9;' + c.spend + '</p></div>';
                    html += '</div>';
                    html += '</div>';

                    card.innerHTML = html;
                    grid.appendChild(card);
                }
            }

            function filterCustomers() {
                var q = document.getElementById('searchInput').value.toLowerCase();
                var cards = document.querySelectorAll('.cust-card');
                for (var i = 0; i < cards.length; i++) {
                    cards[i].style.display = cards[i].getAttribute('data-search').indexOf(q) !== -1 ? 'block' : 'none';
                }
            }

            function openCustomerModal() {
                document.getElementById('customerModal').classList.remove('hidden');
            }
            function closeCustomerModal() {
                document.getElementById('customerModal').classList.add('hidden');
                document.getElementById('addCustomerForm').reset();
            }
            function handleAddCustomer(e) {
                e.preventDefault();
                var name = document.getElementById('custName').value;
                var owner = document.getElementById('custOwner').value;
                var phone = document.getElementById('custPhone').value;
                var area = document.getElementById('custArea').value;
                var email = document.getElementById('custEmail').value || 'N/A';
                var password = document.getElementById('custPassword').value;

                var newCust = {
                    key: 'cs_profile_cust_' + Date.now(),
                    name: name,
                    owner: owner,
                    area: area,
                    phone: phone,
                    email: email,
                    orders: 0,
                    spend: '0',
                    joined: 'Today'
                };

                customers.unshift(newCust);
                buildCustomerCards(customers);
                filterCustomers();
                closeCustomerModal();
            }

            buildCustomerCards(customers);
        </script>
    </body>

    </html>