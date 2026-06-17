
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Privacy Policy",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              Text(
                "Last updated: June 2026\n",
              ),

              Text(
                "We respect your privacy and are committed to protecting any data you may share while using our application.",
              ),

              SizedBox(height: 20),

              Text(
                "1. Information We Collect",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "We do not collect personal information unless explicitly required for app functionality.",
              ),

              SizedBox(height: 15),

              Text(
                "2. How We Use Information",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "Any data collected is used only to improve app performance and user experience.",
              ),

              SizedBox(height: 15),

              Text(
                "3. Data Security",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "We ensure your data is stored securely and is not shared with third parties.",
              ),

              SizedBox(height: 15),

              Text(
                "4. Third-Party Services",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "This app does not use third-party tracking or advertising services.",
              ),

              SizedBox(height: 15),

              Text(
                "5. Contact Us",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "If you have any questions, contact us at: support@example.com",
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}