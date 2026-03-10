<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <div class="w-64 h-screen bg-indigo-900 text-white fixed flex flex-col justify-between">
        <div>
            <div class="p-5 border-b border-indigo-700 flex items-center gap-3">
                <span class="text-2xl">📊</span>
                <div>
                    <h2 class="text-lg font-black">CoolStock</h2>
                    <p class="text-xs text-indigo-300">Manager Panel</p>
                </div>
            </div>
            <nav class="mt-4 space-y-1 px-3">
                <a href="dashboard.jsp"
                    class="flex items-center gap-3 py-2.5 px-4 rounded-xl hover:bg-indigo-700 transition font-semibold text-sm">
                    <span>🏠</span> Dashboard
                </a>
                <a href="profile.jsp"
                    class="flex items-center gap-3 py-2.5 px-4 rounded-xl hover:bg-indigo-700 transition font-semibold text-sm">
                    <span>👤</span> My Profile
                </a>
            </nav>
        </div>
        <div class="mb-5 px-4">
            <a href="../../logout.jsp"
                class="block py-3 px-4 bg-red-600 rounded-xl hover:bg-red-700 transition text-center font-bold text-sm">
                🚪 Logout
            </a>
        </div>
    </div>