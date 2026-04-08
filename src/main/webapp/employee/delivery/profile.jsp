<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>My Profile | CoolStock — Delivery</title>
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
            <!-- Delivery Sidebar -->
            <div class="w-64 h-screen bg-orange-700 text-white fixed flex flex-col justify-between">
                <div>
                    <div class="p-5 border-b border-orange-600 flex items-center gap-3"><span class="text-2xl">🛵</span>
                        <div>
                            <h2 class="text-lg font-black">CoolStock</h2>
                            <p class="text-xs text-orange-200">Delivery Panel</p>
                        </div>
                    </div>
                    <nav class="mt-4 space-y-1 px-3">
                        <a href="dashboard.jsp"
                            class="flex items-center gap-3 py-2.5 px-4 rounded-xl hover:bg-orange-600 transition font-semibold text-sm"><span>🏠</span>
                            My Orders</a>
                        <a href="previous_orders.jsp"
                            class="flex items-center gap-3 py-2.5 px-4 rounded-xl hover:bg-orange-600 transition font-semibold text-sm"><span>📜</span>
                            Previous Orders</a>
                        <a href="profile.jsp"
                            class="flex items-center gap-3 py-2.5 px-4 rounded-xl bg-orange-600 font-semibold text-sm"><span>👤</span>
                            My Profile</a>
                    </nav>
                </div>
                <div class="mb-5 px-4"><a href="../../logout.jsp"
                        class="block py-3 px-4 bg-red-600 rounded-xl hover:bg-red-700 transition text-center font-bold text-sm">🚪
                        Logout</a></div>
            </div>
            <div class="ml-64 p-8 w-full max-w-4xl">
                <div
                    class="bg-gradient-to-r from-orange-500 to-red-500 text-white p-7 rounded-2xl mb-8 flex justify-between items-center shadow-lg">
                    <div>
                        <h1 class="text-3xl font-black">👤 My Profile</h1>
                        <p class="opacity-70 mt-1">View and update your details</p>
                    </div>
                    <a href="dashboard.jsp"
                        class="bg-white/20 px-4 py-2 rounded-xl text-sm font-semibold hover:bg-white/30 transition">←
                        Dashboard</a>
                </div>
                <div class="grid grid-cols-3 gap-6">
                    <div class="bg-white rounded-2xl shadow-lg p-6 flex flex-col items-center text-center">
                        <% Integer userIdObj=(Integer) session.getAttribute("loggedUserId"); if (userIdObj==null) {
                            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Session Expired" );
                            return; } int userId=userIdObj; String fullName=(String)
                            session.getAttribute("loggedFullName"); String email=(String)
                            session.getAttribute("loggedEmail"); String username=(String)
                            session.getAttribute("loggedUsername"); String phone="" ; String profilePhoto=null; try
                            (java.sql.Connection conn=com.coolstack.util.DBConnection.getConnection()) {
                            java.sql.PreparedStatement ps=conn.prepareStatement("SELECT * FROM users WHERE id=?");
                            ps.setInt(1, userId); java.sql.ResultSet rs=ps.executeQuery(); if (rs.next()) {
                            email=rs.getString("email"); phone=rs.getString("phone");
                            profilePhoto=rs.getString("profile_photo"); } } catch (Exception e) { e.printStackTrace(); }
                            %>
                            <div class="relative mb-4">
                                <img id="photoPreview"
                                    src="<%= (profilePhoto != null && !profilePhoto.isEmpty()) ? request.getContextPath() + "/" + profilePhoto : "../../assets/img/default-avatar.png" %>" alt="Profile"
                                class="w-36 h-36 rounded-full border-4 border-orange-100 shadow-md object-cover
                                bg-gray-100">
                                <button onclick="document.getElementById('fileInput').click()"
                                    class="absolute bottom-1 right-1 bg-orange-600 text-white w-9 h-9 rounded-full flex items-center justify-center text-lg shadow hover:bg-orange-800 transition">📷</button>
                            </div>
                            <input type="file" id="fileInput" accept="image/*" onchange="uploadPhoto(event)">
                            <p class="font-black text-xl text-gray-800" id="displayName">
                                <%= fullName %>
                            </p>
                            <span class="bg-orange-100 text-orange-700 px-3 py-1 rounded-full text-xs font-bold mt-1">🛵
                                Delivery Boy</span>
                            <button onclick="document.getElementById('fileInput').click()"
                                class="mt-4 w-full py-2 bg-orange-600 text-white rounded-xl font-semibold text-sm hover:bg-orange-800 transition">📷
                                Change Photo</button>
                            <p class="text-xs text-gray-400 mt-2">Photo visible to Admin in Manage Staff</p>
                    </div>
                    <div class="col-span-2 bg-white rounded-2xl shadow-lg p-6">
                        <div class="flex justify-between items-center mb-6">
                            <h2 class="text-xl font-bold text-gray-800">Profile Details</h2><button id="editBtn"
                                onclick="toggleEdit()"
                                class="bg-orange-500 text-white px-4 py-2 rounded-xl text-sm font-bold hover:bg-orange-700 transition">✏️
                                Edit Profile</button>
                        </div>
                        <div class="space-y-4">
                            <div class="grid grid-cols-2 gap-4">
                                <div><label class="text-xs font-bold text-gray-400 uppercase">Full Name</label>
                                    <p id="view-name" class="font-semibold text-gray-800 mt-0.5">
                                        <%= fullName %>
                                    </p>
                                    <input id="edit-name" type="text" value="<%= fullName %>"
                                        class="hidden w-full border-2 border-gray-200 rounded-xl px-3 py-2 mt-0.5 text-sm outline-none">
                                </div>
                                <div><label class="text-xs font-bold text-gray-400 uppercase">Role</label>
                                    <p class="font-semibold text-gray-800 mt-0.5">🛵 Delivery Boy</p>
                                </div>
                            </div>
                            <div class="grid grid-cols-2 gap-4">
                                <div><label class="text-xs font-bold text-gray-400 uppercase">Email</label>
                                    <p id="view-email" class="font-semibold text-gray-800 mt-0.5">
                                        <%= email %>
                                    </p>
                                    <input id="edit-email" type="email" value="<%= email %>"
                                        class="hidden w-full border-2 border-gray-200 rounded-xl px-3 py-2 mt-0.5 text-sm outline-none">
                                </div>
                                <div><label class="text-xs font-bold text-gray-400 uppercase">Contact</label>
                                    <p id="view-phone" class="font-semibold text-gray-800 mt-0.5">
                                        <%= phone %>
                                    </p>
                                    <input id="edit-phone" type="text" value="<%= phone %>"
                                        class="hidden w-full border-2 border-gray-200 rounded-xl px-3 py-2 mt-0.5 text-sm outline-none">
                                </div>
                            </div>
                            <div><label class="text-xs font-bold text-gray-400 uppercase">Username</label>
                                <p class="font-semibold text-gray-800 mt-0.5">
                                    <%= username %>
                                </p>
                            </div>
                        </div>
                        <button id="saveBtn" onclick="saveProfile()"
                            class="hidden mt-6 w-full py-3 bg-emerald-600 text-white font-black rounded-2xl hover:bg-emerald-700 transition">💾
                            Save Changes</button>
                        <div id="savedMsg"
                            class="hidden mt-4 bg-green-50 text-green-700 p-3 rounded-xl text-sm font-semibold text-center">
                            ✅ Profile updated successfully!</div>
                    </div>
                </div>
            </div>
        </div>
        <script>
            function toggleEdit() { const e = !document.getElementById('saveBtn').classList.contains('hidden');['name', 'email', 'phone'].forEach(f => { document.getElementById('view-' + f).classList.toggle('hidden', !e); document.getElementById('edit-' + f).classList.toggle('hidden', e); }); document.getElementById('saveBtn').classList.toggle('hidden'); document.getElementById('editBtn').innerText = e ? '✏️ Edit Profile' : '✖ Cancel'; }
            function saveProfile() {
                // Placeholder for profile update logic
                toggleEdit(); document.getElementById('savedMsg').classList.remove('hidden'); setTimeout(() => document.getElementById('savedMsg').classList.add('hidden'), 3000);
            }
            function uploadPhoto(e) { /* Placeholder for photo upload logic */ }
        </script>
    </body>

    </html>