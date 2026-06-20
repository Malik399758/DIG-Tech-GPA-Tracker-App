import 'package:flutter/material.dart';

class EmptyDashboardScreen extends StatefulWidget {
  final VoidCallback onCreateSemester;

  const EmptyDashboardScreen({
    super.key,
    required this.onCreateSemester,
  });

  @override
  State<EmptyDashboardScreen> createState() => _EmptyDashboardScreenState();
}

class _EmptyDashboardScreenState extends State<EmptyDashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _float;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);

    // 🔥 Smooth floating motion (no blinking)
    _float = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: -16.0, end: 12.0).chain(
          CurveTween(curve: Curves.easeInOutCubic),
        ),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 12.0, end: -16.0).chain(
          CurveTween(curve: Curves.easeInOutCubic),
        ),
        weight: 50,
      ),
    ]).animate(_controller);

    // 🔥 Soft breathing scale (premium UI feel)
    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.96, end: 1.05).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.05, end: 0.96).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
        weight: 50,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1F3A),

      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.06),
              child: Column(
                children: [

                  const Spacer(),

                  // ================= ICON =================
                  Transform.translate(
                    offset: Offset(0, _float.value),
                    child: Transform.scale(
                      scale: _scale.value,
                      child: Container(
                        padding: EdgeInsets.all(width * 0.10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF14B8A6),
                              Color(0xFF1E3A8A),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF14B8A6).withOpacity(0.25),
                              blurRadius: 45,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.school_rounded,
                          size: width * 0.15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.03),

                  // ================= TITLE =================
                  Text(
                    "Start Your Academic Journey",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.065,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: height * 0.015),

                  // ================= DESCRIPTION =================
                  Text(
                    "Create your first semester and track SGPA, CGPA, and academic progress in a modern smart way.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: width * 0.035,
                      height: 1.5,
                    ),
                  ),

                  const Spacer(),

                  // ================= BUTTON =================
                  SizedBox(
                    width: double.infinity,
                    height: height * 0.065,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF14B8A6),
                        elevation: 12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: widget.onCreateSemester,
                      child: Text(
                        "Create First Semester",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.03),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}