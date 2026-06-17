/*

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import '../../model/subject_model.dart';
import '../../utils/transcript_pdf.dart';
import '../../viewmodel/grades/grade_view_model.dart';

class TranscriptScreen extends StatelessWidget {
  const TranscriptScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final vm = Provider.of<GradeViewModel>(context);
    final data = vm.groupedBySemester;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1F3A),

      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {

              final allSubjects = vm.subjects;
              final cgpa = vm.cgpa;

              final pdf = await FullTranscriptPdf.generate(
                subjects: allSubjects,
                cgpa: cgpa,
              );

              await Printing.layoutPdf(
                onLayout: (format) => pdf,
              );
            },
          )
        ],
        title: const Text("Transcript"),
        backgroundColor: const Color(0xFF0B1F3A),
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            // =====================
            // CGPA HERO CARD
            // =====================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF1E3A8A),
                    Color(0xFF14B8A6),
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Cumulative GPA",
                    style: TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    vm.cgpa.toStringAsFixed(2),
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    "Overall Academic Performance",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // =====================
            // SEMESTER LIST
            // =====================
            Expanded(
              child: data.isEmpty
                  ? const Center(
                child: Text(
                  "No academic records found",
                  style: TextStyle(color: Colors.white70),
                ),
              )
                  : ListView(
                children: data.entries.map((entry) {

                  int sem = entry.key;
                  List<SubjectModel> subjects =
                  List<SubjectModel>.from(entry.value);

                  double sgpa = _calculateSGPA(subjects);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),

                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF1A2F4E),
                          const Color(0xFF0B1F3A),
                        ],
                      ),

                      border: Border.all(
                        color: Colors.white.withOpacity(0.06),
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.35),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),

                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),

                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        childrenPadding: const EdgeInsets.only(bottom: 16),

                        iconColor: Colors.tealAccent,
                        collapsedIconColor: Colors.white60,

                        // ================= HEADER =================
                        title: Row(
                          children: [

                            // LEFT TITLE
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Semester $sem",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.2,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  "${subjects.length} Subjects",
                                  style: const TextStyle(
                                    color: Colors.white60,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),

                            const Spacer(),

                            // SGPA BADGE (HERO ELEMENT)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.tealAccent.withOpacity(0.25),
                                    Colors.teal.withOpacity(0.12),
                                  ],
                                ),
                                border: Border.all(
                                  color: Colors.tealAccent.withOpacity(0.25),
                                ),
                              ),
                              child: Text(
                                "SGPA ${sgpa.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: Colors.tealAccent,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // ================= SUBJECT LIST =================
                        children: subjects.map((s) {
                          final gp = _gradePoint(s.grade);
                          final qp = s.credit * gp;

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

                            padding: const EdgeInsets.all(14),

                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.03),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.05),
                              ),
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                // SUBJECT NAME
                                Text(
                                  s.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // ================= INFO GRID =================
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [

                                    _chip("Credit ${s.credit}", Colors.white70,
                                        Colors.white.withOpacity(0.06)),

                                    _chip("Grade ${s.grade}", Colors.tealAccent,
                                        Colors.teal.withOpacity(0.15)),

                                    _chip("GP ${gp.toStringAsFixed(2)}", Colors.white70,
                                        Colors.white.withOpacity(0.06)),

                                    _chip("QP ${qp.toStringAsFixed(2)}", Colors.orangeAccent,
                                        Colors.orange.withOpacity(0.12)),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _gradePoint(String grade) {
    switch (grade) {
      case "A": return 4.0;
      case "A-": return 3.7;
      case "B+": return 3.3;
      case "B": return 3.0;
      case "C": return 2.3;
      case "D": return 2.0;
      default: return 0.0;
    }
  }

  Widget _chip(
      String text,
      Color textColor,
      Color bg, {
        IconData? icon,
      }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 30),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),

      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
        ),

        // subtle depth (Play Store feel)
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [

          // OPTIONAL ICON (makes it PRO)
          if (icon != null) ...[
            Icon(
              icon,
              size: 14,
              color: textColor,
            ),
            const SizedBox(width: 6),
          ],

          // TEXT
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateSGPA(List<SubjectModel> subjects) {
    double totalPoints = 0;
    int totalCredits = 0;

    for (var s in subjects) {
      totalPoints += s.credit * _gradePoint(s.grade);
      totalCredits += s.credit;
    }

    return totalCredits == 0 ? 0 : totalPoints / totalCredits;
  }

  double _subjectGPA(SubjectModel s) {
    return s.credit * _gradePoint(s.grade);
  }
}*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:printing/printing.dart';

import '../../model/subject_model.dart';
import '../../viewmodel/grades/grade_view_model.dart';
import '../../utils/transcript_pdf.dart';

class TranscriptScreen extends StatelessWidget {
  const TranscriptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GradeViewModel>();
    final data = vm.groupedBySemester;


    return Scaffold(
      backgroundColor: const Color(0xFF0B1F3A),

      // ================= APPBAR =================
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1F3A),
        foregroundColor: Colors.white,
        title: const Text("Academic Transcript"),

        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: () async {
              final pdf = await FullTranscriptPdf.generate(
                subjects: vm.subjects,
                cgpa: vm.cgpa,
                scale: vm.scale,
              );

              await Printing.layoutPdf(
                onLayout: (_) => pdf,
              );
            },
          )
        ],
      ),

      // ================= BODY =================
      body: Column(
        children: [

          // ================= CGPA CARD =================
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF14B8A6)],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Cumulative GPA",
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    vm.cgpa.toStringAsFixed(2),
                    key: ValueKey(vm.cgpa),
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Overall Academic Performance",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ================= LIST =================
          Expanded(
            child: data.isEmpty
                ? const Center(
              child: Text(
                "No academic records found",
                style: TextStyle(color: Colors.white70),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final sem = data.keys.elementAt(index);
                final subjects = data[sem]!;
                final sgpa = vm.sgpaBySemester(sem);

                return _semesterCard(vm, sem, subjects,sgpa);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================= SEMESTER CARD =================
  Widget _semesterCard(
      GradeViewModel vm,
      int sem,
      List<SubjectModel> subjects,
      double sgpa,
      ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF132A4A), Color(0xFF0F223D)],
        ),
        border: Border.all(color: Colors.white12),
      ),

      child: Theme(
        data: ThemeData.dark().copyWith(dividerColor: Colors.transparent),

        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          childrenPadding: const EdgeInsets.only(bottom: 14),

          iconColor: Colors.tealAccent,
          collapsedIconColor: Colors.white60,

          // ================= HEADER =================
          title: Row(
            children: [
              Column(
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
                  const SizedBox(height: 4),
                  Text(
                    "${subjects.length} Subjects",
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),

              const Spacer(),

              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.teal.withOpacity(0.15),
                  border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
                ),
                child: Text(
                  "SGPA ${sgpa.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.tealAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          // ================= SUBJECT LIST =================
          children: subjects.map((s) {
            final gp = vm.gradePoint(s.grade);
            final qp = s.credit * gp;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              padding: const EdgeInsets.all(12),

              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white10),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _chip("Credit ${s.credit}", Colors.white70),
                      _chip("Grade ${s.grade}", Colors.tealAccent),
                      _chip("GP ${gp.toStringAsFixed(2)}", Colors.white70),
                      _chip("QP ${qp.toStringAsFixed(2)}", Colors.orangeAccent),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ================= CHIP =================
  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}