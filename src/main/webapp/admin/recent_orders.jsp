<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Recent Orders | CoolStock Admin</title>
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
                        class="bg-gradient-to-r from-emerald-700 to-teal-600 text-white p-7 rounded-2xl mb-8 flex justify-between items-center shadow-lg">
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
                            <input id="searchInput" type="text" placeholder="Search order ID..."
                                oninput="filterOrders()"
                                class="bg-white/20 border border-white/30 text-white placeholder-white/60 rounded-xl px-4 py-2 text-sm font-semibold outline-none w-52">
                        </div>
                    </div>

                    <!-- Stats -->
                    <div class="grid grid-cols-4 gap-6 mb-8">
                        <div class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition">
                            <p class="text-gray-400 text-sm">Total Orders (Today)</p>
                            <p class="text-3xl font-black text-emerald-700 mt-1">14</p>
                        </div>
                        <div class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition">
                            <p class="text-gray-400 text-sm">Revenue (Today)</p>
                            <p class="text-3xl font-black text-teal-600 mt-1">&#x20B9;84,500</p>
                        </div>
                        <div
                            class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition border-l-4 border-orange-400">
                            <p class="text-gray-400 text-sm">Processing</p>
                            <p class="text-3xl font-black text-orange-500 mt-1">5</p>
                        </div>
                        <div
                            class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition border-l-4 border-blue-400">
                            <p class="text-gray-400 text-sm">Shipped</p>
                            <p class="text-3xl font-black text-blue-500 mt-1">3</p>
                        </div>
                    </div>

                    <!-- Orders Table -->
                    <div class="bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden">
                        <div class="p-6 border-b border-gray-100 bg-gray-50 flex justify-between items-center">
                            <h2 class="text-xl font-black text-gray-800">Order Logs</h2>
                            <button
                                class="bg-emerald-100 text-emerald-700 px-4 py-1.5 rounded-full text-xs font-bold hover:bg-emerald-200 transition">
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
                                    <!-- Dynamic Rows -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
        </div>

        <script>
            var orders = [
                { id: '#ORD-9824', customer: 'Ramesh General Store', date: 'Today, 10:45 AM', items: '24 Tubs, 50 Cones', amount: '₹8,400', status: 'Processing', statusColor: 'bg-orange-100 text-orange-600' },
                { id: '#ORD-9823', customer: 'Patel Kirana Shop', date: 'Today, 09:30 AM', items: '100 Cones, 200 Sticks', amount: '₹7,500', status: 'Shipped', statusColor: 'bg-blue-100 text-blue-600' },
                { id: '#ORD-9822', customer: 'Sharma Cold Store', date: 'Yesterday, 04:15 PM', items: '10 Tubs', amount: '₹1,500', status: 'Delivered', statusColor: 'bg-green-100 text-green-600' },
                { id: '#ORD-9821', customer: 'Kumar Sweets', date: 'Yesterday, 02:10 PM', items: '50 Tubs, 400 Sticks', amount: '₹12,400', status: 'Delivered', statusColor: 'bg-green-100 text-green-600' },
                { id: '#ORD-9820', customer: 'Joshi Provisions', date: 'Yesterday, 11:05 AM', items: '150 Cones', amount: '₹6,000', status: 'Processing', statusColor: 'bg-orange-100 text-orange-600' },
                { id: '#ORD-9819', customer: 'Mehta Traders', date: 'Mar 09, 2026', items: '20 Tubs', amount: '₹3,000', status: 'Cancelled', statusColor: 'bg-red-100 text-red-600' },
                { id: '#ORD-9818', customer: 'Ramesh General Store', date: 'Mar 09, 2026', items: '500 Sticks', amount: '₹10,000', status: 'Delivered', statusColor: 'bg-green-100 text-green-600' },
                { id: '#ORD-9817', customer: 'Patel Kirana Shop', date: 'Mar 08, 2026', items: '30 Tubs, 60 Cones', amount: '₹6,500', status: 'Delivered', statusColor: 'bg-green-100 text-green-600' }
            ];

            function buildOrderTable(data) {
                var tbody = document.getElementById('orderTableBody');
                tbody.innerHTML = '';
                for (var i = 0; i < data.length; i++) {
                    var o = data[i];

                    var tr = document.createElement('tr');
                    tr.className = 'border-b border-gray-50 hover:bg-gray-50/50 transition';
                    tr.setAttribute('data-status', o.status);
                    tr.setAttribute('data-id', o.id.toLowerCase());

                    var html = '';
                    html += '<td class="px-6 py-4 font-black text-gray-800">' + o.id + '</td>';
                    html += '<td class="px-6 py-4 font-semibold text-gray-700">' + o.customer + '</td>';
                    html += '<td class="px-6 py-4 text-gray-500 text-xs">' + o.date + '</td>';
                    html += '<td class="px-6 py-4 text-gray-500 text-xs truncate max-w-[150px]" title="' + o.items + '">' + o.items + '</td>';
                    html += '<td class="px-6 py-4 font-black text-emerald-600">' + o.amount + '</td>';
                    html += '<td class="px-6 py-4">';
                    html += '<span class="px-3 py-1 rounded-full text-xs font-bold ' + o.statusColor + '">' + o.status + '</span>';
                    html += '</td>';
                    html += '<td class="px-6 py-4 text-center">';
                    html += '<button class="text-gray-400 hover:text-emerald-600 transition p-2 bg-white rounded-full shadow-sm border border-gray-100" title="View Details">👁️</button>';
                    html += '</td>';

                    tr.innerHTML = html;
                    tbody.appendChild(tr);
                }
            }

            function filterOrders() {
                var q = document.getElementById('searchInput').value.toLowerCase();
                var status = document.getElementById('statusFilter').value;
                var rows = document.querySelectorAll('#orderTableBody tr');

                for (var i = 0; i < rows.length; i++) {
                    var matchId = rows[i].getAttribute('data-id').indexOf(q) !== -1;
                    var matchStatus = status === 'all' || rows[i].getAttribute('data-status') === status;
                    rows[i].style.display = (matchId && matchStatus) ? '' : 'none';
                }
            }

            buildOrderTable(orders);
        </script>
    </body>

    </html>