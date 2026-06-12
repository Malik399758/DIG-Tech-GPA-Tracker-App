import 'package:flutter/material.dart';
import 'package:grade_flow/views/gpa/add_subject_screen.dart';
import 'package:grade_flow/views/gpa/analysis_screen.dart';
import 'package:grade_flow/views/gpa/transcript_screen.dart';
import 'package:grade_flow/views/main/semester_add_screen.dart';
import 'package:grade_flow/views/main/setting_screen.dart';
import 'package:provider/provider.dart';

import '../../cons/routes/app_route.dart';
import '../../core/providers/profile_provider.dart';
import '../../core/storage/app_prefs.dart';
import '../../viewmodel/grades/grade_view_model.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GradeViewModel>(context);
    final profile = context.watch<ProfileProvider>();

    if (vm.subjects.isEmpty) {
      return EmptyDashboardScreen(
        onCreateSemester: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddSubjectScreen(),
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0B1F3A),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ================= HEADER =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Dashboard",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  IconButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    SettingsScreen()));
                  }, icon: Icon(Icons.settings))



                ],
              ),

              const SizedBox(height: 6),

              Text(
                "Track your academic progress",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 16),

              // ================= PROFILE CARD =================
              _profileCard(profile),

              const SizedBox(height: 16),

              // ================= CGPA CARD =================
              _cgpaCard(vm),

              const SizedBox(height: 16),

              // ================= STATS =================
              Row(
                children: [
                  Expanded(
                    child: _miniCard(
                      "SGPA",
                      vm.sgpaBySemester(vm.currentSemester).toStringAsFixed(2),
                      Icons.trending_up,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _miniCard(
                      "Semesters",
                      vm.currentSemester.toString(),
                      Icons.school,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // ================= QUICK ACTIONS =================
              const Text(
                "Quick Actions",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _actionCard(
                      icon: Icons.add,
                      title: "Add Semester",
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

                  const SizedBox(width: 10),

                  Expanded(
                    child: _actionCard(
                      icon: Icons.menu_book,
                      title: "Transcript",
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

              const SizedBox(height: 14),

              _primaryButton(
                "View Semester Details",
                Icons.arrow_forward_ios,
                    () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.semesterDetail,
                    arguments: vm.currentSemester,
                  );
                },
              ),

              const SizedBox(height: 18),

              // ================= INSIGHT CARD =================
              InsightCard(onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    AnalysisScreen()));
              },),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // PROFILE CARD
  // =========================================================
  Widget _profileCard(ProfileProvider profile) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.university,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "STUDENT",
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // CGPA CARD
  // =========================================================
  Widget _cgpaCard(GradeViewModel vm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Current CGPA",
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 10),

          Text(
            vm.cgpa.toStringAsFixed(2),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            "Excellent academic performance 🚀",
            style: TextStyle(color: Colors.tealAccent, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // MINI CARD
  // =========================================================
  Widget _miniCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.tealAccent, size: 20),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // ACTION CARD
  // =========================================================
  Widget _actionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.tealAccent),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // PRIMARY BUTTON
  // =========================================================
  Widget _primaryButton(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1E3A8A), Color(0xFF14B8A6)],
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // INSIGHT CARD
  // =========================================================



  Widget _emptyDashboard(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // ================= ICON =================
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF14B8A6).withOpacity(0.25),
                    const Color(0xFF1E3A8A).withOpacity(0.25),
                  ],
                ),
              ),
              child: const Icon(
                Icons.school_outlined,
                size: 42,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 18),

            // ================= TITLE =================
            const Text(
              "No Semester Added Yet",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // ================= DESCRIPTION =================
            const Text(
              "Start by adding your first semester to track SGPA, CGPA and academic progress.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 20),

            // ================= PRIMARY BUTTON =================
            Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF14B8A6)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, "/subject");
                },
                child: const Text(
                  "Add First Semester",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ================= SECONDARY ACTION =================
            TextButton(
              onPressed: () {
                // optional: load demo data
              },
              child: const Text(
                "Explore Demo Data",
                style: TextStyle(color: Colors.white60),
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