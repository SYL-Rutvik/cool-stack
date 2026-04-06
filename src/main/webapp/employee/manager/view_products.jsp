<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
    <% if ("POST".equalsIgnoreCase(request.getMethod())) { String action=request.getParameter("action"); if
        ("add_or_update".equals(action)) { String name=request.getParameter("name"); String
        cat=request.getParameter("category"); String flavor=request.getParameter("flavor"); String
        priceStr=request.getParameter("price"); String stockStr=request.getParameter("stock"); try (java.sql.Connection
        conn=com.coolstack.util.DBConnection.getConnection()) { java.sql.PreparedStatement
        checkStmt=conn.prepareStatement( "SELECT id FROM products WHERE name = ?" ); checkStmt.setString(1, name);
        java.sql.ResultSet rs=checkStmt.executeQuery(); if (rs.next()) { int pid=rs.getInt("id");
        java.sql.PreparedStatement
        updateStmt=conn.prepareStatement( "UPDATE products SET stock_quantity = stock_quantity + ? WHERE id = ?" );
        updateStmt.setInt(1, Integer.parseInt(stockStr)); updateStmt.setInt(2, pid); updateStmt.executeUpdate();
        updateStmt.close(); } else { java.sql.PreparedStatement
        insertStmt=conn.prepareStatement( "INSERT INTO products (name, category, flavor, price, stock_quantity) "
        + "VALUES (?, ?, ?, ?, ?)" ); insertStmt.setString(1, name); insertStmt.setString(2, cat);
        insertStmt.setString(3, flavor); insertStmt.setBigDecimal(4, new java.math.BigDecimal(priceStr));
        insertStmt.setInt(5, Integer.parseInt(stockStr)); insertStmt.executeUpdate(); insertStmt.close(); }
        checkStmt.close(); } catch (Exception e) { e.printStackTrace(); } response.sendRedirect("view_products.jsp");
        return; } } %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Manage Products And Stock | Manager</title>
            <script src="https://cdn.tailwindcss.com"></script>
            <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&display=swap"
                rel="stylesheet">
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
                    <form id="addProductForm" method="POST" action="view_products.jsp" class="p-6 space-y-4">
                        <input type="hidden" name="action" value="add_or_update">
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Action</label>
                            <select id="existingProdSelect" onchange="handleProdSelect()"
                                class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition bg-white mb-4">
                                <option value="">-- Create New Product --</option>
                            </select>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Product Name</label>
                            <input type="text" id="prodName" name="name" required placeholder="e.g. Vanilla Delight Tub"
                                class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition">
                        </div>
                        <div class="grid grid-cols-2 gap-4">
                            <div>
                                <label class="block text-sm font-bold text-gray-700 mb-1">Category</label>
                                <select id="prodCat" name="category"
                                    class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition bg-white">
                                    <option value="Tubs">Tubs</option>
                                    <option value="Cones">Cones</option>
                                    <option value="Sticks">Sticks</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-sm font-bold text-gray-700 mb-1">Flavor</label>
                                <input type="text" id="prodFlavor" name="flavor" required placeholder="e.g. Vanilla"
                                    class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition">
                            </div>
                        </div>
                        <div class="grid grid-cols-2 gap-4">
                            <div>
                                <label class="block text-sm font-bold text-gray-700 mb-1">Price (₹)</label>
                                <input type="number" id="prodPrice" name="price" required min="1" placeholder="120"
                                    class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition">
                            </div>
                            <div>
                                <label class="block text-sm font-bold text-gray-700 mb-1">Add Stock Amount</label>
                                <input type="number" id="prodStock" name="stock" required min="1" placeholder="50"
                                    class="w-full border border-gray-300 rounded-xl px-4 py-2 outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-200 transition">
                            </div>
                        </div>
                        <div class="pt-4 flex justify-end gap-3 border-t border-gray-100 mt-6">
                            <button type="button" onclick="closeProductModal()"
                                class="px-5 py-2 text-gray-500 font-bold hover:bg-gray-100 rounded-xl transition">Cancel</button>
                            <button type="submit"
                                class="px-5 py-2 bg-blue-600 text-white font-bold rounded-xl hover:bg-blue-700 transition shadow-md">Save
                                And Update Stock</button>
                        </div>
                    </form>
                </div>
            </div>

            <script>
                var products = [
                <% 
                    try (java.sql.Connection conn = com.coolstack.util.DBConnection.getConnection()) {
                    java.sql.Statement stmt = conn.createStatement();
                    java.sql.ResultSet rsProd = stmt.executeQuery("SELECT * FROM products");
                    while (rsProd.next()) {
                            int stock = rsProd.getInt("stock_quantity");
                            boolean alert = stock < 50;
                            String badge = "bg-blue-100 text-blue-700";
                        out.print("{ id: 'PROD-" + rsProd.getInt("id") + "', name: '" + rsProd.getString("name").replace("'", "\\'") + "', category: '" + rsProd.getString("category").replace("'", "\\'") + "', flavor: '" + rsProd.getString("flavor").replace("'", "\\'") + "', price: " + rsProd.getBigDecimal("price") + ", stock: " + stock + ", emoji: '🍦', badge: '" + badge + "', alert: " + alert + " },");
                    }
                } catch (Exception e) { e.printStackTrace(); }
                %>
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

                buildProductCards(products);
            </script>
        </body>

        </html>