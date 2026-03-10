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

                    <!-- Stats -->
                    <div class="grid grid-cols-4 gap-6 mb-8">
                        <div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
                            <p class="text-gray-400 text-sm">New Orders</p>
                            <p class="text-3xl font-black text-orange-500 mt-2" id="stat-new">4</p>
                            <p class="text-orange-400 text-xs mt-1">Not yet assigned</p>
                        </div>
                        <div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
                            <p class="text-gray-400 text-sm">Assigned</p>
                            <p class="text-3xl font-black text-blue-600 mt-2">3</p>
                            <p class="text-blue-400 text-xs mt-1">Delivery in progress</p>
                        </div>
                        <div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
                            <p class="text-gray-400 text-sm">Delivered Today</p>
                            <p class="text-3xl font-black text-green-600 mt-2">5</p>
                            <p class="text-green-400 text-xs mt-1">Cash collection pending</p>
                        </div>
                        <div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
                            <p class="text-gray-400 text-sm">Total Orders Today</p>
                            <p class="text-3xl font-black text-indigo-600 mt-2">12</p>
                        </div>
                    </div>

                    <!-- PENDING ORDERS — ASSIGN TO DELIVERY BOY -->
                    <div class="bg-white rounded-2xl shadow-lg overflow-hidden mb-8">
                        <div class="flex justify-between items-center p-6 border-b bg-orange-50">
                            <div>
                                <h2 class="text-xl font-bold text-gray-800">⏳ Pending Orders — Assign to Delivery Boy
                                </h2>
                                <p class="text-gray-400 text-sm mt-0.5">These orders are placed by customers and need to
                                    be assigned</p>
                            </div>
                            <span class="bg-orange-500 text-white text-sm font-bold px-4 py-1.5 rounded-full"
                                id="pendingBadge">4 Unassigned</span>
                        </div>
                        <div class="p-6 space-y-4" id="pendingOrdersList">

                            <!-- Order Card Template -->
                            <div class="border-2 border-orange-100 rounded-2xl p-5 hover:border-orange-300 transition"
                                id="order-301">
                                <div class="flex justify-between items-start gap-4">
                                    <div>
                                        <div class="flex items-center gap-2 mb-1">
                                            <span class="font-black text-gray-800 text-lg">#ORD-301</span>
                                            <span
                                                class="bg-orange-100 text-orange-700 text-xs font-bold px-2 py-0.5 rounded-full">Pending</span>
                                        </div>
                                        <p class="text-sm text-gray-600">🏪 <span class="font-semibold">Ramesh General
                                                Store</span> — Village Khari, Dist. Anand</p>
                                        <p class="text-sm text-gray-500 mt-1">📦 Chocolate Cone × 5 cartons, Vanilla
                                            Cone × 3 cartons</p>
                                        <p class="text-sm text-indigo-600 font-semibold mt-1">💰 Total: ₹7,560</p>
                                        <p class="text-xs text-gray-400 mt-1">📅 Placed: 10 Mar 2026, 10:30 AM</p>
                                    </div>
                                    <div class="flex flex-col gap-2 min-w-[200px]">
                                        <select id="delivery-301"
                                            class="border-2 border-gray-200 p-2 rounded-xl text-sm focus:border-indigo-400 outline-none">
                                            <option value="">— Select Delivery Boy —</option>
                                            <option value="Neha Singh">🛵 Neha Singh</option>
                                            <option value="Rohit Das">🛵 Rohit Das</option>
                                            <option value="Arjun Mehta">🛵 Arjun Mehta</option>
                                        </select>
                                        <button onclick="assignOrder('order-301', '#ORD-301', 'delivery-301')"
                                            class="bg-indigo-600 text-white py-2 rounded-xl font-bold text-sm hover:bg-indigo-700 transition">
                                            📌 Assign Order
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <div class="border-2 border-orange-100 rounded-2xl p-5 hover:border-orange-300 transition"
                                id="order-302">
                                <div class="flex justify-between items-start gap-4">
                                    <div>
                                        <div class="flex items-center gap-2 mb-1">
                                            <span class="font-black text-gray-800 text-lg">#ORD-302</span>
                                            <span
                                                class="bg-orange-100 text-orange-700 text-xs font-bold px-2 py-0.5 rounded-full">Pending</span>
                                        </div>
                                        <p class="text-sm text-gray-600">🏪 <span class="font-semibold">Patel Kirana
                                                Shop</span> — Nadiad, Kheda</p>
                                        <p class="text-sm text-gray-500 mt-1">📦 Mango Shake × 10 cartons, Family Pack ×
                                            2 cases</p>
                                        <p class="text-sm text-indigo-600 font-semibold mt-1">💰 Total: ₹14,880</p>
                                        <p class="text-xs text-gray-400 mt-1">📅 Placed: 10 Mar 2026, 11:15 AM</p>
                                    </div>
                                    <div class="flex flex-col gap-2 min-w-[200px]">
                                        <select id="delivery-302"
                                            class="border-2 border-gray-200 p-2 rounded-xl text-sm focus:border-indigo-400 outline-none">
                                            <option value="">— Select Delivery Boy —</option>
                                            <option value="Neha Singh">🛵 Neha Singh</option>
                                            <option value="Rohit Das">🛵 Rohit Das</option>
                                            <option value="Arjun Mehta">🛵 Arjun Mehta</option>
                                        </select>
                                        <button onclick="assignOrder('order-302', '#ORD-302', 'delivery-302')"
                                            class="bg-indigo-600 text-white py-2 rounded-xl font-bold text-sm hover:bg-indigo-700 transition">
                                            📌 Assign Order
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <div class="border-2 border-orange-100 rounded-2xl p-5 hover:border-orange-300 transition"
                                id="order-303">
                                <div class="flex justify-between items-start gap-4">
                                    <div>
                                        <div class="flex items-center gap-2 mb-1">
                                            <span class="font-black text-gray-800 text-lg">#ORD-303</span>
                                            <span
                                                class="bg-orange-100 text-orange-700 text-xs font-bold px-2 py-0.5 rounded-full">Pending</span>
                                        </div>
                                        <p class="text-sm text-gray-600">🏪 <span class="font-semibold">Sharma Cold
                                                Store</span> — Anklav, Anand</p>
                                        <p class="text-sm text-gray-500 mt-1">📦 Strawberry Cup × 8 cartons,
                                            Butterscotch Cup × 6 cartons</p>
                                        <p class="text-sm text-indigo-600 font-semibold mt-1">💰 Total: ₹8,760</p>
                                        <p class="text-xs text-gray-400 mt-1">📅 Placed: 10 Mar 2026, 12:00 PM</p>
                                    </div>
                                    <div class="flex flex-col gap-2 min-w-[200px]">
                                        <select id="delivery-303"
                                            class="border-2 border-gray-200 p-2 rounded-xl text-sm focus:border-indigo-400 outline-none">
                                            <option value="">— Select Delivery Boy —</option>
                                            <option value="Neha Singh">🛵 Neha Singh</option>
                                            <option value="Rohit Das">🛵 Rohit Das</option>
                                            <option value="Arjun Mehta">🛵 Arjun Mehta</option>
                                        </select>
                                        <button onclick="assignOrder('order-303', '#ORD-303', 'delivery-303')"
                                            class="bg-indigo-600 text-white py-2 rounded-xl font-bold text-sm hover:bg-indigo-700 transition">
                                            📌 Assign Order
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <div class="border-2 border-orange-100 rounded-2xl p-5 hover:border-orange-300 transition"
                                id="order-304">
                                <div class="flex justify-between items-start gap-4">
                                    <div>
                                        <div class="flex items-center gap-2 mb-1">
                                            <span class="font-black text-gray-800 text-lg">#ORD-304</span>
                                            <span
                                                class="bg-orange-100 text-orange-700 text-xs font-bold px-2 py-0.5 rounded-full">Pending</span>
                                        </div>
                                        <p class="text-sm text-gray-600">🏪 <span class="font-semibold">Kumar Sweets &
                                                Stores</span> — Borsad, Anand</p>
                                        <p class="text-sm text-gray-500 mt-1">📦 Chocolate Cone × 12 cartons, Mango
                                            Shake × 5 cartons</p>
                                        <p class="text-sm text-indigo-600 font-semibold mt-1">💰 Total: ₹13,440</p>
                                        <p class="text-xs text-gray-400 mt-1">📅 Placed: 10 Mar 2026, 1:00 PM</p>
                                    </div>
                                    <div class="flex flex-col gap-2 min-w-[200px]">
                                        <select id="delivery-304"
                                            class="border-2 border-gray-200 p-2 rounded-xl text-sm focus:border-indigo-400 outline-none">
                                            <option value="">— Select Delivery Boy —</option>
                                            <option value="Neha Singh">🛵 Neha Singh</option>
                                            <option value="Rohit Das">🛵 Rohit Das</option>
                                            <option value="Arjun Mehta">🛵 Arjun Mehta</option>
                                        </select>
                                        <button onclick="assignOrder('order-304', '#ORD-304', 'delivery-304')"
                                            class="bg-indigo-600 text-white py-2 rounded-xl font-bold text-sm hover:bg-indigo-700 transition">
                                            📌 Assign Order
                                        </button>
                                    </div>
                                </div>
                            </div>

                        </div>
                        <div id="allAssigned" class="hidden p-10 text-center text-gray-400">
                            <div class="text-5xl mb-3">🎉</div>
                            <p class="font-semibold text-lg">All orders have been assigned!</p>
                        </div>
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
                                <tr class="border-b hover:bg-gray-50">
                                    <td class="py-3 px-6 font-bold">#ORD-298</td>
                                    <td class="px-6">Mehta Traders</td>
                                    <td class="px-6 font-semibold text-indigo-600">₹9,200</td>
                                    <td class="px-6">🛵 Neha Singh</td>
                                    <td class="px-6"><span
                                            class="bg-blue-100 text-blue-700 px-2 py-0.5 rounded-full text-xs font-bold">In
                                            Transit</span></td>
                                </tr>
                                <tr class="border-b hover:bg-gray-50">
                                    <td class="py-3 px-6 font-bold">#ORD-299</td>
                                    <td class="px-6">Joshi Provisions</td>
                                    <td class="px-6 font-semibold text-indigo-600">₹5,760</td>
                                    <td class="px-6">🛵 Rohit Das</td>
                                    <td class="px-6"><span
                                            class="bg-yellow-100 text-yellow-700 px-2 py-0.5 rounded-full text-xs font-bold">Picked
                                            Up</span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                </div>
        </div>

        <div id="toast"
            class="hidden fixed bottom-6 right-6 bg-green-500 text-white px-6 py-3 rounded-2xl shadow-2xl font-semibold z-50">
        </div>

        <script>
            let pendingCount = 4;

            function assignOrder(cardId, orderId, selectId) {
                const sel = document.getElementById(selectId);
                const deliveryBoy = sel.value;
                if (!deliveryBoy) { alert('Please select a Delivery Boy first!'); return; }

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
        <td class="px-6">🛵 ${deliveryBoy}</td>
        <td class="px-6"><span class="bg-blue-100 text-blue-700 px-2 py-0.5 rounded-full text-xs font-bold">Assigned ✓</span></td>
    `;
                tbody.prepend(row);

                showToast('📌 ' + orderId + ' assigned to ' + deliveryBoy + '!');
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