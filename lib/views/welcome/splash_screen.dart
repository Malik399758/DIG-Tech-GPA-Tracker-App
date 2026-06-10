import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/storage/app_prefs.dart';
import '../../viewmodel/auth_flow_viewmodel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    initApp();
  }

  Future<void> initApp() async {
    final prefs = await SharedPreferences.getInstance();

    final appPrefs = AppPrefs(prefs);
    final authVM = AuthFlowViewModel(appPrefs);

    // Splash delay (UX only)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final route = authVM.getNextRoute();

    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF1E3A8A),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              height: size.width * 0.28,
              width: size.width * 0.28,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.school,
                size: 55,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "GradeFlow",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "SGPA • CGPA • Transcript Manager",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 35),

            const CircularProgressIndicator(
              color: Color(0xFF14B8A6),
            ),
          ],
        ),
      ),
    );
  }
}