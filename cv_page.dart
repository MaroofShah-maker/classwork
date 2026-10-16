import 'package:flutter/material.dart';

import 'menu_page.dart';

class CVPage extends StatefulWidget {
  const CVPage({super.key});

  @override
  State<CVPage> createState() => _CVPageState();
}

class _CVPageState extends State<CVPage> {
  // Controls the animated ring around the profile picture
  double _ringSize = 130;
  bool _isExpanded = false;

  void _toggleProfile() {
    setState(() {
      _isExpanded = !_isExpanded;
      _ringSize = _isExpanded ? 170 : 130;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maroof Shah — CV'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.restaurant_menu),
            tooltip: 'Open Menu',
            onPressed: () {
              // Animated route transition into MenuPage
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 700),
                  pageBuilder: (_, anim, __) => const MenuPage(),
                  transitionsBuilder: (_, anim, __, child) {
                    final curved = CurvedAnimation(
                      parent: anim,
                      curve: Curves.easeInOutCubic,
                    );
                    return FadeTransition(
                      opacity: curved,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.15, 0),
                          end: Offset.zero,
                        ).animate(curved),
                        child: child,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ---------- HEADER with animated picture ----------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: Colors.indigo.shade50,
              child: Column(
                children: [
                  // ---- Animated tappable avatar ----
                  GestureDetector(
                    onTap: _toggleProfile,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeInOutBack,
                      width: _ringSize,
                      height: _ringSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: _isExpanded
                              ? [Colors.indigo, Colors.purple]
                              : [Colors.indigo.shade200, Colors.indigo],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.indigo.withOpacity(
                              _isExpanded ? 0.5 : 0.2,
                            ),
                            blurRadius: _isExpanded ? 25 : 10,
                            spreadRadius: _isExpanded ? 4 : 1,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(5),
                      child: const CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage('assets/profile.jpg'),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ---- Animated name (CrossFade between bold & glow) ----
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 500),
                    style: TextStyle(
                      fontSize: _isExpanded ? 30 : 26,
                      fontWeight: FontWeight.bold,
                      color: _isExpanded ? Colors.purple : Colors.indigo,
                    ),
                    child: const Text('Maroof Shah'),
                  ),

                  const SizedBox(height: 4),
                  const Text(
                    'BS Software Engineering Student',
                    style: TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                  const SizedBox(height: 10),

                  // ---- Contact row with fade animation ----
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: _isExpanded ? 1.0 : 0.85,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.phone, size: 16, color: Colors.indigo),
                        SizedBox(width: 5),
                        Text('+92-301-8352047', style: TextStyle(fontSize: 13)),
                        SizedBox(width: 15),
                        Icon(Icons.email, size: 16, color: Colors.indigo),
                        SizedBox(width: 5),
                        Text(
                          'maroof.ouch@gmail.com',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),
                  // ---- Hint text with AnimatedCrossFade ----
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 400),
                    crossFadeState: _isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: const Text(
                      'Tap the picture to expand',
                      style: TextStyle(fontSize: 11, color: Colors.black38),
                    ),
                    secondChild: const Text(
                      'Tap again to shrink',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ---------- CONTACT ----------
            _section('Contact', [
              _tile(Icons.location_on, 'Islamabad I-14/3, Pakistan'),
              _tile(Icons.phone, '+92-301-8352047'),
              _tile(Icons.email, 'maroof.ouch@gmail.com'),
            ]),

            // ---------- CAREER OBJECTIVE ----------
            _section('Career Objective', [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Text(
                  '"Motivated BS Software Engineering student seeking an internship opportunity to apply programming, web development, and database skills in a practical environment. Eager to learn, contribute, and grow as a software developer."',
                  style: TextStyle(fontSize: 14, height: 1.5),
                ),
              ),
            ]),

            // ---------- EDUCATION ----------
            _section('Education', [
              _tile(
                Icons.school,
                'BS Software Engineering — Riphah International University, Islamabad',
              ),
              _tile(Icons.timelapse, 'Currently in 5th Semester'),
              _tile(Icons.grade, 'CGPA: 3.00 / 4.00'),
              _tile(
                Icons.school,
                'DIT (Diploma in Information Technology) — TBA Computer Institute, Ouch',
              ),
              _tile(Icons.grade, 'Marks: 729 / 1000'),
            ]),

            // ---------- TECHNICAL SKILLS ----------
            _section('Technical Skills', [
              _tile(Icons.code, 'Programming: C++, C#'),
              _tile(Icons.web, 'Web: HTML, CSS, JavaScript, PHP'),
              _tile(Icons.storage, 'Databases: SQL Server, MySQL'),
              _tile(
                Icons.build,
                'Tools: Visual Studio, VS Code, Microsoft Office',
              ),
              _tile(
                Icons.merge_type,
                'Concepts: OOP, Database Design, CRUD, Web Development, Software Development',
              ),
              _tile(Icons.auto_graph, 'SDLC Models: Agile, Waterfall, RAD'),
            ]),

            // ---------- PERSONAL SKILLS ----------
            _section('Personal Skills', [
              _tile(Icons.psychology, 'Good Analytical Skills'),
              _tile(Icons.record_voice_over, 'Communication Skills'),
              _tile(
                Icons.translate,
                'Language Proficiency: Pashto, Urdu, English',
              ),
            ]),

            // ---------- ACADEMIC PROJECTS ----------
            _section('Academic Projects', [
              _tile(
                Icons.directions_car,
                'Car Showroom Management System (Web)\n'
                'HTML, CSS, PHP, MySQL — managed car inventory, customer records, and sales operations with add/update/view modules.',
              ),
              _tile(
                Icons.library_books,
                'Library Management System (C++)\n'
                'Console app using arrays, linked lists, AVL trees, queues, stacks, and heaps. Features: Add, Issue, Return, Search, Display, Sort by ID, Remove, Undo, Recently Issued.',
              ),
              _tile(
                Icons.home_work,
                'Hostel Management System (C# + SQL Server)\n'
                'Windows Forms desktop app with Student/Room/Payment management and automatic due calculation, integrated with SQL Server.',
              ),
            ]),

            // ---------- REFERENCE ----------
            _section('Reference', [
              _tile(
                Icons.person,
                'Sadaqat Ali — Assistant Professor, Department of Computer Science',
              ),
              _tile(
                Icons.account_balance,
                'Faculty of Computing, Riphah International University, Islamabad',
              ),
              _tile(Icons.email, 'Sadaqat.ali@riphah.edu.pk'),
            ]),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ---------- reusable helpers ----------
  Widget _section(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          const Divider(thickness: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _tile(IconData icon, String text) {
    return ListTile(
      leading: Icon(icon, color: Colors.indigo),
      title: Text(text, style: const TextStyle(fontSize: 14, height: 1.3)),
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}
