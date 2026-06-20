import 'package:flutter/material.dart';
import 'package:grade_flow/views/gpa/add_subject_screen.dart';
import 'package:grade_flow/views/gpa/analysis_screen.dart';
import 'package:grade_flow/views/gpa/transcript_screen.dart';
import 'package:grade_flow/views/main/semester_add_screen.dart';
import 'package:grade_flow/views/main/setting_screen.dart';
import 'package:provider/provider.dart';

import '../../cons/routes/app_route.dart';
import '../../core/providers/profile_provider.dart';
import '../../viewmodel/grades/grade_view_model.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GradeViewModel>(context);
    final profile = context.watch<ProfileProvider>();

    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    if (vm.subjects.isEmpty) {
      return EmptyDashboardScreen(
        onCreateSemester: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddSubjectScreen()),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0B1F3A),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(w * 0.04),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ================= HEADER =================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Dashboard",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: w * 0.07,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      IconButton(
                        iconSize: w * 0.06,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SettingsScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.settings, color: Colors.white),
                      ),
                    ],
                  ),

                  SizedBox(height: h * 0.005),

                  Text(
                    "Track your academic progress",
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: w * 0.035,
                    ),
                  ),

                  SizedBox(height: h * 0.02),

                  // PROFILE
                  _profileCard(profile, w),

                  SizedBox(height: h * 0.02),

                  // CGPA
                  _cgpaCard(vm, w),

                  SizedBox(height: h * 0.02),

                  // STATS
                  Row(
                    children: [
                      Expanded(
                        child: _miniCard(
                          "SGPA",
                          vm.sgpaBySemester(vm.currentSemester)
                              .toStringAsFixed(2),
                          Icons.trending_up,
                          w,
                        ),
                      ),
                      SizedBox(width: w * 0.03),
                      Expanded(
                        child: _miniCard(
                          "Semesters",
                          vm.currentSemester.toString(),
                          Icons.school,
                          w,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: h * 0.02),

                  // QUICK ACTION TITLE
                  Text(
                    "Quick Actions",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: w * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: h * 0.015),

                  Row(
                    children: [
                      Expanded(
                        child: _actionCard(
                          icon: Icons.add,
                          title: "Add Semester",
                          w: w,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AddSubjectScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: w * 0.03),
                      Expanded(
                        child: _actionCard(
                          icon: Icons.menu_book,
                          title: "Transcript",
                          w: w,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TranscriptScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: h * 0.02),

                  _primaryButton(
                    "View Semester Details",
                    Icons.arrow_forward_ios,
                    w,
                        () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.semesterDetail,
                        arguments: vm.currentSemester,
                      );
                    },
                  ),

                  SizedBox(height: h * 0.02),

                  InsightCard(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AnalysisScreen(),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: h * 0.03),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= PROFILE =================
  Widget _profileCard(ProfileProvider profile, double w) {
    return Container(
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF14B8A6)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white),
          ),
          SizedBox(width: w * 0.03),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: w * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  profile.university,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: w * 0.03,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= CGPA =================
  Widget _cgpaCard(GradeViewModel vm, double w) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(w * 0.05),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Current CGPA",
            style: TextStyle(color: Colors.white70, fontSize: w * 0.03),
          ),
          SizedBox(height: w * 0.02),

          Text(
            vm.cgpa.toStringAsFixed(2),
            style: TextStyle(
              color: Colors.white,
              fontSize: w * 0.10,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            "Excellent academic performance 🚀",
            style: TextStyle(
              color: Colors.tealAccent,
              fontSize: w * 0.03,
            ),
          ),
        ],
      ),
    );
  }

  // ================= MINI CARD =================
  Widget _miniCard(String title, String value, IconData icon, double w) {
    return Container(
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.tealAccent, size: 18),
          SizedBox(height: w * 0.02),

          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: w * 0.045,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            title,
            style: TextStyle(
              color: Colors.white60,
              fontSize: w * 0.03,
            ),
          ),
        ],
      ),
    );
  }

  // ================= ACTION CARD =================
  Widget _actionCard({
    required IconData icon,
    required String title,
    required double w,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(w * 0.04),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.tealAccent, size: 18),
            SizedBox(height: w * 0.02),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: w * 0.03,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= PRIMARY BUTTON =================
  Widget _primaryButton(
      String title,
      IconData icon,
      double w,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(w * 0.04),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1E3A8A), Color(0xFF14B8A6)],
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: w * 0.045),
            SizedBox(width: w * 0.02),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: w * 0.035,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class InsightCard extends StatefulWidget {
  final VoidCallback onTap;

  const InsightCard({
    super.key,
    required this.onTap,
  });

  @override
  State<InsightCard> createState() => _InsightCardState();
}

class _InsightCardState extends State<InsightCard>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;

  bool _pressed = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _scale = Tween<double>(begin: 0.95, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fade.value,
          child: Transform.scale(
            scale: _scale.value * (_pressed ? 0.98 : 1),
            child: GestureDetector(
              onTapDown: (_) => setState(() => _pressed = true),
              onTapUp: (_) => setState(() => _pressed = false),
              onTapCancel: () => setState(() => _pressed = false),
              onTap: widget.onTap,

              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.08),
                      Colors.white.withOpacity(0.04),
                    ],
                  ),
                  border: Border.all(
                    color: const Color(0xFF14B8A6).withOpacity(0.25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),

                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Performance Insight",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "Strong progress. Stay consistent for top results.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),

                    SizedBox(height: 12),

                    Row(
                      children: [

                        Icon(
                          Icons.insights,
                          size: 16,
                          color: Color(0xFF14B8A6),
                        ),

                        SizedBox(width: 6),

                        Text(
                          "Tap to view analytics",
                          style: TextStyle(
                            color: Color(0xFF14B8A6),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}