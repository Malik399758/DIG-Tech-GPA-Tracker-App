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

    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1F3A),

      body: SafeArea(
        child: Column(
          children: [

            SizedBox(height: height * 0.025),

            // HEADER
            Text(
              "GradeFlow",
              style: TextStyle(
                fontSize: width * 0.065,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),

            SizedBox(height: height * 0.005),

            Text(
              "Your Academic Intelligence App",
              style: TextStyle(
                fontSize: width * 0.032,
                color: Colors.white70,
              ),
            ),

            SizedBox(height: height * 0.025),

            // PAGEVIEW
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
                        padding: EdgeInsets.all(width * 0.05),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF132A4A),
                                Color(0xFF0F223D),
                              ],
                            ),
                            borderRadius:
                            BorderRadius.circular(width * 0.06),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.30),
                                blurRadius: width * 0.05,
                                offset: Offset(0, height * 0.01),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              // ICON
                              AnimatedContainer(
                                duration:
                                const Duration(milliseconds: 500),
                                height: width * 0.40,
                                width: width * 0.40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(.10),
                                ),
                                child: Icon(
                                  page["icon"] as IconData,
                                  size: width * 0.20,
                                  color: const Color(0xFF14B8A6),
                                ),
                              ),

                              SizedBox(height: height * 0.04),

                              // TITLE
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.06),
                                child: Text(
                                  page["title"].toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: width * 0.060,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                              SizedBox(height: height * 0.015),

                              // DESCRIPTION
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.08),
                                child: Text(
                                  page["desc"].toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: width * 0.036,
                                    height: 1.6,
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

            // INDICATOR
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                    (i) {
                  final isActive = index == i;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(
                      horizontal: width * 0.01,
                    ),
                    height: height * 0.010,
                    width: isActive
                        ? width * 0.065
                        : width * 0.020,
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFF14B8A6)
                          : Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: height * 0.03),

            // BUTTON
            Padding(
              padding: EdgeInsets.all(width * 0.04),
              child: SizedBox(
                width: double.infinity,
                height: height * 0.065,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF14B8A6),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(width * 0.035),
                    ),
                  ),
                  onPressed: () async {
                    final prefs =
                    await SharedPreferences.getInstance();

                    final appPrefs = AppPrefs(prefs);

                    if (index == pages.length - 1) {
                      await appPrefs.setOnboardingDone();

                      final isProfileDone =
                          appPrefs.isProfileDone;

                      Navigator.pushReplacementNamed(
                        context,
                        isProfileDone
                            ? AppRoutes.dashboard
                            : "/profile",
                      );
                    } else {
                      controller.nextPage(
                        duration:
                        const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(
                    index == pages.length - 1
                        ? "Get Started"
                        : "Next",
                    style: TextStyle(
                      fontSize: width * 0.040,
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