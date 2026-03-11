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

                <!-- Stats -->
                <div class="grid grid-cols-4 gap-6 mb-8">
                    <div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
                        <p class="text-gray-400 text-sm">Assigned to Me</p>
                        <p class="text-3xl font-black text-orange-500 mt-2">4</p>
                    </div>
                    <div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
                        <p class="text-gray-400 text-sm">Delivered</p>
                        <p class="text-3xl font-black text-green-600 mt-2" id="deliveredCount">1</p>
                    </div>
                    <div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
                        <p class="text-gray-400 text-sm">In Transit</p>
                        <p class="text-3xl font-black text-blue-600 mt-2" id="transitCount">1</p>
                    </div>
                    <div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition border-2 border-red-200">
                        <p class="text-red-500 text-sm font-semibold">Cash to Deposit</p>
                        <p class="text-3xl font-black text-red-600 mt-2" id="cashCount">0</p>
                        <p class="text-red-400 text-xs mt-1">Give to Cashier</p>
                    </div>
                </div>

                <!-- ASSIGNED ORDERS -->
                <div class="bg-white rounded-2xl shadow-lg overflow-hidden mb-8">
                    <div class="p-6 border-b bg-orange-50">
                        <h2 class="text-xl font-bold text-gray-800">📋 My Assigned Orders</h2>
                        <p class="text-gray-400 text-sm mt-0.5">Pick up, deliver, and mark each order complete</p>
                    </div>
                    <div class="p-6 space-y-4">

                        <!-- Order: Assigned (not started) -->
                        <div class="border-2 border-gray-100 rounded-2xl p-5" id="dord-301">
                            <div class="flex justify-between items-start gap-4">
                                <div>
                                    <div class="flex items-center gap-2 mb-1">
                                        <span class="font-black text-lg text-gray-800">#ORD-301</span>
                                        <span
                                            class="bg-gray-100 text-gray-600 text-xs font-bold px-2 py-0.5 rounded-full"
                                            id="status-dord-301">Assigned</span>
                                    </div>
                                    <p class="text-sm text-gray-600">🏪 <strong>Ramesh General Store</strong> — Village
                                        Khari, Dist. Anand</p>
                                    <p class="text-sm text-gray-500 mt-1">📦 Chocolate Cone × 5, Vanilla Cone × 3
                                        cartons</p>
                                    <p class="text-sm font-bold text-indigo-600 mt-1">💰 Collect: ₹7,560 (Cash on
                                        Delivery)</p>
                                </div>
                                <div class="flex flex-col gap-2 min-w-[160px]">
                                    <button id="btn-dord-301" onclick="startDelivery('dord-301', '₹7,560')"
                                        class="bg-orange-500 text-white py-2 px-4 rounded-xl font-bold text-sm hover:bg-orange-600 transition">
                                        🚀 Start Delivery
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Order: In Transit -->
                        <div class="border-2 border-blue-200 rounded-2xl p-5 bg-blue-50" id="dord-298">
                            <div class="flex justify-between items-start gap-4">
                                <div>
                                    <div class="flex items-center gap-2 mb-1">
                                        <span class="font-black text-lg text-gray-800">#ORD-298</span>
                                        <span
                                            class="bg-blue-100 text-blue-700 text-xs font-bold px-2 py-0.5 rounded-full"
                                            id="status-dord-298">In Transit 🛵</span>
                                    </div>
                                    <p class="text-sm text-gray-600">🏪 <strong>Mehta Traders</strong> — Nadiad, Kheda
                                    </p>
                                    <p class="text-sm text-gray-500 mt-1">📦 Mango Shake × 7, Family Pack × 1 case</p>
                                    <p class="text-sm font-bold text-indigo-600 mt-1">💰 Collect: ₹9,200 (Cash on
                                        Delivery)</p>
                                </div>
                                <div class="flex flex-col gap-2 min-w-[160px]">
                                    <button id="btn-dord-298" onclick="markDelivered('dord-298', '₹9,200')"
                                        class="bg-green-500 text-white py-2 px-4 rounded-xl font-bold text-sm hover:bg-green-600 transition">
                                        ✅ Mark Delivered
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Order: Delivered -->
                        <div class="border-2 border-green-200 rounded-2xl p-5 bg-green-50" id="dord-295">
                            <div class="flex justify-between items-start gap-4">
                                <div>
                                    <div class="flex items-center gap-2 mb-1">
                                        <span class="font-black text-lg text-gray-800">#ORD-295</span>
                                        <span
                                            class="bg-green-100 text-green-700 text-xs font-bold px-2 py-0.5 rounded-full">Delivered
                                            ✅</span>
                                    </div>
                                    <p class="text-sm text-gray-600">🏪 <strong>Patel Kirana</strong> — Anklav, Anand
                                    </p>
                                    <p class="text-sm text-gray-500 mt-1">📦 Strawberry Cup × 10 cartons</p>
                                    <p class="text-sm font-bold text-green-600 mt-1">💰 Collected: ₹6,000 — Deposit to
                                        Cashier</p>
                                </div>
                                <div class="min-w-[160px]">
                                    <span class="text-green-600 font-semibold text-sm">Cash collected ✓</span>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>

                <!-- PENDING CASH TO DEPOSIT -->
                <div class="bg-white rounded-2xl shadow-lg overflow-hidden border-2 border-red-100">
                    <div class="p-6 border-b bg-red-50 flex justify-between items-center">
                        <div>
                            <h2 class="text-xl font-bold text-red-700">💰 Pending Cash to Deposit to Cashier</h2>
                            <p class="text-gray-400 text-sm mt-0.5">Hand over all collected cash and click "Cash
                                Deposited"</p>
                        </div>
                        <span class="bg-red-500 text-white text-sm font-bold px-4 py-1.5 rounded-full" id="cashBadge">0
                            Pending</span>
                    </div>
                    <div class="p-6">
                        <div id="cashList" class="space-y-3"></div>
                        <div id="noCash" class="text-center py-8 text-gray-400">
                            <div class="text-4xl mb-2">💼</div>
                            <p class="font-semibold">No cash pending. Deliver orders first!</p>
                        </div>
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
                setTimeout(() => t.classList.add('hidden'), 3500);
            }

            function startDelivery(id, amount) {
                document.getElementById(id).className = 'border-2 border-blue-200 rounded-2xl p-5 bg-blue-50';
                document.getElementById('status-' + id).innerHTML = 'In Transit 🛵';
                document.getElementById('status-' + id).className = 'bg-blue-100 text-blue-700 text-xs font-bold px-2 py-0.5 rounded-full';
                const btn = document.getElementById('btn-' + id);
                btn.innerText = '✅ Mark Delivered';
                btn.className = 'bg-green-500 text-white py-2 px-4 rounded-xl font-bold text-sm hover:bg-green-600 transition';
                btn.setAttribute('onclick', `markDelivered('${id}', '${amount}')`);
                transitCount++;
                document.getElementById('transitCount').innerText = transitCount;
                showToast('🛵 Delivery started!');
            }

            function markDelivered(id, amount) {
                document.getElementById(id).className = 'border-2 border-green-200 rounded-2xl p-5 bg-green-50';
                document.getElementById('status-' + id + '') && (document.getElementById('status-' + id).innerHTML = 'Delivered ✅');
                document.getElementById('btn-' + id).outerHTML = '<span class="text-green-600 font-semibold text-sm">✓ Delivered</span>';
                deliveredCount++;
                document.getElementById('deliveredCount').innerText = deliveredCount;

                // Add to cash deposit list
                cashItems.push({ id, amount });
                document.getElementById('cashCount').innerText = cashItems.length;
                document.getElementById('cashBadge').innerText = cashItems.length + ' Pending';
                document.getElementById('noCash').classList.add('hidden');

                const div = document.createElement('div');
                div.className = 'flex justify-between items-center bg-red-50 border border-red-200 rounded-xl p-4';
                div.id = 'cash-' + id;
                div.innerHTML = `
        <div>
            <p class="font-bold text-gray-800">${id.replace('dord', '#ORD-')}</p>
            <p class="text-red-600 font-black text-lg">${amount} to deposit</p>
        </div>
        <button onclick="depositCash('cash-${id}')"
            class="bg-red-500 text-white px-5 py-2 rounded-xl font-bold hover:bg-red-600 transition text-sm">
            💵 Cash Deposited to Cashier
        </button>
    `;
                document.getElementById('cashList').appendChild(div);
                showToast('✅ Order marked as Delivered! Deposit cash to Cashier.', 'bg-green-500');
            }

            function depositCash(divId) {
                document.getElementById(divId).remove();
                cashItems.pop();
                document.getElementById('cashCount').innerText = cashItems.length;
                document.getElementById('cashBadge').innerText = cashItems.length + ' Pending';
                if (cashItems.length === 0) document.getElementById('noCash').classList.remove('hidden');
                showToast('💰 Cash deposited to Cashier! Invoice will be generated.', 'bg-blue-500');
            }

            setInterval(() => {
                const now = new Date();
                document.getElementById('liveClock').innerText = String(now.getHours()).padStart(2, '0') + ':' + String(now.getMinutes()).padStart(2, '0') + ':' + String(now.getSeconds()).padStart(2, '0');
                document.getElementById('liveDate').innerText = now.toDateString();
            }, 1000);
        </script>
    </body>

    </html>