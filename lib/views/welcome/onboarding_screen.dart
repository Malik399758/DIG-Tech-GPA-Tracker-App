import 'package:flutter/material.dart';
import 'package:grade_flow/cons/routes/app_route.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {

  final PageController controller = PageController();
  int index = 0;

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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF8FAFC),
              Color(0xFFEFF6FF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [

              const SizedBox(height: 20),

              // TOP TITLE
              const Text(
                "Welcome to GradeFlow",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A8A),
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Your Academic Performance Companion",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 20),

              // PAGE VIEW
              Expanded(
                child: PageView.builder(
                  controller: controller,
                  onPageChanged: (i) => setState(() => index = i),
                  itemCount: pages.length,
                  itemBuilder: (context, i) {

                    final page = pages[i];

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          // ICON CARD (Premium look)
                          Container(
                            height: size.width * 0.45,
                            width: size.width * 0.45,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Icon(
                              page["icon"] as IconData,
                              size: 90,
                              color: const Color(0xFF1E3A8A),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // TITLE CARD
                          Text(
                            page["title"].toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // DESCRIPTION CARD
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              page["desc"].toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // DOT INDICATOR (Premium)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(pages.length, (i) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: index == i ? 24 : 8,
                    decoration: BoxDecoration(
                      color: index == i
                          ? const Color(0xFF1E3A8A)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 20),

              // BUTTON (Premium style)
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      elevation: 6,
                      shadowColor: Colors.blue.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {

                      if (index == pages.length - 1) {
                        // NEXT SCREEN HERE (Dashboard)
                        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
                      } else {
                        controller.nextPage(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                        );
                      }

                    },
                    child: Text(
                      index == pages.length - 1
                          ? "Get Started"
                          : "Next",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}