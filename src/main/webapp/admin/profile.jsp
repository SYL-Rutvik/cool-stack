<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>My Profile | CoolStock — Admin</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&display=swap" rel="stylesheet">
        <style>
            body {
                font-family: 'Outfit', sans-serif;
            }

            #photoPreview {
                object-fit: cover;
            }

            input[type=file] {
                display: none;
            }
        </style>
    </head>

    <body class="bg-gray-100 min-h-screen">
        <div class="flex">
            <%@ include file="sidebar.jsp" %>
                <div class="ml-64 p-8 w-full max-w-4xl">
                    <% com.coolstack.model.Admin admin=(com.coolstack.model.Admin) request.getAttribute("admin"); if
                        (admin==null) { Integer loggedId=(Integer) session.getAttribute("loggedUserId"); if (loggedId
                        !=null) { com.coolstack.dao.AdminDAO dao=new com.coolstack.dao.AdminDAO();
                        admin=dao.getAdminById(loggedId); } if (admin==null) {
                        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please Login First" );
                        return; } } %>
                        <!-- Header -->
                        <div
                            class="bg-gradient-to-r from-slate-800 to-gray-700 text-white p-7 rounded-2xl mb-8 flex justify-between items-center shadow-lg">
                            <div>
                                <h1 class="text-3xl font-black">👤 My Profile</h1>
                                <p class="opacity-70 mt-1">View and update your account details</p>
                            </div>
                            <a href="dashboard.jsp"
                                class="bg-white/20 px-4 py-2 rounded-xl text-sm font-semibold hover:bg-white/30 transition">←
                                Back to Dashboard</a>
                        </div>

                        <div class="grid grid-cols-3 gap-6">

                            <!-- Photo Card -->
                            <div class="bg-white rounded-2xl shadow-lg p-6 flex flex-col items-center text-center">
                                <div class="relative mb-4">
                                    <% String photoUrl=admin.getProfilePhoto(); if (photoUrl==null ||
                                        photoUrl.isEmpty()) {
                                        photoUrl="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='100' height='100' viewBox='0 0 100 100'%3E%3Ccircle cx='50' cy='50' r='50' fill='%23e2e8f0'/%3E%3Ctext x='50' y='62' font-size='40' text-anchor='middle' fill='%2394a3b8'%3E⚙️%3C/text%3E%3C/svg%3E"
                                        ; } %>
                                        <img id="photoPreview" src="<%= photoUrl %>" alt="Profile Photo"
                                            class="w-36 h-36 rounded-full border-4 border-slate-200 shadow-md object-cover bg-gray-100">
                                        <button onclick="document.getElementById('fileInput').click()"
                                            class="absolute bottom-1 right-1 bg-slate-700 text-white w-9 h-9 rounded-full flex items-center justify-center text-lg shadow hover:bg-slate-900 transition">
                                            📷
                                        </button>
                                </div>
                                <input type="file" id="fileInput" accept="image/*" onchange="uploadPhoto(event)">
                                <p class="font-black text-xl text-gray-800" id="displayName">
                                    <%= admin.getName() %>
                                </p>
                                <span
                                    class="bg-slate-100 text-slate-700 px-3 py-1 rounded-full text-xs font-bold mt-1">⚙️
                                    Admin</span>
                                <button onclick="document.getElementById('fileInput').click()"
                                    class="mt-4 w-full py-2 bg-slate-700 text-white rounded-xl font-semibold text-sm hover:bg-slate-900 transition">
                                    📷 Change Photo
                                </button>
                                <p class="text-xs text-gray-400 mt-2">Photo is stored in your account</p>
                            </div>

                            <!-- Details Card -->
                            <div class="col-span-2 bg-white rounded-2xl shadow-lg p-6">
                                <form action="<%=request.getContextPath()%>/AdminProfileServlet" method="POST">
                                    <div class="flex justify-between items-center mb-6">
                                        <h2 class="text-xl font-bold text-gray-800">Profile Details</h2>
                                        <button type="button" id="editBtn" onclick="toggleEdit()"
                                            class="bg-slate-700 text-white px-4 py-2 rounded-xl text-sm font-bold hover:bg-slate-900 transition">
                                            ✏️ Edit Profile
                                        </button>
                                    </div>

                                    <input type="hidden" name="id" value="<%= admin.getId() %>">

                                    <div class="space-y-4">
                                        <div class="grid grid-cols-2 gap-4">
                                            <div>
                                                <label class="text-xs font-bold text-gray-400 uppercase">Full
                                                    Name</label>
                                                <p id="view-name" class="font-semibold text-gray-800 mt-0.5">
                                                    <%= admin.getName() %>
                                                </p>
                                                <input id="edit-name" name="name" type="text"
                                                    value="<%= admin.getName() %>"
                                                    class="hidden w-full border-2 border-gray-200 rounded-xl px-3 py-2 mt-0.5 text-sm focus:border-slate-400 outline-none">
                                            </div>
                                            <div>
                                                <label class="text-xs font-bold text-gray-400 uppercase">Role</label>
                                                <p class="font-semibold text-gray-800 mt-0.5">⚙️ Admin</p>
                                            </div>
                                        </div>
                                        <div class="grid grid-cols-2 gap-4">
                                            <div>
                                                <label class="text-xs font-bold text-gray-400 uppercase">Email</label>
                                                <p id="view-email" class="font-semibold text-gray-800 mt-0.5">
                                                    <%= admin.getEmail() %>
                                                </p>
                                                <input id="edit-email" name="email" type="email"
                                                    value="<%= admin.getEmail() %>"
                                                    class="hidden w-full border-2 border-gray-200 rounded-xl px-3 py-2 mt-0.5 text-sm focus:border-slate-400 outline-none">
                                            </div>
                                            <div>
                                                <label class="text-xs font-bold text-gray-400 uppercase">Contact
                                                    Number</label>
                                                <p id="view-phone" class="font-semibold text-gray-800 mt-0.5">
                                                    <%= admin.getPhone() %>
                                                </p>
                                                <input id="edit-phone" name="phone" type="text"
                                                    value="<%= admin.getPhone() %>"
                                                    class="hidden w-full border-2 border-gray-200 rounded-xl px-3 py-2 mt-0.5 text-sm focus:border-slate-400 outline-none">
                                            </div>
                                        </div>
                                        <div>
                                            <label class="text-xs font-bold text-gray-400 uppercase">Username</label>
                                            <p class="font-semibold text-gray-800 mt-0.5">
                                                <%= admin.getUsername() %>
                                            </p>
                                        </div>
                                        <div>
                                            <label class="text-xs font-bold text-gray-400 uppercase">Member
                                                Since</label>
                                            <p class="font-semibold text-gray-800 mt-0.5">
                                                <%= admin.getCreatedAt() !=null ? admin.getCreatedAt().toString()
                                                    : "N/A" %>
                                            </p>
                                        </div>
                                    </div>

                                    <!-- Save Button (hidden in view mode) -->
                                    <button type="submit" id="saveBtn"
                                        class="hidden mt-6 w-full py-3 bg-emerald-600 text-white font-black rounded-2xl hover:bg-emerald-700 transition">
                                        💾 Save Changes
                                    </button>

                                    <% if ("success".equals(request.getParameter("status"))) { %>
                                        <div id="savedMsg"
                                            class="mt-4 bg-green-50 text-green-700 p-3 rounded-xl text-sm font-semibold text-center">
                                            ✅ Profile updated successfully!
                                        </div>
                                        <% } else if ("error".equals(request.getParameter("status"))) { %>
                                            <div id="errorMsg"
                                                class="mt-4 bg-red-50 text-red-700 p-3 rounded-xl text-sm font-semibold text-center">
                                                ❌ Failed to update profile!
                                            </div>
                                            <% } %>
                                </form>
                            </div>
                        </div>
                </div>
        </div>

        <script>
            let isEditing = false;

            function toggleEdit() {
                isEditing = !isEditing;
                ['name', 'email', 'phone'].forEach(f => {
                    const viewEl = document.getElementById('view-' + f);
                    const editEl = document.getElementById('edit-' + f);
                    if (viewEl && editEl) {
                        viewEl.classList.toggle('hidden', isEditing);
                        editEl.classList.toggle('hidden', !isEditing);
                    }
                });
                document.getElementById('saveBtn').classList.toggle('hidden', !isEditing);
                document.getElementById('editBtn').innerText = isEditing ? '✖ Cancel' : '✏️ Edit Profile';
            }

            function uploadPhoto(event) {
                const file = event.target.files[0];
                if (!file) return;
                const reader = new FileReader();
                reader.onload = e => {
                    const src = e.target.result;
                    document.getElementById('photoPreview').src = src;
                };
                reader.readAsDataURL(file);
            }
        </script>
    </body>

    </html>