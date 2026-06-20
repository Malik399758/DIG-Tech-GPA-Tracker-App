import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/storage/app_prefs.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final nameController = TextEditingController();
  final uniController = TextEditingController();
  final degreeController = TextEditingController();

  bool loading = false;

  Future<void> _saveProfile() async {
    if (nameController.text.isEmpty ||
        uniController.text.isEmpty ||
        degreeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => loading = true);

    final prefs = await SharedPreferences.getInstance();
    final appPrefs = AppPrefs(prefs);

    await prefs.setString("name", nameController.text.trim());
    await prefs.setString("university", uniController.text.trim());
    await prefs.setString("degree", degreeController.text.trim());

    await appPrefs.setProfileDone(
      name: nameController.text.trim(),
      university: uniController.text.trim(),
    );

    setState(() => loading = false);

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, "/dashboard");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1F3A),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.06,
            vertical: height * 0.03,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: height * 0.9,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ================= ICON =================
                Center(
                  child: Container(
                    height: width * 0.22,
                    width: width * 0.22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF14B8A6), Color(0xFF0EA5E9)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.35),
                          blurRadius: 25,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.school_rounded,
                      color: Colors.white,
                      size: width * 0.10,
                    ),
                  ),
                ),

                SizedBox(height: height * 0.04),

                // ================= TITLE =================
                Text(
                  "Create Your Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.075,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: height * 0.01),

                Text(
                  "Set up your academic profile to personalize GPA tracking and performance insights.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: width * 0.036,
                    height: 1.5,
                  ),
                ),

                SizedBox(height: height * 0.04),

                // ================= FORM CARD =================
                Container(
                  padding: EdgeInsets.all(width * 0.05),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildField("Full Name", nameController, Icons.person_outline),
                      SizedBox(height: height * 0.018),
                      _buildField("University", uniController, Icons.school_outlined),
                      SizedBox(height: height * 0.018),
                      _buildField("Degree Program", degreeController, Icons.menu_book_outlined),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.05),

                // ================= BUTTON =================
                SizedBox(
                  width: double.infinity,
                  height: height * 0.07,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF14B8A6),
                      elevation: 10,
                      shadowColor: Colors.teal.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: loading ? null : _saveProfile,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: loading
                          ? Row(
                        key: const ValueKey("loading"),
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: width * 0.05,
                            width: width * 0.05,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: width * 0.03),
                          Text(
                            "Saving Profile...",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                          : Text(
                        "Continue",
                        key: const ValueKey("text"),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.043,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: height * 0.03),

                Center(
                  child: Text(
                    "Your data stays securely on your device",
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: width * 0.03,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= FIELD =================
  Widget _buildField(
      String hint,
      TextEditingController controller,
      IconData icon,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: const Color(0xFF14B8A6)),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
        ),
      ),
    );
  }
}