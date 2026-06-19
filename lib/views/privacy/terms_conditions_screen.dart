import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1F3A),

      appBar: AppBar(
        title: Text(
          "Terms & Conditions",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
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
                "Terms & Conditions",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "By using GradeFlow, you agree to the following terms and conditions.",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 20),

              _sectionTitle("1. Usage of App"),
              _text(
                "You agree to use GradeFlow only for educational and lawful purposes. Any misuse of the application features is strictly prohibited.",
              ),

              const SizedBox(height: 15),

              _sectionTitle("2. User Responsibility"),
              _text(
                "You are fully responsible for any data you enter, including academic records and calculations.",
              ),

              const SizedBox(height: 15),

              _sectionTitle("3. Modifications"),
              _text(
                "We reserve the right to update, modify, or improve these terms at any time without prior notice.",
              ),

              const SizedBox(height: 15),

              _sectionTitle("4. Limitation of Liability"),
              _text(
                "GradeFlow is provided as-is. We are not responsible for any data loss or misuse of the application.",
              ),

              const SizedBox(height: 15),

              _sectionTitle("5. Contact"),
              _text(
                "For any questions or issues, contact us at:\nyaseenmalik.coder@gmail.com",
              ),

              const SizedBox(height: 25),

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