import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/grades/grade_view_model.dart';

class AddSubjectScreen extends StatefulWidget {
  const AddSubjectScreen({super.key});

  @override
  State<AddSubjectScreen> createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubjectScreen> {

  final TextEditingController subjectController = TextEditingController();

  int selectedCredit = 3;
  String selectedGrade = "A";
  int selectedSemester = 1;

  final List<String> grades = ["A", "A-", "B+", "B", "C", "D", "F"];
  final List<int> semesters = List.generate(8, (index) => index + 1);

  @override
  Widget build(BuildContext context) {

    final vm = Provider.of<GradeViewModel>(context);
    final grouped = vm.groupedBySemester;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1F3A),

      appBar: AppBar(
        title: const Text("Add Subject"),
        backgroundColor: const Color(0xFF0B1F3A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // =====================
              // HEADER
              // =====================
              const Text(
                "Build Your Semester",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Add subjects and assign them to a semester",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 20),

              // =====================
              // SEMESTER SELECTOR
              // =====================
              const Text(
                "Select Semester",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),

              const SizedBox(height: 10),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: semesters.map((sem) {
                    final isSelected = selectedSemester == sem;

                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedSemester = sem);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF1E3A8A)
                              : Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? Border.all(color: const Color(0xFF14B8A6))
                              : null,
                        ),
                        child: Text(
                          "Sem $sem",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 20),

              // =====================
              // INPUT CARD
              // =====================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [

                    TextField(
                      controller: subjectController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Subject Name",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                        icon: Icon(Icons.book, color: Colors.white70),
                      ),
                    ),

                    const Divider(color: Colors.white24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Credit Hours",
                          style: TextStyle(color: Colors.white70),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (selectedCredit > 1) {
                                    selectedCredit--;
                                  }
                                });
                              },
                              icon: const Icon(Icons.remove, color: Colors.white),
                            ),
                            Text(
                              "$selectedCredit",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() => selectedCredit++);
                              },
                              icon: const Icon(Icons.add, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // =====================
              // GRADE SELECTOR
              // =====================
              const Text(
                "Select Grade",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),

              const SizedBox(height: 10),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: grades.map((g) {
                    final isSelected = selectedGrade == g;

                    return GestureDetector(
                      onTap: () => setState(() => selectedGrade = g),
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF14B8A6)
                              : Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          g,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 20),

              // =====================
              // ADD BUTTON
              // =====================
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF14B8A6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    if (subjectController.text.isNotEmpty) {
                      vm.addSubject(
                        subjectController.text,
                        selectedCredit,
                        selectedGrade,
                        selectedSemester,
                      );

                      subjectController.clear();
                    }
                  },
                  child: const Text(
                    "Add Subject",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // =====================
              // LIST (IMPORTANT FIX)
              // =====================
              const Text(
                "Your Subjects",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),

              const SizedBox(height: 10),


              // =====================
// LIST (UPGRADED PROFESSIONAL)
// =====================
              const SizedBox(height: 10),

              if (grouped.isEmpty)
                Center(
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
              else
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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

                        children: subjects.isEmpty
                            ? [
                          const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "No subjects in this semester",
                              style: TextStyle(color: Colors.white54),
                            ),
                          )
                        ]
                            : subjects.map((s) {
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
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

                                IconButton(
                                  onPressed: () async {
                                    await vm.deleteSubject(s);
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

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}