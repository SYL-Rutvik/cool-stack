<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Manage Staff | CoolStock Admin</title>
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
                        class="bg-gradient-to-r from-slate-800 to-gray-700 text-white p-7 rounded-2xl mb-8 flex justify-between items-center shadow-lg">
                        <div>
                            <h1 class="text-3xl font-black">&#x1F465; Manage Staff</h1>
                            <p class="opacity-70 mt-1">All Managers, Cashiers and Delivery Boys in the system</p>
                        </div>
                        <div class="flex gap-4 items-center">
                            <select id="roleFilter" onchange="filterStaff()"
                                class="bg-white/20 border border-white/30 text-white rounded-xl px-4 py-2 text-sm font-semibold outline-none w-40">
                                <option value="all" class="text-gray-800">All Roles</option>
                                <option value="Manager" class="text-gray-800">Manager</option>
                                <option value="Cashier" class="text-gray-800">Cashier</option>
                                <option value="Delivery" class="text-gray-800">Delivery</option>
                            </select>
                            <button onclick="openStaffModal()"
                                class="bg-indigo-600 hover:bg-indigo-500 text-white px-5 py-2 rounded-xl font-bold transition shadow-md">
                                ➕ Add Staff
                            </button>
                        </div>
                    </div>

                    <div class="grid grid-cols-3 gap-6" id="staffGrid"></div>
                </div>
        </div>

        <!-- Add Staff Modal -->
        <div id="staffModal"
            class="hidden fixed inset-0 bg-black/50 z-50 flex items-center justify-center backdrop-blur-sm">
            <div class="bg-white rounded-2xl shadow-2xl w-[500px] overflow-hidden transform transition-all">
                <div class="p-6 border-b border-gray-100 flex justify-between items-center bg-gray-50">
                    <h2 class="text-xl font-black text-gray-800">Add New Staff</h2>
                    <button onclick="closeStaffModal()"
                        class="text-gray-400 hover:text-red-500 text-2xl leading-none">&times;</button>
                </div>
                <form id="addStaffForm" onsubmit="handleAddStaff(event)" class="p-6 space-y-4">
                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-1">Full Name</label>
                        <input type="text" id="staffName" required
                            class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 transition">
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Role</label>
                            <select id="staffRole"
                                class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 transition bg-white">
                                <option value="Manager">Manager</option>
                                <option value="Cashier">Cashier</option>
                                <option value="Delivery">Delivery</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Phone</label>
                            <input type="text" id="staffPhone" required
                                class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 transition">
                        </div>
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Email Address</label>
                            <input type="email" id="staffEmail" required
                                class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 transition">
                        </div>
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Password</label>
                            <input type="password" id="staffPassword" required
                                class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 transition">
                        </div>
                    </div>
                    <div class="pt-4 flex justify-end gap-3 border-t border-gray-100 mt-6">
                        <button type="button" onclick="closeStaffModal()"
                            class="px-5 py-2 text-gray-500 font-bold hover:bg-gray-100 rounded-xl transition">Cancel</button>
                        <button type="submit"
                            class="px-5 py-2 bg-indigo-600 text-white font-bold rounded-xl hover:bg-indigo-700 transition shadow-md">Add
                            Member</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            var staffList = [
                <% 
                    try (java.sql.Connection conn = com.coolstack.util.DBConnection.getConnection()) {
                java.sql.Statement stmt = conn.createStatement();
                // Unified query for all staff roles
                java.sql.ResultSet rsStaff = stmt.executeQuery("SELECT id, name, email, phone, role, profile_photo, created_at FROM users WHERE role IN ('manager', 'cashier', 'delivery')");

                while (rsStaff.next()) {
                            String role = rsStaff.getString("role");
                            String displayRole = role.substring(0, 1).toUpperCase() + role.substring(1);
                            String badge = "bg-gray-100 text-gray-700";
                            String photo = rsStaff.getString("profile_photo");
                    if (photo == null || photo.isEmpty()) photo = "";

                    if (role.equals("manager")) badge = "bg-indigo-100 text-indigo-700";
                    else if (role.equals("cashier")) badge = "bg-emerald-100 text-emerald-700";
                    else if (role.equals("delivery")) badge = "bg-orange-100 text-orange-700";

                    out.print("{ key: 'db_user_" + rsStaff.getInt("id") + "', name: '" + rsStaff.getString("name").replace("'", "\\'") + "', role: '" + displayRole + "', roleIcon: '" + displayRole.charAt(0) + "', email: '" + rsStaff.getString("email").replace("'", "\\'") + "', phone: '" + rsStaff.getString("phone").replace("'", "\\'") + "', dbPhoto: '" + photo + "', joined: '" + rsStaff.getTimestamp("created_at") + "', orders: 0, badge: '" + badge + "' },");
                }
            } catch (Exception e) { e.printStackTrace(); }
                %>
            ];

            var roleEmoji = { 'Manager': '📊', 'Cashier': '💳', 'Delivery': '🛵' };
            var defaultSvg = 'data:image/svg+xml,%3Csvg xmlns%3D%22http%3A//www.w3.org/2000/svg%22 width%3D%22120%22 height%3D%22120%22 viewBox%3D%220 0 120 120%22%3E%3Ccircle cx%3D%2260%22 cy%3D%2260%22 r%3D%2260%22 fill%3D%22%23e2e8f0%22/%3E%3Ctext x%3D%2260%22 y%3D%2276%22 font-size%3D%2240%22 text-anchor%3D%22middle%22 fill%3D%22%2394a3b8%22%3E%E2%9D%93%3C/text%3E%3C/svg%3E';

            function buildStaffCards(data) {
                var grid = document.getElementById('staffGrid');
                grid.innerHTML = '';
                for (var i = 0; i < data.length; i++) {
                    var s = data[i];
                    var profile = JSON.parse(localStorage.getItem(s.key) || '{}');
                    var photo = profile.photo || defaultSvg;
                    var name = profile.name || s.name;
                    var email = profile.email || s.email;
                    var phone = profile.phone || s.phone;
                    var emoji = roleEmoji[s.role] || '';

                    var ordersHtml = '';
                    if (s.orders > 0) {
                        ordersHtml = '<p class="text-indigo-600 font-semibold text-sm">' + emoji + ' ' + s.orders + ' orders handled</p>';
                    }

                    var card = document.createElement('div');
                    card.className = 'staff-card bg-white rounded-2xl shadow-lg overflow-hidden hover:-translate-y-1 transition duration-300';
                    card.setAttribute('data-role', s.role);

                    var html = '';
                    html += '<div class="h-20 bg-gradient-to-r from-slate-700 to-slate-600 relative">';
                    html += '<img src="' + photo + '" alt="' + name + '" onerror="this.src=\'' + defaultSvg + '\'" ';
                    html += 'class="absolute -bottom-8 left-6 w-20 h-20 rounded-2xl border-4 border-white shadow-lg object-cover">';
                    html += '</div>';
                    html += '<div class="pt-12 px-6 pb-6">';
                    html += '<div class="flex justify-between items-start mb-3">';
                    html += '<div><h3 class="font-black text-gray-800 text-lg leading-tight">' + name + '</h3>';
                    html += '<span class="inline-block ' + s.badge + ' px-2 py-0.5 rounded-full text-xs font-bold mt-1">' + emoji + ' ' + s.role + '</span></div>';
                    html += '<span class="text-xs text-gray-400">Since ' + s.joined + '</span>';
                    html += '</div>';
                    html += '<div class="space-y-1.5 text-sm text-gray-500 mb-4">';
                    html += '<p>&#x1F4E7; ' + email + '</p>';
                    html += '<p>&#x1F4DE; ' + phone + '</p>';
                    html += ordersHtml;
                    html += '</div></div>';

                    card.innerHTML = html;
                    grid.appendChild(card);
                }
            }

            function filterStaff() {
                var role = document.getElementById('roleFilter').value;
                var cards = document.querySelectorAll('.staff-card');
                for (var i = 0; i < cards.length; i++) {
                    cards[i].style.display = (role === 'all' || cards[i].getAttribute('data-role') === role) ? 'block' : 'none';
                }
            }

            function openStaffModal() {
                document.getElementById('staffModal').classList.remove('hidden');
            }
            function closeStaffModal() {
                document.getElementById('staffModal').classList.add('hidden');
                document.getElementById('addStaffForm').reset();
            }
            function handleAddStaff(e) {
                e.preventDefault();
                var name = document.getElementById('staffName').value;
                var role = document.getElementById('staffRole').value;
                var phone = document.getElementById('staffPhone').value;
                var email = document.getElementById('staffEmail').value;
                var password = document.getElementById('staffPassword').value;

                var formData = new URLSearchParams();
                formData.append('action', 'addEmployee');
                formData.append('name', name);
                formData.append('role', role);
                formData.append('phone', phone);
                formData.append('email', email);
                formData.append('password', password);

                fetch('../addUser', {
                    method: 'POST',
                    body: formData,
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    }
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            alert('Employee added successfully!');
                            location.reload();
                        } else {
                            alert('Error adding employee: ' + data.message);
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('An error occurred. Check the console for details.');
                    });
            }

            buildStaffCards(staffList);
        </script>
    </body>

    </html>