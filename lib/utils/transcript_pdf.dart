import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../model/subject_model.dart';

class FullTranscriptPdf {

  static Future<Uint8List> generate({
    required List<SubjectModel> subjects,
    required double cgpa,
  }) async {

    final pdf = pw.Document();

    // GROUP BY SEMESTER
    final Map<int, List<SubjectModel>> grouped = {};

    for (var s in subjects) {
      grouped.putIfAbsent(s.semester, () => []);
      grouped[s.semester]!.add(s);
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),

        build: (context) {

          return [

            // ================= HEADER =================
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    "UNIVERSITY OF ACADEMIC RECORDS",
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    "OFFICIAL TRANSCRIPT REPORT",
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 20),

            // ================= CGPA BOX =================
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(width: 1),
              ),
              child: pw.Text(
                "CUMULATIVE GPA: ${cgpa.toStringAsFixed(2)}",
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),

            pw.SizedBox(height: 20),

            // ================= SEMESTERS =================
            ...grouped.entries.map((entry) {

              final sem = entry.key;
              final semSubjects = entry.value;

              final sgpa = _calculateSGPA(semSubjects);

              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [

                  pw.SizedBox(height: 15),

                  pw.Text(
                    "Semester $sem  |  SGPA: ${sgpa.toStringAsFixed(2)}",
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),

                  pw.SizedBox(height: 8),

                  pw.Table.fromTextArray(
                    headers: ["Subject", "CH", "Grade", "GP", "QP"],
                    data: semSubjects.map((s) {
                      final gp = _gradePoint(s.grade);
                      final qp = s.credit * gp;

                      return [
                        s.name,
                        s.credit.toString(),
                        s.grade,
                        gp.toStringAsFixed(2),
                        qp.toStringAsFixed(2),
                      ];
                    }).toList(),
                  ),
                ],
              );
            }).toList(),

            pw.SizedBox(height: 30),

            // ================= FOOTER =================
            pw.Center(
              child: pw.Text(
                "This is a system generated academic transcript",
                style: const pw.TextStyle(fontSize: 10),
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  // ================= GPA =================
  static double _gradePoint(String grade) {
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

  static double _calculateSGPA(List<SubjectModel> subjects) {
    double totalPoints = 0;
    int totalCredits = 0;

    for (var s in subjects) {
      totalPoints += s.credit * _gradePoint(s.grade);
      totalCredits += s.credit;
    }

    return totalCredits == 0 ? 0 : totalPoints / totalCredits;
  }
}