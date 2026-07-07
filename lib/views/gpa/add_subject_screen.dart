import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/grades/grade_view_model.dart';

class AddSubjectScreen extends StatefulWidget {
  const AddSubjectScreen({super.key});

  @override
  State<AddSubjectScreen> createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubjectScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController subjectController = TextEditingController();

  int selectedCredit = 3;
  String selectedGrade = "A";
  int selectedSemester = 1;

  final List<String> grades = ["A", "A-", "B+", "B", "C", "D", "F"];
  final List<int> semesters = List.generate(8, (index) => index + 1);

  // animation
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  bool showError = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    subjectController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _addSubject(GradeViewModel vm) {
    final text = subjectController.text.trim();

    if (text.isEmpty) {
      setState(() => showError = true);

      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) setState(() => showError = false);
      });

      _showError("Please enter subject name");
      return;
    }

    vm.addSubject(
      text,
      selectedCredit,
      selectedGrade,
      selectedSemester,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.only(
          bottom: 0,
          left: 16,
          right: 16,
          top: 20,
        ),
        content: Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF14B8A6), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF14B8A6),
                  size: 22,
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Subject Added",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${subjectController.text} • Semester $selectedSemester",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    subjectController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GradeViewModel>(context);

    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1F3A),

      appBar: AppBar(
        title: const Text("Add Semester"),
        backgroundColor: const Color(0xFF0B1F3A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(w * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    "Build Your Semester",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: w * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: h * 0.01),

                  Text(
                    "Add subjects and assign them to a semester",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: w * 0.035,
                    ),
                  ),

                  SizedBox(height: h * 0.02),

                  const Text(
                    "Select Semester",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),

                  SizedBox(height: h * 0.01),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: semesters.map((sem) {
                        final isSelected = selectedSemester == sem;

                        return GestureDetector(
                          onTap: () {
                            setState(() => selectedSemester = sem);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
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

                  SizedBox(height: h * 0.02),

                  Container(
                    padding: EdgeInsets.all(w * 0.04),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: showError
                          ? Border.all(color: Colors.redAccent)
                          : null,
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
                                  icon: const Icon(Icons.remove,
                                      color: Colors.white),
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
                                  icon: const Icon(Icons.add,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: h * 0.02),

                  const Text(
                    "Select Grade",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),

                  SizedBox(height: h * 0.01),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: grades.map((g) {
                        final isSelected = selectedGrade == g;

                        return GestureDetector(
                          onTap: () => setState(() => selectedGrade = g),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
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

                  SizedBox(height: h * 0.03),

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
                      onPressed: () => _addSubject(vm),
                      child: const Text(
                        "Add Subject",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}