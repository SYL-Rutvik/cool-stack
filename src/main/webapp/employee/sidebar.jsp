<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <div class="h-screen w-64 bg-slate-800 text-white fixed flex flex-col justify-between">

        <!-- Top Section -->
        <div>
            <div class="p-5 text-center border-b border-slate-700">
                <h2 class="text-xl font-bold">Employee Panel</h2>
            </div>

            <nav class="mt-5">
                <a href="dashboard.jsp" class="block py-3 px-6 hover:bg-slate-700 transition duration-200">
                    Dashboard
                </a>
                <a href="order.jsp" class="block py-3 px-6 hover:bg-slate-700 transition duration-200">
                    Order
                </a>

                <a href="show_orders.jsp" class="block py-3 px-6 hover:bg-slate-700 transition duration-200">
                    Show Order
                </a>


            </nav>
        </div>

        <!-- Bottom Logout -->
        <div class="md-5">
            <a href="../logout.jsp"
                class="block py-3 px-6 bg-red-600 rounded hover:bg-red-700 transition duration-200 text-center">
                Logout
            </a>
        </div>

    </div>