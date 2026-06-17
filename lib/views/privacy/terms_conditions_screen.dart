
import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms & Conditions"),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Terms & Conditions",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),

              Text(
                "By using this application, you agree to the following terms and conditions.",
              ),

              SizedBox(height: 20),

              Text(
                "1. Usage of App",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "You agree to use this app only for lawful purposes and not misuse its features.",
              ),

              SizedBox(height: 15),

              Text(
                "2. User Responsibility",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "Users are responsible for how they use the application.",
              ),

              SizedBox(height: 15),

              Text(
                "3. Modifications",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "We reserve the right to update or change these terms at any time.",
              ),

              SizedBox(height: 15),

              Text(
                "4. Limitation of Liability",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "We are not responsible for any damages caused by the use of this app.",
              ),

              SizedBox(height: 15),

              Text(
                "5. Contact",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "For any issues, contact: support@example.com",
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}