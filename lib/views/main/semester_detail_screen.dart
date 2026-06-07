import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/grades/grade_view_model.dart';

class SemesterDetailScreen extends StatelessWidget {
  const SemesterDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final vm = Provider.of<GradeViewModel>(context);

    // GROUPED DATA
    final grouped = vm.groupedBySemester;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1F3A),

      appBar: AppBar(
        title: const Text("Semester Details"),
        backgroundColor: const Color(0xFF0B1F3A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: grouped.isEmpty
          ? const Center(
        child: Text(
          "No academic records found",
          style: TextStyle(color: Colors.white70),
        ),
      )
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [

          const Text(
            "Courses",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          // =====================
          // SEMESTER WISE GROUP
          // =====================
          ...grouped.entries.map((entry) {

            final sem = entry.key;
            final subjects = entry.value;

            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white12),
              ),
              child: ExpansionTile(
                collapsedIconColor: Colors.white,
                iconColor: const Color(0xFF14B8A6),
                title: Text(
                  "Semester $sem",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                children: subjects.map((s) {

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        // SUBJECT NAME
                        Expanded(
                          child: Text(
                            s["name"],
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),

                        // CREDIT
                        Text(
                          "${s["credit"]} CH",
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),

                        const SizedBox(width: 10),

                        // GRADE
                        Text(
                          s["grade"],
                          style: const TextStyle(
                            color: Color(0xFF14B8A6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}