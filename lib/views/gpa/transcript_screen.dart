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
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1F3A),

      // ================= APPBAR =================
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1F3A),
        foregroundColor: Colors.white,
        title: const Text("Academic Transcript"),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Builder(
              builder: (context) {
                final size = MediaQuery.of(context).size;

                final double buttonSize = (size.width * 0.10).clamp(40.0, 52.0);

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () async {
                      final pdf = await FullTranscriptPdf.generate(
                        subjects: vm.subjects,
                        cgpa: vm.cgpa,
                        scale: vm.scale,
                      );

                      await Printing.layoutPdf(onLayout: (_) => pdf);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: buttonSize,
                      width: buttonSize,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF14B8A6), Color(0xFF1E3A8A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.download_rounded,
                        color: Colors.white,
                        size: buttonSize * 0.45,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
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
                    style: TextStyle(
                      fontSize: isTablet ? 32 : 40,
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

                      return _semesterCard(context, vm, sem, subjects, sgpa);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ================= SEMESTER CARD =================
  Widget _semesterCard(
    BuildContext context,
    GradeViewModel vm,
    int sem,
    List<SubjectModel> subjects,
    double sgpa,
  ) {
    final size = MediaQuery.of(context).size;

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
          tilePadding: EdgeInsets.symmetric(
            horizontal: size.width * 0.04,
            vertical: size.height * 0.01,
          ),
          childrenPadding: const EdgeInsets.only(bottom: 14),
          iconColor: Colors.tealAccent,
          collapsedIconColor: Colors.white60,

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
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
