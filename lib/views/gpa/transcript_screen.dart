
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
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ExpansionTile(
                      iconColor: Colors.white,
                      collapsedIconColor: Colors.white,

                      title: Text(
                        "Semester $sem",
                        style: const TextStyle(color: Colors.white),
                      ),

                      // ✅ FIXED HERE
                      subtitle: Text(
                        "SGPA: ${sgpa.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),

                      children: subjects.map((s) {
                        return ListTile(
                          title: Text(
                            s.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            "CH: ${s.credit} | Grade: ${s.grade} | GP: ${_gradePoint(s.grade).toStringAsFixed(2)} | QP: ${(s.credit * _gradePoint(s.grade)).toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        );
                      }).toList(),
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
}