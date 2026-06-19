import 'package:flutter/material.dart';
import 'package:grade_flow/cons/routes/app_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/storage/app_prefs.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController controller = PageController();
  int index = 0;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  final pages = [
    {
      "title": "Track Your SGPA Easily",
      "desc": "Calculate semester GPA instantly with smart automation.",
      "icon": Icons.calculate,
    },
    {
      "title": "Manage Full Transcript",
      "desc": "Keep all semesters organized in one clean academic record.",
      "icon": Icons.menu_book,
    },
    {
      "title": "Analyze Performance",
      "desc": "Visualize GPA trends and improve your academic results.",
      "icon": Icons.show_chart,
    },
  ];

  @override
  void initState() {
    super.initState();

    _animController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    _animController.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onPageChanged(int i) {
    setState(() => index = i);
    _animController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1F3A),

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // HEADER
            const Text(
              "GradeFlow",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),

            const Text(
              "Your Academic Intelligence App",
              style: TextStyle(
                fontSize: 13,
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 20),

            // PAGE VIEW
            Expanded(
              child: PageView.builder(
                controller: controller,
                onPageChanged: _onPageChanged,
                itemCount: pages.length,
                itemBuilder: (context, i) {
                  final page = pages[i];

                  return FadeTransition(
                    opacity: _fadeAnim,
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 400),
                      scale: index == i ? 1 : 0.95,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF132A4A),
                                Color(0xFF0F223D),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                height: size.width * 0.4,
                                width: size.width * 0.4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.1),
                                ),
                                child: Icon(
                                  page["icon"] as IconData,
                                  size: 90,
                                  color: const Color(0xFF14B8A6),
                                ),
                              ),

                              const SizedBox(height: 30),

                              Text(
                                page["title"].toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),

                              const SizedBox(height: 12),

                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 24),
                                child: Text(
                                  page["desc"].toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // INDICATOR (MODERN)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pages.length, (i) {
                final isActive = index == i;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: isActive ? 26 : 8,
                  decoration: BoxDecoration(
                    color:
                    isActive ? const Color(0xFF14B8A6) : Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }),
            ),

            const SizedBox(height: 25),

            // BUTTON
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF14B8A6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final appPrefs = AppPrefs(prefs);

                    if (index == pages.length - 1) {
                      await appPrefs.setOnboardingDone();

                      final isProfileDone = appPrefs.isProfileDone;

                      Navigator.pushReplacementNamed(
                        context,
                        isProfileDone ? AppRoutes.dashboard : "/profile",
                      );
                    } else {
                      controller.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(
                    index == pages.length - 1 ? "Get Started" : "Next",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}