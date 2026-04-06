<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%@ page import="java.sql.*, java.math.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Products | CoolStock Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Outfit', sans-serif; }
    </style>
</head>

<body class="bg-gray-100 min-h-screen">
    <div class="flex">
        <%@ include file="sidebar.jsp" %>
        <div class="ml-64 p-8 w-full">

            <div class="bg-gradient-to-r from-blue-700 to-cyan-600 text-white p-7 rounded-2xl mb-8 flex justify-between items-center shadow-lg">
                <div>
                    <h1 class="text-3xl font-black">&#x1F4E6; Manage Products</h1>
                    <p class="opacity-70 mt-1">Ice cream inventory and product catalog</p>
                </div>
                <div class="flex gap-4 items-center">
                    <select id="categoryFilter" onchange="filterProducts()" class="bg-white/20 border border-white/30 text-white rounded-xl px-4 py-2 text-sm font-semibold outline-none w-40">
                        <option value="all" class="text-gray-800">All Categories</option>
                        <option value="Tubs" class="text-gray-800">Tubs</option>
                        <option value="Cones" class="text-gray-800">Cones</option>
                        <option value="Sticks" class="text-gray-800">Sticks</option>
                    </select>
                    <input id="searchInput" type="text" placeholder="Search product..." oninput="filterProducts()" class="bg-white/20 border border-white/30 text-white placeholder-white/60 rounded-xl px-4 py-2 text-sm font-semibold outline-none w-52">
                </div>
            </div>

            <% 
                int totalProducts = 0; int lowStockCount = 0; String bestSeller = "N/A";
                try (Connection conn = com.coolstack.util.DBConnection.getConnection(); Statement stmt = conn.createStatement()) {
                    // All queries below are kept on single lines to prevent JSP compilation errors
                    ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM products");
                    if (rs.next()) totalProducts = rs.getInt(1);
                    
                    rs = stmt.executeQuery("SELECT COUNT(*) FROM products WHERE stock_quantity < 50");
                    if (rs.next()) lowStockCount = rs.getInt(1);
                    
                    rs = stmt.executeQuery("SELECT p.name FROM products p JOIN order_items oi ON p.id = oi.product_id GROUP BY p.id, p.name ORDER BY SUM(oi.quantity) DESC LIMIT 1");
                    if (rs.next()) bestSeller = rs.getString(1);
                } catch (Exception e) { e.printStackTrace(); } 
            %>

            <div class="grid grid-cols-3 gap-6 mb-8">
                <div class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition">
                    <p class="text-gray-400 text-sm">Total Product Lines</p>
                    <p class="text-3xl font-black text-blue-700 mt-1"><%= totalProducts %></p>
                </div>
                <div class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition border-l-4 border-red-500">
                    <p class="text-gray-400 text-sm">Low Stock Items</p>
                    <p class="text-3xl font-black text-red-600 mt-1"><%= lowStockCount %></p>
                </div>
                <div class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition border-l-4 border-green-500">
                    <p class="text-gray-400 text-sm">Best Seller Value</p>
                    <p class="text-3xl font-black text-green-600 mt-1"><%= bestSeller %></p>
                </div>
            </div>

            <div class="grid grid-cols-4 gap-6" id="productGrid"></div>
        </div>
    </div>

    <script>
        var products = [
            <% 
                try (Connection conn = com.coolstack.util.DBConnection.getConnection(); Statement stmt = conn.createStatement()) {
                    ResultSet rsProd = stmt.executeQuery("SELECT * FROM products");
                    while (rsProd.next()) {
                        int stock = rsProd.getInt("stock_quantity");
                        String cat = rsProd.getString("category");
                        boolean alert = stock < 50;
                        String badge = "bg-blue-100 text-blue-700";
                        String emoji = "🍦";
                        if ("Tubs".equalsIgnoreCase(cat)) { badge = "bg-purple-100 text-purple-700"; emoji = "🍨"; }
                        else if ("Sticks".equalsIgnoreCase(cat)) { badge = "bg-orange-100 text-orange-700"; emoji = "🍭"; }
                        else if ("Cones".equalsIgnoreCase(cat)) { badge = "bg-pink-100 text-pink-700"; emoji = "🍦"; }

                        String pName = rsProd.getString("name").replace("'", "\\'");
                        String pFlavor = rsProd.getString("flavor").replace("'", "\\'");
                        String pCat = cat.replace("'", "\\'");
                        BigDecimal pPrice = rsProd.getBigDecimal("price");

                        out.print("{ id: 'PROD-" + rsProd.getInt("id") + "', name: '" + pName + "', category: '" + pCat + "', flavor: '" + pFlavor + "', price: '₹" + pPrice + "', stock: " + stock + ", emoji: '" + emoji + "', badge: '" + badge + "', alert: " + alert + " },");
                    }
                } catch (Exception e) { e.printStackTrace(); }
            %>
        ];

        function buildProductCards(data) {
            var grid = document.getElementById('productGrid');
            grid.innerHTML = '';
            for (var i = 0; i < data.length; i++) {
                var p = data[i];
                var stockPercent = Math.min((p.stock / 500) * 100, 100);
                var barColor = p.alert ? 'bg-red-500' : 'bg-emerald-500';
                var card = document.createElement('div');
                card.className = 'prod-card bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden hover:shadow-xl hover:-translate-y-2 transition duration-300 flex flex-col pt-8 relative group';
                card.setAttribute('data-search', (p.name + ' ' + p.flavor + ' ' + p.category).toLowerCase());
                card.setAttribute('data-cat', p.category);

                card.innerHTML = `${p.alert ? '<div class="absolute top-4 right-4 bg-red-500 text-white text-[10px] uppercase font-black px-3 py-1 rounded-full animate-pulse z-10">Low Stock</div>' : ''}
                    <div class="flex justify-center mb-6 text-7xl drop-shadow-xl group-hover:scale-110 transition duration-500">${p.emoji}</div>
                    <div class="px-6 pb-6 flex-1 flex flex-col">
                        <div class="flex-1">
                            <span class="inline-block ${p.badge} px-3 py-1 rounded-xl text-[10px] font-bold uppercase tracking-wider mb-2">${p.category}</span>
                            <h3 class="font-black text-gray-800 text-xl leading-tight mb-1 group-hover:text-blue-700 transition">${p.name}</h3>
                            <p class="text-gray-400 text-xs font-semibold">${p.flavor}</p>
                        </div>
                        <div class="mt-6 mb-4">
                            <div class="flex justify-between items-end mb-1.5">
                                <span class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">Stock Level</span>
                                <span class="text-xs font-bold ${p.alert} ? 'text-red-500' : 'text-gray-700'}">${p.stock} Units</span>
                            </div>
                            <div class="w-full bg-gray-100 h-2 rounded-full overflow-hidden">
                                <div class="${barColor} h-full rounded-full transition-all duration-1000" style="width: ${stockPercent}%"></div>
                            </div>
                        </div>
                        <div class="border-t border-gray-50 pt-4 flex justify-between items-center">
                            <div>
                                <p class="text-[9px] text-gray-400 font-bold uppercase">Unit Price</p>
                                <p class="font-black text-blue-700 text-lg">${p.price}</p>
                            </div>
                            <div class="flex gap-2">
                                <button class="w-8 h-8 flex items-center justify-center bg-gray-50 text-gray-400 rounded-xl hover:bg-blue-600 hover:text-white transition">📦</button>
                                <button class="w-8 h-8 flex items-center justify-center bg-gray-50 text-gray-400 rounded-xl hover:bg-slate-800 hover:text-white transition">✏️</button>
                            </div>
                        </div>
                    </div>`;
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