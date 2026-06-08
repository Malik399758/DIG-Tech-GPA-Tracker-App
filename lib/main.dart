import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grade_flow/viewmodel/grades/grade_view_model.dart';
import 'package:grade_flow/views/welcome/splash_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import 'cons/routes/app_route.dart';
import 'data/hive_boxes.dart';
import 'model/subject_model.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(SubjectModelAdapter());

  await Hive.openBox<SubjectModel>(
    HiveBoxes.subjectBox,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GradeViewModel()),
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
      // START SCREEN
      initialRoute: AppRoutes.splash,

      // ROUTE HANDLER
      onGenerateRoute: AppRoutes.generateRoute,

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: const ColorScheme.light(
          primary: Color(0xFF1E3A8A), // deep blue
          secondary: Color(0xFF14B8A6), // teal
        ),

        textTheme: GoogleFonts.poppinsTextTheme(),

      ),

      darkTheme: ThemeData(
        useMaterial3: true,

        brightness: Brightness.dark,

        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1E3A8A),
          secondary: Color(0xFF14B8A6),
        ),

        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),

      themeMode: ThemeMode.system,
    );
  }
}