<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <div class="w-64 h-screen bg-slate-800 text-white fixed flex flex-col justify-between overflow-y-auto">
        <div>
            <div class="p-5 border-b border-slate-700 flex items-center gap-3">
                <span class="text-2xl">🍦</span>
                <div>
                    <h2 class="text-lg font-black">CoolStock</h2>
                    <p class="text-xs text-slate-400">Admin Panel</p>
                </div>
            </div>
            <nav class="mt-4 space-y-1 px-3">

                <!-- Dashboard -->
                <p class="text-xs text-slate-500 uppercase font-bold px-3 pt-2 pb-1">Overview</p>
                <a href="dashboard.jsp"
                    class="flex items-center gap-3 py-2.5 px-4 rounded-xl hover:bg-slate-700 transition font-semibold text-sm">
                    <span>🏠</span> Dashboard
                </a>
                <!-- <a href="dashboard.jsp#requests"
                    class="flex items-center gap-3 py-2.5 px-4 rounded-xl hover:bg-slate-700 transition font-semibold text-sm">
                    <span>📋</span> Join Requests
                </a> -->

                <!-- Management -->
                <p class="text-xs text-slate-500 uppercase font-bold px-3 pt-4 pb-1">Management</p>
                <a href="view_products.jsp"
                    class="flex items-center gap-3 py-2.5 px-4 rounded-xl hover:bg-slate-700 transition font-semibold text-sm">
                    <span>📦</span> Manage Products
                </a>
                <a href="recent_orders.jsp"
                    class="flex items-center gap-3 py-2.5 px-4 rounded-xl hover:bg-slate-700 transition font-semibold text-sm">
                    <span>🧾</span> Recent Orders
                </a>
                <a href="view_employees.jsp"
                    class="flex items-center gap-3 py-2.5 px-4 rounded-xl hover:bg-slate-700 transition font-semibold text-sm">
                    <span>👥</span> Manage Staff
                </a>
                <a href="view_customers.jsp"
                    class="flex items-center gap-3 py-2.5 px-4 rounded-xl hover:bg-slate-700 transition font-semibold text-sm">
                    <span>🏪</span> Manage Customers
                </a>

                <!-- Profile -->
                <p class="text-xs text-slate-500 uppercase font-bold px-3 pt-4 pb-1">Account</p>
                <a href="profile.jsp"
                    class="flex items-center gap-3 py-2.5 px-4 rounded-xl hover:bg-slate-700 transition font-semibold text-sm">
                    <span>👤</span> My Profile
                </a>

            </nav>
        </div>
        <div class="mb-5 px-4 pb-2">
            <a href="../logout.jsp"
                class="block py-3 px-4 bg-red-600 rounded-xl hover:bg-red-700 transition text-center font-bold text-sm">
                🚪 Logout
            </a>
        </div>
    </div>