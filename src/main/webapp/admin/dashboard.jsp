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

					<% int tCust=0, tEmp=0, tOrd=0; try (java.sql.Connection
						conn=com.coolstack.util.DBConnection.getConnection(); java.sql.Statement
						stmt=conn.createStatement()) { java.sql.ResultSet
						rs=stmt.executeQuery( "SELECT COUNT(*) FROM users WHERE role = 'customer'" ); if(rs.next())
						tCust=rs.getInt(1);
						rs=stmt.executeQuery( "SELECT COUNT(*) FROM users WHERE role IN ('manager', 'cashier', 'delivery')"
						); if(rs.next()) tEmp=rs.getInt(1); rs=stmt.executeQuery( "SELECT COUNT(*) FROM orders" );
						if(rs.next()) tOrd=rs.getInt(1); } catch(Exception e) { e.printStackTrace(); } %>
						<!-- Stats Overview -->
						<div class="grid grid-cols-4 gap-6 mb-8">
							<div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
								<p class="text-gray-400 text-sm">Total Customers</p>
								<p class="text-3xl font-black text-slate-700 mt-2">
									<%= tCust %>
								</p>
								<p class="text-green-500 text-xs mt-1">↑ Direct DB Count</p>
							</div>
							<div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
								<p class="text-gray-400 text-sm">Total Employees</p>
								<p class="text-3xl font-black text-blue-600 mt-2">
									<%= tEmp %>
								</p>
								<p class="text-gray-400 text-xs mt-1">Manager · Delivery · Cashier</p>
							</div>
							<div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
								<p class="text-gray-400 text-sm">Orders Recorded</p>
								<p class="text-3xl font-black text-purple-600 mt-2">
									<%= tOrd %>
								</p>
								<p class="text-green-500 text-xs mt-1">↑ Live from database</p>
							</div>
							<div class="bg-white p-6 rounded-2xl shadow hover:scale-105 transition">
								<p class="text-gray-400 text-sm">Pending Join Requests</p>
								<p class="text-3xl font-black text-orange-500 mt-2" id="pendingCount">0</p>
								<p class="text-green-500 text-xs mt-1">All processed</p>
							</div>
						</div>

						<!-- Join Requests Section -->
						<div class="bg-white rounded-2xl shadow-lg overflow-hidden mb-8">
							<div class="flex justify-between items-center p-6 border-b bg-orange-50">
								<div>
									<h2 class="text-xl font-bold text-gray-800">📋 New Join Requests</h2>
									<p class="text-gray-400 text-sm mt-0.5">Review applicants and approve to add them to
										the
										system</p>
								</div>
								<span class="bg-gray-500 text-white text-sm font-bold px-4 py-1.5 rounded-full"
									id="badgeCount">0 Pending</span>
							</div>
							<div class="p-6 space-y-4 hidden" id="requestsList">
							</div>
							<div id="noRequests" class="p-10 text-center text-gray-400">
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
									<% try (java.sql.Connection conn=com.coolstack.util.DBConnection.getConnection();
										java.sql.Statement stmt=conn.createStatement()) { java.sql.ResultSet
										rs=stmt.executeQuery( "SELECT name, username, 'Manager' as role, '📊' as icon FROM managers "
										+ "UNION SELECT name, username, 'Delivery' as role, '🛵' as icon FROM delivery_boys "
										+ "UNION SELECT name, username, 'Cashier' as role, '💳' as icon FROM cashiers LIMIT 5"
										); while(rs.next()) { %>
										<tr class="border-b hover:bg-gray-50">
											<td class="py-3 px-6 font-semibold">
												<%= rs.getString("name") %>
											</td>
											<td class="px-6">
												<%= rs.getString("icon") %>
													<%= rs.getString("role") %>
											</td>
											<td class="px-6 text-gray-400">
												<%= rs.getString("username") %>
											</td>
											<td class="px-6"><span
													class="bg-green-100 text-green-700 px-2 py-0.5 rounded-full text-xs">Active</span>
											</td>
										</tr>
										<% } } catch(Exception e) { e.printStackTrace(); } %>
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