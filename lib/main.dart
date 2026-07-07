import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grade_flow/core/providers/profile_provider.dart';
import 'package:grade_flow/viewmodel/grades/grade_view_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cons/routes/app_route.dart';
import 'core/storage/app_prefs.dart';
import 'data/hive_boxes.dart';
import 'model/subject_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ================= HIVE =================
  await Hive.initFlutter();
  Hive.registerAdapter(SubjectModelAdapter());
  await Hive.openBox<SubjectModel>(HiveBoxes.subjectBox);

  // ================= PREFS =================
  final sharedPrefs = await SharedPreferences.getInstance();
  final appPrefs = AppPrefs(sharedPrefs);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GradeViewModel(appPrefs),
        ),

        ChangeNotifierProvider(
          create: (_) => ProfileProvider(appPrefs)..loadProfile(),
        ),
      ],
      child: const GradeFlowApp(),
    ),
  );
}

class GradeFlowApp extends StatelessWidget {
  const GradeFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,

      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF0B1F3A),
          centerTitle: true,

          titleTextStyle: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),

          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),

        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.grey.shade100,

        colorScheme: const ColorScheme.light(
          primary: Color(0xFF1E3A8A),
          secondary: Color(0xFF14B8A6),
        ),

        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
    );
  }
}