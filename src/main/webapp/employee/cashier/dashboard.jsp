<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Cashier Dashboard | CoolStock</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&display=swap" rel="stylesheet">
        <style>
            body {
                font-family: 'Outfit', sans-serif;
            }

            @media print {
                .no-print {
                    display: none !important;
                }

                body {
                    background: white;
                }

                .ml-64 {
                    margin-left: 0 !important;
                }
            }
        </style>
    </head>

    <body class="bg-gray-100 min-h-screen">
        <div class="flex">

            <!-- Cashier Sidebar -->
            <div class="w-64 h-screen bg-emerald-700 text-white fixed flex flex-col justify-between no-print">
                <div>
                    <div class="p-5 border-b border-emerald-600 flex items-center gap-3">
                        <span class="text-2xl">💳</span>
                        <div>
                            <h2 class="text-lg font-black">CoolStock</h2>
                            <p class="text-xs text-emerald-200">Cashier Panel</p>
                        </div>
                    </div>
                    <nav class="mt-4 space-y-1 px-3">
                        <a href="dashboard.jsp"
                            class="flex items-center gap-3 py-2.5 px-4 rounded-xl bg-emerald-600 font-semibold text-sm"><span>💳</span>
                            Payment Verification</a>
                        <a href="profile.jsp"
                            class="flex items-center gap-3 py-2.5 px-4 rounded-xl hover:bg-emerald-600 transition font-semibold text-sm"><span>👤</span>
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
                    class="bg-gradient-to-r from-emerald-600 to-teal-600 text-white p-7 rounded-2xl mb-8 flex justify-between items-center shadow-lg no-print">
                    <div>
                        <h1 class="text-3xl font-black">💳 Cashier — Payment Verification</h1>
                        <p class="opacity-80 mt-1">Verify cash received from Delivery Boy & generate invoice</p>
                    </div>
                    <div class="text-right">
                        <div id="liveDate" class="text-sm opacity-70"></div>
                        <div id="liveClock" class="text-2xl font-bold mt-1"></div>
                    </div>
                </div>

                <!-- Stats -->
                <div class="grid grid-cols-3 gap-6 mb-8 no-print">
                    <div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
                        <p class="text-gray-400 text-sm">Pending Verifications</p>
                        <p class="text-3xl font-black text-orange-500 mt-2" id="pendingVerify">2</p>
                        <p class="text-orange-400 text-xs mt-1">Cash received, needs approval</p>
                    </div>
                    <div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
                        <p class="text-gray-400 text-sm">Verified Today</p>
                        <p class="text-3xl font-black text-green-600 mt-2" id="verifiedCount">3</p>
                    </div>
                    <div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
                        <p class="text-gray-400 text-sm">Cash Collected Today</p>
                        <p class="text-3xl font-black text-emerald-600 mt-2">₹22,560</p>
                    </div>
                </div>

                <!-- PENDING PAYMENT VERIFICATIONS -->
                <div class="bg-white rounded-2xl shadow-lg overflow-hidden mb-8 no-print">
                    <div class="flex justify-between items-center p-6 border-b bg-orange-50">
                        <div>
                            <h2 class="text-xl font-bold text-gray-800">⏳ Awaiting Payment Verification</h2>
                            <p class="text-gray-400 text-sm mt-0.5">Delivery Boy has deposited cash — verify and
                                generate invoice</p>
                        </div>
                        <span class="bg-orange-500 text-white text-sm font-bold px-4 py-1.5 rounded-full"
                            id="pendingBadge">2 Pending</span>
                    </div>
                    <div class="p-6 space-y-4" id="pendingList">

                        <!-- Pending Verification 1 -->
                        <div class="border-2 border-orange-200 rounded-2xl p-6 bg-orange-50" id="pay-295">
                            <div class="flex justify-between items-start gap-4">
                                <div>
                                    <div class="flex items-center gap-2 mb-2">
                                        <span class="font-black text-xl text-gray-800">#ORD-295</span>
                                        <span
                                            class="bg-orange-100 text-orange-700 text-xs font-bold px-2 py-1 rounded-full">Cash
                                            Received — Verify</span>
                                    </div>
                                    <p class="text-sm text-gray-600 mb-1">🏪 <strong>Patel Kirana Shop</strong> —
                                        Anklav, Anand</p>
                                    <p class="text-sm text-gray-500 mb-1">📦 Strawberry Cup × 10 cartons</p>
                                    <p class="text-sm text-gray-500 mb-1">🛵 Delivered by: <strong>Neha Singh</strong>
                                    </p>
                                    <p class="text-xl font-black text-emerald-600 mt-2">💵 Cash Received: ₹6,000</p>
                                </div>
                                <div class="flex flex-col gap-3 min-w-[200px]">
                                    <button
                                        onclick="verifyPayment('pay-295', 'ORD-295', 'Patel Kirana Shop', 'Anklav, Anand', 'Strawberry Cup × 10 cartons', '6,000')"
                                        class="bg-emerald-600 text-white py-3 px-4 rounded-xl font-bold hover:bg-emerald-700 transition text-sm">
                                        ✅ Verify & Generate Invoice
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Pending Verification 2 -->
                        <div class="border-2 border-orange-200 rounded-2xl p-6 bg-orange-50" id="pay-293">
                            <div class="flex justify-between items-start gap-4">
                                <div>
                                    <div class="flex items-center gap-2 mb-2">
                                        <span class="font-black text-xl text-gray-800">#ORD-293</span>
                                        <span
                                            class="bg-orange-100 text-orange-700 text-xs font-bold px-2 py-1 rounded-full">Cash
                                            Received — Verify</span>
                                    </div>
                                    <p class="text-sm text-gray-600 mb-1">🏪 <strong>Sharma Cold Store</strong> —
                                        Borsad, Anand</p>
                                    <p class="text-sm text-gray-500 mb-1">📦 Chocolate Cone × 8, Mango Shake × 3 cartons
                                    </p>
                                    <p class="text-sm text-gray-500 mb-1">🛵 Delivered by: <strong>Rohit Das</strong>
                                    </p>
                                    <p class="text-xl font-black text-emerald-600 mt-2">💵 Cash Received: ₹8,640</p>
                                </div>
                                <div class="flex flex-col gap-3 min-w-[200px]">
                                    <button
                                        onclick="verifyPayment('pay-293', 'ORD-293', 'Sharma Cold Store', 'Borsad, Anand', 'Chocolate Cone × 8 + Mango Shake × 3', '8,640')"
                                        class="bg-emerald-600 text-white py-3 px-4 rounded-xl font-bold hover:bg-emerald-700 transition text-sm">
                                        ✅ Verify & Generate Invoice
                                    </button>
                                </div>
                            </div>
                        </div>

                    </div>
                    <div id="allVerified" class="hidden p-10 text-center text-gray-400">
                        <div class="text-5xl mb-3">🎉</div>
                        <p class="font-semibold text-lg">All payments verified for today!</p>
                    </div>
                </div>

                <!-- VERIFIED PAYMENTS -->
                <div class="bg-white rounded-2xl shadow-lg overflow-hidden no-print">
                    <div class="p-6 border-b">
                        <h2 class="text-xl font-bold text-gray-800">✅ Verified Payments — Invoices Generated</h2>
                    </div>
                    <table class="w-full text-sm">
                        <thead class="bg-gray-50 text-gray-500 uppercase text-xs">
                            <tr>
                                <th class="py-3 px-6 text-left">Order ID</th>
                                <th class="px-6 text-left">Customer</th>
                                <th class="px-6 text-left">Amount</th>
                                <th class="px-6 text-left">Status</th>
                                <th class="px-6 text-left">Invoice</th>
                            </tr>
                        </thead>
                        <tbody class="text-gray-700" id="verifiedTable">
                            <tr class="border-b hover:bg-gray-50">
                                <td class="py-3 px-6 font-bold">#ORD-290</td>
                                <td class="px-6">Joshi Provisions</td>
                                <td class="px-6 font-bold text-emerald-600">₹5,760</td>
                                <td class="px-6"><span
                                        class="bg-green-100 text-green-700 px-2 py-0.5 rounded-full text-xs font-bold">PAID
                                        ✅</span></td>
                                <td class="px-6"><button
                                        onclick="printInvoice('ORD-290','Joshi Provisions','Nadiad','Vanilla Cone × 8 cartons','5,760')"
                                        class="text-blue-600 hover:underline text-xs font-semibold">🖨️ Print
                                        Invoice</button></td>
                            </tr>
                        </tbody>
                    </table>
                </div>

            </div>
        </div>

        <!-- INVOICE MODAL -->
        <div id="invoiceModal" class="hidden fixed inset-0 bg-black/60 flex items-center justify-center z-50 no-print">
            <div class="bg-white rounded-3xl shadow-2xl w-full max-w-xl p-0 overflow-hidden">
                <!-- Invoice Header -->
                <div
                    class="bg-gradient-to-r from-emerald-600 to-teal-600 text-white p-8 flex justify-between items-center">
                    <div>
                        <h1 class="text-3xl font-black">🍦 CoolStock</h1>
                        <p class="text-sm opacity-80 mt-1">Ice Cream Wholesale — Official Invoice</p>
                    </div>
                    <div class="text-right text-sm opacity-80">
                        <p id="inv-id" class="font-bold text-xl">INV-000</p>
                        <p id="inv-date"></p>
                    </div>
                </div>
                <!-- Invoice Body -->
                <div class="p-8">
                    <div class="flex justify-between mb-6">
                        <div>
                            <p class="text-xs text-gray-400 uppercase font-bold mb-1">Billed To</p>
                            <p class="font-black text-gray-800 text-lg" id="inv-customer">—</p>
                            <p class="text-gray-500 text-sm" id="inv-address">—</p>
                        </div>
                        <div class="text-right">
                            <p class="text-xs text-gray-400 uppercase font-bold mb-1">Payment Status</p>
                            <span class="bg-green-100 text-green-700 px-4 py-1.5 rounded-full font-black text-sm">PAID
                                ✅</span>
                        </div>
                    </div>
                    <table class="w-full text-sm mb-6">
                        <thead>
                            <tr class="border-b-2 text-gray-400 uppercase text-xs">
                                <th class="pb-3 text-left">Description</th>
                                <th class="pb-3 text-right">Amount</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="py-3 text-gray-700" id="inv-items">—</td>
                                <td class="py-3 text-right font-black text-gray-800">₹<span id="inv-subtotal">0</span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <div class="bg-emerald-50 rounded-2xl p-4 flex justify-between items-center mb-6">
                        <span class="font-bold text-gray-700 text-lg">Total Paid</span>
                        <span class="text-3xl font-black text-emerald-700">₹<span id="inv-total">0</span></span>
                    </div>
                    <div class="flex gap-3">
                        <button onclick="window.print()"
                            class="flex-1 py-3 bg-emerald-600 text-white font-bold rounded-2xl hover:bg-emerald-700 transition">🖨️
                            Print Invoice</button>
                        <button onclick="closeInvoice()"
                            class="flex-1 py-3 bg-gray-100 text-gray-700 font-bold rounded-2xl hover:bg-gray-200 transition">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <div id="toast"
            class="hidden fixed bottom-6 right-6 bg-emerald-500 text-white px-6 py-3 rounded-2xl shadow-2xl font-semibold z-50">
        </div>

        <script>
            let pendingVerify = 2;

            function showToast(msg) {
                const t = document.getElementById('toast');
                t.innerText = msg; t.classList.remove('hidden');
                setTimeout(() => t.classList.add('hidden'), 3500);
            }

            function verifyPayment(cardId, orderId, customer, address, items, amount) {
                document.getElementById(cardId).style.display = 'none';
                pendingVerify--;
                document.getElementById('pendingVerify').innerText = pendingVerify;
                document.getElementById('pendingBadge').innerText = pendingVerify + ' Pending';
                document.getElementById('verifiedCount').innerText = parseInt(document.getElementById('verifiedCount').innerText) + 1;
                if (pendingVerify <= 0) document.getElementById('allVerified').classList.remove('hidden');

                // Add to verified table
                const tbody = document.getElementById('verifiedTable');
                const row = document.createElement('tr');
                row.className = 'border-b hover:bg-gray-50 bg-green-50';
                row.innerHTML = `
        <td class="py-3 px-6 font-bold">#${orderId}</td>
        <td class="px-6">${customer}</td>
        <td class="px-6 font-bold text-emerald-600">₹${amount}</td>
        <td class="px-6"><span class="bg-green-100 text-green-700 px-2 py-0.5 rounded-full text-xs font-bold">PAID ✅</span></td>
        <td class="px-6"><button onclick="printInvoice('${orderId}','${customer}','${address}','${items}','${amount}')" class="text-blue-600 hover:underline text-xs font-semibold">🖨️ Print Invoice</button></td>
    `;
                tbody.prepend(row);
                showToast('✅ Payment verified! Invoice generated for ' + customer);
                printInvoice(orderId, customer, address, items, amount);
            }

            function printInvoice(orderId, customer, address, items, amount) {
                document.getElementById('inv-id').innerText = 'INV-' + orderId;
                document.getElementById('inv-date').innerText = new Date().toLocaleDateString('en-IN', { day: '2-digit', month: 'short', year: 'numeric' });
                document.getElementById('inv-customer').innerText = customer;
                document.getElementById('inv-address').innerText = address;
                document.getElementById('inv-items').innerText = items;
                document.getElementById('inv-subtotal').innerText = amount;
                document.getElementById('inv-total').innerText = amount;
                document.getElementById('invoiceModal').classList.remove('hidden');
            }

            function closeInvoice() { document.getElementById('invoiceModal').classList.add('hidden'); }

            setInterval(() => {
                const now = new Date();
                document.getElementById('liveClock').innerText = String(now.getHours()).padStart(2, '0') + ':' + String(now.getMinutes()).padStart(2, '0') + ':' + String(now.getSeconds()).padStart(2, '0');
                document.getElementById('liveDate').innerText = now.toDateString();
            }, 1000);
        </script>
    </body>

    </html>