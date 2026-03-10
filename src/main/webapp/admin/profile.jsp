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
                                <img id="photoPreview" src="" alt="Profile Photo"
                                    class="w-36 h-36 rounded-full border-4 border-slate-200 shadow-md object-cover bg-gray-100"
                                    onerror="this.src='data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' width=\'100\' height=\'100\' viewBox=\'0 0 100 100\'%3E%3Ccircle cx=\'50\' cy=\'50\' r=\'50\' fill=\'%23e2e8f0\'/%3E%3Ctext x=\'50\' y=\'62\' font-size=\'40\' text-anchor=\'middle\' fill=\'%2394a3b8\'%3E⚙️%3C/text%3E%3C/svg%3E'">
                                <button onclick="document.getElementById('fileInput').click()"
                                    class="absolute bottom-1 right-1 bg-slate-700 text-white w-9 h-9 rounded-full flex items-center justify-center text-lg shadow hover:bg-slate-900 transition">
                                    📷
                                </button>
                            </div>
                            <input type="file" id="fileInput" accept="image/*" onchange="uploadPhoto(event)">
                            <p class="font-black text-xl text-gray-800" id="displayName">Admin</p>
                            <span class="bg-slate-100 text-slate-700 px-3 py-1 rounded-full text-xs font-bold mt-1">⚙️
                                Admin</span>
                            <button onclick="document.getElementById('fileInput').click()"
                                class="mt-4 w-full py-2 bg-slate-700 text-white rounded-xl font-semibold text-sm hover:bg-slate-900 transition">
                                📷 Change Photo
                            </button>
                            <p class="text-xs text-gray-400 mt-2">Photo is visible to all staff in Manage pages</p>
                        </div>

                        <!-- Details Card -->
                        <div class="col-span-2 bg-white rounded-2xl shadow-lg p-6">
                            <div class="flex justify-between items-center mb-6">
                                <h2 class="text-xl font-bold text-gray-800">Profile Details</h2>
                                <button id="editBtn" onclick="toggleEdit()"
                                    class="bg-slate-700 text-white px-4 py-2 rounded-xl text-sm font-bold hover:bg-slate-900 transition">
                                    ✏️ Edit Profile
                                </button>
                            </div>

                            <div class="space-y-4">
                                <div class="grid grid-cols-2 gap-4">
                                    <div>
                                        <label class="text-xs font-bold text-gray-400 uppercase">Full Name</label>
                                        <p id="view-name" class="font-semibold text-gray-800 mt-0.5">Admin User</p>
                                        <input id="edit-name" type="text" value="Admin User"
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
                                        <p id="view-email" class="font-semibold text-gray-800 mt-0.5">admin@coolstock.in
                                        </p>
                                        <input id="edit-email" type="email" value="admin@coolstock.in"
                                            class="hidden w-full border-2 border-gray-200 rounded-xl px-3 py-2 mt-0.5 text-sm focus:border-slate-400 outline-none">
                                    </div>
                                    <div>
                                        <label class="text-xs font-bold text-gray-400 uppercase">Contact Number</label>
                                        <p id="view-phone" class="font-semibold text-gray-800 mt-0.5">+91 99999 00001
                                        </p>
                                        <input id="edit-phone" type="text" value="+91 99999 00001"
                                            class="hidden w-full border-2 border-gray-200 rounded-xl px-3 py-2 mt-0.5 text-sm focus:border-slate-400 outline-none">
                                    </div>
                                </div>
                                <div>
                                    <label class="text-xs font-bold text-gray-400 uppercase">Username</label>
                                    <p class="font-semibold text-gray-800 mt-0.5">admin</p>
                                </div>
                                <div>
                                    <label class="text-xs font-bold text-gray-400 uppercase">Joined</label>
                                    <p class="font-semibold text-gray-800 mt-0.5">1 January 2025</p>
                                </div>
                            </div>

                            <!-- Save Button (hidden in view mode) -->
                            <button id="saveBtn" onclick="saveProfile()"
                                class="hidden mt-6 w-full py-3 bg-emerald-600 text-white font-black rounded-2xl hover:bg-emerald-700 transition">
                                💾 Save Changes
                            </button>

                            <div id="savedMsg"
                                class="hidden mt-4 bg-green-50 text-green-700 p-3 rounded-xl text-sm font-semibold text-center">
                                ✅ Profile updated successfully!
                            </div>
                        </div>
                    </div>
                </div>
        </div>

        <script>
            const STORAGE_KEY = 'cs_profile_admin';
            let isEditing = false;

            function loadProfile() {
                const data = JSON.parse(localStorage.getItem(STORAGE_KEY) || '{}');
                if (data.photo) document.getElementById('photoPreview').src = data.photo;
                if (data.name) { document.getElementById('view-name').innerText = data.name; document.getElementById('edit-name').value = data.name; document.getElementById('displayName').innerText = data.name; }
                if (data.email) { document.getElementById('view-email').innerText = data.email; document.getElementById('edit-email').value = data.email; }
                if (data.phone) { document.getElementById('view-phone').innerText = data.phone; document.getElementById('edit-phone').value = data.phone; }
            }

            function toggleEdit() {
                isEditing = !isEditing;
                ['name', 'email', 'phone'].forEach(f => {
                    document.getElementById('view-' + f).classList.toggle('hidden', isEditing);
                    document.getElementById('edit-' + f).classList.toggle('hidden', !isEditing);
                });
                document.getElementById('saveBtn').classList.toggle('hidden', !isEditing);
                document.getElementById('editBtn').innerText = isEditing ? '✖ Cancel' : '✏️ Edit Profile';
                document.getElementById('savedMsg').classList.add('hidden');
            }

            function saveProfile() {
                const data = JSON.parse(localStorage.getItem(STORAGE_KEY) || '{}');
                data.name = document.getElementById('edit-name').value;
                data.email = document.getElementById('edit-email').value;
                data.phone = document.getElementById('edit-phone').value;
                localStorage.setItem(STORAGE_KEY, JSON.stringify(data));
                document.getElementById('view-name').innerText = data.name;
                document.getElementById('view-email').innerText = data.email;
                document.getElementById('view-phone').innerText = data.phone;
                document.getElementById('displayName').innerText = data.name;
                toggleEdit();
                document.getElementById('savedMsg').classList.remove('hidden');
                setTimeout(() => document.getElementById('savedMsg').classList.add('hidden'), 3000);
            }

            function uploadPhoto(event) {
                const file = event.target.files[0];
                if (!file) return;
                const reader = new FileReader();
                reader.onload = e => {
                    const src = e.target.result;
                    document.getElementById('photoPreview').src = src;
                    const data = JSON.parse(localStorage.getItem(STORAGE_KEY) || '{}');
                    data.photo = src;
                    localStorage.setItem(STORAGE_KEY, JSON.stringify(data));
                };
                reader.readAsDataURL(file);
            }

            loadProfile();
        </script>
    </body>

    </html>