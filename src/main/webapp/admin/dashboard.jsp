<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html>

	<head>
		<meta charset="UTF-8">
		<title>Admin Dashboard | CoolStock</title>
		<script src="https://cdn.tailwindcss.com"></script>
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

					<!-- Header -->
					<div
						class="bg-gradient-to-r from-slate-800 to-gray-700 text-white p-7 rounded-2xl mb-8 flex justify-between items-center shadow-lg">
						<div>
							<h1 class="text-3xl font-black">⚙️ Admin Control Panel</h1>
							<p class="opacity-80 mt-1">CoolStock — Ice Cream Wholesale System</p>
						</div>
						<div class="text-right">
							<div id="liveDate" class="text-sm opacity-70"></div>
							<div id="liveClock" class="text-2xl font-bold mt-1"></div>
						</div>
					</div>

					<!-- Stats Overview -->
					<div class="grid grid-cols-4 gap-6 mb-8">
						<div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
							<p class="text-gray-400 text-sm">Total Customers</p>
							<p class="text-3xl font-black text-slate-700 mt-2">24</p>
							<p class="text-green-500 text-xs mt-1">↑ 3 new this week</p>
						</div>
						<div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
							<p class="text-gray-400 text-sm">Total Employees</p>
							<p class="text-3xl font-black text-blue-600 mt-2">12</p>
							<p class="text-gray-400 text-xs mt-1">Manager · Delivery · Cashier</p>
						</div>
						<div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
							<p class="text-gray-400 text-sm">Orders This Month</p>
							<p class="text-3xl font-black text-purple-600 mt-2">138</p>
							<p class="text-green-500 text-xs mt-1">↑ 12% vs last month</p>
						</div>
						<div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
							<p class="text-gray-400 text-sm">Pending Join Requests</p>
							<p class="text-3xl font-black text-orange-500 mt-2" id="pendingCount">3</p>
							<p class="text-orange-400 text-xs mt-1">Awaiting approval</p>
						</div>
					</div>

					<!-- Join Requests Section -->
					<div class="bg-white rounded-2xl shadow-lg overflow-hidden mb-8">
						<div class="flex justify-between items-center p-6 border-b bg-orange-50">
							<div>
								<h2 class="text-xl font-bold text-gray-800">📋 New Join Requests</h2>
								<p class="text-gray-400 text-sm mt-0.5">Review applicants and approve to add them to the
									system</p>
							</div>
							<span class="bg-orange-500 text-white text-sm font-bold px-4 py-1.5 rounded-full"
								id="badgeCount">3 Pending</span>
						</div>
						<div class="p-6 space-y-4" id="requestsList">

							<!-- Request 1 -->
							<div class="border-2 border-gray-100 rounded-2xl p-5 hover:border-orange-200 transition"
								id="req-1">
								<div class="flex justify-between items-start">
									<div class="flex items-center gap-4">
										<div
											class="w-12 h-12 bg-orange-100 rounded-2xl flex items-center justify-center text-2xl">
											👤</div>
										<div>
											<p class="font-bold text-gray-800 text-lg">Rajesh Kumar</p>
											<p class="text-gray-500 text-sm">📞 +91 98765 43210 &nbsp;|&nbsp; 📧
												rajesh@example.com</p>
											<p class="text-gray-400 text-xs mt-1">Applied for: <span
													class="font-semibold text-blue-600">Delivery Boy</span>
												&nbsp;|&nbsp; Applied on: 10 Mar 2026</p>
										</div>
									</div>
									<div class="flex gap-3">
										<button onclick="approveRequest('req-1', 'Rajesh Kumar')"
											class="bg-green-500 text-white px-5 py-2 rounded-xl font-semibold hover:bg-green-600 transition text-sm">
											✅ Approve
										</button>
										<button onclick="rejectRequest('req-1')"
											class="bg-red-100 text-red-600 px-5 py-2 rounded-xl font-semibold hover:bg-red-200 transition text-sm">
											❌ Reject
										</button>
									</div>
								</div>
								<div class="mt-3 ml-16 text-sm text-gray-500 bg-gray-50 rounded-xl p-3">
									<span class="font-semibold">Cover Note:</span> "I have 2 years of delivery
									experience in the food industry. Available for day shifts."
								</div>
							</div>

							<!-- Request 2 -->
							<div class="border-2 border-gray-100 rounded-2xl p-5 hover:border-orange-200 transition"
								id="req-2">
								<div class="flex justify-between items-start">
									<div class="flex items-center gap-4">
										<div
											class="w-12 h-12 bg-blue-100 rounded-2xl flex items-center justify-center text-2xl">
											👤</div>
										<div>
											<p class="font-bold text-gray-800 text-lg">Sunita Patel</p>
											<p class="text-gray-500 text-sm">📞 +91 87654 32109 &nbsp;|&nbsp; 📧
												sunita@example.com</p>
											<p class="text-gray-400 text-xs mt-1">Applied for: <span
													class="font-semibold text-purple-600">Cashier</span> &nbsp;|&nbsp;
												Applied on: 9 Mar 2026</p>
										</div>
									</div>
									<div class="flex gap-3">
										<button onclick="approveRequest('req-2', 'Sunita Patel')"
											class="bg-green-500 text-white px-5 py-2 rounded-xl font-semibold hover:bg-green-600 transition text-sm">
											✅ Approve
										</button>
										<button onclick="rejectRequest('req-2')"
											class="bg-red-100 text-red-600 px-5 py-2 rounded-xl font-semibold hover:bg-red-200 transition text-sm">
											❌ Reject
										</button>
									</div>
								</div>
								<div class="mt-3 ml-16 text-sm text-gray-500 bg-gray-50 rounded-xl p-3">
									<span class="font-semibold">Cover Note:</span> "Commerce graduate with tally and
									billing experience. Looking for full-time work."
								</div>
							</div>

							<!-- Request 3 -->
							<div class="border-2 border-gray-100 rounded-2xl p-5 hover:border-orange-200 transition"
								id="req-3">
								<div class="flex justify-between items-start">
									<div class="flex items-center gap-4">
										<div
											class="w-12 h-12 bg-green-100 rounded-2xl flex items-center justify-center text-2xl">
											👤</div>
										<div>
											<p class="font-bold text-gray-800 text-lg">Vikram Shah</p>
											<p class="text-gray-500 text-sm">📞 +91 76543 21098 &nbsp;|&nbsp; 📧
												vikram@example.com</p>
											<p class="text-gray-400 text-xs mt-1">Applied for: <span
													class="font-semibold text-indigo-600">Manager</span> &nbsp;|&nbsp;
												Applied on: 8 Mar 2026</p>
										</div>
									</div>
									<div class="flex gap-3">
										<button onclick="approveRequest('req-3', 'Vikram Shah')"
											class="bg-green-500 text-white px-5 py-2 rounded-xl font-semibold hover:bg-green-600 transition text-sm">
											✅ Approve
										</button>
										<button onclick="rejectRequest('req-3')"
											class="bg-red-100 text-red-600 px-5 py-2 rounded-xl font-semibold hover:bg-red-200 transition text-sm">
											❌ Reject
										</button>
									</div>
								</div>
								<div class="mt-3 ml-16 text-sm text-gray-500 bg-gray-50 rounded-xl p-3">
									<span class="font-semibold">Cover Note:</span> "5 years in wholesale distribution
									management. Can handle team coordination and order workflows."
								</div>
							</div>

						</div>
						<div id="noRequests" class="hidden p-10 text-center text-gray-400">
							<div class="text-5xl mb-3">✅</div>
							<p class="font-semibold">All join requests have been processed!</p>
						</div>
					</div>

					<!-- Current Staff List -->
					<div class="bg-white rounded-2xl shadow-lg overflow-hidden">
						<div class="p-6 border-b">
							<h2 class="text-xl font-bold text-gray-800">👥 Current Active Staff</h2>
						</div>
						<table class="w-full text-sm">
							<thead class="bg-gray-50 text-gray-500 uppercase text-xs">
								<tr>
									<th class="py-3 px-6 text-left">Name</th>
									<th class="px-6 text-left">Role</th>
									<th class="px-6 text-left">Username</th>
									<th class="px-6 text-left">Status</th>
								</tr>
							</thead>
							<tbody class="text-gray-700">
								<tr class="border-b hover:bg-gray-50">
									<td class="py-3 px-6 font-semibold">Amit Sharma</td>
									<td class="px-6">📊 Manager</td>
									<td class="px-6 text-gray-400">manager</td>
									<td class="px-6"><span
											class="bg-green-100 text-green-700 px-2 py-0.5 rounded-full text-xs">Active</span>
									</td>
								</tr>
								<tr class="border-b hover:bg-gray-50">
									<td class="py-3 px-6 font-semibold">Neha Singh</td>
									<td class="px-6">🛵 Delivery</td>
									<td class="px-6 text-gray-400">delivery</td>
									<td class="px-6"><span
											class="bg-green-100 text-green-700 px-2 py-0.5 rounded-full text-xs">Active</span>
									</td>
								</tr>
								<tr class="border-b hover:bg-gray-50">
									<td class="py-3 px-6 font-semibold">Priya Patel</td>
									<td class="px-6">💳 Cashier</td>
									<td class="px-6 text-gray-400">cashier</td>
									<td class="px-6"><span
											class="bg-green-100 text-green-700 px-2 py-0.5 rounded-full text-xs">Active</span>
									</td>
								</tr>
							</tbody>
						</table>
					</div>

				</div>
		</div>

		<!-- Toast -->
		<div id="toast"
			class="hidden fixed bottom-6 right-6 text-white px-6 py-3 rounded-2xl shadow-2xl font-semibold z-50 transition-all">
		</div>

		<script>
			function showToast(msg, color = 'bg-green-500') {
				const t = document.getElementById('toast');
				t.className = `fixed bottom-6 right-6 text-white px-6 py-3 rounded-2xl shadow-2xl font-semibold z-50 ${color}`;
				t.innerText = msg;
				setTimeout(() => t.className += ' hidden', 3000);
			}

			function approveRequest(id, name) {
				document.getElementById(id).style.display = 'none';
				updateCount(-1);
				showToast('✅ ' + name + ' has been approved and added to the system!', 'bg-green-500');
			}

			function rejectRequest(id) {
				document.getElementById(id).style.display = 'none';
				updateCount(-1);
				showToast('❌ Application rejected.', 'bg-red-500');
			}

			function updateCount(delta) {
				const el = document.getElementById('pendingCount');
				const badge = document.getElementById('badgeCount');
				let count = parseInt(el.innerText) + delta;
				el.innerText = count;
				badge.innerText = count + ' Pending';
				if (count <= 0) {
					document.getElementById('noRequests').classList.remove('hidden');
				}
			}

			// Clock
			setInterval(() => {
				const now = new Date();
				document.getElementById('liveClock').innerText =
					String(now.getHours()).padStart(2, '0') + ':' +
					String(now.getMinutes()).padStart(2, '0') + ':' +
					String(now.getSeconds()).padStart(2, '0');
				document.getElementById('liveDate').innerText = now.toDateString();
			}, 1000);
		</script>
	</body>

	</html>