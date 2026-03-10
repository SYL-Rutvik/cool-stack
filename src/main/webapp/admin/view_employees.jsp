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
                        <select id="roleFilter" onchange="filterStaff()"
                            class="bg-white/20 border border-white/30 text-white rounded-xl px-4 py-2 text-sm font-semibold outline-none">
                            <option value="all">All Roles</option>
                            <option value="Manager">Manager</option>
                            <option value="Cashier">Cashier</option>
                            <option value="Delivery">Delivery</option>
                        </select>
                    </div>

                    <div class="grid grid-cols-3 gap-6" id="staffGrid"></div>
                </div>
        </div>

        <script>
            var staffList = [
                { key: 'cs_profile_manager', name: 'Amit Sharma', role: 'Manager', roleIcon: 'M', email: 'amit@coolstock.in', phone: '+91 98001 11111', joined: '1 Jan 2025', orders: 138, badge: 'bg-indigo-100 text-indigo-700' },
                { key: 'cs_profile_delivery', name: 'Neha Singh', role: 'Delivery', roleIcon: 'D', email: 'neha@coolstock.in', phone: '+91 98001 22222', joined: '5 Feb 2025', orders: 92, badge: 'bg-orange-100 text-orange-700' },
                { key: 'cs_profile_cashier', name: 'Priya Patel', role: 'Cashier', roleIcon: 'C', email: 'priya@coolstock.in', phone: '+91 98001 33333', joined: '10 Mar 2025', orders: 0, badge: 'bg-emerald-100 text-emerald-700' },
                { key: 'cs_profile_delivery2', name: 'Rohit Das', role: 'Delivery', roleIcon: 'D', email: 'rohit@coolstock.in', phone: '+91 98001 44444', joined: '15 Apr 2025', orders: 74, badge: 'bg-orange-100 text-orange-700' },
                { key: 'cs_profile_delivery3', name: 'Arjun Mehta', role: 'Delivery', roleIcon: 'D', email: 'arjun@coolstock.in', phone: '+91 98001 55555', joined: '20 May 2025', orders: 61, badge: 'bg-orange-100 text-orange-700' }
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

            buildStaffCards(staffList);
        </script>
    </body>

    </html>