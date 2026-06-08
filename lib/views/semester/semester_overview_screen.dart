
import 'package:flutter/material.dart';
import 'package:grade_flow/views/semester/semester_detail_screen.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/grades/grade_view_model.dart';

class SemesterOverviewScreen extends StatelessWidget {
  const SemesterOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GradeViewModel>(context);
    final grouped = vm.groupedBySemester;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1F3A),
      appBar: AppBar(
        title: const Text("Semester Overview"),
        backgroundColor: const Color(0xFF0B1F3A),
      ),

      body: grouped.isEmpty
          ? const Center(
        child: Text(
          "No data available",
          style: TextStyle(color: Colors.white70),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: grouped.keys.length,
        itemBuilder: (context, index) {
          final sem = grouped.keys.elementAt(index);
          final subjects = grouped[sem]!;
          final sgpa = vm.sgpaBySemester(sem);

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SemesterDetailScreen(
                    semester: sem,
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(16),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Semester $sem",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "${subjects.length} Subjects",
                    style: const TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "SGPA: ${sgpa.toStringAsFixed(2)}",
                    style: const TextStyle(color: Colors.tealAccent),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}