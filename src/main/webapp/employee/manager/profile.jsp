<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>My Profile | CoolStock — Manager</title>
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
        <div class="flex">
            <%@ include file="sidebar.jsp" %>
                <div class="ml-64 p-8 w-full max-w-4xl">
                    <div
                        class="bg-gradient-to-r from-indigo-600 to-purple-600 text-white p-7 rounded-2xl mb-8 flex justify-between items-center shadow-lg">
                        <div>
                            <h1 class="text-3xl font-black">👤 My Profile</h1>
                            <p class="opacity-70 mt-1">View and update your details</p>
                        </div>
                        <a href="dashboard.jsp"
                            class="bg-white/20 px-4 py-2 rounded-xl text-sm font-semibold hover:bg-white/30 transition">←
                            Dashboard</a>
                    </div>
                    <div class="grid grid-cols-3 gap-6">
                        <!-- Photo Card -->
                        <div class="bg-white rounded-2xl shadow-lg p-6 flex flex-col items-center text-center">
                            <div class="relative mb-4">
                                <img id="photoPreview" src="" alt="Profile"
                                    class="w-36 h-36 rounded-full border-4 border-indigo-100 shadow-md object-cover bg-gray-100">
                                <button onclick="document.getElementById('fileInput').click()"
                                    class="absolute bottom-1 right-1 bg-indigo-600 text-white w-9 h-9 rounded-full flex items-center justify-center text-lg shadow hover:bg-indigo-800 transition">📷</button>
                            </div>
                            <input type="file" id="fileInput" accept="image/*" onchange="uploadPhoto(event)">
                            <p class="font-black text-xl text-gray-800" id="displayName">Manager</p>
                            <span class="bg-indigo-100 text-indigo-700 px-3 py-1 rounded-full text-xs font-bold mt-1">📊
                                Manager</span>
                            <button onclick="document.getElementById('fileInput').click()"
                                class="mt-4 w-full py-2 bg-indigo-600 text-white rounded-xl font-semibold text-sm hover:bg-indigo-800 transition">📷
                                Change Photo</button>
                            <p class="text-xs text-gray-400 mt-2">Photo visible to Admin in Manage Staff</p>
                        </div>
                        <!-- Details Card -->
                        <div class="col-span-2 bg-white rounded-2xl shadow-lg p-6">
                            <form action="<%=request.getContextPath()%>/ManagerProfileServlet" method="POST">
                                <div class="flex justify-between items-center mb-6">
                                    <h2 class="text-xl font-bold text-gray-800">Profile Details</h2>
                                    <button type="button" id="editBtn" onclick="toggleEdit()"
                                        class="bg-indigo-600 text-white px-4 py-2 rounded-xl text-sm font-bold hover:bg-indigo-800 transition">✏️
                                        Edit Profile</button>
                                </div>

                                <% com.coolstack.model.Manager manager=(com.coolstack.model.Manager)
                                    request.getAttribute("manager"); if (manager==null) { int
                                    loggedId=(session.getAttribute("loggedUserId") !=null) ? (int)
                                    session.getAttribute("loggedUserId") : -1; if (loggedId !=-1) {
                                    com.coolstack.dao.ManagerDAO dao=new com.coolstack.dao.ManagerDAO();
                                    manager=dao.getManagerById(loggedId); } if (manager==null) {
                                    response.sendRedirect(request.getContextPath()
                                    + "/login.jsp?error=Please Login First" ); return; } } %>
                                    <input type="hidden" name="id" value="<%= manager.getId() %>">

                                    <div class="space-y-4">
                                        <div class="grid grid-cols-2 gap-4">
                                            <div><label class="text-xs font-bold text-gray-400 uppercase">Full
                                                    Name</label>
                                                <p id="view-name" class="font-semibold text-gray-800 mt-0.5">
                                                    <%= manager.getName() %>
                                                </p>
                                                <input id="edit-name" name="name" type="text"
                                                    value="<%= manager.getName() %>"
                                                    class="hidden w-full border-2 border-gray-200 rounded-xl px-3 py-2 mt-0.5 text-sm focus:border-indigo-400 outline-none">
                                            </div>
                                            <div><label class="text-xs font-bold text-gray-400 uppercase">Role</label>
                                                <p class="font-semibold text-gray-800 mt-0.5">📊 Manager</p>
                                            </div>
                                        </div>
                                        <div class="grid grid-cols-2 gap-4">
                                            <div><label class="text-xs font-bold text-gray-400 uppercase">Email</label>
                                                <p id="view-email" class="font-semibold text-gray-800 mt-0.5">
                                                    <%= manager.getEmail() %>
                                                </p>
                                                <input id="edit-email" name="email" type="email"
                                                    value="<%= manager.getEmail() %>"
                                                    class="hidden w-full border-2 border-gray-200 rounded-xl px-3 py-2 mt-0.5 text-sm focus:border-indigo-400 outline-none">
                                            </div>
                                            <div><label
                                                    class="text-xs font-bold text-gray-400 uppercase">Contact</label>
                                                <p id="view-phone" class="font-semibold text-gray-800 mt-0.5">
                                                    <%= manager.getPhone() %>
                                                </p>
                                                <input id="edit-phone" name="phone" type="text"
                                                    value="<%= manager.getPhone() %>"
                                                    class="hidden w-full border-2 border-gray-200 rounded-xl px-3 py-2 mt-0.5 text-sm focus:border-indigo-400 outline-none">
                                            </div>
                                        </div>
                                        <div><label class="text-xs font-bold text-gray-400 uppercase">Username</label>
                                            <p class="font-semibold text-gray-800 mt-0.5">manager</p>
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
        </div>
        <script>
            function toggleEdit() {
                const isEditing = !document.getElementById('saveBtn').classList.contains('hidden');
                const fields = ['name', 'email', 'phone'];

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