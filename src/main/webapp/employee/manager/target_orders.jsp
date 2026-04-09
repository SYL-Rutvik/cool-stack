<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    // Fetch delivery boys for the assign dropdown
    java.util.List<String[]> dboyList = new java.util.ArrayList<>();
    try (java.sql.Connection conn = com.coolstack.util.DBConnection.getConnection()) {
        java.sql.Statement stmt = conn.createStatement();
        java.sql.ResultSet rs = stmt.executeQuery("SELECT id, name FROM delivery_boys WHERE current_status = 'Available'");
        while(rs.next()) {
            dboyList.add(new String[]{rs.getString("id"), rs.getString("name")});
        }
    } catch (Exception e) {}
%>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Manage Orders | Manager</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.28/jspdf.plugin.autotable.min.js"></script>
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
                            <h1 class="text-3xl font-black">&#x1F4E6; Manage Orders</h1>
                            <p class="opacity-70 mt-1">Track customer orders and prioritize urgent deliveries</p>
                        </div>
                        <div class="flex gap-4 items-center">
                            <!-- Date Range Filters -->
                            <div class="flex items-center bg-white/20 px-3 py-1.5 rounded-xl border border-white/30 text-white">
                                <span class="text-xs font-bold mr-2 opacity-70">DATE:</span>
                                <input type="date" id="fromDate" onchange="filterOrders()" class="bg-transparent text-sm font-semibold outline-none cursor-pointer [color-scheme:dark]">
                                <span class="mx-2 opacity-40">-</span>
                                <input type="date" id="toDate" onchange="filterOrders()" class="bg-transparent text-sm font-semibold outline-none cursor-pointer [color-scheme:dark]">
                            </div>

                            <select id="statusFilter" onchange="filterOrders()"
                                class="bg-white/20 border border-white/30 text-white rounded-xl px-4 py-2 text-sm font-semibold outline-none w-40">
                                <option value="all" class="text-gray-800">All Statuses</option>
                                <option value="Processing" class="text-gray-800">Processing</option>
                                <option value="Shipped" class="text-gray-800">Shipped</option>
                                <option value="Delivered" class="text-gray-800">Delivered</option>
                                <option value="Cancelled" class="text-gray-800">Cancelled</option>
                            </select>
                            <input id="searchInput" type="text" placeholder="Search order ID..."
                                oninput="filterOrders()"
                                class="bg-white/20 border border-white/30 text-white placeholder-white/60 rounded-xl px-4 py-2 text-sm font-semibold outline-none w-52">
                        </div>
                    </div>

                    <!-- Stats -->
                    <div class="grid grid-cols-4 gap-6 mb-8">
                        <div class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition">
                            <p class="text-gray-400 text-sm">Total Orders</p>
                            <p class="text-3xl font-black text-blue-700 mt-1" id="stat-total">0</p>
                        </div>
                        <div
                            class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition border-l-4 border-red-500">
                            <p class="text-gray-400 text-sm">Urgent Deliveries</p>
                            <p class="text-3xl font-black text-red-600 mt-1 animate-pulse" id="stat-urgent">0</p>
                        </div>
                        <div
                            class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition border-l-4 border-orange-400">
                            <p class="text-gray-400 text-sm">Processing</p>
                            <p class="text-3xl font-black text-orange-500 mt-1" id="stat-processing">0</p>
                        </div>
                        <div
                            class="bg-white p-5 rounded-2xl shadow hover:scale-105 transition border-l-4 border-green-500">
                            <p class="text-gray-400 text-sm">Delivered</p>
                            <p class="text-3xl font-black text-green-500 mt-1" id="stat-delivered">0</p>
                        </div>
                    </div>

                    <!-- Orders Table -->
                    <div class="bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden">
                        <div class="p-6 border-b border-gray-100 bg-gray-50 flex justify-between items-center">
                            <h2 class="text-xl font-black text-gray-800">Order Logs</h2>
                            <button
                                class="bg-emerald-100 text-emerald-700 px-4 py-1.5 rounded-full text-xs font-bold hover:bg-emerald-200 transition">
                                📥 Export CSV
                            </button>
                        </div>
                        <div class="overflow-x-auto">
                            <table class="w-full text-left border-collapse">
                                <thead>
                                    <tr class="text-xs uppercase text-gray-400 border-b border-gray-100 bg-white">
                                        <th class="px-6 py-4 font-bold tracking-wider">Order ID</th>
                                        <th class="px-6 py-4 font-bold tracking-wider">Customer</th>
                                        <th class="px-6 py-4 font-bold tracking-wider">Date</th>
                                        <th class="px-6 py-4 font-bold tracking-wider">Priority</th>
                                        <th class="px-6 py-4 font-bold tracking-wider">Items Summary</th>
                                        <th class="px-6 py-4 font-bold tracking-wider">Delivery Boy</th>
                                        <th class="px-6 py-4 font-bold tracking-wider">Amount</th>
                                        <th class="px-6 py-4 font-bold tracking-wider">Status</th>
                                        <th class="px-6 py-4 font-bold tracking-wider text-center">Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="orderTableBody" class="text-sm">
                                    <!-- Dynamic Rows -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
        </div>

        <script>
            var orders = [
                <% 
                    try (java.sql.Connection conn = com.coolstack.util.DBConnection.getConnection()) {
                java.sql.Statement stmt = conn.createStatement();
                        String query = "SELECT o.id, c.shop_name, c.name as cust_name, c.phone as cust_phone, c.address as cust_address, o.order_date, o.total_amount, o.status, u.name as delivery_boy " +
                    "FROM orders o JOIN customers c ON o.customer_id = c.id " +
                    "LEFT JOIN users u ON o.delivery_boy_id = u.id ORDER BY o.order_date DESC";
                java.sql.ResultSet rsOrd = stmt.executeQuery(query);
                while (rsOrd.next()) {
                            String status = rsOrd.getString("status");
                            String urgency = "Regular";
                            String dboy = rsOrd.getString("delivery_boy") != null ? rsOrd.getString("delivery_boy") : "Not Assigned";
                    if (status.equals("Pending") || status.equals("Processing")) urgency = "Urgent";

                    out.print("{ id: '#ORD-" + rsOrd.getInt("id") + "', shop: '" + rsOrd.getString("shop_name").replace("'", "\\'") + "', custName: '" + rsOrd.getString("cust_name").replace("'", "\\'") + "', custPhone: '" + rsOrd.getString("cust_phone").replace("'", "\\'") + "', custAddress: '" + rsOrd.getString("cust_address").replace("'", "\\'") + "', date: '" + rsOrd.getTimestamp("order_date") + "', items: 'Check Details', dboy: '" + dboy.replace("'", "\\'") + "', amount: '" + rsOrd.getBigDecimal("total_amount") + "', status: '" + status + "', urgency: '" + urgency + "' },");
                }
            } catch (Exception e) { e.printStackTrace(); }
                %>
            ];

            // Custom sort function to put Urgent/Very Urgent at the top if they are Pending or Processing
            orders.sort(function (a, b) {
                var weightA = (a.urgency && a.urgency.includes('Urgent') && (a.status === 'Pending' || a.status === 'Processing')) ? 1 : 0;
                var weightB = (b.urgency && b.urgency.includes('Urgent') && (b.status === 'Pending' || b.status === 'Processing')) ? 1 : 0;
                return weightB - weightA;
            });

            function getStatusStyle(status) {
                if (status === 'Pending') return 'bg-yellow-100 text-yellow-700';
                if (status === 'Processing') return 'bg-orange-100 text-orange-600';
                if (status === 'Assigned' || status === 'In Transit' || status === 'Shipped') return 'bg-blue-100 text-blue-600';
                if (status === 'Delivered' || status === 'Paid') return 'bg-green-100 text-green-600';
                if (status === 'Cancelled') return 'bg-red-100 text-red-600';
                return 'bg-gray-100 text-gray-600';
            }

            function getPriorityStyle(urgency) {
                if (urgency === 'Very Urgent') return '<span class="px-2 py-0.5 rounded text-[10px] font-black uppercase bg-red-600 text-white shadow-sm animate-pulse">Very Urgent</span>';
                if (urgency === 'Urgent') return '<span class="px-2 py-0.5 rounded text-[10px] font-black uppercase bg-orange-500 text-white shadow-sm">Urgent</span>';
                return '<span class="px-2 py-0.5 rounded text-[10px] font-bold uppercase bg-gray-100 text-gray-500">Regular</span>';
            }

            function buildOrderTable(data) {
                var tbody = document.getElementById('orderTableBody');
                tbody.innerHTML = '';
                var totalOrders = data.length;
                var urgentCount = 0;
                var processingCount = 0;
                var deliveredCount = 0;

                for (var i = 0; i < data.length; i++) {
                    var o = data[i];

                    if (o.urgency && o.urgency.includes('Urgent') && (o.status !== 'Delivered' && o.status !== 'Paid')) urgentCount++;
                    if (o.status === 'Processing' || o.status === 'Pending') processingCount++;
                    if (o.status === 'Delivered' || o.status === 'Paid') deliveredCount++;

                    // For managers, high urgency rows that are still active get a special background tint
                    var rowTint = (o.urgency && o.urgency.includes('Urgent') && o.status !== 'Delivered' && o.status !== 'Paid') ? 'bg-red-50/50 border-red-100' : 'bg-white border-gray-50';

                    var tr = document.createElement('tr');
                    tr.className = 'border-b hover:bg-gray-50 transition ' + rowTint;
                    tr.setAttribute('data-status', o.status);
                    tr.setAttribute('data-id', o.id.toLowerCase());
                    tr.setAttribute('data-raw-date', o.date);

                    var html = '';
                    html += '<td class="px-6 py-4 font-black text-gray-800">' + o.id + '</td>';
                    html += '<td class="px-6 py-4 font-semibold text-gray-700">' + o.shop + '</td>';
                    html += '<td class="px-6 py-4 text-gray-500 text-xs">' + o.date + '</td>';
                    html += '<td class="px-6 py-4">' + getPriorityStyle(o.urgency) + '</td>';
                    html += '<td class="px-6 py-4 text-gray-500 text-xs truncate max-w-[150px]" title="' + o.items + '">' + o.items + '</td>';
                    html += '<td class="px-6 py-4 font-semibold text-gray-700 text-sm">' + o.dboy + '</td>';
                    html += '<td class="px-6 py-4 font-black text-blue-700">&#x20B9;' + Number(o.amount).toLocaleString('en-IN') + '</td>';
                    html += '<td class="px-6 py-4">';
                    html += '<span class="px-3 py-1 rounded-full text-xs font-bold ' + getStatusStyle(o.status) + '">' + o.status + '</span>';
                    html += '</td>';
                    var pureId = o.id.replace('#ORD-', '');
                    html += '<td class="px-6 py-4 text-center">';
                    html += '<div class="flex items-center justify-center gap-1.5">';
                    html += '<button onclick="viewOrder(' + pureId + ')" class="text-blue-600 bg-blue-50 hover:bg-blue-600 hover:text-white px-2.5 py-1.5 rounded-lg text-xs font-bold transition">View</button>';
                    html += '<button onclick="openUpdateModal(' + pureId + ', \'' + o.status + '\')" class="text-emerald-600 bg-emerald-50 hover:bg-emerald-600 hover:text-white px-2.5 py-1.5 rounded-lg text-xs font-bold transition">Update</button>';
                    html += '<button onclick="confirmDeleteOrder(' + pureId + ')" class="text-red-600 bg-red-50 hover:bg-red-600 hover:text-white px-2.5 py-1.5 rounded-lg text-xs font-bold transition">Delete</button>';
                    html += '</div>';
                    html += '</td>';

                    tr.innerHTML = html;
                    tbody.appendChild(tr);
                }

                document.getElementById('stat-total').innerText = totalOrders;
                document.getElementById('stat-urgent').innerText = urgentCount;
                document.getElementById('stat-processing').innerText = processingCount;
                document.getElementById('stat-delivered').innerText = deliveredCount;
            }

            function filterOrders() {
                var q = document.getElementById('searchInput').value.toLowerCase();
                var status = document.getElementById('statusFilter').value;
                var fromDate = document.getElementById('fromDate').value;
                var toDate = document.getElementById('toDate').value;
                var rows = document.querySelectorAll('#orderTableBody tr');

                for (var i = 0; i < rows.length; i++) {
                    var matchId = rows[i].getAttribute('data-id').indexOf(q) !== -1;
                    var matchStatus = status === 'all' || rows[i].getAttribute('data-status') === status;
                    
                    var matchDate = true;
                    var rowDateStr = rows[i].getAttribute('data-raw-date');
                    if (rowDateStr && (fromDate || toDate)) {
                        var rowDate = new Date(rowDateStr.split(' ')[0]); // Parse YYYY-MM-DD
                        rowDate.setHours(0,0,0,0);
                        if (fromDate) {
                            var fDate = new Date(fromDate);
                            fDate.setHours(0,0,0,0);
                            if (rowDate < fDate) matchDate = false;
                        }
                        if (toDate) {
                            var tDate = new Date(toDate);
                            tDate.setHours(0,0,0,0);
                            if (rowDate > tDate) matchDate = false;
                        }
                    }

                    rows[i].style.display = (matchId && matchStatus && matchDate) ? '' : 'none';
                }
            }

            buildOrderTable(orders);

            var customerDataCache = {};
            orders.forEach(o => {
                customerDataCache[o.id.replace('#ORD-', '')] = {
                    name: o.custName,
                    phone: o.custPhone,
                    address: o.custAddress,
                    shop: o.shop
                };
            });

            const ctxPath = '<%= request.getContextPath() %>';
            let currentOrderId = null;
            let currentOrderItemsData = [];
            let currentOrderTotal = 0;
            let currentCustomerInfo = null;

            // View Order Items
            function viewOrder(id) {
                document.getElementById('viewModal').classList.remove('hidden');
                document.getElementById('itemsTableBody').innerHTML = '<tr><td colspan="4" class="text-center py-4 text-gray-500">Loading items...</td></tr>';
                document.getElementById('viewModalTitle').textContent = 'Order Items: #ORD-' + id;
                
                currentOrderId = id;
                currentOrderItemsData = [];
                currentOrderTotal = 0;

                currentCustomerInfo = customerDataCache[id];
                if (currentCustomerInfo) {
                    document.getElementById('modalCustShop').textContent = currentCustomerInfo.shop;
                    document.getElementById('modalCustName').textContent = currentCustomerInfo.name;
                    document.getElementById('modalCustPhone').textContent = currentCustomerInfo.phone;
                    document.getElementById('modalCustAddress').textContent = currentCustomerInfo.address;
                }

                fetch(ctxPath + '/ManagerOrderServlet?action=getDetails&id=' + id)
                    .then(r => r.json())
                    .then(data => {
                        let tbody = document.getElementById('itemsTableBody');
                        tbody.innerHTML = '';
                        if (data.success && data.items.length > 0) {
                            currentOrderItemsData = data.items;
                            data.items.forEach(item => {
                                currentOrderTotal += parseFloat(item.subtotal);
                                tbody.innerHTML += `<tr class="border-b border-gray-100">
                                    <td class="py-3 px-4 font-semibold text-gray-700">${item.name}</td>
                                    <td class="py-3 px-4 text-center text-gray-600">${item.quantity}</td>
                                    <td class="py-3 px-4 text-center text-gray-600">&#x20B9;${item.unit_price}</td>
                                    <td class="py-3 px-4 text-right font-bold text-indigo-700">&#x20B9;${item.subtotal}</td>
                                </tr>`;
                            });
                        } else {
                            tbody.innerHTML = '<tr><td colspan="4" class="text-center py-4 text-gray-500">No items found.</td></tr>';
                        }
                    });
            }

            // Generate Professional PDF Invoice
            function downloadInvoice() {
                if (!window.jspdf || !window.jspdf.jsPDF) {
                    alert('PDF library is loading, try again in a moment');
                    return;
                }
                if (currentOrderItemsData.length === 0) {
                    alert('No details available to generate invoice. Please wait for items to load.');
                    return;
                }
                
                const { jsPDF } = window.jspdf;
                const doc = new jsPDF();
                
                doc.setFontSize(22);
                doc.setTextColor(59, 130, 246);
                doc.text('COOLSTACK', 14, 20);
                
                doc.setFontSize(10);
                doc.setTextColor(100);
                doc.text('Manager Panel Invoice System', 14, 26);
                doc.text('Invoice for Order: #ORD-' + currentOrderId, 14, 32);
                doc.text('Date Generated: ' + new Date().toLocaleString(), 14, 38);

                if (currentCustomerInfo) {
                    doc.setFontSize(11);
                    doc.setTextColor(0);
                    doc.text('Bill To:', 130, 26);
                    doc.setFontSize(10);
                    doc.setTextColor(100);
                    doc.text(currentCustomerInfo.shop, 130, 32);
                    doc.text(currentCustomerInfo.name + ' (' + currentCustomerInfo.phone + ')', 130, 38);
                    
                    var splitAddress = doc.splitTextToSize(currentCustomerInfo.address, 65);
                    doc.text(splitAddress, 130, 44);
                }

                const bodyData = currentOrderItemsData.map(item => [
                    item.name,
                    item.quantity.toString(),
                    'Rs. ' + item.unit_price,
                    'Rs. ' + item.subtotal
                ]);

                bodyData.push([{ content: 'Total Amount', colSpan: 3, styles: { halign: 'right', fontStyle: 'bold' } }, 'Rs. ' + currentOrderTotal.toFixed(2)]);

                doc.autoTable({
                    startY: 58,
                    head: [['Item Name', 'Quantity', 'Rate', 'Subtotal']],
                    body: bodyData,
                    theme: 'grid',
                    headStyles: { fillColor: [59, 130, 246] },
                    styles: { fontSize: 10 }
                });

                doc.save('CoolStack_Invoice_ORD_' + currentOrderId + '.pdf');
            }

            function closeViewModal() {
                document.getElementById('viewModal').classList.add('hidden');
            }

            // Update Order
            function openUpdateModal(id, currentStatus) {
                currentOrderId = id;
                document.getElementById('updateOrderIdDisplay').textContent = '#ORD-' + id;
                document.getElementById('updateStatus').value = currentStatus;
                document.getElementById('updateModal').classList.remove('hidden');
            }

            function closeUpdateModal() {
                document.getElementById('updateModal').classList.add('hidden');
            }

            function submitUpdate() {
                const status = document.getElementById('updateStatus').value;
                const dboy = document.getElementById('updateDeliveryBoy').value;
                document.getElementById('updateBtn').textContent = 'Saving...';
                
                fetch(ctxPath + '/ManagerOrderServlet', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: `action=update&id=${currentOrderId}&status=${encodeURIComponent(status)}&deliveryBoyId=${encodeURIComponent(dboy)}`
                })
                .then(r => r.json())
                .then(data => {
                    if(data.success) {
                        alert('Order updated successfully!');
                        location.reload();
                    } else {
                        alert('Update failed: ' + data.message);
                        document.getElementById('updateBtn').textContent = 'Save Changes';
                    }
                });
            }

            // Delete Order
            function confirmDeleteOrder(id) {
                currentOrderId = id;
                document.getElementById('deleteOrderIdDisplay').textContent = '#ORD-' + id;
                document.getElementById('deleteModal').classList.remove('hidden');
            }

            function closeDeleteModal() {
                document.getElementById('deleteModal').classList.add('hidden');
            }

            function submitDelete() {
                document.getElementById('deleteBtn').textContent = 'Deleting...';
                fetch(ctxPath + '/ManagerOrderServlet', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'action=delete&id=' + currentOrderId
                })
                .then(r => r.json())
                .then(data => {
                    if(data.success) {
                        location.reload();
                    } else {
                        alert('Delete failed: ' + data.message);
                        document.getElementById('deleteBtn').textContent = 'Yes, Delete';
                    }
                });
            }
        </script>

        <!-- VIEW MODAL -->
        <div id="viewModal" class="hidden fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4 backdrop-blur-sm">
            <div class="bg-white rounded-2xl w-full max-w-2xl overflow-hidden shadow-2xl">
                <div class="bg-indigo-600 px-6 py-4 flex justify-between items-center text-white">
                    <h2 class="font-black text-xl" id="viewModalTitle">Order Items</h2>
                    <button onclick="closeViewModal()" class="text-white hover:text-gray-200 text-2xl font-bold">&times;</button>
                </div>
                <div class="p-6">
                    <!-- Customer Summary -->
                    <div class="mb-6 bg-indigo-50/50 p-4 rounded-xl border border-indigo-100 flex justify-between items-start">
                        <div>
                            <p class="text-xs font-bold text-indigo-400 tracking-wider uppercase mb-1">Customer Details</p>
                            <p class="font-black text-gray-800 text-lg" id="modalCustShop"></p>
                            <p class="text-sm font-semibold text-gray-600 mt-0.5" id="modalCustName"></p>
                        </div>
                        <div class="text-right max-w-[200px]">
                            <p class="text-xs font-bold text-gray-400 tracking-wider uppercase mb-1">Contact</p>
                            <p class="text-sm font-bold text-indigo-600" id="modalCustPhone"></p>
                            <p class="text-xs text-gray-500 mt-0.5 text-right" id="modalCustAddress"></p>
                        </div>
                    </div>

                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-gray-50 text-gray-500 text-xs uppercase border-b border-gray-200">
                                <th class="py-3 px-4 font-bold tracking-wider">Item Name</th>
                                <th class="py-3 px-4 font-bold tracking-wider text-center">Qty</th>
                                <th class="py-3 px-4 font-bold tracking-wider text-center">Price</th>
                                <th class="py-3 px-4 font-bold tracking-wider text-right">Subtotal</th>
                            </tr>
                        </thead>
                        <tbody id="itemsTableBody" class="text-sm"></tbody>
                    </table>
                </div>
                <div class="p-4 border-t border-gray-100 flex justify-end gap-3">
                    <button onclick="downloadInvoice()" class="px-5 py-2 bg-indigo-100 text-indigo-700 rounded-xl font-black hover:bg-indigo-200 transition">Download Invoice</button>
                    <button onclick="closeViewModal()" class="px-5 py-2 bg-gray-100 text-gray-700 rounded-xl font-bold hover:bg-gray-200 transition">Close</button>
                </div>
            </div>
        </div>

        <!-- UPDATE MODAL -->
        <div id="updateModal" class="hidden fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4 backdrop-blur-sm">
            <div class="bg-white rounded-2xl w-full max-w-md overflow-hidden shadow-2xl">
                <div class="bg-emerald-500 px-6 py-4 text-white">
                    <h2 class="font-black text-xl">Update Order: <span id="updateOrderIdDisplay"></span></h2>
                </div>
                <div class="p-6 space-y-4">
                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Status</label>
                        <select id="updateStatus" class="w-full border-2 border-gray-200 text-gray-800 rounded-xl px-4 py-2 font-semibold outline-none">
                            <option value="Pending">Pending</option>
                            <option value="Processing">Processing</option>
                            <option value="Out for Delivery">Out for Delivery</option>
                            <option value="Delivered">Delivered</option>
                            <option value="Paid">Paid</option>
                            <option value="Cancelled">Cancelled</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Assign Delivery Boy</label>
                        <select id="updateDeliveryBoy" class="w-full border-2 border-gray-200 text-gray-800 rounded-xl px-4 py-2 font-semibold outline-none">
                            <option value="">-- No changes / Keep current --</option>
                            <% for(String[] dboy : dboyList) { %>
                                <option value="<%= dboy[0] %>"><%= dboy[1] %></option>
                            <% } %>
                        </select>
                    </div>
                </div>
                <div class="p-4 border-t border-gray-100 flex justify-end gap-3">
                    <button onclick="closeUpdateModal()" class="px-5 py-2 bg-gray-100 text-gray-700 rounded-xl font-bold hover:bg-gray-200 transition">Cancel</button>
                    <button id="updateBtn" onclick="submitUpdate()" class="px-5 py-2 bg-emerald-500 text-white rounded-xl font-black shadow hover:bg-emerald-600 transition">Save Changes</button>
                </div>
            </div>
        </div>

        <!-- DELETE MODAL -->
        <div id="deleteModal" class="hidden fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4 backdrop-blur-sm">
            <div class="bg-white rounded-2xl w-full max-w-sm overflow-hidden shadow-2xl p-6 text-center">
                <div class="w-14 h-14 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-4">
                    <span class="text-red-500 font-black text-3xl">&times;</span>
                </div>
                <h2 class="text-2xl font-black text-gray-800 mb-2">Delete Order?</h2>
                <p class="text-gray-500 font-semibold mb-6">Are you sure you want to completely erase <span id="deleteOrderIdDisplay" class="text-red-500"></span>? This action cannot be undone.</p>
                <div class="flex gap-3 justify-center">
                    <button onclick="closeDeleteModal()" class="px-5 py-2.5 bg-gray-100 text-gray-600 rounded-xl font-bold hover:bg-gray-200 transition">Cancel</button>
                    <button id="deleteBtn" onclick="submitDelete()" class="px-5 py-2.5 bg-red-500 text-white rounded-xl font-black shadow hover:bg-red-600 transition">Yes, Delete</button>
                </div>
            </div>
        </div>

    </body>

    </html>