<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    // ── GUARD: must be logged in as manager ─────────────────────────────────
    if (session.getAttribute("loggedUserRole") == null ||
        !session.getAttribute("loggedUserRole").toString().equals("manager")) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access Denied");
        return;
    }

    // ── LOAD PRODUCTS A-Z from DB ────────────────────────────────────────────
    java.util.List<java.util.Map<String,Object>> productList = new java.util.ArrayList<>();
    int totalProducts = 0, lowStockCount = 0;
    double totalValue = 0;
    java.util.Set<String> categories = new java.util.TreeSet<>();

    try (java.sql.Connection conn = com.coolstack.util.DBConnection.getConnection()) {
        if (conn != null) {
            // Check if pieces_per_box column exists — handle gracefully if DB not yet altered
            boolean hasPiecesPerBox = false;
            try {
                java.sql.ResultSet colCheck = conn.getMetaData().getColumns(null, null, "products", "pieces_per_box");
                hasPiecesPerBox = colCheck.next();
                colCheck.close();
            } catch (Exception ignored) {}

            String sql = hasPiecesPerBox
                ? "SELECT id, name, category, flavor, price, stock_quantity, pieces_per_box, created_at FROM products ORDER BY name ASC"
                : "SELECT id, name, category, flavor, price, stock_quantity, 0 AS pieces_per_box, created_at FROM products ORDER BY name ASC";

            java.sql.PreparedStatement ps = conn.prepareStatement(sql);
            java.sql.ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                java.util.Map<String,Object> p = new java.util.HashMap<>();
                p.put("id",            rs.getInt("id"));
                p.put("name",          rs.getString("name") != null ? rs.getString("name") : "");
                p.put("category",      rs.getString("category") != null ? rs.getString("category") : "General");
                p.put("flavor",        rs.getString("flavor") != null ? rs.getString("flavor") : "-");
                p.put("price",         rs.getBigDecimal("price"));
                p.put("stock",         rs.getInt("stock_quantity"));
                p.put("piecesPerBox",  rs.getInt("pieces_per_box"));
                p.put("createdAt",     rs.getTimestamp("created_at"));

                categories.add(rs.getString("category") != null ? rs.getString("category") : "General");
                int stock = rs.getInt("stock_quantity");
                double price = rs.getBigDecimal("price").doubleValue();
                if (stock < 50) lowStockCount++;
                totalValue += (stock * price);
                totalProducts++;
                productList.add(p);
            }
            rs.close(); ps.close();
        }
    } catch (Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventory Management | CoolStock Manager</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <!-- jsPDF for PDF export -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.8.2/jspdf.plugin.autotable.min.js"></script>
    <style>
        body { font-family: 'Outfit', sans-serif; }

        /* Table row hover */
        .prod-row:hover { background: #f8faff; }

        /* Restock input */
        .restock-input {
            width: 70px;
            border: 1.5px solid #e5e7eb;
            border-radius: 8px;
            padding: 4px 8px;
            font-size: 13px;
            font-family: 'Outfit', sans-serif;
            font-weight: 600;
            text-align: center;
            outline: none;
            transition: border .2s;
        }
        .restock-input:focus { border-color: #6366f1; }

        /* Tooltip */
        .tooltip { position: relative; }
        .tooltip:hover::after {
            content: attr(data-tip);
            position: absolute;
            bottom: 110%;
            left: 50%;
            transform: translateX(-50%);
            background: #1e293b;
            color: #fff;
            font-size: 11px;
            padding: 3px 8px;
            border-radius: 6px;
            white-space: nowrap;
            z-index: 99;
        }

        /* Modal animation */
        .modal-box { animation: popIn .18s cubic-bezier(.34,1.5,.64,1) both; }
        @keyframes popIn {
            from { transform: scale(.92); opacity: 0; }
            to   { transform: scale(1);  opacity: 1; }
        }

        /* Low stock pulse */
        .low-stock-badge { animation: pulse 2s infinite; }
        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: .6; }
        }

        /* Sortable header */
        th.sortable { cursor: pointer; user-select: none; }
        th.sortable:hover { color: #4f46e5; }

        /* Action buttons */
        .btn-action {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 5px 12px;
            border-radius: 8px;
            font-size: 11px;
            font-weight: 700;
            transition: all .15s;
            border: 1.5px solid transparent;
        }
        .btn-restock { background: #eff6ff; color: #2563eb; border-color: #bfdbfe; }
        .btn-restock:hover { background: #2563eb; color: #fff; }
        .btn-edit    { background: #f0fdf4; color: #16a34a; border-color: #bbf7d0; }
        .btn-edit:hover { background: #16a34a; color: #fff; }
        .btn-delete  { background: #fff1f2; color: #dc2626; border-color: #fecaca; }
        .btn-delete:hover { background: #dc2626; color: #fff; }

        /* Toast */
        #toast { transition: opacity .3s; }

        /* Scrollbar */
        ::-webkit-scrollbar { width: 6px; height: 6px; }
        ::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 99px; }
    </style>
</head>
<body class="bg-gray-50 min-h-screen">
<div class="flex">
    <%@ include file="sidebar.jsp" %>

    <div class="ml-64 p-8 w-full min-h-screen">

        <!-- ── PAGE HEADER ──────────────────────────────────────────────── -->
        <div class="bg-gradient-to-r from-indigo-700 via-blue-700 to-cyan-600 text-white p-7 rounded-2xl mb-8 shadow-xl">
            <div class="flex justify-between items-center flex-wrap gap-4">
                <div>
                    <h1 class="text-3xl font-black tracking-tight">Inventory Management</h1>
                    <p class="opacity-70 mt-1 text-sm">Manage products, update stock, and track inventory</p>
                </div>
                <div class="flex gap-3 items-center flex-wrap">

                    <!-- Search with Clear X -->
                    <div class="relative">
                        <input id="searchInput" type="text" placeholder="Search product name..."
                            oninput="applyFilters()"
                            class="bg-white/15 border border-white/30 text-white placeholder-white/50 rounded-xl px-4 py-2.5 text-sm font-medium outline-none w-56 pr-8">
                        <button id="clearSearch" onclick="clearSearch()"
                            class="absolute right-2.5 top-1/2 -translate-y-1/2 text-white/70 hover:text-white text-lg leading-none hidden"
                            title="Clear search">&times;</button>
                    </div>

                    <!-- Category Filter -->
                    <select id="categoryFilter" onchange="applyFilters()"
                        class="bg-white/15 border border-white/30 text-white rounded-xl px-4 py-2.5 text-sm font-semibold outline-none">
                        <option value="all" class="text-gray-800">All Categories</option>
                        <% for (String cat : categories) { %>
                        <option value="<%= cat %>" class="text-gray-800"><%= cat %></option>
                        <% } %>
                    </select>

                    <!-- Clear Filters -->
                    <button id="clearFiltersBtn" onclick="clearAllFilters()"
                        class="hidden bg-red-500/80 border border-red-300/30 text-white px-4 py-2.5 rounded-xl text-sm font-bold hover:bg-red-500 transition whitespace-nowrap">
                        Clear Filters
                    </button>

                    <!-- Low Stock Toggle -->
                    <button id="lowStockToggle" onclick="toggleLowStock()"
                        class="bg-white/15 border border-white/30 text-white px-4 py-2.5 rounded-xl text-sm font-bold hover:bg-white/25 transition">
                        Low Stock Only
                    </button>

                    <!-- Download CSV -->
                    <button onclick="downloadCSV()"
                        class="bg-emerald-500/80 border border-emerald-300/30 text-white px-4 py-2.5 rounded-xl text-sm font-bold hover:bg-emerald-500 transition whitespace-nowrap">
                        Download CSV
                    </button>

                    <!-- Download PDF -->
                    <button onclick="downloadPDF()"
                        class="bg-orange-500/80 border border-orange-300/30 text-white px-4 py-2.5 rounded-xl text-sm font-bold hover:bg-orange-500 transition whitespace-nowrap">
                        Download PDF
                    </button>

                    <!-- Audit Logs -->
                    <button onclick="openAuditModal()"
                        class="bg-blue-600/90 border border-blue-400/50 text-white px-5 py-2.5 rounded-xl text-sm font-bold hover:bg-blue-600 shadow-lg transition whitespace-nowrap">
                        📋 Audit Logs
                    </button>

                    <!-- Add Product -->
                    <button onclick="openAddModal()"
                        class="bg-white text-indigo-700 px-5 py-2.5 rounded-xl font-black text-sm hover:bg-indigo-50 transition shadow-lg whitespace-nowrap">
                        + Add Product
                    </button>
                </div>
            </div>
        </div>

        <!-- ── STAT CARDS (3 dynamic) ──────────────────────────────────── -->
        <div class="grid grid-cols-3 gap-6 mb-6">
            <div class="bg-white p-5 rounded-2xl shadow border border-gray-100 hover:-translate-y-1 transition duration-200">
                <p class="text-gray-400 text-xs font-bold uppercase tracking-wider mb-1">Total Products</p>
                <p class="text-4xl font-black text-indigo-700"><%= totalProducts %></p>
                <p class="text-xs text-gray-400 mt-1">Unique product lines</p>
            </div>
            <div class="bg-white p-5 rounded-2xl shadow border-l-4 border-red-500 border border-gray-100 hover:-translate-y-1 transition duration-200">
                <p class="text-gray-400 text-xs font-bold uppercase tracking-wider mb-1">Low Stock Items</p>
                <p class="text-4xl font-black text-red-600"><%= lowStockCount %></p>
                <p class="text-xs text-gray-400 mt-1">Below 50 units threshold</p>
            </div>
            <div class="bg-white p-5 rounded-2xl shadow border-l-4 border-emerald-500 border border-gray-100 hover:-translate-y-1 transition duration-200">
                <p class="text-gray-400 text-xs font-bold uppercase tracking-wider mb-1">Total Inventory Value</p>
                <p class="text-4xl font-black text-emerald-600">&#8377;<%= String.format("%,.0f", totalValue) %></p>
                <p class="text-xs text-gray-400 mt-1">Price x Stock across all items</p>
            </div>
        </div>

        <!-- ── LOW STOCK ALERT BANNER ───────────────────────────────────── -->
        <% if (lowStockCount > 0) { %>
        <div class="mb-6 bg-red-50 border border-red-200 rounded-2xl p-5">
            <p class="font-bold text-red-700 text-sm mb-3">Warning: <%= lowStockCount %> item(s) running low on stock</p>
            <div class="flex flex-wrap gap-2">
                <% for (java.util.Map<String,Object> p : productList) {
                    if ((int)p.get("stock") < 50) { %>
                <span class="bg-white border border-red-200 text-red-700 font-bold px-3 py-1 rounded-lg text-xs shadow-sm">
                    <%= p.get("name") %> &mdash; <%= p.get("stock") %> left
                </span>
                <% } } %>
            </div>
        </div>
        <% } %>

        <!-- ── PRODUCT TABLE ─────────────────────────────────────────────── -->
        <div class="bg-white rounded-2xl shadow border border-gray-100 overflow-hidden">
            <div class="px-6 py-4 border-b border-gray-100 bg-gray-50 flex justify-between items-center">
                <div>
                    <h2 class="text-lg font-black text-gray-800">Product Inventory</h2>
                    <p class="text-xs text-gray-400 mt-0.5">Sorted A to Z &mdash; <span id="visibleCount"><%= totalProducts %></span> products shown</p>
                </div>
                <span class="text-xs text-gray-400 font-semibold">Quick Restock: type amount then click Apply</span>
            </div>

            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse" id="productTable">
                    <thead>
                        <tr class="text-[11px] uppercase text-gray-400 bg-gray-50 border-b border-gray-100 tracking-wider">
                            <th class="px-5 py-3 font-black w-8"><input type="checkbox" id="selectAllCheckbox" onchange="toggleAllCheckboxes()" class="w-4 h-4 rounded text-indigo-600 focus:ring-indigo-500 cursor-pointer"></th>
                            <th class="px-5 py-3 font-black w-8">#</th>
                            <th class="px-5 py-3 font-black sortable" onclick="sortTable('name')">Product Name &#x25B2;&#x25BC;</th>
                            <th class="px-5 py-3 font-black">Category</th>
                            <th class="px-5 py-3 font-black">Flavor</th>
                            <th class="px-5 py-3 font-black sortable text-right" onclick="sortTable('price')">Price &#x25B2;&#x25BC;</th>
                            <th class="px-5 py-3 font-black text-center">Per Box Pcs</th>
                            <th class="px-5 py-3 font-black sortable text-center" onclick="sortTable('stock')">Stock &#x25B2;&#x25BC;</th>
                            <th class="px-5 py-3 font-black text-center" style="width:180px">Quick Restock</th>
                            <th class="px-5 py-3 font-black text-center" style="width:180px">Actions</th>
                        </tr>
                    </thead>
                    <tbody id="productTbody">
                        <%
                        int rowNum = 0;
                        for (java.util.Map<String,Object> p : productList) {
                            rowNum++;
                            int stock = (int) p.get("stock");
                            boolean isLow = stock < 50;
                            java.math.BigDecimal price = (java.math.BigDecimal) p.get("price");
                            int pbs = (int) p.get("piecesPerBox");
                            String category = (String) p.get("category");
                            String flavor   = (String) p.get("flavor");
                            String name     = ((String) p.get("name")).replace("'", "\\'").replace("\"", "&quot;");
                            int id = (int) p.get("id");
                        %>
                        <%
                            // JSON-safe display strings for data-* attributes
                            String safeNameAttr = ((String)p.get("name")).replace("&", "&amp;").replace("\"", "&quot;").replace("<","&lt;").replace(">","&gt;");
                            String safeCatAttr  = category.replace("&","&amp;").replace("\"","&quot;");
                            String safeFlvAttr  = flavor.replace("&","&amp;").replace("\"","&quot;");
                        %>
                        <tr class="prod-row border-b border-gray-50 transition"
                            id="row_<%= id %>"
                            data-id="<%= id %>"
                            data-name="<%= ((String)p.get("name")).toLowerCase() %>"
                            data-display-name="<%= safeNameAttr %>"
                            data-category="<%= safeCatAttr %>"
                            data-flavor="<%= safeFlvAttr %>"
                            data-stock="<%= stock %>"
                            data-price="<%= price %>"
                            data-pbs="<%= pbs %>">

                            <td class="px-5 py-3.5"><input type="checkbox" class="row-checkbox w-4 h-4 rounded text-indigo-600 focus:ring-indigo-500 cursor-pointer" value="<%= id %>" onchange="updateBulkActionVisibility()"></td>
                            <td class="px-5 py-3.5 text-gray-400 text-xs font-bold"><%= rowNum %></td>

                            <td class="px-5 py-3.5">
                                <div class="flex items-center gap-2">
                                    <span class="font-bold text-gray-800 text-sm"><%= p.get("name") %></span>
                                    <% if (isLow) { %>
                                    <span class="low-stock-badge bg-red-100 text-red-600 text-[10px] font-black px-2 py-0.5 rounded-full uppercase">Low Stock</span>
                                    <% } %>
                                </div>
                            </td>

                            <td class="px-5 py-3.5">
                                <span class="<%= getCategoryStyle(category) %> text-xs font-bold px-2.5 py-1 rounded-full">
                                    <%= category %>
                                </span>
                            </td>

                            <td class="px-5 py-3.5 text-gray-500 text-sm"><%= flavor %></td>

                            <td class="px-5 py-3.5 text-right">
                                <span class="font-black text-indigo-700 text-sm">&#8377;<%= price %></span>
                            </td>

                            <td class="px-5 py-3.5 text-center">
                                <span class="font-semibold text-gray-600 text-sm"><%= pbs > 0 ? pbs : "-" %></span>
                            </td>

                            <td class="px-5 py-3.5 text-center" id="stockCell_<%= id %>">
                                <span class="font-black text-sm <%= isLow ? "text-red-600" : "text-gray-700" %>">
                                    <%= stock %>
                                </span>
                                <span class="text-gray-400 text-xs ml-1">units</span>
                            </td>

                            <td class="px-5 py-3.5 text-center">
                                <div class="flex items-center justify-center gap-2">
                                    <input type="number" step="1"
                                        class="restock-input"
                                        id="restockQty_<%= id %>"
                                        placeholder="+ / -"
                                        title="Enter positive to add, negative to remove">
                                    <button class="btn-action btn-restock tooltip"
                                        data-tip="Adjust stock (add or remove)"
                                        onclick="doRestock(<%= id %>)">
                                        Apply
                                    </button>
                                </div>
                            </td>

                            <td class="px-5 py-3.5 text-center">
                                <div class="flex items-center justify-center gap-1.5">
                                    <button class="btn-action btn-edit"
                                        onclick="openEditFromRow(<%= id %>)">
                                        Edit
                                    </button>
                                    <button class="btn-action btn-delete"
                                        onclick="confirmDelete(<%= id %>)">
                                        Delete
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <% } %>


                        <% if (totalProducts == 0) { %>
                        <tr>
                            <td colspan="9" class="px-6 py-16 text-center text-gray-400">
                                <p class="text-2xl font-black mb-2">No products found</p>
                                <p class="text-sm">Click "Add Product" to get started</p>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <!-- No results message -->
            <div id="noResultsMsg" class="hidden px-6 py-12 text-center text-gray-400">
                <p class="text-xl font-black mb-1">No matching products</p>
                <p class="text-sm">Try adjusting your search or filter</p>
            </div>
        </div>

    </div><!-- /content -->
</div><!-- /flex wrapper -->


<!-- ══════════════════════════════════════════════════════════════════
     ADD PRODUCT MODAL
══════════════════════════════════════════════════════════════════ -->
<div id="addModal" class="hidden fixed inset-0 bg-black/50 z-50 flex items-center justify-center backdrop-blur-sm px-4">
    <div class="bg-white rounded-2xl shadow-2xl w-full max-w-lg modal-box overflow-hidden">
        <div class="bg-gradient-to-r from-indigo-600 to-blue-600 px-6 py-5 flex justify-between items-center">
            <h2 class="text-xl font-black text-white">Add New Product</h2>
            <button onclick="closeAddModal()" class="text-white/70 hover:text-white text-2xl leading-none">&times;</button>
        </div>
        <form id="addForm" onsubmit="submitAdd(event)" class="p-6 space-y-4">
            <div>
                <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Product Name *</label>
                <input type="text" id="add_name" required placeholder="e.g. Vanilla Delight Tub"
                    class="w-full border-2 border-gray-200 rounded-xl px-4 py-2.5 text-sm font-semibold outline-none focus:border-indigo-400 transition">
            </div>
            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Category</label>
                    <select id="add_category"
                        class="w-full border-2 border-gray-200 rounded-xl px-4 py-2.5 text-sm font-semibold outline-none focus:border-indigo-400 bg-white transition">
                        <option value="Tubs">Tubs</option>
                        <option value="Cones">Cones</option>
                        <option value="Sticks">Sticks</option>
                        <option value="Cups">Cups</option>
                        <option value="Family Pack">Family Pack</option>
                        <option value="General">General</option>
                    </select>
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Flavor</label>
                    <input type="text" id="add_flavor" placeholder="e.g. Strawberry"
                        class="w-full border-2 border-gray-200 rounded-xl px-4 py-2.5 text-sm font-semibold outline-none focus:border-indigo-400 transition">
                </div>
            </div>
            <div class="grid grid-cols-3 gap-4">
                <div>
                    <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Price (Rs.) *</label>
                    <input type="number" id="add_price" required min="1" step="0.01" placeholder="120"
                        class="w-full border-2 border-gray-200 rounded-xl px-4 py-2.5 text-sm font-semibold outline-none focus:border-indigo-400 transition">
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Opening Stock *</label>
                    <input type="number" id="add_stock" required min="0" placeholder="50"
                        class="w-full border-2 border-gray-200 rounded-xl px-4 py-2.5 text-sm font-semibold outline-none focus:border-indigo-400 transition">
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Pcs Per Box</label>
                    <input type="number" id="add_pbs" min="0" placeholder="12"
                        class="w-full border-2 border-gray-200 rounded-xl px-4 py-2.5 text-sm font-semibold outline-none focus:border-indigo-400 transition">
                </div>
            </div>
            <div class="flex justify-end gap-3 pt-4 border-t border-gray-100">
                <button type="button" onclick="closeAddModal()"
                    class="px-5 py-2.5 text-gray-500 font-bold hover:bg-gray-100 rounded-xl transition text-sm">Cancel</button>
                <button type="submit" id="addSubmitBtn"
                    class="px-6 py-2.5 bg-indigo-600 text-white font-black rounded-xl hover:bg-indigo-700 transition shadow-md text-sm">
                    Add Product
                </button>
            </div>
        </form>
    </div>
</div>


<!-- ══════════════════════════════════════════════════════════════════
     EDIT PRODUCT MODAL
══════════════════════════════════════════════════════════════════ -->
<div id="editModal" class="hidden fixed inset-0 bg-black/50 z-50 flex items-center justify-center backdrop-blur-sm px-4">
    <div class="bg-white rounded-2xl shadow-2xl w-full max-w-lg modal-box overflow-hidden">
        <div class="bg-gradient-to-r from-emerald-600 to-teal-600 px-6 py-5 flex justify-between items-center">
            <h2 class="text-xl font-black text-white">Edit Product</h2>
            <button onclick="closeEditModal()" class="text-white/70 hover:text-white text-2xl leading-none">&times;</button>
        </div>
        <form id="editForm" onsubmit="submitEdit(event)" class="p-6 space-y-4">
            <input type="hidden" id="edit_id">
            <div>
                <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Product Name *</label>
                <input type="text" id="edit_name" required
                    class="w-full border-2 border-gray-200 rounded-xl px-4 py-2.5 text-sm font-semibold outline-none focus:border-emerald-400 transition">
            </div>
            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Category</label>
                    <select id="edit_category"
                        class="w-full border-2 border-gray-200 rounded-xl px-4 py-2.5 text-sm font-semibold outline-none focus:border-emerald-400 bg-white transition">
                        <option value="Tubs">Tubs</option>
                        <option value="Cones">Cones</option>
                        <option value="Sticks">Sticks</option>
                        <option value="Cups">Cups</option>
                        <option value="Family Pack">Family Pack</option>
                        <option value="General">General</option>
                    </select>
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Flavor</label>
                    <input type="text" id="edit_flavor"
                        class="w-full border-2 border-gray-200 rounded-xl px-4 py-2.5 text-sm font-semibold outline-none focus:border-emerald-400 transition">
                </div>
            </div>
            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Price (Rs.) *</label>
                    <input type="number" id="edit_price" required min="1" step="0.01"
                        class="w-full border-2 border-gray-200 rounded-xl px-4 py-2.5 text-sm font-semibold outline-none focus:border-emerald-400 transition">
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Pcs Per Box</label>
                    <input type="number" id="edit_pbs" min="0"
                        class="w-full border-2 border-gray-200 rounded-xl px-4 py-2.5 text-sm font-semibold outline-none focus:border-emerald-400 transition">
                </div>
            </div>
            <div class="flex justify-end gap-3 pt-4 border-t border-gray-100">
                <button type="button" onclick="closeEditModal()"
                    class="px-5 py-2.5 text-gray-500 font-bold hover:bg-gray-100 rounded-xl transition text-sm">Cancel</button>
                <button type="submit" id="editSubmitBtn"
                    class="px-6 py-2.5 bg-emerald-600 text-white font-black rounded-xl hover:bg-emerald-700 transition shadow-md text-sm">
                    Save Changes
                </button>
            </div>
        </form>
    </div>
</div>


<!-- ══════════════════════════════════════════════════════════════════
     DELETE CONFIRM MODAL
══════════════════════════════════════════════════════════════════ -->
<div id="deleteModal" class="hidden fixed inset-0 bg-black/50 z-50 flex items-center justify-center backdrop-blur-sm px-4">
    <div class="bg-white rounded-2xl shadow-2xl w-full max-w-sm modal-box p-6 text-center">
        <div class="w-14 h-14 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-4">
            <span class="text-red-600 font-black text-2xl">!</span>
        </div>
        <h2 class="text-xl font-black text-gray-800 mb-2">Delete Product?</h2>
        <p class="text-gray-500 text-sm mb-1">You are about to delete:</p>
        <p id="deleteName" class="font-black text-indigo-700 text-base mb-6"></p>
        <p class="text-xs text-red-500 font-semibold mb-5">This action cannot be undone.</p>
        <div class="flex gap-3 justify-center">
            <button onclick="closeDeleteModal()"
                class="px-6 py-2.5 bg-gray-100 text-gray-600 font-bold rounded-xl hover:bg-gray-200 transition text-sm">Cancel</button>
            <button id="confirmDeleteBtn"
                class="px-6 py-2.5 bg-red-600 text-white font-black rounded-xl hover:bg-red-700 transition shadow-md text-sm">
                Yes, Delete
            </button>
        </div>
    </div>
</div>


<!-- ── TOAST NOTIFICATION ──────────────────────────────────────────── -->
<div id="toast" class="hidden fixed bottom-6 right-6 z-[100] px-6 py-3.5 rounded-2xl shadow-2xl font-bold text-white text-sm max-w-sm">
</div>


<script>
    // ── Context Path for AJAX ────────────────────────────────────────
    const ctxPath = '<%= request.getContextPath() %>';
    let lowStockOnly = false;
    let pendingDeleteId = null;
    let sortDir = {}; // track sort direction per column

    // ── FILTER LOGIC ─────────────────────────────────────────────────
    function applyFilters() {
        const q   = document.getElementById('searchInput').value.toLowerCase().trim();
        const cat = document.getElementById('categoryFilter').value;
        const rows = document.querySelectorAll('#productTbody .prod-row');
        let visibleCount = 0;

        rows.forEach(row => {
            const name     = row.getAttribute('data-name') || '';
            const rowCat   = row.getAttribute('data-category') || '';
            const stock    = parseInt(row.getAttribute('data-stock')) || 0;

            const matchSearch = name.includes(q);
            const matchCat    = cat === 'all' || rowCat === cat.toLowerCase();
            const matchLow    = !lowStockOnly || stock < 50;

            if (matchSearch && matchCat && matchLow) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
            }
        });

        document.getElementById('visibleCount').textContent = visibleCount;
        document.getElementById('noResultsMsg').classList.toggle('hidden', visibleCount > 0);

        // Show/hide clear search X
        const clearSearchBtn = document.getElementById('clearSearch');
        if (clearSearchBtn) clearSearchBtn.classList.toggle('hidden', q.length === 0);

        // Show/hide global clear filters button
        const hasFilter = q.length > 0 || cat !== 'all' || lowStockOnly;
        const clearFiltersBtn = document.getElementById('clearFiltersBtn');
        if (clearFiltersBtn) clearFiltersBtn.classList.toggle('hidden', !hasFilter);
    }

    // ── CLEAR SEARCH ─────────────────────────────────────────────────
    function clearSearch() {
        document.getElementById('searchInput').value = '';
        document.getElementById('clearSearch').classList.add('hidden');
        applyFilters();
    }

    // ── CLEAR ALL FILTERS ────────────────────────────────────────────
    function clearAllFilters() {
        document.getElementById('searchInput').value = '';
        document.getElementById('categoryFilter').value = 'all';
        if (lowStockOnly) toggleLowStock(); // reset low stock toggle
        document.getElementById('clearFiltersBtn').classList.add('hidden');
        document.getElementById('clearSearch').classList.add('hidden');
        applyFilters();
    }



    function toggleLowStock() {
        lowStockOnly = !lowStockOnly;
        const btn = document.getElementById('lowStockToggle');
        btn.classList.toggle('bg-red-500', lowStockOnly);
        btn.classList.toggle('text-white', lowStockOnly);
        btn.classList.toggle('bg-white/15', !lowStockOnly);
        btn.textContent = lowStockOnly ? 'Show All' : 'Low Stock Only';
        applyFilters();
    }

    // ── SORT TABLE ───────────────────────────────────────────────────
    function sortTable(column) {
        sortDir[column] = !sortDir[column]; // toggle asc/desc
        const tbody = document.getElementById('productTbody');
        const rows  = Array.from(tbody.querySelectorAll('.prod-row'));

        rows.sort((a, b) => {
            let av = a.getAttribute('data-' + column) || '';
            let bv = b.getAttribute('data-' + column) || '';
            if (column === 'price' || column === 'stock') {
                av = parseFloat(av); bv = parseFloat(bv);
            }
            if (av < bv) return sortDir[column] ? -1 : 1;
            if (av > bv) return sortDir[column] ? 1 : -1;
            return 0;
        });

        rows.forEach(r => tbody.appendChild(r));

        // Update row numbers after sort
        let n = 1;
        tbody.querySelectorAll('.prod-row').forEach(r => {
            r.cells[0].textContent = n++;
        });
    }

    // ── QUICK RESTOCK ────────────────────────────────────────────────
    function doRestock(id) {
        const input = document.getElementById('restockQty_' + id);
        const qty   = parseInt(input.value);
        const row   = document.getElementById('row_' + id);
        const name  = row ? row.getAttribute('data-display-name') : 'Product';

        if (isNaN(qty) || qty === 0) {
            showToast('Enter a valid non-zero quantity to adjust', 'orange');
            return;
        }

        fetch(ctxPath + '/ProductServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'action=restock&id=' + id + '&addQty=' + qty
        })
        .then(r => r.json())
        .then(data => {
            if (data.success) {
                const newStock = data.newStock;
                const stockCell = document.getElementById('stockCell_' + id);
                if (stockCell) {
                    stockCell.innerHTML = `<span class="font-black text-sm ${newStock < 50 ? 'text-red-600' : 'text-gray-700'}">${newStock}</span> <span class="text-gray-400 text-xs ml-1">units</span>`;
                }
                if (row) row.setAttribute('data-stock', newStock);

                // Update low stock badge
                const nameTd = row ? row.cells[1] : null;
                if (nameTd) {
                    const existingBadge = nameTd.querySelector('.low-stock-badge');
                    if (newStock < 50 && !existingBadge) {
                        const span = document.createElement('span');
                        span.className = 'low-stock-badge bg-red-100 text-red-600 text-[10px] font-black px-2 py-0.5 rounded-full uppercase';
                        span.textContent = 'Low Stock';
                        nameTd.querySelector('div').appendChild(span);
                    } else if (newStock >= 50 && existingBadge) {
                        existingBadge.remove();
                    }
                }

                input.value = '';
                showToast(name + ' restocked to ' + newStock + ' units', 'green');
            } else {
                showToast(data.message, 'red');
            }
        })
        .catch(() => showToast('Network error during restock', 'red'));
    }

    // ── ADD PRODUCT MODAL ────────────────────────────────────────────
    function openAddModal() {
        document.getElementById('addForm').reset();
        document.getElementById('addModal').classList.remove('hidden');
        document.getElementById('add_name').focus();
    }
    function closeAddModal() {
        document.getElementById('addModal').classList.add('hidden');
    }
    function submitAdd(e) {
        e.preventDefault();
        const btn = document.getElementById('addSubmitBtn');
        btn.disabled = true; btn.textContent = 'Saving...';

        const body = [
            'action=add',
            'name='     + encodeURIComponent(document.getElementById('add_name').value),
            'category=' + encodeURIComponent(document.getElementById('add_category').value),
            'flavor='   + encodeURIComponent(document.getElementById('add_flavor').value),
            'price='    + encodeURIComponent(document.getElementById('add_price').value),
            'stock='    + encodeURIComponent(document.getElementById('add_stock').value),
            'pieces_per_box=' + encodeURIComponent(document.getElementById('add_pbs').value || '0')
        ].join('&');

        fetch(ctxPath + '/ProductServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: body
        })
        .then(r => r.json())
        .then(data => {
            btn.disabled = false; btn.textContent = 'Add Product';
            if (data.success) {
                closeAddModal();
                showToast('Product added! Refreshing...', 'green');
                setTimeout(() => location.reload(), 1200);
            } else {
                showToast(data.message, 'red');
            }
        })
        .catch(() => { btn.disabled = false; btn.textContent = 'Add Product'; showToast('Network error', 'red'); });
    }

    // ── EDIT PRODUCT MODAL ───────────────────────────────────────────
    function openEditFromRow(id) {
        const row = document.getElementById('row_' + id);
        if (!row) return;
        const name     = row.getAttribute('data-display-name') || '';
        const category = row.getAttribute('data-category') || 'General';
        const flavor   = row.getAttribute('data-flavor') || '';
        const price    = row.getAttribute('data-price') || '0';
        const pbs      = row.getAttribute('data-pbs') || '0';
        openEditModal(id, name, category, flavor, price, pbs);
    }

    function openEditModal(id, name, category, flavor, price, pbs) {
        document.getElementById('edit_id').value = id;
        document.getElementById('edit_name').value = name;
        document.getElementById('edit_flavor').value = flavor;
        document.getElementById('edit_price').value = price;
        document.getElementById('edit_pbs').value = pbs;

        const catSel = document.getElementById('edit_category');
        for (let opt of catSel.options) {
            opt.selected = (opt.value === category);
        }
        // If category not in list, add it
        if (catSel.value !== category) {
            const opt = new Option(category, category, true, true);
            catSel.add(opt);
        }

        document.getElementById('editModal').classList.remove('hidden');
        document.getElementById('edit_name').focus();
    }
    function closeEditModal() {
        document.getElementById('editModal').classList.add('hidden');
    }
    function submitEdit(e) {
        e.preventDefault();
        const btn = document.getElementById('editSubmitBtn');
        btn.disabled = true; btn.textContent = 'Saving...';

        const body = [
            'action=edit',
            'id='       + encodeURIComponent(document.getElementById('edit_id').value),
            'name='     + encodeURIComponent(document.getElementById('edit_name').value),
            'category=' + encodeURIComponent(document.getElementById('edit_category').value),
            'flavor='   + encodeURIComponent(document.getElementById('edit_flavor').value),
            'price='    + encodeURIComponent(document.getElementById('edit_price').value),
            'pieces_per_box=' + encodeURIComponent(document.getElementById('edit_pbs').value || '0')
        ].join('&');

        fetch(ctxPath + '/ProductServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: body
        })
        .then(r => r.json())
        .then(data => {
            btn.disabled = false; btn.textContent = 'Save Changes';
            if (data.success) {
                closeEditModal();
                showToast('Product updated! Refreshing...', 'green');
                setTimeout(() => location.reload(), 1200);
            } else {
                showToast(data.message, 'red');
            }
        })
        .catch(() => { btn.disabled = false; btn.textContent = 'Save Changes'; showToast('Network error', 'red'); });
    }

    // ── DELETE PRODUCT ───────────────────────────────────────────────
    function confirmDelete(id) {
        const row  = document.getElementById('row_' + id);
        const name = row ? (row.getAttribute('data-display-name') || 'this product') : 'this product';
        pendingDeleteId = id;
        document.getElementById('deleteName').textContent = name;
        document.getElementById('deleteModal').classList.remove('hidden');

        document.getElementById('confirmDeleteBtn').onclick = function() {
            this.disabled = true; this.textContent = 'Deleting...';
            fetch(ctxPath + '/ProductServlet', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'action=delete&id=' + pendingDeleteId
            })
            .then(r => r.json())
            .then(data => {
                if (data.success) {
                    closeDeleteModal();
                    showToast(name + ' deleted', 'red');
                    setTimeout(() => location.reload(), 1200);
                } else {
                    showToast(data.message, 'red');
                    this.disabled = false; this.textContent = 'Yes, Delete';
                }
            })
            .catch(() => { this.disabled = false; this.textContent = 'Yes, Delete'; showToast('Network error', 'red'); });
        };
    }
    function closeDeleteModal() {
        document.getElementById('deleteModal').classList.add('hidden');
    }

    // ── TOAST ────────────────────────────────────────────────────────
    function showToast(msg, type) {
        const t = document.getElementById('toast');
        const colors = { green:'bg-emerald-600', red:'bg-red-500', orange:'bg-orange-500', blue:'bg-indigo-600' };
        t.className = 'fixed bottom-6 right-6 z-[100] px-6 py-3.5 rounded-2xl shadow-2xl font-bold text-white text-sm max-w-sm ' + (colors[type] || colors.blue);
        t.textContent = msg;
        t.style.opacity = '1';
        if (t._timer) clearTimeout(t._timer);
        t._timer = setTimeout(() => { t.style.opacity = '0'; setTimeout(() => t.classList.add('hidden'), 300); }, 3000);
        t.classList.remove('hidden');
    }

    // ── CLOSE MODALS ON BACKDROP CLICK ──────────────────────────────
    ['addModal','editModal','deleteModal'].forEach(id => {
        document.getElementById(id).addEventListener('click', function(e) {
            if (e.target === this) {
                this.classList.add('hidden');
            }
        });
    });

    // ── EXPORT CSV ───────────────────────────────────────────────────
    function downloadCSV() {
        let csv = [];
        const rows = document.querySelectorAll('#productTbody tr.prod-row');
        csv.push(['ID', 'Name', 'Category', 'Flavor', 'Price', 'Pcs Per Box', 'Stock'].join(','));
        rows.forEach(row => {
            if (row.style.display !== 'none') { // Export only visible rows
                const rowData = [
                    row.getAttribute('data-id') || '',
                    '"' + (row.getAttribute('data-display-name') || '').replace(/"/g, '""') + '"',
                    '"' + (row.getAttribute('data-category') || '') + '"',
                    '"' + (row.getAttribute('data-flavor') || '') + '"',
                    row.getAttribute('data-price') || '0',
                    row.getAttribute('data-pbs') || '0',
                    row.getAttribute('data-stock') || '0'
                ];
                csv.push(rowData.join(','));
            }
        });
        const csvFile = new Blob([csv.join('\n')], { type: 'text/csv' });
        const downloadLink = document.createElement('a');
        downloadLink.download = 'coolstack_inventory.csv';
        downloadLink.href = window.URL.createObjectURL(csvFile);
        downloadLink.style.display = 'none';
        document.body.appendChild(downloadLink);
        downloadLink.click();
        document.body.removeChild(downloadLink);
        showToast('CSV downloaded', 'green');
    }

    // ── EXPORT PDF ───────────────────────────────────────────────────
    function downloadPDF() {
        if (!window.jspdf || !window.jspdf.jsPDF) {
            showToast('PDF library is loading, try again in a moment', 'orange');
            return;
        }
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF();
        
        doc.text('CoolStack Inventory Report', 14, 15);
        doc.setFontSize(10);
        doc.text('Generated on: ' + new Date().toLocaleString(), 14, 22);

        const rows = document.querySelectorAll('#productTbody tr.prod-row');
        const bodyData = [];
        rows.forEach(row => {
            if (row.style.display !== 'none') {
                bodyData.push([
                    row.getAttribute('data-id') || '',
                    row.getAttribute('data-display-name') || '',
                    row.getAttribute('data-category') || '',
                    row.getAttribute('data-flavor') || '',
                    row.getAttribute('data-price') || '0',
                    row.getAttribute('data-stock') || '0'
                ]);
            }
        });

        doc.autoTable({
            startY: 28,
            head: [['ID', 'Name', 'Category', 'Flavor', 'Price', 'Stock']],
            body: bodyData,
            theme: 'grid',
            headStyles: { fillColor: [79, 70, 229] }, // Indigo-600
            styles: { fontSize: 9 }
        });

        doc.save('coolstack_inventory.pdf');
        showToast('PDF downloaded', 'green');
    }

    // ── BULK ACTIONS & CHECKBOXES ────────────────────────────────────
    function toggleAllCheckboxes() {
        const isChecked = document.getElementById('selectAllCheckbox').checked;
        document.querySelectorAll('.row-checkbox').forEach(cb => {
            // Only select visible rows
            if (cb.closest('tr').style.display !== 'none') {
                cb.checked = isChecked;
            }
        });
        updateBulkActionVisibility();
    }

    function updateBulkActionVisibility() {
        const checkedCount = document.querySelectorAll('.row-checkbox:checked').length;
        const bulkBar = document.getElementById('bulkActionBar');
        if (checkedCount > 0) {
            document.getElementById('bulkCountDisplay').textContent = checkedCount;
            bulkBar.classList.remove('translate-y-full', 'opacity-0');
            bulkBar.classList.add('translate-y-0', 'opacity-100');
        } else {
            bulkBar.classList.remove('translate-y-0', 'opacity-100');
            bulkBar.classList.add('translate-y-full', 'opacity-0');
        }
    }

    function bulkDelete() {
        const checked = Array.from(document.querySelectorAll('.row-checkbox:checked')).map(cb => cb.value);
        if (checked.length === 0) return;
        if (!confirm('Are you sure you want to completely delete ' + checked.length + ' products? This cannot be undone.')) return;

        const body = new URLSearchParams();
        body.append('action', 'bulk_delete');
        checked.forEach(id => body.append('ids[]', id));

        fetch(ctxPath + '/ProductServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: body.toString()
        })
        .then(r => r.json())
        .then(data => {
            if (data.success) {
                showToast(checked.length + ' items deleted', 'red');
                setTimeout(() => location.reload(), 1200);
            } else {
                showToast(data.message, 'red');
            }
        }).catch(() => showToast('Network Error', 'red'));
    }

    // ── AUDIT LOGS ───────────────────────────────────────────────────
    function openAuditModal() {
        document.getElementById('auditModal').classList.remove('hidden');
        document.getElementById('auditTableBody').innerHTML = '<tr><td colspan="5" class="py-4 text-center text-gray-500">Loading logs...</td></tr>';
        
        fetch(ctxPath + '/ProductServlet?action=fetch_logs', { method: 'POST' })
        .then(r => r.json())
        .then(data => {
            const tbody = document.getElementById('auditTableBody');
            tbody.innerHTML = '';
            if (data.success && data.logs.length > 0) {
                data.logs.forEach(log => {
                    const changeColor = log.change > 0 ? 'text-emerald-600' : (log.change < 0 ? 'text-red-600' : 'text-gray-500');
                    const changeStr = log.change > 0 ? '+' + log.change : log.change;
                    tbody.innerHTML += `<tr class="border-b border-gray-100/50 hover:bg-gray-50 text-sm">
                        <td class="py-3 px-4 text-gray-500 text-xs">${log.date}</td>
                        <td class="py-3 px-4 font-bold text-gray-700">${log.user}</td>
                        <td class="py-3 px-4 text-gray-600 font-semibold">${log.product}</td>
                        <td class="py-3 px-4 text-center"><span class="bg-blue-50 text-blue-700 text-[10px] font-black uppercase px-2 py-1 rounded">${log.action}</span></td>
                        <td class="py-3 px-4 text-right font-black ${changeColor}">${changeStr}</td>
                    </tr>`;
                });
            } else {
                tbody.innerHTML = '<tr><td colspan="5" class="py-4 text-center text-gray-500">No logs found</td></tr>';
            }
        }).catch(() => showToast('Failed to load logs', 'red'));
    }

    function closeAuditModal() {
        document.getElementById('auditModal').classList.add('hidden');
    }
</script>

<!-- ── BULK ACTION BAR (Sticky Footer) ──────────────────────────── -->
<div id="bulkActionBar" class="fixed bottom-0 left-64 right-0 bg-indigo-900 border-t border-indigo-700 shadow-2xl p-4 flex justify-between items-center transform translate-y-full opacity-0 transition-all duration-300 z-40">
    <div class="text-white">
        <span class="font-black text-xl" id="bulkCountDisplay">0</span> items selected
    </div>
    <div class="flex gap-3">
        <button onclick="bulkDelete()" class="bg-red-500 hover:bg-red-600 text-white font-bold px-6 py-2.5 rounded-xl shadow transition">Bulk Delete</button>
    </div>
</div>

<!-- ── AUDIT MODAL ──────────────────────────────────────────────── -->
<div id="auditModal" class="hidden fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4 backdrop-blur-sm">
    <div class="bg-white rounded-2xl w-full max-w-4xl overflow-hidden shadow-2xl">
        <div class="bg-blue-600 px-6 py-4 flex justify-between items-center text-white">
            <h2 class="font-black text-xl">Inventory Audit Logs</h2>
            <button onclick="closeAuditModal()" class="text-white hover:text-gray-200 text-2xl font-bold">&times;</button>
        </div>
        <div class="p-0 overflow-y-auto max-h-[60vh]">
            <table class="w-full text-left border-collapse">
                <thead class="sticky top-0 bg-gray-50 shadow-sm z-10">
                    <tr class="text-[11px] uppercase text-gray-400 border-b border-gray-200 tracking-wider">
                        <th class="py-3 px-4 font-black">Date / Time</th>
                        <th class="py-3 px-4 font-black">User</th>
                        <th class="py-3 px-4 font-black">Product</th>
                        <th class="py-3 px-4 font-black text-center">Action</th>
                        <th class="py-3 px-4 font-black text-right">Change</th>
                    </tr>
                </thead>
                <tbody id="auditTableBody"></tbody>
            </table>
        </div>
        <div class="p-4 border-t border-gray-100 flex justify-end">
            <button onclick="closeAuditModal()" class="px-5 py-2 bg-gray-100 text-gray-700 rounded-xl font-bold hover:bg-gray-200 transition">Close</button>
        </div>
    </div>
</div>

<script>
    // Include bulk action bar in modal close handler exclusions or backdrop logic if needed
    document.getElementById('auditModal').addEventListener('click', function(e) { if(e.target === this) closeAuditModal(); });
</script>

</body>
</html>

<%!
    // Helper: category badge colors
    private String getCategoryStyle(String category) {
        if (category == null) return "bg-gray-100 text-gray-600";
        switch (category.toLowerCase()) {
            case "tubs":        return "bg-blue-100 text-blue-700";
            case "cones":       return "bg-yellow-100 text-yellow-700";
            case "sticks":      return "bg-pink-100 text-pink-700";
            case "cups":        return "bg-purple-100 text-purple-700";
            case "family pack": return "bg-emerald-100 text-emerald-700";
            default:            return "bg-gray-100 text-gray-600";
        }
    }
%>
