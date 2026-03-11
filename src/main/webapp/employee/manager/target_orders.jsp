<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Manage Orders | Manager</title>
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
                        class="bg-gradient-to-r from-blue-700 to-cyan-600 text-white p-7 rounded-2xl mb-8 flex justify-between items-center shadow-lg">
                        <div>
                            <h1 class="text-3xl font-black">&#x1F4E6; Manage Orders</h1>
                            <p class="opacity-70 mt-1">Track customer orders and prioritize urgent deliveries</p>
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
                            <p class="text-gray-400 text-sm">Total Orders</p>
                            <p class="text-3xl font-black text-blue-700 mt-1" id="stat-total">0</p>
                        </div>
                        <div
                            class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition border-l-4 border-red-500">
                            <p class="text-gray-400 text-sm">Urgent Deliveries</p>
                            <p class="text-3xl font-black text-red-600 mt-1 animate-pulse" id="stat-urgent">0</p>
                        </div>
                        <div
                            class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition border-l-4 border-orange-400">
                            <p class="text-gray-400 text-sm">Processing</p>
                            <p class="text-3xl font-black text-orange-500 mt-1" id="stat-processing">0</p>
                        </div>
                        <div
                            class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition border-l-4 border-green-500">
                            <p class="text-gray-400 text-sm">Delivered</p>
                            <p class="text-3xl font-black text-green-500 mt-1" id="stat-delivered">0</p>
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
                                        <th class="px-6 py-4 font-bold tracking-wider">Date</th>
                                        <th class="px-6 py-4 font-bold tracking-wider">Priority</th>
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
            var orders = JSON.parse(localStorage.getItem('cs_orders') || '[]');

            // Default fallback if empty
            if (orders.length === 0) {
                orders = [
                    { id: '#ORD-301', shop: 'Ramesh General Store', date: 'Today, 10:45 AM', items: 'Family Pack x 2 cartons', amount: 5280, status: 'Processing', urgency: 'Very Urgent' },
                    { id: '#ORD-302', shop: 'Patel Kirana Shop', date: 'Today, 09:30 AM', items: 'Chocolate Cone x 5 cartons', amount: 3600, status: 'Pending', urgency: 'Regular' }
                ];
            }

            // Custom sort function to put Urgent/Very Urgent at the top if they are Pending or Processing
            orders.sort(function (a, b) {
                var weightA = (a.urgency && a.urgency.includes('Urgent') && (a.status === 'Pending' || a.status === 'Processing')) ? 1 : 0;
                var weightB = (b.urgency && b.urgency.includes('Urgent') && (b.status === 'Pending' || b.status === 'Processing')) ? 1 : 0;
                return weightB - weightA;
            });

            function getStatusStyle(status) {
                if (status === 'Pending') return 'bg-yellow-100 text-yellow-700';
                if (status === 'Processing') return 'bg-orange-100 text-orange-600';
                if (status === 'Assigned' || status === 'In Transit' || status === 'Shipped') return 'bg-blue-100 text-blue-600';
                if (status === 'Delivered' || status === 'Paid') return 'bg-green-100 text-green-600';
                if (status === 'Cancelled') return 'bg-red-100 text-red-600';
                return 'bg-gray-100 text-gray-600';
            }

            function getPriorityStyle(urgency) {
                if (urgency === 'Very Urgent') return '<span class="px-2 py-0.5 rounded text-[10px] font-black uppercase bg-red-600 text-white shadow-sm animate-pulse">Very Urgent</span>';
                if (urgency === 'Urgent') return '<span class="px-2 py-0.5 rounded text-[10px] font-black uppercase bg-orange-500 text-white shadow-sm">Urgent</span>';
                return '<span class="px-2 py-0.5 rounded text-[10px] font-bold uppercase bg-gray-100 text-gray-500">Regular</span>';
            }

            function buildOrderTable(data) {
                var tbody = document.getElementById('orderTableBody');
                tbody.innerHTML = '';
                var totalOrders = data.length;
                var urgentCount = 0;
                var processingCount = 0;
                var deliveredCount = 0;

                for (var i = 0; i < data.length; i++) {
                    var o = data[i];

                    if (o.urgency && o.urgency.includes('Urgent') && (o.status !== 'Delivered' && o.status !== 'Paid')) urgentCount++;
                    if (o.status === 'Processing' || o.status === 'Pending') processingCount++;
                    if (o.status === 'Delivered' || o.status === 'Paid') deliveredCount++;

                    // For managers, high urgency rows that are still active get a special background tint
                    var rowTint = (o.urgency && o.urgency.includes('Urgent') && o.status !== 'Delivered' && o.status !== 'Paid') ? 'bg-red-50/50 border-red-100' : 'bg-white border-gray-50';

                    var tr = document.createElement('tr');
                    tr.className = 'border-b hover:bg-gray-50 transition ' + rowTint;
                    tr.setAttribute('data-status', o.status);
                    tr.setAttribute('data-id', o.id.toLowerCase());

                    var html = '';
                    html += '<td class="px-6 py-4 font-black text-gray-800">' + o.id + '</td>';
                    html += '<td class="px-6 py-4 font-semibold text-gray-700">' + o.shop + '</td>';
                    html += '<td class="px-6 py-4 text-gray-500 text-xs">' + o.date + '</td>';
                    html += '<td class="px-6 py-4">' + getPriorityStyle(o.urgency) + '</td>';
                    html += '<td class="px-6 py-4 text-gray-500 text-xs truncate max-w-[150px]" title="' + o.items + '">' + o.items + '</td>';
                    html += '<td class="px-6 py-4 font-black text-blue-700">&#x20B9;' + Number(o.amount).toLocaleString('en-IN') + '</td>';
                    html += '<td class="px-6 py-4">';
                    html += '<span class="px-3 py-1 rounded-full text-xs font-bold ' + getStatusStyle(o.status) + '">' + o.status + '</span>';
                    html += '</td>';
                    html += '<td class="px-6 py-4 text-center">';
                    html += '<button class="text-gray-400 hover:text-blue-600 transition p-2 bg-white rounded-full shadow-sm border border-gray-100" title="Assign / Process">⚙️</button>';
                    html += '</td>';

                    tr.innerHTML = html;
                    tbody.appendChild(tr);
                }

                document.getElementById('stat-total').innerText = totalOrders;
                document.getElementById('stat-urgent').innerText = urgentCount;
                document.getElementById('stat-processing').innerText = processingCount;
                document.getElementById('stat-delivered').innerText = deliveredCount;
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