<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="CoolStock Ice Cream – Your favourite ice cream shop with online ordering, fast delivery, and a modern POS experience. Explore our menu or join our team today!">
    <title>CoolStock Ice Cream | Sweet Every Scoop</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Outfit', sans-serif; }

        /* Hero gradient animation */
        @keyframes gradientShift {
            0%   { background-position: 0% 50%; }
            50%  { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        .hero-bg {
            background: linear-gradient(270deg, #7c3aed, #ec4899, #f97316, #ec4899, #7c3aed);
            background-size: 300% 300%;
            animation: gradientShift 10s ease infinite;
        }

        /* Floating ice cream animation */
        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(-5deg); }
            50%       { transform: translateY(-18px) rotate(5deg); }
        }
        .float-anim { animation: float 4s ease-in-out infinite; }

        /* Scroll reveal fade-in */
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        .fade-in-up { animation: fadeInUp 0.7s ease forwards; }

        /* Card hover glow */
        .card-hover { transition: transform 0.3s ease, box-shadow 0.3s ease; }
        .card-hover:hover {
            transform: translateY(-6px);
            box-shadow: 0 20px 40px rgba(124,58,237,0.25);
        }

        /* Glassmorphism */
        .glass {
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255,255,255,0.25);
        }

        /* Modal overlay */
        #applyModal { display: none; }
        #applyModal.active { display: flex; }

        /* Custom scrollbar */
        ::-webkit-scrollbar { width: 8px; }
        ::-webkit-scrollbar-track { background: #f1f5f9; }
        ::-webkit-scrollbar-thumb { background: #a78bfa; border-radius: 4px; }
    </style>
</head>
<body class="bg-gray-50 text-gray-800">

    <!-- ===================== NAVBAR ===================== -->
    <nav class="fixed top-0 left-0 right-0 z-50 glass bg-white/80 shadow-sm">
        <div class="max-w-7xl mx-auto px-6 py-3 flex items-center justify-between">
            <!-- Logo -->
            <div class="flex items-center gap-2">
                <span class="text-3xl">🍦</span>
                <span class="text-xl font-800 font-bold bg-gradient-to-r from-purple-600 to-pink-500 bg-clip-text text-transparent">CoolStock</span>
            </div>
            <!-- Nav Links -->
            <div class="hidden md:flex items-center gap-8">
                <a href="#about" class="text-gray-600 hover:text-purple-600 font-medium transition-colors duration-200">About</a>
                <a href="#features" class="text-gray-600 hover:text-purple-600 font-medium transition-colors duration-200">Features</a>
                <a href="#careers" class="text-gray-600 hover:text-purple-600 font-medium transition-colors duration-200">Careers</a>
            </div>
            <!-- CTA Buttons -->
            <div class="flex items-center gap-3">
                <a href="login.jsp" id="nav-staff-login" class="px-4 py-2 rounded-xl border-2 border-purple-500 text-purple-600 font-semibold hover:bg-purple-50 transition-all duration-200">
                    Staff Login
                </a>
                <a href="menu.jsp" id="nav-order-now" class="px-4 py-2 rounded-xl bg-gradient-to-r from-purple-600 to-pink-500 text-white font-semibold hover:opacity-90 hover:scale-105 transition-all duration-200 shadow-lg">
                    Order Now ✨
                </a>
            </div>
        </div>
    </nav>

    <!-- ===================== HERO SECTION ===================== -->
    <section class="hero-bg min-h-screen flex items-center justify-center text-white text-center px-6 pt-20">
        <div class="max-w-4xl mx-auto fade-in-up">
            <!-- Floating Emoji -->
            <div class="float-anim text-8xl mb-6 select-none">🍦</div>
            <h1 class="text-5xl md:text-7xl font-black mb-5 leading-tight">
                Welcome to<br>
                <span class="text-yellow-300">CoolStock</span> Ice Cream
            </h1>
            <p class="text-xl md:text-2xl font-light mb-10 text-white/90 max-w-2xl mx-auto">
                Experience the sweetest scoops in town — delivered fresh to your door or pick it up at our store. Every bite, a new adventure! 🎉
            </p>
            <!-- CTA Buttons -->
            <div class="flex flex-col sm:flex-row gap-4 justify-center">
                <a href="menu.jsp" id="hero-order-now"
                   class="px-8 py-4 bg-yellow-400 text-gray-900 font-bold text-lg rounded-2xl hover:bg-yellow-300 hover:scale-105 transition-all duration-300 shadow-2xl">
                    🛒 Order Now
                </a>
                <a href="login.jsp" id="hero-staff-login"
                   class="px-8 py-4 glass text-white font-bold text-lg rounded-2xl hover:bg-white/20 hover:scale-105 transition-all duration-300">
                    🔐 Staff Login
                </a>
                <a href="#careers" id="hero-join-us"
                   class="px-8 py-4 bg-white/20 text-white font-bold text-lg rounded-2xl hover:bg-white/30 hover:scale-105 transition-all duration-300">
                    💼 Join Our Team
                </a>
            </div>
            <!-- Scroll hint -->
            <div class="mt-16 animate-bounce text-white/70 text-sm">
                <p>↓ Scroll to explore</p>
            </div>
        </div>
    </section>

    <!-- ===================== ABOUT SECTION ===================== -->
    <section id="about" class="py-24 px-6 bg-white">
        <div class="max-w-6xl mx-auto text-center">
            <span class="inline-block bg-purple-100 text-purple-700 text-sm font-semibold px-4 py-1 rounded-full mb-4">✨ About Us</span>
            <h2 class="text-4xl md:text-5xl font-black text-gray-900 mb-6">More Than Just Ice Cream</h2>
            <p class="text-lg text-gray-500 max-w-3xl mx-auto mb-16">
                CoolStock is a modern Ice Cream shop powered by a cutting-edge Point-of-Sale (POS) system. We combine a love for creamy, handcrafted flavours with the convenience of technology — so you can order online, track your delivery, and earn loyalty points, all in one place.
            </p>

            <!-- Info Cards -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                <div class="card-hover bg-gradient-to-br from-purple-50 to-indigo-100 rounded-3xl p-8 text-left">
                    <div class="text-5xl mb-4">🌍</div>
                    <h3 class="text-xl font-bold text-gray-800 mb-2">Online Ordering</h3>
                    <p class="text-gray-500">Browse our full menu from anywhere, add to cart, and have your favourite scoops delivered straight to your door.</p>
                </div>
                <div class="card-hover bg-gradient-to-br from-pink-50 to-rose-100 rounded-3xl p-8 text-left">
                    <div class="text-5xl mb-4">🚀</div>
                    <h3 class="text-xl font-bold text-gray-800 mb-2">Fast Delivery</h3>
                    <p class="text-gray-500">Our dedicated delivery team ensures your order arrives fresh and on time — every single time.</p>
                </div>
                <div class="card-hover bg-gradient-to-br from-orange-50 to-yellow-100 rounded-3xl p-8 text-left">
                    <div class="text-5xl mb-4">🖥️</div>
                    <h3 class="text-xl font-bold text-gray-800 mb-2">Modern POS System</h3>
                    <p class="text-gray-500">Our in-store technology streamlines operations for cashiers, managers, and admins — making every transaction seamless.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- ===================== FEATURES SECTION ===================== -->
    <section id="features" class="py-24 px-6 bg-gray-50">
        <div class="max-w-6xl mx-auto text-center">
            <span class="inline-block bg-pink-100 text-pink-700 text-sm font-semibold px-4 py-1 rounded-full mb-4">🍨 Our Platform</span>
            <h2 class="text-4xl md:text-5xl font-black text-gray-900 mb-6">Built for Everyone</h2>
            <p class="text-lg text-gray-500 max-w-2xl mx-auto mb-16">Our system serves multiple roles, each with a tailored experience.</p>

            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">

                <!-- Admin -->
                <div class="card-hover bg-white rounded-3xl p-7 shadow-md text-left border border-blue-100">
                    <div class="w-12 h-12 bg-blue-100 rounded-2xl flex items-center justify-center text-2xl mb-4">⚙️</div>
                    <h3 class="text-lg font-bold text-gray-800 mb-1">Administrator</h3>
                    <p class="text-gray-500 text-sm">Full system control — manage employees, products, orders, and analytics from a powerful central dashboard.</p>
                </div>

                <!-- Employee -->
                <div class="card-hover bg-white rounded-3xl p-7 shadow-md text-left border border-green-100">
                    <div class="w-12 h-12 bg-green-100 rounded-2xl flex items-center justify-center text-2xl mb-4">👨‍🍳</div>
                    <h3 class="text-lg font-bold text-gray-800 mb-1">Employee</h3>
                    <p class="text-gray-500 text-sm">Create and manage daily orders, preview bills, and track active transactions efficiently.</p>
                </div>

                <!-- Manager -->
                <div class="card-hover bg-white rounded-3xl p-7 shadow-md text-left border border-indigo-100">
                    <div class="w-12 h-12 bg-indigo-100 rounded-2xl flex items-center justify-center text-2xl mb-4">📊</div>
                    <h3 class="text-lg font-bold text-gray-800 mb-1">Manager</h3>
                    <p class="text-gray-500 text-sm">Monitor store performance, manage staff schedules, handle inventory, and oversee supplier relations.</p>
                </div>

                <!-- Cashier -->
                <div class="card-hover bg-white rounded-3xl p-7 shadow-md text-left border border-yellow-100">
                    <div class="w-12 h-12 bg-yellow-100 rounded-2xl flex items-center justify-center text-2xl mb-4">💳</div>
                    <h3 class="text-lg font-bold text-gray-800 mb-1">Cashier / POS</h3>
                    <p class="text-gray-500 text-sm">A lightning-fast, touch-friendly checkout interface with real-time cart calculations and receipt generation.</p>
                </div>

                <!-- Delivery -->
                <div class="card-hover bg-white rounded-3xl p-7 shadow-md text-left border border-orange-100">
                    <div class="w-12 h-12 bg-orange-100 rounded-2xl flex items-center justify-center text-2xl mb-4">🛵</div>
                    <h3 class="text-lg font-bold text-gray-800 mb-1">Delivery</h3>
                    <p class="text-gray-500 text-sm">View assigned orders, update delivery status in real-time, and navigate to customer locations seamlessly.</p>
                </div>

                <!-- Customer -->
                <div class="card-hover bg-white rounded-3xl p-7 shadow-md text-left border border-rose-100">
                    <div class="w-12 h-12 bg-rose-100 rounded-2xl flex items-center justify-center text-2xl mb-4">🧑‍💻</div>
                    <h3 class="text-lg font-bold text-gray-800 mb-1">Customer</h3>
                    <p class="text-gray-500 text-sm">Browse the menu, manage your cart, place orders, track deliveries, and earn loyalty points — all online.</p>
                </div>

            </div>
        </div>
    </section>

    <!-- ===================== CAREERS SECTION ===================== -->
    <section id="careers" class="py-24 px-6 bg-white">
        <div class="max-w-4xl mx-auto text-center">
            <span class="inline-block bg-orange-100 text-orange-700 text-sm font-semibold px-4 py-1 rounded-full mb-4">💼 Careers</span>
            <h2 class="text-4xl md:text-5xl font-black text-gray-900 mb-4">Join Our Sweet Team</h2>
            <p class="text-lg text-gray-500 max-w-2xl mx-auto mb-12">
                We're always looking for passionate and dedicated people to be a part of the CoolStock family. Apply for the role that suits you best!
            </p>

            <!-- Open Roles -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-12">
                <div class="card-hover bg-gradient-to-br from-indigo-50 to-purple-50 rounded-3xl p-7 border border-indigo-100 text-left cursor-pointer" onclick="openApply('Manager')">
                    <div class="text-4xl mb-3">📊</div>
                    <h3 class="text-lg font-bold text-gray-800 mb-1">Manager</h3>
                    <p class="text-gray-500 text-sm mb-4">Lead the team, oversee daily operations, and drive store performance.</p>
                    <span class="inline-block bg-indigo-100 text-indigo-700 text-xs font-semibold px-3 py-1 rounded-full">Apply →</span>
                </div>
                <div class="card-hover bg-gradient-to-br from-yellow-50 to-orange-50 rounded-3xl p-7 border border-yellow-100 text-left cursor-pointer" onclick="openApply('Cashier / POS Operator')">
                    <div class="text-4xl mb-3">💳</div>
                    <h3 class="text-lg font-bold text-gray-800 mb-1">Cashier / POS Operator</h3>
                    <p class="text-gray-500 text-sm mb-4">Handle in-store transactions and deliver a great checkout experience.</p>
                    <span class="inline-block bg-yellow-100 text-yellow-700 text-xs font-semibold px-3 py-1 rounded-full">Apply →</span>
                </div>
                <div class="card-hover bg-gradient-to-br from-orange-50 to-red-50 rounded-3xl p-7 border border-orange-100 text-left cursor-pointer" onclick="openApply('Delivery Person')">
                    <div class="text-4xl mb-3">🛵</div>
                    <h3 class="text-lg font-bold text-gray-800 mb-1">Delivery Person</h3>
                    <p class="text-gray-500 text-sm mb-4">Deliver our iconic scoops fresh and on time to happy customers.</p>
                    <span class="inline-block bg-orange-100 text-orange-700 text-xs font-semibold px-3 py-1 rounded-full">Apply →</span>
                </div>
            </div>

            <button id="open-apply-btn" onclick="openApply('')"
                class="px-8 py-4 bg-gradient-to-r from-purple-600 to-pink-500 text-white font-bold text-lg rounded-2xl hover:opacity-90 hover:scale-105 transition-all duration-300 shadow-xl">
                📝 Apply for a Job
            </button>
        </div>
    </section>

    <!-- ===================== APPLY MODAL ===================== -->
    <div id="applyModal" class="fixed inset-0 z-50 items-center justify-center bg-black/60 backdrop-blur-sm px-4">
        <div class="bg-white rounded-3xl shadow-2xl w-full max-w-lg p-8 relative overflow-y-auto max-h-[90vh]">
            <!-- Close Button -->
            <button onclick="closeApply()" class="absolute top-4 right-5 text-gray-400 hover:text-gray-700 text-2xl font-bold">&times;</button>

            <div class="text-center mb-6">
                <div class="text-5xl mb-3">🍦</div>
                <h2 class="text-3xl font-black text-gray-800">Apply for a Job</h2>
                <p class="text-gray-500 mt-1">Fill in your details and we'll get back to you!</p>
            </div>

            <form id="applyForm" action="#" method="post" onsubmit="handleFormSubmit(event)" class="space-y-5">

                <!-- Full Name -->
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-1" for="applicant-name">Full Name</label>
                    <input type="text" id="applicant-name" name="full_name" required placeholder="e.g., Rutvik Shiyal"
                        class="w-full border-2 border-gray-200 rounded-xl px-4 py-3 focus:outline-none focus:border-purple-500 transition-colors duration-200">
                </div>

                <!-- Email -->
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-1" for="applicant-email">Email Address</label>
                    <input type="email" id="applicant-email" name="email" required placeholder="you@example.com"
                        class="w-full border-2 border-gray-200 rounded-xl px-4 py-3 focus:outline-none focus:border-purple-500 transition-colors duration-200">
                </div>

                <!-- Phone Number -->
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-1" for="applicant-phone">Phone Number</label>
                    <input type="tel" id="applicant-phone" name="phone" required placeholder="+91 98765 43210"
                        class="w-full border-2 border-gray-200 rounded-xl px-4 py-3 focus:outline-none focus:border-purple-500 transition-colors duration-200">
                </div>

                <!-- Role Selection -->
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2" for="applicant-role">Applying For</label>
                    <select id="applicant-role" name="role" required
                        class="w-full border-2 border-gray-200 rounded-xl px-4 py-3 focus:outline-none focus:border-purple-500 transition-colors duration-200 bg-white">
                        <option value="" disabled selected>-- Select a Role --</option>
                        <option value="Manager">📊 Manager</option>
                        <option value="Cashier / POS Operator">💳 Cashier / POS Operator</option>
                        <option value="Delivery Person">🛵 Delivery Person</option>
                    </select>
                </div>

                <!-- Cover Letter -->
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-1" for="applicant-cover">Why do you want to join us?</label>
                    <textarea id="applicant-cover" name="cover_letter" rows="4" placeholder="Tell us a bit about your experience and why you'd like to join CoolStock..."
                        class="w-full border-2 border-gray-200 rounded-xl px-4 py-3 focus:outline-none focus:border-purple-500 transition-colors duration-200 resize-none"></textarea>
                </div>

                <!-- Submit -->
                <button type="submit" id="submit-application-btn"
                    class="w-full py-4 bg-gradient-to-r from-purple-600 to-pink-500 text-white font-bold text-lg rounded-2xl hover:opacity-90 hover:scale-[1.02] transition-all duration-300 shadow-lg">
                    🚀 Submit Application
                </button>
            </form>
        </div>
    </div>

    <!-- ===================== FOOTER ===================== -->
    <footer class="bg-gray-900 text-white py-14 px-6">
        <div class="max-w-6xl mx-auto grid grid-cols-1 md:grid-cols-3 gap-10">

            <!-- Brand -->
            <div>
                <div class="flex items-center gap-2 mb-4">
                    <span class="text-3xl">🍦</span>
                    <span class="text-xl font-bold text-white">CoolStock</span>
                </div>
                <p class="text-gray-400 text-sm leading-relaxed">Your favourite ice cream shop, powered by technology. Sweet every scoop.</p>
            </div>

            <!-- Quick Links -->
            <div>
                <h4 class="font-bold text-white mb-4">Quick Links</h4>
                <ul class="space-y-2 text-gray-400 text-sm">
                    <li><a href="#about" class="hover:text-purple-400 transition-colors">About Us</a></li>
                    <li><a href="#features" class="hover:text-purple-400 transition-colors">Features</a></li>
                    <li><a href="#careers" class="hover:text-purple-400 transition-colors">Careers</a></li>
                    <li><a href="login.jsp" class="hover:text-purple-400 transition-colors">Staff Login</a></li>
                </ul>
            </div>

            <!-- Contact -->
            <div>
                <h4 class="font-bold text-white mb-4">Contact Us</h4>
                <ul class="space-y-2 text-gray-400 text-sm">
                    <li>📍 123 Scoop Street, Flavour City</li>
                    <li>📞 +91 98765 43210</li>
                    <li>📧 hello@coolstack.com</li>
                    <li>🕐 Mon–Sun: 10:00 AM – 10:00 PM</li>
                </ul>
            </div>
        </div>

        <div class="max-w-6xl mx-auto mt-10 pt-6 border-t border-gray-700 flex flex-col sm:flex-row items-center justify-between text-gray-500 text-sm">
            <p>© 2026 CoolStock Ice Cream. All rights reserved.</p>
            <p class="mt-2 sm:mt-0">Made with ❤️ by Team CoolStock</p>
        </div>
    </footer>

    <!-- ===================== SCRIPTS ===================== -->
    <script>
        // Open modal and pre-select role if provided
        function openApply(role) {
            document.getElementById('applyModal').classList.add('active');
            if (role) {
                const select = document.getElementById('applicant-role');
                for (let opt of select.options) {
                    if (opt.value === role) { opt.selected = true; break; }
                }
            }
            document.body.style.overflow = 'hidden';
        }

        // Close modal
        function closeApply() {
            document.getElementById('applyModal').classList.remove('active');
            document.body.style.overflow = '';
        }

        // Close modal by clicking outside
        document.getElementById('applyModal').addEventListener('click', function(e) {
            if (e.target === this) closeApply();
        });

        // Form submission handler (placeholder — no backend yet)
        function handleFormSubmit(e) {
            e.preventDefault();
            const name   = document.getElementById('applicant-name').value;
            const role   = document.getElementById('applicant-role').value;
            const btn    = document.getElementById('submit-application-btn');
            btn.textContent = '✅ Application Submitted!';
            btn.disabled = true;
            btn.classList.remove('from-purple-600','to-pink-500');
            btn.classList.add('from-green-500','to-emerald-400');
            setTimeout(() => {
                closeApply();
                document.getElementById('applyForm').reset();
                btn.textContent = '🚀 Submit Application';
                btn.disabled = false;
                btn.classList.add('from-purple-600','to-pink-500');
                btn.classList.remove('from-green-500','to-emerald-400');
            }, 2500);
        }

        // Smooth scroll for anchor links
        document.querySelectorAll('a[href^="#"]').forEach(a => {
            a.addEventListener('click', function(e) {
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    e.preventDefault();
                    target.scrollIntoView({ behavior: 'smooth' });
                }
            });
        });
    </script>

</body>
</html>
