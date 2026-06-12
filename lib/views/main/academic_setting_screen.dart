import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/grades/grade_view_model.dart';

class AcademicSettingsScreen extends StatelessWidget {
  const AcademicSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1F3A),
      appBar: AppBar(
        title: const Text("Academic Settings"),
        backgroundColor: const Color(0xFF0B1F3A),
      ),

      body: Consumer<GradeViewModel>(
        builder: (context, vm, child) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                // ================= SCALE CARD =================
                TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 500),
                  tween: Tween<double>(begin: 0.8, end: 1),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },

                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E3A8A), Color(0xFF14B8A6)],
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.insights, color: Colors.white),
                      title: const Text(
                        "GPA Scale",
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        "${vm.scale.toStringAsFixed(1)} System",
                        style: const TextStyle(color: Colors.white70),
                      ),

                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white70,
                        size: 16,
                      ),

                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: const Color(0xFF0B1F3A),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (_) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                const SizedBox(height: 16),

                                _scaleTile(context, vm, 4.0, "4.0 Scale"),
                                _scaleTile(context, vm, 5.0, "5.0 Scale"),

                                const SizedBox(height: 20),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _scaleTile(
      BuildContext context,
      GradeViewModel vm,
      double value,
      String title,
      ) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: vm.scale == value
          ? const Icon(Icons.check_circle, color: Colors.tealAccent)
          : null,
      onTap: () async {
        await vm.setGpaScale(value);

        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("GPA Scale Updated"),
            backgroundColor: Colors.teal,
          ),
        );
      },
    );
  }
}