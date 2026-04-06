<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>My Profile | CoolStock — Customer</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&display=swap" rel="stylesheet">
        <style>
            body {
                font-family: 'Outfit', sans-serif;
            }

            input[type=file] {
                display: none;
            }
        </style>
    </head>

    <body class="bg-gray-100 min-h-screen">

        <!-- Customer Nav -->
        <nav class="bg-white shadow-sm sticky top-0 z-40 px-6 py-3 flex justify-between items-center">
            <div class="flex items-center gap-2"><span class="text-3xl">🍦</span>
                <div><span class="text-xl font-black text-gray-800">CoolStock</span><span
                        class="text-xs text-gray-400 ml-2">Customer Portal</span></div>
            </div>
            <div class="flex gap-4 text-sm font-semibold">
                <a href="place_order.jsp" class="text-gray-500 hover:text-purple-600 transition">📦 Place Order</a>
                <a href="track_order.jsp" class="text-gray-500 hover:text-purple-600 transition">📍 Track Orders</a>
                <a href="profile.jsp" class="text-purple-600 border-b-2 border-purple-600 pb-0.5">👤 My Profile</a>
            </div>
            <a href="../logout.jsp"
                class="bg-red-100 text-red-600 px-4 py-2 rounded-xl font-semibold text-sm hover:bg-red-200 transition">🚪
                Logout</a>
        </nav>

        <div class="max-w-4xl mx-auto px-6 py-8">
            <div class="bg-gradient-to-r from-purple-600 to-pink-500 text-white p-7 rounded-2xl mb-8 shadow-lg">
                <h1 class="text-3xl font-black">👤 My Profile</h1>
                <p class="opacity-70 mt-1">Manage your shop account and contact details</p>
            </div>

            <div class="grid grid-cols-3 gap-6">
                <!-- Photo Card -->
                <div class="bg-white rounded-2xl shadow-lg p-6 flex flex-col items-center text-center">
                    <div class="relative mb-4">
                        <img id="photoPreview" src="" alt="Profile"
                            class="w-36 h-36 rounded-full border-4 border-purple-100 shadow-md object-cover bg-gray-100">
                        <button onclick="document.getElementById('fileInput').click()"
                            class="absolute bottom-1 right-1 bg-purple-600 text-white w-9 h-9 rounded-full flex items-center justify-center text-lg shadow hover:bg-purple-800 transition">📷</button>
                    </div>
                    <input type="file" id="fileInput" accept="image/*" onchange="uploadPhoto(event)">
                    <p class="font-black text-xl text-gray-800" id="displayName">Shop Owner</p>
                    <span class="bg-purple-100 text-purple-700 px-3 py-1 rounded-full text-xs font-bold mt-1">🏪
                        Customer</span>
                    <button onclick="document.getElementById('fileInput').click()"
                        class="mt-4 w-full py-2 bg-purple-600 text-white rounded-xl font-semibold text-sm hover:bg-purple-800 transition">📷
                        Change Photo</button>
                    <p class="text-xs text-gray-400 mt-2">Photo visible to Admin</p>
                </div>

                <!-- Details Card -->
                <div class="col-span-2 bg-white rounded-2xl shadow-lg p-6">
                    <form action="<%=request.getContextPath()%>/CustomerProfileServlet" method="POST">
                        <div class="flex justify-between items-center mb-6">
                            <h2 class="text-xl font-bold text-gray-800">Account Details</h2>
                            <button type="button" id="editBtn" onclick="toggleEdit()"
                                class="bg-purple-600 text-white px-4 py-2 rounded-xl text-sm font-bold hover:bg-purple-800 transition">✏️
                                Edit Profile</button>
                        </div>

                        <% com.coolstack.model.Customer customer=(com.coolstack.model.Customer)
                            request.getAttribute("customer"); if (customer==null) { int
                            loggedId=(session.getAttribute("loggedUserId") !=null) ? (int)
                            session.getAttribute("loggedUserId") : -1; if (loggedId !=-1) {
                            com.coolstack.dao.CustomerDAO dao=new com.coolstack.dao.CustomerDAO();
                            customer=dao.getCustomerById(loggedId); } if (customer==null) {
                            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please Login First" );
                            return; } } %>
                            <input type="hidden" name="id" value="<%= customer.getId() %>">

                            <div class="space-y-4">
                                <div class="grid grid-cols-2 gap-4">
                                    <div><label class="text-xs font-bold text-gray-400 uppercase">Owner Name</label>
                                        <p id="view-name" class="font-semibold text-gray-800 mt-0.5">
                                            <%= customer.getName() %>
                                        </p>
                                        <input id="edit-name" name="name" type="text" value="<%= customer.getName() %>"
                                            class="hidden w-full border-2 border-gray-200 rounded-xl px-3 py-2 mt-0.5 text-sm outline-none">
                                    </div>
                                    <div><label class="text-xs font-bold text-gray-400 uppercase">Shop Name</label>
                                        <p id="view-shop" class="font-semibold text-gray-800 mt-0.5">
                                            <%= customer.getShopName() %>
                                        </p>
                                        <input id="edit-shop" name="shopName" type="text"
                                            value="<%= customer.getShopName() %>"
                                            class="hidden w-full border-2 border-gray-200 rounded-xl px-3 py-2 mt-0.5 text-sm outline-none">
                                    </div>
                                </div>
                                <div class="grid grid-cols-2 gap-4">
                                    <div><label class="text-xs font-bold text-gray-400 uppercase">Email</label>
                                        <p id="view-email" class="font-semibold text-gray-800 mt-0.5">
                                            <%= customer.getEmail() %>
                                        </p>
                                        <input id="edit-email" name="email" type="email"
                                            value="<%= customer.getEmail() %>"
                                            class="hidden w-full border-2 border-gray-200 rounded-xl px-3 py-2 mt-0.5 text-sm outline-none">
                                    </div>
                                    <div><label class="text-xs font-bold text-gray-400 uppercase">Contact</label>
                                        <p id="view-phone" class="font-semibold text-gray-800 mt-0.5">
                                            <%= customer.getPhone() %>
                                        </p>
                                        <input id="edit-phone" name="phone" type="text"
                                            value="<%= customer.getPhone() %>"
                                            class="hidden w-full border-2 border-gray-200 rounded-xl px-3 py-2 mt-0.5 text-sm outline-none">
                                    </div>
                                </div>
                                <div><label class="text-xs font-bold text-gray-400 uppercase">Shop Address</label>
                                    <p id="view-addr" class="font-semibold text-gray-800 mt-0.5">
                                        <%= customer.getAddress() %>
                                    </p>
                                    <input id="edit-addr" name="address" type="text"
                                        value="<%= customer.getAddress() %>"
                                        class="hidden w-full border-2 border-gray-200 rounded-xl px-3 py-2 mt-0.5 text-sm outline-none">
                                </div>
                                <div><label class="text-xs font-bold text-gray-400 uppercase">Username</label>
                                    <p class="font-semibold text-gray-800 mt-0.5">customer</p>
                                </div>
                            </div>
                            <button id="saveBtn" type="submit"
                                class="hidden mt-6 w-full py-3 bg-emerald-600 text-white font-black rounded-2xl hover:bg-emerald-700 transition">💾
                                Save Changes</button>
                            <% if ("success".equals(request.getParameter("status"))) { %>
                                <div id="savedMsg"
                                    class="mt-4 bg-green-50 text-green-700 p-3 rounded-xl text-sm font-semibold text-center">
                                    ✅ Profile updated successfully!</div>
                                <% } else if ("error".equals(request.getParameter("status"))) { %>
                                    <div id="errorMsg"
                                        class="mt-4 bg-red-50 text-red-700 p-3 rounded-xl text-sm font-semibold text-center">
                                        ❌ Failed to update profile!</div>
                                    <% } %>
                    </form>
                </div>
            </div>
        </div>

        <script>
            function toggleEdit() {
                const isEditing = !document.getElementById('saveBtn').classList.contains('hidden');
                const fields = ['name', 'shop', 'email', 'phone', 'addr'];

                fields.forEach(f => {
                    const viewEl = document.getElementById('view-' + f);
                    const editEl = document.getElementById('edit-' + f);
                    if (viewEl && editEl) {
                        viewEl.classList.toggle('hidden', !isEditing);
                        editEl.classList.toggle('hidden', isEditing);
                    }
                });

                document.getElementById('saveBtn').classList.toggle('hidden');
                document.getElementById('editBtn').innerText = isEditing ? '✏️ Edit Profile' : '✖ Cancel';
            }

            function uploadPhoto(e) {
                const r = new FileReader();
                r.onload = ev => {
                    document.getElementById('photoPreview').src = ev.target.result;
                };
                r.readAsDataURL(e.target.files[0]);
            }
        </script>
    </body>

    </html>