
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
    return Scaffold(
      backgroundColor: const Color(0xFF0B1F3A),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20),

              const Text(
                "Create Your Profile",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Tell us about yourself to personalize GPA tracking",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 30),

              // ================= INPUTS =================
              _buildField("Full Name", nameController, Icons.person),
              const SizedBox(height: 12),

              _buildField("University", uniController, Icons.school),
              const SizedBox(height: 12),

              _buildField("Degree (e.g BSCS)", degreeController, Icons.menu_book),

              const Spacer(),

              // ================= BUTTON =================
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    loading ? const Color(0xFF0F766E) : const Color(0xFF14B8A6),
                    disabledBackgroundColor: const Color(0xFF0F766E).withOpacity(0.6),
                    elevation: loading ? 0 : 6,
                    shadowColor: Colors.teal.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),

                  onPressed: loading ? null : _saveProfile,

                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),

                    child: loading
                        ? const Row(
                      key: ValueKey("loading"),
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          "Saving...",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                        : const Text(
                      "Continue",
                      key: ValueKey("text"),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // ================= TEXT FIELD UI =================
  Widget _buildField(
      String hint,
      TextEditingController controller,
      IconData icon,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white70),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}