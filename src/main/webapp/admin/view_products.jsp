<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Manage Products | CoolStock Admin</title>
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
                            <h1 class="text-3xl font-black">&#x1F4E6; Manage Products</h1>
                            <p class="opacity-70 mt-1">Ice cream inventory and product catalog</p>
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
                        </div>
                    </div>

                    <!-- Stats -->
                    <div class="grid grid-cols-3 gap-6 mb-8">
                        <div class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition">
                            <p class="text-gray-400 text-sm">Total Product Lines</p>
                            <p class="text-3xl font-black text-blue-700 mt-1">12</p>
                        </div>
                        <div
                            class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition border-l-4 border-red-500">
                            <p class="text-gray-400 text-sm">Low Stock Items</p>
                            <p class="text-3xl font-black text-red-600 mt-1">2</p>
                        </div>
                        <div class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition">
                            <p class="text-gray-400 text-sm">Best Seller Value</p>
                            <p class="text-3xl font-black text-green-600 mt-1">Chocolate Cone</p>
                        </div>
                    </div>

                    <div class="grid grid-cols-4 gap-6" id="productGrid"></div>
                </div>
        </div>

        <script>
            var products = [
                { id: 'PROD-1', name: 'Vanilla Paradise Tub', category: 'Tubs', flavor: 'Vanilla', price: '₹120', stock: 450, emoji: '🍨', badge: 'bg-yellow-100 text-yellow-700' },
                { id: 'PROD-2', name: 'Rich Chocolate Cone', category: 'Cones', flavor: 'Chocolate', price: '₹40', stock: 1200, emoji: '🍦', badge: 'bg-blue-100 text-blue-700' },
                { id: 'PROD-3', name: 'Mango Magic Stick', category: 'Sticks', flavor: 'Mango', price: '₹25', stock: 35, emoji: '🍡', badge: 'bg-green-100 text-green-700', alert: true },
                { id: 'PROD-4', name: 'Strawberry Swirl Tub', category: 'Tubs', flavor: 'Strawberry', price: '₹150', stock: 310, emoji: '🍨', badge: 'bg-pink-100 text-pink-700' },
                { id: 'PROD-5', name: 'Butterscotch Crunch', category: 'Cones', flavor: 'Butterscotch', price: '₹50', stock: 850, emoji: '🍦', badge: 'bg-yellow-100 text-yellow-700' },
                { id: 'PROD-6', name: 'Black Current Stick', category: 'Sticks', flavor: 'Black Current', price: '₹30', stock: 10, emoji: '🍡', badge: 'bg-purple-100 text-purple-700', alert: true },
                { id: 'PROD-7', name: 'Kulfi Delight', category: 'Sticks', flavor: 'Kesar Pista', price: '₹35', stock: 540, emoji: '🍡', badge: 'bg-orange-100 text-orange-700' },
                { id: 'PROD-8', name: 'Cookies & Cream Tub', category: 'Tubs', flavor: 'Chocolate/Vanilla', price: '₹180', stock: 200, emoji: '🍨', badge: 'bg-gray-100 text-gray-700' },
                { id: 'PROD-9', name: 'Choco Lava Cone', category: 'Cones', flavor: 'Double Chocolate', price: '₹60', stock: 500, emoji: '🍦', badge: 'bg-red-100 text-red-700' },
                { id: 'PROD-10', name: 'Orange Candy Stick', category: 'Sticks', flavor: 'Orange', price: '₹15', stock: 2000, emoji: '🍡', badge: 'bg-orange-100 text-orange-700' },
                { id: 'PROD-11', name: 'Pista Green Tub', category: 'Tubs', flavor: 'Pistachio', price: '₹160', stock: 180, emoji: '🍨', badge: 'bg-green-100 text-green-700' },
                { id: 'PROD-12', name: 'Vanilla Plain Cone', category: 'Cones', flavor: 'Vanilla', price: '₹30', stock: 1400, emoji: '🍦', badge: 'bg-yellow-100 text-yellow-700' }
            ];

            function buildProductCards(data) {
                var grid = document.getElementById('productGrid');
                grid.innerHTML = '';
                for (var i = 0; i < data.length; i++) {
                    var p = data[i];

                    var card = document.createElement('div');
                    card.className = 'prod-card bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden hover:-translate-y-1 transition duration-300 flex flex-col pt-6 relative';
                    card.setAttribute('data-search', (p.name + ' ' + p.flavor + ' ' + p.category).toLowerCase());
                    card.setAttribute('data-cat', p.category);

                    // Low stock badge
                    var alertBadge = p.alert ? '<div class="absolute top-3 right-3 bg-red-500 text-white text-[10px] uppercase font-black px-2 py-0.5 rounded-full animate-pulse tracking-wide">Low Stock!</div>' : '';

                    // Stock color logic
                    var stockColorClass = p.alert ? 'text-red-500 font-bold' : 'text-gray-500';

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
                    html += '<p class="font-black text-blue-700 text-lg">' + p.price + '</p>';
                    html += '</div>';
                    html += '<div class="text-right">';
                    html += '<p class="text-[10px] text-gray-400 font-bold uppercase tracking-wider">In Stock</p>';
                    html += '<p class="text-sm ' + stockColorClass + '">' + p.stock + ' units</p>';
                    html += '</div>';
                    html += '</div>';
                    html += '</div>';

                    card.innerHTML = html;
                    grid.appendChild(card);
                }
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

            buildProductCards(products);
        </script>
    </body>

    </html>