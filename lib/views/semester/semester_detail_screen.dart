import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/grades/grade_view_model.dart';

class SemesterDetailScreen extends StatefulWidget {
  final int semester;

  const SemesterDetailScreen({super.key, required this.semester});

  @override
  State<SemesterDetailScreen> createState() => _SemesterDetailScreenState();
}

class _SemesterDetailScreenState extends State<SemesterDetailScreen> {
  void _showDeleteSemesterDialog(
    BuildContext context,
    GradeViewModel vm,
    int semester,
  ) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: const Color(0xFF132A4A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.redAccent,
                    size: 34,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Delete Semester",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Semester $semester and all associated subjects will be permanently removed.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, height: 1.5),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.white.withOpacity(.15),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await vm.deleteSemester(semester);

                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Delete",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF132A4A), Color(0xFF0F223D)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    // color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.06)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),

                  child: Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(dividerColor: Colors.transparent),

                    child: ExpansionTile(
                      trailing: SizedBox(),
                      tilePadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      childrenPadding: const EdgeInsets.only(bottom: 12),

                      iconColor: Colors.tealAccent,
                      collapsedIconColor: Colors.white60,

                      // ================= HEADER =================
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Semester $sem",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              const Spacer(),

                              Align(
                                alignment: Alignment.topRight,
                                child: PopupMenuButton<String>(
                                  padding: EdgeInsets.zero,
                                  tooltip: "Options",

                                  color: const Color(0xFF1A355C),
                                  elevation: 15,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),

                                  icon: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.05),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.more_vert_rounded,
                                      color: Colors.white60,
                                      size: 18,
                                    ),
                                  ),

                                  itemBuilder: (_) => [
                                    PopupMenuItem(
                                      value: "delete",
                                      child: Row(
                                        children: const [
                                          Icon(Icons.delete_outline, color: Colors.redAccent),
                                          SizedBox(width: 10),
                                          Text(
                                            "Delete Semester",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],

                                  onSelected: (value) {
                                    if (value == "delete") {
                                      _showDeleteSemesterDialog(context, vm, sem);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // ================= CHIPS =================
                          Row(
                            children: [
                              _chip(
                                "${subjects.length} Subjects",
                                Colors.tealAccent,
                                Colors.teal.withOpacity(0.15),
                              ),

                              const SizedBox(width: 10),

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
                        ],
                      ),

                      // ================= SUBJECT LIST =================
                      children: subjects.map((s) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),

                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.04),
                            ),
                          ),

                          child: Row(
                            children: [
                              // SUBJECT INFO
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      s.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      "Credit ${s.credit} • Grade ${s.grade}",
                                      style: const TextStyle(
                                        color: Colors.white54,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // DELETE BUTTON
                              InkWell(
                                onTap: () async {
                                  await vm.deleteSubject(s);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.redAccent,
                                      content: Text("${s.name} deleted"),
                                    ),
                                  );
                                },

                                borderRadius: BorderRadius.circular(10),

                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.redAccent,
                                    size: 18,
                                  ),
                                ),
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
    );
  }

  Widget _chip(String text, Color textColor, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
