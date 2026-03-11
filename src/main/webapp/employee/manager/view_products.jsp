<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Manage Products & Stock | Manager</title>
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
                            <h1 class="text-3xl font-black">&#x1F4E6; Inventory Management</h1>
                            <p class="opacity-70 mt-1">View products, add new items, and update stock</p>
                        </div>
                        <div class="flex gap-4 items-center">
                            <select id="categoryFilter" onchange="filterProducts()"
                                class="bg-white/20 border border-white/30 text-white rounded-xl px-4 py-2 text-sm font-semibold outline-none w-40">
                                <option value="all" class="text-gray-800">All Categories</option>
                                <option value="Tubs" class="text-gray-800">Tubs</option>
                                <option value="Cones" class="text-gray-800">Cones</option>
                                <option value="Sticks" class="text-gray-800">Sticks</option>
                            </select>
                            <input id="searchInput" type="text" placeholder="Search product..."
                                oninput="filterProducts()"
                                class="bg-white/20 border border-white/30 text-white placeholder-white/60 rounded-xl px-4 py-2 text-sm font-semibold outline-none w-52">
                            <button onclick="openProductModal()"
                                class="bg-blue-900 hover:bg-blue-800 text-white px-5 py-2 rounded-xl font-bold transition shadow-md whitespace-nowrap">
                                ➕ Add Product / Stock
                            </button>
                        </div>
                    </div>

                    <!-- Stats -->
                    <div class="grid grid-cols-3 gap-6 mb-6">
                        <div class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition">
                            <p class="text-gray-400 text-sm">Total Product Lines</p>
                            <p class="text-3xl font-black text-blue-700 mt-1" id="totalProductsCount">12</p>
                        </div>
                        <div
                            class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition border-l-4 border-red-500">
                            <p class="text-gray-400 text-sm">Low Stock Items</p>
                            <p class="text-3xl font-black text-red-600 mt-1" id="lowStockCount">2</p>
                        </div>
                        <div
                            class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition border-l-4 border-green-500">
                            <p class="text-gray-400 text-sm">Total Inventory Value</p>
                            <p class="text-3xl font-black text-green-600 mt-1" id="totalValueCount">₹0</p>
                        </div>
                    </div>

                    <div id="lowStockList" class="hidden mb-8 bg-red-50 p-5 rounded-2xl border border-red-200">
                        <!-- Populated dynamically -->
                    </div>

                    <div class="grid grid-cols-4 gap-6" id="productGrid"></div>
                </div>
        </div>

        <!-- Add Product Modal -->
        <div id="productModal"
            class="hidden fixed inset-0 bg-black/50 z-50 flex items-center justify-center backdrop-blur-sm">
            <div class="bg-white rounded-2xl shadow-2xl w-[550px] overflow-hidden transform transition-all">
                <div class="p-6 border-b border-gray-100 flex justify-between items-center bg-blue-50">
                    <h2 class="text-xl font-black text-gray-800">Add New Product / Stock</h2>
                    <button onclick="closeProductModal()"
                        class="text-gray-400 hover:text-red-500 text-2xl leading-none">&times;</button>
                </div>
                <form id="addProductForm" onsubmit="handleAddProduct(event)" class="p-6 space-y-4">
                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-1">Action</label>
                        <select id="existingProdSelect" onchange="handleProdSelect()"
                            class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition bg-white mb-4">
                            <option value="">-- Create New Product --</option>
                        </select>
                        <label class="block text-sm font-bold text-gray-700 mb-1">Product Name</label>
                        <input type="text" id="prodName" required placeholder="e.g. Vanilla Delight Tub"
                            class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition">
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Category</label>
                            <select id="prodCat"
                                class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition bg-white">
                                <option value="Tubs">Tubs</option>
                                <option value="Cones">Cones</option>
                                <option value="Sticks">Sticks</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Flavor</label>
                            <input type="text" id="prodFlavor" required placeholder="e.g. Vanilla"
                                class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition">
                        </div>
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Price (₹)</label>
                            <input type="number" id="prodPrice" required min="1" placeholder="120"
                                class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition">
                        </div>
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Add Stock Amount</label>
                            <input type="number" id="prodStock" required min="1" placeholder="50"
                                class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition">
                        </div>
                    </div>
                    <div class="pt-4 flex justify-end gap-3 border-t border-gray-100 mt-6">
                        <button type="button" onclick="closeProductModal()"
                            class="px-5 py-2 text-gray-500 font-bold hover:bg-gray-100 rounded-xl transition">Cancel</button>
                        <button type="submit"
                            class="px-5 py-2 bg-blue-600 text-white font-bold rounded-xl hover:bg-blue-700 transition shadow-md">Save
                            & Update Stock</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            var products = [
                { id: 'PROD-1', name: 'Vanilla Paradise Tub', category: 'Tubs', flavor: 'Vanilla', price: 120, stock: 450, emoji: '🍨', badge: 'bg-yellow-100 text-yellow-700' },
                { id: 'PROD-2', name: 'Rich Chocolate Cone', category: 'Cones', flavor: 'Chocolate', price: 40, stock: 1200, emoji: '🍦', badge: 'bg-blue-100 text-blue-700' },
                { id: 'PROD-3', name: 'Mango Magic Stick', category: 'Sticks', flavor: 'Mango', price: 25, stock: 35, emoji: '🍡', badge: 'bg-green-100 text-green-700', alert: true },
                { id: 'PROD-4', name: 'Strawberry Swirl Tub', category: 'Tubs', flavor: 'Strawberry', price: 150, stock: 310, emoji: '🍨', badge: 'bg-pink-100 text-pink-700' },
                { id: 'PROD-5', name: 'Butterscotch Crunch', category: 'Cones', flavor: 'Butterscotch', price: 50, stock: 850, emoji: '🍦', badge: 'bg-yellow-100 text-yellow-700' },
                { id: 'PROD-6', name: 'Black Current Stick', category: 'Sticks', flavor: 'Black Current', price: 30, stock: 10, emoji: '🍡', badge: 'bg-purple-100 text-purple-700', alert: true },
                { id: 'PROD-7', name: 'Kulfi Delight', category: 'Sticks', flavor: 'Kesar Pista', price: 35, stock: 540, emoji: '🍡', badge: 'bg-orange-100 text-orange-700' },
                { id: 'PROD-8', name: 'Cookies & Cream Tub', category: 'Tubs', flavor: 'Chocolate/Vanilla', price: 180, stock: 200, emoji: '🍨', badge: 'bg-gray-100 text-gray-700' },
                { id: 'PROD-9', name: 'Choco Lava Cone', category: 'Cones', flavor: 'Double Chocolate', price: 60, stock: 500, emoji: '🍦', badge: 'bg-red-100 text-red-700' },
                { id: 'PROD-10', name: 'Orange Candy Stick', category: 'Sticks', flavor: 'Orange', price: 15, stock: 2000, emoji: '🍡', badge: 'bg-orange-100 text-orange-700' },
                { id: 'PROD-11', name: 'Pista Green Tub', category: 'Tubs', flavor: 'Pistachio', price: 160, stock: 180, emoji: '🍨', badge: 'bg-green-100 text-green-700' },
                { id: 'PROD-12', name: 'Vanilla Plain Cone', category: 'Cones', flavor: 'Vanilla', price: 30, stock: 1400, emoji: '🍦', badge: 'bg-yellow-100 text-yellow-700' }
            ];

            function updateStats() {
                var total = 0;
                var low = 0;
                var value = 0;
                var lowNames = [];
                for (var i = 0; i < products.length; i++) {
                    total++;
                    if (products[i].stock < 50) {
                        low++;
                        lowNames.push(products[i].name + ' (' + products[i].stock + ' left)');
                    }
                    value += (products[i].price * products[i].stock);
                }
                document.getElementById('totalProductsCount').innerText = total;
                document.getElementById('lowStockCount').innerText = low;
                document.getElementById('totalValueCount').innerText = '₹' + value.toLocaleString();

                var lowStockDiv = document.getElementById('lowStockList');
                if (low > 0) {
                    lowStockDiv.classList.remove('hidden');
                    lowStockDiv.innerHTML = '<h3 class="font-bold text-red-700 mb-3 flex items-center gap-2">⚠️ <span>Items Running Low on Stock</span></h3><div class="flex flex-wrap gap-2">' + lowNames.map(function (name) { return '<span class="bg-white text-red-700 font-bold px-3 py-1.5 rounded-lg text-xs border border-red-200 shadow-sm">' + name + '</span>'; }).join('') + '</div>';
                } else {
                    lowStockDiv.classList.add('hidden');
                }
            }

            function buildProductCards(data) {
                var grid = document.getElementById('productGrid');
                grid.innerHTML = '';
                for (var i = 0; i < data.length; i++) {
                    var p = data[i];
                    var isAlert = p.stock < 50; // Dynamic low stock alert

                    var card = document.createElement('div');
                    card.className = 'prod-card bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden hover:-translate-y-1 transition duration-300 flex flex-col pt-6 relative';
                    card.setAttribute('data-search', (p.name + ' ' + p.flavor + ' ' + p.category).toLowerCase());
                    card.setAttribute('data-cat', p.category);

                    // Low stock badge
                    var alertBadge = isAlert ? '<div class="absolute top-3 right-3 bg-red-500 text-white text-[10px] uppercase font-black px-2 py-0.5 rounded-full animate-pulse tracking-wide">Low Stock!</div>' : '';
                    var stockColorClass = isAlert ? 'text-red-500 font-bold' : 'text-gray-500';

                    var html = '';
                    html += alertBadge;
                    html += '<div class="flex justify-center mb-4 text-6xl drop-shadow-md">' + p.emoji + '</div>';
                    html += '<div class="px-5 pb-5 flex-1 flex flex-col">';
                    html += '<div class="flex-1">';
                    html += '<span class="inline-block ' + p.badge + ' px-2 py-0.5 rounded-full text-xs font-bold mb-2">' + p.category + '</span>';
                    html += '<h3 class="font-black text-gray-800 text-lg leading-tight mb-1">' + p.name + '</h3>';
                    html += '<p class="text-gray-400 text-xs font-medium mb-3">Flavor: ' + p.flavor + '</p>';
                    html += '</div>';

                    html += '<div class="mt-auto border-t border-gray-100 pt-3 flex justify-between items-end">';
                    html += '<div>';
                    html += '<p class="text-[10px] text-gray-400 font-bold uppercase tracking-wider">Unit Price</p>';
                    html += '<p class="font-black text-blue-700 text-lg">₹' + p.price + '</p>';
                    html += '</div>';
                    html += '<div class="text-right">';
                    html += '<p class="text-[10px] text-gray-400 font-bold uppercase tracking-wider">In Stock</p>';
                    html += '<p class="text-sm ' + stockColorClass + '">' + p.stock + ' units</p>';
                    html += '</div>';
                    html += '</div>';
                    html += '</div>';

                    // Clicking card can also act as quick edit shortcut - optionally implemented
                    // card.onclick = function() { ... }

                    card.innerHTML = html;
                    grid.appendChild(card);
                }
                updateStats();
            }

            function filterProducts() {
                var q = document.getElementById('searchInput').value.toLowerCase();
                var cat = document.getElementById('categoryFilter').value;
                var cards = document.querySelectorAll('.prod-card');
                for (var i = 0; i < cards.length; i++) {
                    var matchText = cards[i].getAttribute('data-search').indexOf(q) !== -1;
                    var matchCat = cat === 'all' || cards[i].getAttribute('data-cat') === cat;
                    cards[i].style.display = (matchText && matchCat) ? 'flex' : 'none';
                }
            }

            function handleProdSelect() {
                var val = document.getElementById('existingProdSelect').value;
                if (val) {
                    var p = products.find(function (x) { return x.name === val; });
                    if (p) {
                        document.getElementById('prodName').value = p.name;
                        document.getElementById('prodCat').value = p.category;
                        document.getElementById('prodFlavor').value = p.flavor;
                        document.getElementById('prodPrice').value = p.price;

                        document.getElementById('prodName').readOnly = true;
                        document.getElementById('prodCat').disabled = true;
                        document.getElementById('prodFlavor').readOnly = true;
                        document.getElementById('prodPrice').readOnly = true;
                    }
                } else {
                    document.getElementById('addProductForm').reset();
                    document.getElementById('existingProdSelect').value = '';

                    document.getElementById('prodName').readOnly = false;
                    document.getElementById('prodCat').disabled = false;
                    document.getElementById('prodFlavor').readOnly = false;
                    document.getElementById('prodPrice').readOnly = false;
                }
            }

            function populateProdDropdown() {
                var sel = document.getElementById('existingProdSelect');
                sel.innerHTML = '<option value="">-- Create New Product --</option>';
                products.forEach(function (p) {
                    sel.innerHTML += '<option value="' + p.name + '">Restock: ' + p.name + '</option>';
                });
            }

            function openProductModal() {
                populateProdDropdown();
                document.getElementById('productModal').classList.remove('hidden');
            }
            function closeProductModal() {
                document.getElementById('productModal').classList.add('hidden');
                document.getElementById('addProductForm').reset();
                handleProdSelect(); // Clear readonly statuses
            }
            function handleAddProduct(e) {
                e.preventDefault();
                var name = document.getElementById('prodName').value;
                var cat = document.getElementById('prodCat').value;
                var flavor = document.getElementById('prodFlavor').value;
                var price = parseInt(document.getElementById('prodPrice').value);
                var stock = parseInt(document.getElementById('prodStock').value);

                // Simple mechanism to update existing product stock if name matches roughly
                var existing = null;
                for (var i = 0; i < products.length; i++) {
                    if (products[i].name.toLowerCase() === name.toLowerCase()) {
                        existing = products[i];
                        break;
                    }
                }

                if (existing) {
                    existing.stock += stock;
                    if (document.getElementById('prodPrice').value) existing.price = price;
                } else {
                    var emojis = { 'Tubs': '🍨', 'Cones': '🍦', 'Sticks': '🍡' };
                    var badges = { 'Tubs': 'bg-pink-100 text-pink-700', 'Cones': 'bg-blue-100 text-blue-700', 'Sticks': 'bg-orange-100 text-orange-700' };
                    products.unshift({
                        id: 'PROD-NEW-' + Date.now(),
                        name: name,
                        category: cat,
                        flavor: flavor,
                        price: price,
                        stock: stock,
                        emoji: emojis[cat] || '📦',
                        badge: badges[cat] || 'bg-gray-100 text-gray-700'
                    });
                }

                buildProductCards(products);
                filterProducts();
                closeProductModal();

                // Show success toast (implement if needed)
                alert(existing ? "Stock successfully updated for " + name : "New product added: " + name);
            }

            buildProductCards(products);
        </script>
    </body>

    </html>