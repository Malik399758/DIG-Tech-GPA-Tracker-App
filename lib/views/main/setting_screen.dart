
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../cons/widgets/text_field_widget.dart';
import '../../core/providers/profile_provider.dart';
import '../../core/storage/app_prefs.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF132A4A),
        title: const Text(
          "Reset Data",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "This will permanently delete all academic data. Continue?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () {
              // TODO: call clear Hive data
              Navigator.pop(context);
            },
            child: const Text("Reset"),
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

      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: const Color(0xFF0B1F3A),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // ================= PROFILE CARD =================
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
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ================= GENERAL =================
          const Text(
            "General",
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 10),

          _tile(
            icon: Icons.person_outline,
            title: "Edit Profile",
            subtitle: "Update name & university",
            onTap: () {
              showEditProfile(context);
            },
          ),

          _tile(
            icon: Icons.school_outlined,
            title: "Academic Settings",
            subtitle: "Manage grading system",
            onTap: () {},
          ),

          const SizedBox(height: 20),

          // ================= APPEARANCE =================
          const Text(
            "Appearance",
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 10),

          _tile(
            icon: Icons.color_lens_outlined,
            title: "Theme",
            subtitle: "Dark mode (default)",
            onTap: () {},
          ),

          const SizedBox(height: 20),

          // ================= DATA =================
          const Text(
            "Data",
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 10),

          _tile(
            icon: Icons.backup_outlined,
            title: "Backup Data",
            subtitle: "Save your progress",
            onTap: () {},
          ),

          _tile(
            icon: Icons.delete_forever,
            title: "Reset App",
            subtitle: "Delete all records",
            iconColor: Colors.redAccent,
            onTap: () => _showResetDialog(context),
          ),

          const SizedBox(height: 30),

          // ================= FOOTER =================
          const Center(
            child: Text(
              "GradeFlow v1.0",
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // ================= TILE WIDGET =================
  Widget _tile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color iconColor = const Color(0xFF14B8A6),
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
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
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Colors.white38,
        ),
        onTap: onTap,
      ),
    );
  }

  // profile bottom sheet

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

              const Text(
                "Edit Profile",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              TextFieldWidget(controller: nameCtrl, hint: 'name'),
              const SizedBox(height: 10),
              TextFieldWidget(controller: uniCtrl, hint: 'University'),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF14B8A6),
                  ),
                  onPressed: () async {
                    // 1. SHOW LOADING DIALOG
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF14B8A6),
                        ),
                      ),
                    );

                    // 2. FAKE / REAL PROCESSING DELAY (2 sec UX effect)
                    await Future.delayed(const Duration(seconds: 2));

                    // 3. SAVE PROFILE
                    await provider.updateProfile(
                      nameCtrl.text.trim(),
                      uniCtrl.text.trim(),
                    );

                    // 4. CLOSE LOADER
                    Navigator.pop(context);

                    // 5. SHOW SUCCESS SNACKBAR
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
                                        "Changes saved successfully",
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

                    // 6. CLOSE SCREEN
                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}