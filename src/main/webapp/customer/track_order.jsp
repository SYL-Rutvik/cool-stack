<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Track Orders | CoolStock</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&display=swap" rel="stylesheet">
        <style>
            body {
                font-family: 'Outfit', sans-serif;
            }

            .step {
                position: relative;
            }

            .step::before {
                content: '';
                position: absolute;
                top: 50%;
                left: -50%;
                width: 100%;
                height: 3px;
                background: #e5e7eb;
                z-index: 0;
            }

            .step.done::before {
                background: #10b981;
            }

            .step:first-child::before {
                display: none;
            }
        </style>
    </head>

    <body class="bg-gray-100 min-h-screen">

        <!-- Customer Nav -->
        <nav class="bg-white shadow-sm sticky top-0 z-40 px-6 py-3 flex justify-between items-center">
            <div class="flex items-center gap-2">
                <span class="text-3xl">🍦</span>
                <div><span class="text-xl font-black text-gray-800">CoolStock</span><span
                        class="text-xs text-gray-400 ml-2">Customer Portal</span></div>
            </div>
            <div class="flex gap-4 text-sm font-semibold">
                <a href="place_order.jsp" class="text-gray-500 hover:text-purple-600 transition">📦 Place Order</a>
                <a href="track_order.jsp" class="text-purple-600 border-b-2 border-purple-600 pb-0.5">📍 Track
                    Orders</a>
                <a href="profile.jsp" class="text-gray-500 hover:text-purple-600 transition">👤 My Profile</a>
            </div>
            <a href="../logout.jsp"
                class="bg-red-100 text-red-600 px-4 py-2 rounded-xl font-semibold text-sm hover:bg-red-200 transition">🚪
                Logout</a>
        </nav>

        <div class="max-w-4xl mx-auto px-6 py-8">

            <div class="bg-gradient-to-r from-purple-600 to-pink-500 text-white p-7 rounded-2xl mb-8 shadow-lg">
                <h1 class="text-3xl font-black">📍 Track My Orders</h1>
                <p class="opacity-80 mt-1">Live status of all your bulk orders. Download invoice after payment.</p>
            </div>

            <!-- Orders will render here -->
            <div id="ordersContainer" class="space-y-6"></div>

            <div id="emptyState" class="hidden text-center py-16 bg-white rounded-2xl shadow">
                <div class="text-7xl mb-4">📦</div>
                <h2 class="text-2xl font-bold text-gray-700 mb-2">No Orders Yet</h2>
                <p class="text-gray-400 mb-6">Place your first bulk order for your shop.</p>
                <a href="place_order.jsp"
                    class="px-8 py-3 bg-purple-600 text-white font-bold rounded-2xl hover:bg-purple-700 transition">Place
                    Bulk Order</a>
            </div>
        </div>

        <!-- Invoice Modal -->
        <div id="invModal" class="hidden fixed inset-0 bg-black/60 flex items-center justify-center z-50 p-4">
            <div class="bg-white rounded-3xl shadow-2xl w-full max-w-xl overflow-hidden">
                <div
                    class="bg-gradient-to-r from-emerald-600 to-teal-600 text-white p-8 flex justify-between items-center">
                    <div>
                        <h1 class="text-3xl font-black">🍦 CoolStock</h1>
                        <p class="text-sm opacity-80 mt-1">Official Invoice</p>
                    </div>
                    <div class="text-right">
                        <p id="mi-id" class="font-bold text-xl">INV-000</p>
                        <p id="mi-date" class="text-sm opacity-80"></p>
                    </div>
                </div>
                <div class="p-8">
                    <div class="flex justify-between mb-6">
                        <div>
                            <p class="text-xs text-gray-400 uppercase font-bold mb-1">Billed To</p>
                            <p class="font-black text-lg text-gray-800" id="mi-shop">—</p>
                            <p class="text-gray-500 text-sm" id="mi-addr">—</p>
                        </div>
                        <div class="text-right">
                            <p class="text-xs text-gray-400 uppercase font-bold mb-1">Payment Status</p><span
                                class="bg-green-100 text-green-700 px-4 py-1.5 rounded-full font-black text-sm">PAID
                                ✅</span>
                        </div>
                    </div>
                    <div class="bg-gray-50 rounded-xl p-4 mb-4">
                        <p class="text-sm text-gray-700" id="mi-items">—</p>
                    </div>
                    <div class="bg-emerald-50 rounded-2xl p-4 flex justify-between items-center mb-6">
                        <span class="font-bold text-gray-700">Total Paid (COD)</span>
                        <span class="text-3xl font-black text-emerald-700">₹<span id="mi-total">0</span></span>
                    </div>
                    <div class="flex gap-3">
                        <button onclick="window.print()"
                            class="flex-1 py-3 bg-emerald-600 text-white font-bold rounded-2xl hover:bg-emerald-700 transition">🖨️
                            Download / Print</button>
                        <button onclick="document.getElementById('invModal').classList.add('hidden')"
                            class="flex-1 py-3 bg-gray-100 text-gray-700 font-bold rounded-2xl hover:bg-gray-200 transition">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <script>
            const statusConfig = {
                'Pending': { color: 'bg-orange-100 text-orange-700', icon: '⏳', steps: 0 },
                'Assigned': { color: 'bg-blue-100 text-blue-700', icon: '📌', steps: 1 },
                'In Transit': { color: 'bg-indigo-100 text-indigo-700', icon: '🛵', steps: 2 },
                'Delivered': { color: 'bg-teal-100 text-teal-700', icon: '📦', steps: 3 },
                'Paid': { color: 'bg-green-100 text-green-700', icon: '✅', steps: 4 }
            };

            const allSteps = ['Order Placed', 'Assigned to Delivery', 'Out for Delivery', 'Delivered', 'Payment Received'];

            function renderOrders() {
                let orders = JSON.parse(localStorage.getItem('cs_orders') || '[]');
                // Add demo orders if none exist
                if (!orders.length) {
                    orders = [
                        { id: '#ORD-290', shop: 'Joshi Provisions', addr: 'Nadiad, Kheda', items: 'Vanilla Cone × 8 cartons', amount: 5760, status: 'Paid', date: '10/3/2026 9:00 AM' },
                        { id: '#ORD-285', shop: 'My Shop', addr: 'Village, Dist.', items: 'Chocolate Cone × 5 cartons', amount: 3600, status: 'In Transit', date: '10/3/2026 8:00 AM' },
                    ];
                }

                const container = document.getElementById('ordersContainer');
                const empty = document.getElementById('emptyState');
                container.innerHTML = '';

                if (!orders.length) { empty.classList.remove('hidden'); return; }
                empty.classList.add('hidden');

                orders.forEach(order => {
                    const cfg = statusConfig[order.status] || statusConfig['Pending'];
                    const stepsDone = cfg.steps;

                    var stepsHtml = '';
                    for (var i = 0; i < allSteps.length; i++) {
                        var s = allSteps[i];
                        var circleBg = (i <= stepsDone) ? 'bg-purple-600 text-white' : 'bg-gray-200 text-gray-400';
                        var circleContent = (i <= stepsDone) ? '✓' : (i + 1);
                        var textClass = (i <= stepsDone) ? 'text-purple-700 font-semibold' : 'text-gray-400';

                        stepsHtml += '<div class="flex flex-col items-center">';
                        stepsHtml += '<div class="w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold mb-1 ' + circleBg + '">';
                        stepsHtml += circleContent;
                        stepsHtml += '</div>';
                        stepsHtml += '<span class="text-xs text-center leading-tight ' + textClass + '" style="max-width:60px">' + s + '</span>';
                        stepsHtml += '</div>';

                        if (i < allSteps.length - 1) {
                            var lineBg = (i < stepsDone) ? 'bg-purple-600' : 'bg-gray-200';
                            stepsHtml += '<div class="flex-1 mt-4 h-0.5 ' + lineBg + '"></div>';
                        }
                    }

                    var btnHtml = '';
                    if (order.status === 'Paid') {
                        btnHtml = '<button onclick="viewInvoice(\'' + order.id + '\',\'' + order.shop + '\',\'' + order.addr + '\',\'' + order.items + '\',' + order.amount + ')" ' +
                            'class="w-full py-2.5 bg-emerald-600 text-white font-bold rounded-xl hover:bg-emerald-700 transition text-sm">' +
                            '📄 Download Invoice</button>';
                    } else {
                        btnHtml = '<p class="text-center text-xs text-gray-400 bg-gray-50 rounded-xl py-2">Invoice will be available after payment verification by Cashier</p>';
                    }

                    const card = document.createElement('div');
                    card.className = 'bg-white rounded-2xl shadow-lg p-6';

                    var html = '';
                    html += '<div class="flex justify-between items-start mb-4">';
                    html += '<div>';
                    html += '<span class="font-black text-xl text-gray-800">' + order.id + '</span>';
                    html += '<span class="' + cfg.color + ' ml-2 px-3 py-0.5 rounded-full text-xs font-bold">' + cfg.icon + ' ' + order.status + '</span>';
                    html += '<p class="text-gray-400 text-xs mt-1">📅 ' + order.date + '</p>';
                    html += '</div>';
                    html += '<p class="font-black text-2xl text-purple-700">&#x20B9;' + Number(order.amount).toLocaleString('en-IN') + '</p>';
                    html += '</div>';
                    html += '<p class="text-sm text-gray-600 mb-1">🏪 <strong>' + order.shop + '</strong> \u2014 ' + order.addr + '</p>';
                    html += '<p class="text-sm text-gray-500 mb-5">📦 ' + order.items + '</p>';
                    html += '<div class="flex w-full items-start mb-5">' + stepsHtml + '</div>';
                    html += btnHtml;

                    card.innerHTML = html;
                    container.appendChild(card);
                });
            }

            function viewInvoice(id, shop, addr, items, amount) {
                document.getElementById('mi-id').innerText = 'INV-' + id.replace('#', '');
                document.getElementById('mi-date').innerText = new Date().toLocaleDateString('en-IN', { day: '2-digit', month: 'short', year: 'numeric' });
                document.getElementById('mi-shop').innerText = shop;
                document.getElementById('mi-addr').innerText = addr;
                document.getElementById('mi-items').innerText = items;
                document.getElementById('mi-total').innerText = Number(amount).toLocaleString('en-IN');
                document.getElementById('invModal').classList.remove('hidden');
            }

            renderOrders();
        </script>
    </body>

    </html>