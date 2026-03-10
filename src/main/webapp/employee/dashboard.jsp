<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html>

	<head>
		<meta charset="UTF-8">
		<title>Employee Dashboard</title>

		<!-- Tailwind CSS CDN -->
		<script src="https://cdn.tailwindcss.com"></script>
		<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>




	</head>

	<body class="bg-gray-100">

		<div class="flex">


			<!-- Sidebar -->
			<%@ include file="sidebar.jsp" %>

				<!-- Main Content -->
				<div class="ml-64 p-8 w-full">

					<div
						class="bg-gradient-to-r from-blue-600 to-indigo-600 text-white p-8 rounded-2xl mb-8 flex justify-between items-center shadow-lg">
						<div>
							<h2 id="greetingText" class="text-2xl font-bold"></h2>
							<p class="opacity-90 mt-1">Manage your system efficiently 🚀</p>
						</div>

						<div class="text-right">
							<div id="currentDate" class="text-sm opacity-90"></div>
							<div id="liveClock" class="text-2xl font-bold mt-1"></div>
						</div>
					</div>



					<!-- Top Stats Cards -->
					<div class="grid grid-cols-4 gap-6 mb-8">

						<div
							class="bg-white p-6 rounded-2xl shadow hover:shadow-xl hover:scale-105 transition duration-300">
							<h2 class="text-gray-500">Today's Orders</h2>
							<p class="text-3xl font-bold text-blue-600 mt-2">12</p>
						</div>


						<div
							class="bg-white p-6 rounded-2xl shadow hover:shadow-xl hover:scale-105 transition duration-300">
							<h2 class="text-gray-500">Your Orders</h2>
							<p class="text-2xl font-bold text-green-600 mt-2">120</p>
						</div>

						<div
							class="bg-white p-6 rounded-2xl shadow hover:shadow-xl hover:scale-105 transition duration-300">
							<h2 class="text-gray-500">Total Products</h2>
							<p class="text-2xl font-bold text-purple-600 mt-2">50</p>
						</div>





					</div>

					<!-- Middle Section -->
					<div class="grid grid-cols-2 gap-6 mb-8">

						<!-- Recent Orders -->
						<div class="bg-white p-6 rounded-xl shadow-lg">
							<div class="flex justify-between items-center mb-4">
								<h2 class="text-xl font-semibold">Recent Orders</h2>
								<button
									class="bg-blue-600 text-white px-4 py-2 rounded-lg text-sm hover:bg-blue-700 transition">
									View All
								</button>
							</div>

							<div class="overflow-x-auto">
								<table class="w-full text-left border-collapse">
									<thead>
										<tr class="bg-gray-100 text-gray-600 uppercase text-sm">
											<th class="py-3 px-4">Order ID</th>
											<th class="px-4">Employee</th>
											<th class="px-4">Customer</th>
											<th class="px-4">City</th>
											<th class="px-4">Products</th>

										</tr>
									</thead>
									<tbody class="text-gray-700 text-sm">

										<tr class="border-b hover:bg-gray-50 transition">
											<td class="py-3 px-4 font-semibold">#101</td>
											<td class="px-4">Amit Sharma</td>
											<td class="px-4">Rahul Verma</td>
											<td class="px-4">Delhi</td>
											<td class="px-4">
												<ul class="list-disc pl-4">
													<li>Chocolate Cone</li>
													<li>Vanilla Cup</li>
												</ul>
											</td>

										</tr>

										<tr class="border-b hover:bg-gray-50 transition">
											<td class="py-3 px-4 font-semibold">#102</td>
											<td class="px-4">Neha Singh</td>
											<td class="px-4">Amit Kumar</td>
											<td class="px-4">Mumbai</td>
											<td class="px-4">
												<ul class="list-disc pl-4">
													<li>Strawberry Shake</li>
												</ul>
											</td>

										</tr>

										<tr class="hover:bg-gray-50 transition">
											<td class="py-3 px-4 font-semibold">#103</td>
											<td class="px-4">Rohit Das</td>
											<td class="px-4">Priya Patel</td>
											<td class="px-4">Pune</td>
											<td class="px-4">
												<ul class="list-disc pl-4">
													<li>Family Pack</li>
													<li>Chocolate Shake</li>
												</ul>
											</td>

										</tr>

									</tbody>
								</table>
							</div>
						</div>


						<!-- Low Stock -->
						<div class="bg-white p-6 rounded-lg shadow">
							<h2 class="text-xl font-semibold mb-4 text-red-600">Low Stock Alert</h2>
							<ul class="list-disc pl-5 space-y-2">
								<li>Chocolate Ice Cream (5 left)</li>
								<li>Vanilla Cone (3 left)</li>
								<li>Strawberry Cup (4 left)</li>
							</ul>
						</div>

					</div>

					<!-- Pie Chart Section -->
					<div class="grid grid-cols-2 gap-6 mt-8">

						<div class="bg-white p-6 rounded-2xl shadow">
							<h2 class="text-xl font-semibold mb-4">Product Distribution</h2>
							<div class="w-64 h-64 mx-auto">
								<canvas id="productChart"></canvas>
							</div>
						</div>


					</div>



				</div>

		</div>

	</body>
	<script>

		document.addEventListener("DOMContentLoaded", function () {

			// Greeting + Date + Clock
			function updateClock() {
				const now = new Date();

				const hours = now.getHours();
				const minutes = String(now.getMinutes()).padStart(2, '0');
				const seconds = String(now.getSeconds()).padStart(2, '0');

				const timeString =
					String(hours).padStart(2, '0') + ":" + minutes + ":" + seconds;

				document.getElementById("liveClock").innerText = timeString;
				document.getElementById("currentDate").innerText = now.toDateString();

				let greeting = "Welcome Yash 👋";
				if (hours < 12) greeting = "Good Morning Yash ☀️";
				else if (hours < 18) greeting = "Good Afternoon Yash 🌤️";
				else greeting = "Good Evening Yash 🌙";

				document.getElementById("greetingText").innerText = greeting;
			}

			updateClock();
			setInterval(updateClock, 1000);

			// Pie Chart
			new Chart(document.getElementById('productChart'), {
				type: 'doughnut',
				data: {
					labels: ['Cone', 'Cup', 'Family Pack', 'Shake'],
					datasets: [{
						data: [15, 20, 10, 5],
						backgroundColor: ['#3B82F6', '#10B981', '#F59E0B', '#EF4444'],
					}]
				},
				options: {
					maintainAspectRatio: false,
					plugins: { legend: { position: 'bottom' } }
				}
			});



		});
	</script>