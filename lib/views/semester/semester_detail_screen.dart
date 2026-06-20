import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../model/subject_model.dart';
import '../../viewmodel/grades/grade_view_model.dart';

class SemesterDetailScreen extends StatefulWidget {
  final int semester;

  const SemesterDetailScreen({super.key, required this.semester});

  @override
  State<SemesterDetailScreen> createState() => _SemesterDetailScreenState();
}

class _SemesterDetailScreenState extends State<SemesterDetailScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showDeleteSemesterDialog(BuildContext context, GradeViewModel vm, int sem) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF132A4A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Delete Semester", style: TextStyle(color: Colors.white)),
        content: Text(
          "Semester $sem will be permanently removed.",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel",style: GoogleFonts.poppins(
              color: Colors.white
            ),),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await vm.deleteSemester(sem);
              Navigator.pop(context);
            },
            child: Text("Delete",style: GoogleFonts.poppins(
              color: Colors.white
            ),),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GradeViewModel>();
    final grouped = vm.groupedBySemester;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1F3A),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1F3A),
        title: const Text("Semester Overview"),
      ),

      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: grouped.isEmpty
              ? _emptyState()
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: grouped.length,
            itemBuilder: (context, index) {
              final sem = grouped.keys.elementAt(index);
              final subjects = grouped[sem]!;
              final sgpa = vm.sgpaBySemester(sem);

              return _semesterCard(
                context,
                vm,
                sem,
                subjects,
                sgpa,
              );
            },
          ),
        ),
      ),
    );
  }

  // ================= SEMESTER CARD =================
  Widget _semesterCard(
      BuildContext context,
      GradeViewModel vm,
      int sem,
      List subjects,
      double sgpa,
      ) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 400),
      tween: Tween<double>(begin: 0.95, end: 1),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF132A4A), Color(0xFF0F223D)],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),

              child: ExpansionTile(
                collapsedIconColor: Color(0xFF14B8A6),
                tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

                // HEADER
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Semester $sem",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // FIXED RIGHT MENU
                    PopupMenuButton(
                      color: const Color(0xFF1A355C),
                      icon: const Icon(Icons.more_vert, color: Colors.white60),
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: "edit",
                          child: Row(
                            children: const [
                              Icon(Icons.edit_outlined, color: Colors.tealAccent),
                              SizedBox(width: 10),
                              Text("Edit Semester", style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),

                        PopupMenuItem(
                          value: "delete",
                          child: Row(
                            children: const [
                              Icon(Icons.delete_outline, color: Colors.redAccent),
                              SizedBox(width: 10),
                              Text("Delete Semester", style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == "delete") {
                          _showDeleteSemesterDialog(context, vm, sem);
                        }

                        if (value == "edit") {
                          _showEditSemesterDialog(context, vm, sem);
                        }
                      },
                    ),
                  ],
                ),

                children: [
                  const SizedBox(height: 8),

                  // CHIPS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _chip("${subjects.length} Subjects"),
                        const SizedBox(width: 10),
                        _chip("SGPA ${sgpa.toStringAsFixed(2)}"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // SUBJECT LIST
                  ...subjects.map((s) {
                    return TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 300),
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, v, child) {
                        return Opacity(
                          opacity: v,
                          child: Transform.translate(
                            offset: Offset(20 * (1 - v), 0),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.03),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          s.name,
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          "Credit ${s.credit} • Grade ${s.grade}",
                                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [

                                      // ✏️ EDIT BUTTON
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.tealAccent),
                                        onPressed: () {
                                          _showEditSubjectDialog(context, vm, s);
                                        },
                                      ),

                                      // 🗑 DELETE BUTTON
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                                        onPressed: () async {
                                          await vm.deleteSubject(s);

                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.redAccent,
                                              content: Text("${s.name} deleted"),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ================= CHIP =================
  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.tealAccent, fontSize: 12),
      ),
    );
  }

  // ================= EMPTY STATE =================
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.school_outlined, size: 70, color: Colors.white54),
          SizedBox(height: 10),
          Text(
            "No Semester Data",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(height: 6),
          Text(
            "Start by adding your first subject",
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }

  // subject update
  /*void _showEditSemesterDialog(
      BuildContext context,
      GradeViewModel vm,
      int sem,
      List subjects,
      ) {
    final nameController = TextEditingController();
    final creditController = TextEditingController();
    final gradeController = TextEditingController();

    if (subjects.isNotEmpty) {
      nameController.text = subjects.first.name;
      creditController.text = subjects.first.credit.toString();
      gradeController.text = subjects.first.grade;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF132A4A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Text(
                "Edit Semester Data",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              _inputField("Subject Name", nameController),
              const SizedBox(height: 10),
              _inputField("Credit Hours", creditController, isNumber: true),
              const SizedBox(height: 10),
              _inputField("Grade (A/B/C)", gradeController),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF14B8A6),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () async {
                    // SIMPLE APPROACH:
                    // delete + re-add updated (clean MVVM approach can improve later)

                    final updatedSubject = subjects.first;

                    updatedSubject.name = nameController.text;
                    updatedSubject.credit = int.tryParse(creditController.text) ?? 0;
                    updatedSubject.grade = gradeController.text;

                    await vm.updateSubject(updatedSubject);

                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  // sub update
  Widget _inputField(
      String hint,
      TextEditingController controller, {
        bool isNumber = false,
      }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }*/

  void _showEditSubjectDialog(
      BuildContext context,
      GradeViewModel vm,
      SubjectModel subject,
      ) {
    final nameCtrl = TextEditingController(text: subject.name);
    final creditCtrl = TextEditingController(text: subject.credit.toString());
    final gradeCtrl = TextEditingController(text: subject.grade);
    final semCtrl = TextEditingController(text: subject.semester.toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF132A4A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        final size = MediaQuery.of(context).size;
        final viewInsets = MediaQuery.of(context).viewInsets;

        return AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: viewInsets.bottom),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04,
                  vertical: size.height * 0.02,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // ================= TITLE =================
                    Text(
                      "Edit Subject",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: size.height * 0.02),

                    // ================= FIELDS =================
                    _field("Subject Name", nameCtrl),
                    SizedBox(height: size.height * 0.012),

                    _field("Credit Hours", creditCtrl, number: true),
                    SizedBox(height: size.height * 0.012),

                    _field("Grade (A/B/C)", gradeCtrl),
                    SizedBox(height: size.height * 0.012),

                    _field("Semester", semCtrl, number: true),

                    SizedBox(height: size.height * 0.025),

                    // ================= BUTTON =================
                    SizedBox(
                      width: double.infinity,
                      height: size.height * 0.06,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF14B8A6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () async {
                          subject.name = nameCtrl.text;
                          subject.credit =
                              int.tryParse(creditCtrl.text) ?? subject.credit;
                          subject.grade = gradeCtrl.text;
                          subject.semester =
                              int.tryParse(semCtrl.text) ?? subject.semester;

                          await subject.save();
                          vm.notifyListeners();

                          Navigator.pop(context);
                        },
                        child: Text(
                          "Save Changes",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _field(
      String hint,
      TextEditingController controller, {
        bool number = false,
      }) {
    return TextField(
      controller: controller,
      keyboardType: number ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // sem update
  void _showEditSemesterDialog(
      BuildContext context,
      GradeViewModel vm,
      int sem,
      ) {
    final controller = TextEditingController(text: sem.toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF132A4A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        final size = MediaQuery.of(context).size;
        final viewInsets = MediaQuery.of(context).viewInsets;

        return AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: viewInsets.bottom),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04,
                  vertical: size.height * 0.02,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // ================= TITLE =================
                    Text(
                      "Edit Semester",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: size.height * 0.02),

                    // ================= INPUT =================
                    TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Semester Number",
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.06),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.04,
                          vertical: size.height * 0.018,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    SizedBox(height: size.height * 0.025),

                    // ================= BUTTON =================
                    SizedBox(
                      width: double.infinity,
                      height: size.height * 0.06,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF14B8A6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () async {
                          final newSem = int.tryParse(controller.text);

                          if (newSem == null || newSem <= 0) return;

                          await vm.updateSemester(sem, newSem);

                          Navigator.pop(context);
                        },
                        child: Text(
                          "Save Changes",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: size.height * 0.01),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}