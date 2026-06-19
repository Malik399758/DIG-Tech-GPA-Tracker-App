import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1F3A),

      appBar: AppBar(
        title: Text(
          "Privacy Policy",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0B1F3A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF132A4A),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "Privacy Policy",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Last updated: June 2026",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white60,
                ),
              ),

              const SizedBox(height: 20),

              _sectionTitle("1. Information We Collect"),
              _text(
                "GradeFlow does not collect personal data unless required for core functionality like storing academic records locally on your device.",
              ),

              const SizedBox(height: 15),

              _sectionTitle("2. How We Use Information"),
              _text(
                "All data is used only to calculate GPA, SGPA, and display your academic performance. Nothing is shared externally.",
              ),

              const SizedBox(height: 15),

              _sectionTitle("3. Data Security"),
              _text(
                "Your data is stored locally using secure local storage (Hive). We do not upload or transmit your data to any server.",
              ),

              const SizedBox(height: 15),

              _sectionTitle("4. Third-Party Services"),
              _text(
                "GradeFlow does not use third-party analytics, ads, or tracking services.",
              ),

              const SizedBox(height: 15),

              _sectionTitle("5. Contact Us"),
              _text(
                "If you have any questions, feel free to contact us at:\nyaseenmalik.coder@gmail.com",
              ),

              const SizedBox(height: 20),

              Center(
                child: Text(
                  "GradeFlow • Built for students",
                  style: GoogleFonts.poppins(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF14B8A6),
      ),
    );
  }

  Widget _text(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 13,
        color: Colors.white70,
        height: 1.5,
      ),
    );
  }
}