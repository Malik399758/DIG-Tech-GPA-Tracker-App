/*
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../cons/widgets/text_field_widget.dart';
import '../../core/providers/profile_provider.dart';
import '../../viewmodel/grades/grade_view_model.dart';
import '../privacy/privacy_policy_screen.dart';
import '../privacy/terms_conditions_screen.dart';
import 'academic_setting_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // ================= RESET =================
  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF132A4A),
        title: const Text("Reset Data",
            style: TextStyle(color: Colors.white)),
        content: const Text(
          "This will permanently delete all academic data. Continue?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel",
                style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              final vm = context.read<GradeViewModel>();
              await vm.clearAllData(); // implement in VM

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("All data deleted")),
              );
            },
            child: const Text("Reset"),
          ),
        ],
      ),
    );
  }

  // ================= EXIT =================
  void _exitApp(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF132A4A),
        title: const Text("Exit App",
            style: TextStyle(color: Colors.white)),
        content: const Text(
          "Do you want to close the app?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel",
                style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              Future.delayed(const Duration(milliseconds: 200), () {
                SystemNavigator.pop();
              });
            },
            child: const Text("Exit"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF0B1F3A),

      // ================= APP BAR =================
      appBar: AppBar(
        title: Text("Settings",
            style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: const Color(0xFF0B1F3A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // ================= BODY =================
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // ================= PROFILE =================
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF132A4A), Color(0xFF0F223D)],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 26,
                  backgroundColor: Color(0xFF14B8A6),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(profile.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(profile.university,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ================= GENERAL =================
          const Text("General",
              style: TextStyle(
                  color: Colors.white70, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),

          _tile(
            context: context,
            icon: Icons.person_outline,
            title: "Edit Profile",
            subtitle: "Update name & university",
            onTap: () => showEditProfile(context),
          ),

          _tile(
            context: context,
            icon: Icons.school_outlined,
            title: "Academic Settings",
            subtitle: "Manage grading system",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AcademicSettingsScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // ================= DATA =================
          const Text("Data",
              style: TextStyle(
                  color: Colors.white70, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),

          _tile(
            context: context,
            icon: Icons.delete_forever,
            title: "Reset App",
            subtitle: "Delete all records",
            iconColor: Colors.redAccent,
            onTap: () => _showResetDialog(context),
          ),

          const SizedBox(height: 20),

          // ================= LEGAL =================
          const Text("Legal",
              style: TextStyle(
                  color: Colors.white70, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),

          _tile(
            context: context,
            icon: Icons.privacy_tip_outlined,
            title: "Privacy Policy",
            subtitle: "Read how your data is used",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PrivacyPolicyScreen(),
                ),
              );
            },
          ),

          _tile(
            context: context,
            icon: Icons.description_outlined,
            title: "Terms & Conditions",
            subtitle: "App usage rules",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TermsConditionsScreen(),
                ),
              );
            },
          ),

          _tile(
            context: context,
            icon: Icons.info_outline,
            title: "About App",
            subtitle: "GradeFlow • Developer Info",
            onTap: () {
              showDialog(
                context: context,
                builder: (_) {
                  return Dialog(
                    backgroundColor: const Color(0xFF132A4A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          // APP ICON
                          const CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xFF14B8A6),
                            child: Icon(Icons.school, color: Colors.white, size: 30),
                          ),

                          const SizedBox(height: 12),

                          const Text(
                            "GradeFlow",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          const Text(
                            "Version 1.0.0",
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),

                          const SizedBox(height: 16),

                          const Text(
                            "A smart GPA & CGPA tracking system for students.\nBuilt with Flutter for clean academic management.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),

                          const SizedBox(height: 20),

                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: const Column(
                              children: [
                                Text(
                                  "Developer",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Yaseen Malik",
                                  style: TextStyle(color: Color(0xFF14B8A6)),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF14B8A6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                "Close",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),

          const SizedBox(height: 20),

          // ================= EXIT =================
          _tile(
            context: context,
            icon: Icons.exit_to_app,
            title: "Exit App",
            subtitle: "Close GradeFlow",
            iconColor: Colors.redAccent,
            onTap: () => _exitApp(context),
          ),

          const SizedBox(height: 30),

          Center(
            child: Text(
              "GradeFlow • Built with Flutter",
              style: GoogleFonts.poppins(
                color: Colors.white38,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= TILE =================
  Widget _tile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color iconColor = const Color(0xFF14B8A6),
    required BuildContext context,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: ListTile(
          leading: Icon(icon, color: iconColor),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Colors.white38,
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  // ================= EDIT PROFILE =================
  void showEditProfile(BuildContext context) {
    final provider = context.read<ProfileProvider>();

    final nameCtrl = TextEditingController(text: provider.name);
    final uniCtrl = TextEditingController(text: provider.university);

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF132A4A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Edit Profile",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              TextFieldWidget(controller: nameCtrl, hint: "Name"),
              const SizedBox(height: 10),
              TextFieldWidget(controller: uniCtrl, hint: "University"),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF14B8A6)),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => const Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFF14B8A6)),
                      ),
                    );

                    await Future.delayed(const Duration(seconds: 2));

                    await provider.updateProfile(
                        nameCtrl.text.trim(), uniCtrl.text.trim());

                    Navigator.pop(context);
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        duration: const Duration(seconds: 3),
                        margin: const EdgeInsets.only(
                          bottom: 0,
                          left: 16,
                          right: 16,
                          top: 20,
                        ),
                        content: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFF14B8A6),
                                width: 1,
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF14B8A6),
                                  size: 22,
                                ),
                                SizedBox(width: 10),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Profile Updated",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        "Profile successfully saved.",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Text("Save",
                      style: GoogleFonts.poppins(color: Colors.white)),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../cons/widgets/text_field_widget.dart';
import '../../core/providers/profile_provider.dart';
import '../../viewmodel/grades/grade_view_model.dart';
import '../predictor/goal_gpa_predictor.dart';
import '../privacy/privacy_policy_screen.dart';
import '../privacy/terms_conditions_screen.dart';
import 'academic_setting_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // ================= RESET =================
  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF132A4A),
        title: const Text("Reset Data",
            style: TextStyle(color: Colors.white)),
        content: const Text(
          "This will permanently delete all academic data. Continue?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel",
                style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              final vm = context.read<GradeViewModel>();
              await vm.clearAllData();

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("All data deleted")),
              );
            },
            child: Text("Reset",style: GoogleFonts.poppins(color: Colors.white),),
          ),
        ],
      ),
    );
  }

  void _exitApp(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF132A4A),
        title: const Text("Exit App",
            style: TextStyle(color: Colors.white)),
        content: const Text(
          "Do you want to close the app?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel",
                style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              Future.delayed(const Duration(milliseconds: 200), () {
                SystemNavigator.pop();
              });
            },
            child: Text("Exit",style: GoogleFonts.poppins(
              color: Colors.white
            ),),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();

    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1F3A),

      appBar: AppBar(
        title: Text(
          "Settings",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: w * 0.045,
          ),
        ),
        backgroundColor: const Color(0xFF0B1F3A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: ListView(
        padding: EdgeInsets.all(w * 0.04),
        children: [

          // ================= PROFILE =================
          Container(
            padding: EdgeInsets.all(w * 0.04),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF132A4A), Color(0xFF0F223D)],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 26,
                  backgroundColor: Color(0xFF14B8A6),
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
                      SizedBox(height: h * 0.005),
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
          ),

          SizedBox(height: h * 0.025),

          // ================= GENERAL =================
          Text(
            "General",
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
              fontSize: w * 0.035,
            ),
          ),
          SizedBox(height: h * 0.015),

          _tile(context, Icons.person_outline, "Edit Profile",
              "Update name & university", w, () {
                showEditProfile(context);
              }),

          _tile(context, Icons.school_outlined, "Academic Settings",
              "Manage grading system", w, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AcademicSettingsScreen(),
                  ),
                );
              }),
          Text(
            "Academic Tools",
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
              fontSize: w * 0.035,
            ),
          ),
          SizedBox(height: h * 0.015),

          _tile(
            context,
            Icons.track_changes,
            "Goal GPA Predictor",
            "Predict GPA needed for target CGPA",
            w,
                () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const GoalGpaPredictorScreen(),
                ),
              );
            },
          ),

          SizedBox(height: h * 0.02),

          Text(
            "Data",
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
              fontSize: w * 0.035,
            ),
          ),

          SizedBox(height: h * 0.015),

          _tile(context, Icons.delete_forever, "Reset App",
              "Delete all records", w, () {
                _showResetDialog(context);
              }, Colors.redAccent),

          SizedBox(height: h * 0.02),

          Text(
            "Legal",
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
              fontSize: w * 0.035,
            ),
          ),

          SizedBox(height: h * 0.015),

          _tile(context, Icons.privacy_tip_outlined, "Privacy Policy",
              "Read how your data is used", w, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PrivacyPolicyScreen(),
                  ),
                );
              }),

          _tile(context, Icons.description_outlined,
              "Terms & Conditions", "App usage rules", w, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TermsConditionsScreen(),
                  ),
                );
              }),

          _tile(context, Icons.exit_to_app, "Exit App",
              "Close GradeFlow", w, () {
                _exitApp(context);
              }, Colors.redAccent),

          SizedBox(height: h * 0.03),

          Center(
            child: Text(
              "GradeFlow • Built with Flutter",
              style: GoogleFonts.poppins(
                color: Colors.white38,
                fontSize: w * 0.03,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= TILE =================
  Widget _tile(
      BuildContext context,
      IconData icon,
      String title,
      String subtitle,
      double w,
      VoidCallback onTap, [
        Color iconColor = const Color(0xFF14B8A6),
      ]) {
    return Container(
      margin: EdgeInsets.only(bottom: w * 0.025),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: w * 0.055),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: w * 0.035,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.white54,
            fontSize: w * 0.03,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: w * 0.035,
          color: Colors.white38,
        ),
        onTap: onTap,
      ),
    );
  }

  // ================= EDIT PROFILE =================
  void showEditProfile(BuildContext context) {
    final provider = context.read<ProfileProvider>();

    final nameCtrl = TextEditingController(text: provider.name);
    final uniCtrl = TextEditingController(text: provider.university);

    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF132A4A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: w * 0.04,
            right: w * 0.04,
            top: h * 0.02,
            bottom: MediaQuery.of(context).viewInsets.bottom + h * 0.02,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: h * 0.85, // prevents overflow
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Edit Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: w * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: h * 0.02),

                  TextFieldWidget(controller: nameCtrl, hint: "Name"),
                  SizedBox(height: h * 0.012),

                  TextFieldWidget(controller: uniCtrl, hint: "University"),

                  SizedBox(height: h * 0.025),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF14B8A6),
                        padding: EdgeInsets.symmetric(vertical: h * 0.015),
                      ),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF14B8A6),
                            ),
                          ),
                        );

                        await Future.delayed(const Duration(seconds: 2));

                        await provider.updateProfile(
                          nameCtrl.text.trim(),
                          uniCtrl.text.trim(),
                        );

                        Navigator.pop(context); // loader
                        Navigator.pop(context); // bottom sheet

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            duration: const Duration(seconds: 3),
                            margin: const EdgeInsets.only(
                              bottom: 0,
                              left: 16,
                              right: 16,
                              top: 20,
                            ),
                            content: Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F172A),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color(0xFF14B8A6),
                                    width: 1,
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Color(0xFF14B8A6),
                                      size: 22,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Profile Updated",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            "Profile successfully saved.",
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: w * 0.04,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}