/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/grades/grade_view_model.dart';

class SemesterDetailScreen extends StatelessWidget {
  const SemesterDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GradeViewModel>(context);
    final grouped = vm.groupedBySemester;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1F3A),
      appBar: AppBar(
        title: const Text("Semester Details"),
        backgroundColor: const Color(0xFF0B1F3A),
        foregroundColor: Colors.white,
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
        children: grouped.entries.map((entry) {
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
                    children: [
                      Expanded(
                        child: Text(
                          s.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Text(
                        "${s.credit} CH",
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/grades/grade_view_model.dart';

class SemesterDetailScreen extends StatelessWidget {
  final int semester;

  const SemesterDetailScreen({
    super.key,
    required this.semester,
  });

  @override
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GradeViewModel>(context);

    // 🔥 ALL SEMESTERS GROUPED
    final grouped = vm.groupedBySemester;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1F3A),

      appBar: AppBar(
        title: const Text("Semester Overview"),
        backgroundColor: const Color(0xFF0B1F3A),
      ),

      body: grouped.isEmpty
          ? Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Text(
            "No subjects added yet",
            style: TextStyle(color: Colors.white70),
          ),
        ),
      )
          : ListView(
        padding: const EdgeInsets.all(16),

        children: grouped.entries.map((entry) {
          final sem = entry.key;
          final subjects = entry.value;
          final sgpa = vm.sgpaBySemester(sem);

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),

            child: ExpansionTile(
              iconColor: Colors.tealAccent,
              collapsedIconColor: Colors.white70,
              childrenPadding: const EdgeInsets.only(bottom: 10),

              // ================= HEADER =================
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Semester $sem",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "${subjects.length} Subjects",
                      style: const TextStyle(
                        color: Colors.tealAccent,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              subtitle: Text(
                "SGPA: ${sgpa.toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.tealAccent),
              ),

              // ================= SUBJECT LIST =================
              children: subjects.map((s) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [

                      // LEFT SIDE
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.name,
                              style: const TextStyle(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "CH: ${s.credit} | Grade: ${s.grade}",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // DELETE
                      IconButton(
                        onPressed: () async {
                          await vm.deleteSubject(s);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Subject deleted"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}