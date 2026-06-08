import 'package:flutter/material.dart';

import '../../views/main/dashboard_screen.dart';
import '../../views/semester/semester_detail_screen.dart';
import '../../views/welcome/onboarding_screen.dart';
import '../../views/welcome/splash_screen.dart';

class AppRoutes {
  // ROUTE NAMES
  static const String splash = "/";
  static const String onboarding = "/onboarding";
  static const String dashboard = "/dashboard";


  static const String gpa = "/gpa";
  static const String transcript = "/transcript";
  static const String analytics = "/analytics";
  static const String settings = "/settings";
  static const String subject = "/subject";
  static const String semesterDetail = "/semesterDetail";

  // ROUTE GENERATOR
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {

    switch (routeSettings.name) {

      case splash:
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
        );

      case onboarding:
        return MaterialPageRoute(
          builder: (_) => OnboardingScreen(),
        );

      case dashboard:
        return MaterialPageRoute(
          builder: (_) => DashboardScreen(),
        );

      case AppRoutes.semesterDetail:

        final semester = routeSettings.arguments as int;

        return MaterialPageRoute(
          builder: (_) => SemesterDetailScreen(
            semester: semester,
          ),
        );

      case gpa:
        return _placeholder("GPA Screen");

      case transcript:
        return _placeholder("Transcript Screen");

      case analytics:
        return _placeholder("Analytics Screen");

      case settings:
        return _placeholder("Settings Screen");

      case subject:
        return _placeholder("Subject Screen");

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text(
                "Route Not Found",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        );
    }
  }

  // Placeholder builder
  static MaterialPageRoute _placeholder(String title) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Center(
          child: Text(
            "$title Coming Soon",
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}