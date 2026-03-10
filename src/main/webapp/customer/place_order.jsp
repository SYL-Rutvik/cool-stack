<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Place Bulk Order | CoolStock</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&display=swap" rel="stylesheet">
        <style>
            body {
                font-family: 'Outfit', sans-serif;
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
                <a href="place_order.jsp" class="text-purple-600 border-b-2 border-purple-600 pb-0.5">📦 Place Order</a>
                <a href="track_order.jsp" class="text-gray-500 hover:text-purple-600 transition">📍 Track Orders</a>
            </div>
            <a href="../logout.jsp"
                class="bg-red-100 text-red-600 px-4 py-2 rounded-xl font-semibold text-sm hover:bg-red-200 transition">🚪
                Logout</a>
        </nav>

        <div class="max-w-5xl mx-auto px-6 py-8">

            <!-- Welcome -->
            <div class="bg-gradient-to-r from-purple-600 to-pink-500 text-white p-7 rounded-2xl mb-8 shadow-lg">
                <h1 class="text-3xl font-black">📦 Place Bulk Order</h1>
                <p class="opacity-80 mt-1">Select products in cartons. Minimum 1 carton per product. We deliver to your
                    shop.</p>
            </div>

            <div class="grid grid-cols-3 gap-8">

                <!-- Product Selection -->
                <div class="col-span-2 space-y-4">
                    <h2 class="text-xl font-bold text-gray-800 mb-2">🛒 Select Products (in Cartons)</h2>

                    <div class="grid grid-cols-2 gap-4">

                        <div class="bg-white rounded-2xl p-5 shadow hover:-translate-y-1 transition">
                            <div class="text-4xl mb-2">🍫</div>
                            <h3 class="font-bold text-gray-800">Chocolate Cone</h3>
                            <p class="text-xs text-gray-400">1 Carton = 12 cones</p>
                            <p class="text-purple-600 font-black text-lg mt-1">₹720 / carton</p>
                            <div class="flex items-center gap-3 mt-3">
                                <button onclick="change('ChocolateCone', -1, 720)"
                                    class="w-9 h-9 bg-gray-100 rounded-xl font-bold text-lg hover:bg-red-100 transition">−</button>
                                <span id="qty-ChocolateCone" class="font-black text-xl w-8 text-center">0</span>
                                <button onclick="change('ChocolateCone', 1, 720)"
                                    class="w-9 h-9 bg-gray-100 rounded-xl font-bold text-lg hover:bg-green-100 transition">+</button>
                            </div>
                        </div>

                        <div class="bg-white rounded-2xl p-5 shadow hover:-translate-y-1 transition">
                            <div class="text-4xl mb-2">🍦</div>
                            <h3 class="font-bold text-gray-800">Vanilla Cone</h3>
                            <p class="text-xs text-gray-400">1 Carton = 12 cones</p>
                            <p class="text-purple-600 font-black text-lg mt-1">₹660 / carton</p>
                            <div class="flex items-center gap-3 mt-3">
                                <button onclick="change('VanillaCone', -1, 660)"
                                    class="w-9 h-9 bg-gray-100 rounded-xl font-bold text-lg hover:bg-red-100 transition">−</button>
                                <span id="qty-VanillaCone" class="font-black text-xl w-8 text-center">0</span>
                                <button onclick="change('VanillaCone', 1, 660)"
                                    class="w-9 h-9 bg-gray-100 rounded-xl font-bold text-lg hover:bg-green-100 transition">+</button>
                            </div>
                        </div>

                        <div class="bg-white rounded-2xl p-5 shadow hover:-translate-y-1 transition">
                            <div class="text-4xl mb-2">🍓</div>
                            <h3 class="font-bold text-gray-800">Strawberry Cup</h3>
                            <p class="text-xs text-gray-400">1 Carton = 24 cups</p>
                            <p class="text-purple-600 font-black text-lg mt-1">₹600 / carton</p>
                            <div class="flex items-center gap-3 mt-3">
                                <button onclick="change('StrawberryCup', -1, 600)"
                                    class="w-9 h-9 bg-gray-100 rounded-xl font-bold text-lg hover:bg-red-100 transition">−</button>
                                <span id="qty-StrawberryCup" class="font-black text-xl w-8 text-center">0</span>
                                <button onclick="change('StrawberryCup', 1, 600)"
                                    class="w-9 h-9 bg-gray-100 rounded-xl font-bold text-lg hover:bg-green-100 transition">+</button>
                            </div>
                        </div>

                        <div class="bg-white rounded-2xl p-5 shadow hover:-translate-y-1 transition">
                            <div class="text-4xl mb-2">🥭</div>
                            <h3 class="font-bold text-gray-800">Mango Shake</h3>
                            <p class="text-xs text-gray-400">1 Carton = 12 bottles</p>
                            <p class="text-purple-600 font-black text-lg mt-1">₹960 / carton</p>
                            <div class="flex items-center gap-3 mt-3">
                                <button onclick="change('MangoShake', -1, 960)"
                                    class="w-9 h-9 bg-gray-100 rounded-xl font-bold text-lg hover:bg-red-100 transition">−</button>
                                <span id="qty-MangoShake" class="font-black text-xl w-8 text-center">0</span>
                                <button onclick="change('MangoShake', 1, 960)"
                                    class="w-9 h-9 bg-gray-100 rounded-xl font-bold text-lg hover:bg-green-100 transition">+</button>
                            </div>
                        </div>

                        <div class="bg-white rounded-2xl p-5 shadow hover:-translate-y-1 transition">
                            <div class="text-4xl mb-2">📦</div>
                            <h3 class="font-bold text-gray-800">Family Pack</h3>
                            <p class="text-xs text-gray-400">1 Case = 12 family packs</p>
                            <p class="text-purple-600 font-black text-lg mt-1">₹2,640 / case</p>
                            <div class="flex items-center gap-3 mt-3">
                                <button onclick="change('FamilyPack', -1, 2640)"
                                    class="w-9 h-9 bg-gray-100 rounded-xl font-bold text-lg hover:bg-red-100 transition">−</button>
                                <span id="qty-FamilyPack" class="font-black text-xl w-8 text-center">0</span>
                                <button onclick="change('FamilyPack', 1, 2640)"
                                    class="w-9 h-9 bg-gray-100 rounded-xl font-bold text-lg hover:bg-green-100 transition">+</button>
                            </div>
                        </div>

                        <div class="bg-white rounded-2xl p-5 shadow hover:-translate-y-1 transition">
                            <div class="text-4xl mb-2">🧈</div>
                            <h3 class="font-bold text-gray-800">Butterscotch Cup</h3>
                            <p class="text-xs text-gray-400">1 Carton = 24 cups</p>
                            <p class="text-purple-600 font-black text-lg mt-1">₹660 / carton</p>
                            <div class="flex items-center gap-3 mt-3">
                                <button onclick="change('ButterscotchCup', -1, 660)"
                                    class="w-9 h-9 bg-gray-100 rounded-xl font-bold text-lg hover:bg-red-100 transition">−</button>
                                <span id="qty-ButterscotchCup" class="font-black text-xl w-8 text-center">0</span>
                                <button onclick="change('ButterscotchCup', 1, 660)"
                                    class="w-9 h-9 bg-gray-100 rounded-xl font-bold text-lg hover:bg-green-100 transition">+</button>
                            </div>
                        </div>

                    </div>
                </div>

                <!-- Order Summary + Submit -->
                <div class="space-y-4">
                    <div class="bg-white rounded-2xl shadow-lg p-6 sticky top-20">
                        <h2 class="text-xl font-bold text-gray-800 mb-4">📋 Order Summary</h2>
                        <div id="summaryLines" class="space-y-2 text-sm text-gray-600 mb-4 min-h-[60px]">
                            <p class="text-gray-300 italic">No items selected yet...</p>
                        </div>
                        <div class="border-t pt-4 space-y-2">
                            <div class="flex justify-between text-sm"><span>Subtotal</span><span id="subtotal">₹0</span>
                            </div>
                            <div class="flex justify-between text-sm text-green-600">
                                <span>Delivery</span><span>FREE</span></div>
                            <div class="flex justify-between font-black text-lg border-t pt-2 mt-2">
                                <span>Total (COD)</span><span class="text-purple-700" id="total">₹0</span>
                            </div>
                        </div>

                        <div class="mt-5 space-y-3">
                            <div>
                                <label class="block text-xs font-semibold text-gray-500 mb-1">Shop / Business
                                    Name</label>
                                <input type="text" id="shopName" placeholder="e.g. Ramesh General Store"
                                    class="w-full border-2 border-gray-200 rounded-xl px-3 py-2 text-sm focus:border-purple-400 outline-none">
                            </div>
                            <div>
                                <label class="block text-xs font-semibold text-gray-500 mb-1">Village / Town /
                                    Address</label>
                                <input type="text" id="shopAddress" placeholder="e.g. Village Khari, Anand"
                                    class="w-full border-2 border-gray-200 rounded-xl px-3 py-2 text-sm focus:border-purple-400 outline-none">
                            </div>
                            <div>
                                <label class="block text-xs font-semibold text-gray-500 mb-1">Contact Number</label>
                                <input type="text" id="shopPhone" placeholder="+91 98765 43210"
                                    class="w-full border-2 border-gray-200 rounded-xl px-3 py-2 text-sm focus:border-purple-400 outline-none">
                            </div>
                        </div>

                        <button onclick="placeOrder()"
                            class="mt-5 w-full py-3 bg-gradient-to-r from-purple-600 to-pink-500 text-white font-black rounded-2xl hover:opacity-90 transition shadow-lg">
                            🚀 Place Bulk Order
                        </button>
                        <p class="text-center text-xs text-gray-400 mt-2">Payment: Cash on Delivery</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Success Modal -->
        <div id="successModal" class="hidden fixed inset-0 bg-black/60 flex items-center justify-center z-50 p-4">
            <div class="bg-white rounded-3xl shadow-2xl w-full max-w-sm p-8 text-center">
                <div class="text-7xl mb-4">🎉</div>
                <h2 class="text-3xl font-black text-gray-800 mb-2">Order Placed!</h2>
                <p class="text-gray-500 text-sm mb-2">Your order has been received by our team.</p>
                <p class="text-gray-500 text-sm mb-6">Our Manager will assign a Delivery Boy shortly.</p>
                <div class="bg-purple-50 rounded-xl p-3 mb-6">
                    <p class="text-xs text-gray-500">Order ID</p>
                    <p class="font-black text-purple-700 text-xl" id="newOrderId"></p>
                </div>
                <a href="track_order.jsp"
                    class="block w-full py-3 bg-purple-600 text-white font-bold rounded-2xl hover:bg-purple-700 transition">
                    📍 Track My Order
                </a>
            </div>
        </div>

        <script>
            const cart = {};
            const prices = { ChocolateCone: 720, VanillaCone: 660, StrawberryCup: 600, MangoShake: 960, FamilyPack: 2640, ButterscotchCup: 660 };
            const labels = { ChocolateCone: 'Chocolate Cone', VanillaCone: 'Vanilla Cone', StrawberryCup: 'Strawberry Cup', MangoShake: 'Mango Shake', FamilyPack: 'Family Pack', ButterscotchCup: 'Butterscotch Cup' };

            function change(name, delta, price) {
                if (!cart[name]) cart[name] = 0;
                cart[name] = Math.max(0, cart[name] + delta);
                document.getElementById('qty-' + name).innerText = cart[name];
                updateSummary();
            }

            function updateSummary() {
                const lines = document.getElementById('summaryLines');
                let total = 0, html = '';
                for (const [k, qty] of Object.entries(cart)) {
                    if (qty > 0) { html += `<div class="flex justify-between"><span>${labels[k]} × ${qty}</span><span class="font-semibold">₹${(prices[k] * qty).toLocaleString('en-IN')}</span></div>`; total += prices[k] * qty; }
                }
                lines.innerHTML = html || '<p class="text-gray-300 italic">No items selected yet...</p>';
                document.getElementById('subtotal').innerText = '₹' + total.toLocaleString('en-IN');
                document.getElementById('total').innerText = '₹' + total.toLocaleString('en-IN');
            }

            function placeOrder() {
                const shop = document.getElementById('shopName').value.trim();
                const addr = document.getElementById('shopAddress').value.trim();
                const phone = document.getElementById('shopPhone').value.trim();
                const total = Object.values(cart).reduce((s, q, i) => s, 0);
                const hasItems = Object.values(cart).some(q => q > 0);
                if (!hasItems) { alert('Please select at least 1 carton!'); return; }
                if (!shop || !addr || !phone) { alert('Please fill in your shop details!'); return; }

                const orderId = '#ORD-' + (300 + Math.floor(Math.random() * 100));

                // Save to localStorage for tracking
                let orders = JSON.parse(localStorage.getItem('cs_orders') || '[]');
                const items = Object.entries(cart).filter(([, q]) => q > 0).map(([k, q]) => `${labels[k]} × ${q} cartons`).join(', ');
                const amt = Object.entries(cart).reduce((s, [k, q]) => s + prices[k] * q, 0);
                orders.unshift({ id: orderId, shop, addr, phone, items, amount: amt, status: 'Pending', date: new Date().toLocaleString('en-IN') });
                localStorage.setItem('cs_orders', JSON.stringify(orders));

                document.getElementById('newOrderId').innerText = orderId;
                document.getElementById('successModal').classList.remove('hidden');
            }
        </script>
    </body>

    </html>