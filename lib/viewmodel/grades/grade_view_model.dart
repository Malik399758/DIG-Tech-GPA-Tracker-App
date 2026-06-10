/*


import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../data/hive_boxes.dart';
import '../../model/subject_model.dart';

class GradeViewModel extends ChangeNotifier {
  late final Box<SubjectModel> _box =
  Hive.box<SubjectModel>(HiveBoxes.subjectBox);

  // =====================
  // SUBJECT LIST
  // =====================
  List<SubjectModel> get subjects => _box.values.toList();

  // =====================
  // GROUP BY SEMESTER
  // =====================
  Map<int, List<SubjectModel>> get groupedBySemester {
    Map<int, List<SubjectModel>> data = {};

    for (var s in subjects) {
      data.putIfAbsent(s.semester, () => []);
      data[s.semester]!.add(s);
    }

    return data;
  }

  // =====================
  // CURRENT SEMESTER
  // =====================
  int get currentSemester {
    if (subjects.isEmpty) return 1;

    return subjects
        .map((s) => s.semester)
        .reduce((a, b) => a > b ? a : b);
  }

  // =====================
  // ALL SEMESTERS
  // =====================
  List<int> get allSemesters {
    return subjects.map((s) => s.semester).toSet().toList()..sort();
  }

  // =====================
  // FILTER BY SEMESTER
  // =====================
  List<SubjectModel> subjectsBySemester(int sem) {
    return subjects.where((s) => s.semester == sem).toList();
  }

  // =====================
  // ADD SUBJECT
  // =====================
  void addSubject(String name, int credit, String grade, int semester) {
    final subject = SubjectModel(
      name: name,
      credit: credit,
      grade: grade,
      semester: semester,
    );

    _box.add(subject);
    notifyListeners();
  }

  // =====================
  // DELETE SUBJECT (FIXED)
  // =====================
  void deleteSubject(SubjectModel subject) {
    final key = _box.keyAt(_box.values.toList().indexOf(subject));
    _box.delete(key);
    notifyListeners();
  }

  // =====================
  // GRADE POINT
  // =====================
  double _gradePoint(String grade) {
    switch (grade) {
      case "A":
        return 4.0;
      case "A-":
        return 3.7;
      case "B+":
        return 3.3;
      case "B":
        return 3.0;
      case "C":
        return 2.3;
      case "D":
        return 2.0;
      default:
        return 0.0;
    }
  }

  // =====================
  // CGPA
  // =====================
  double get cgpa {
    double totalPoints = 0;
    int totalCredits = 0;

    for (var s in subjects) {
      totalPoints += s.credit * _gradePoint(s.grade);
      totalCredits += s.credit;
    }

    return totalCredits == 0 ? 0.0 : totalPoints / totalCredits;
  }

  // =====================
  // SGPA PER SEMESTER
  // =====================
  double sgpaBySemester(int sem) {
    double totalPoints = 0;
    int totalCredits = 0;

    for (var s in subjects.where((s) => s.semester == sem)) {
      totalPoints += s.credit * _gradePoint(s.grade);
      totalCredits += s.credit;
    }

    return totalCredits == 0 ? 0.0 : totalPoints / totalCredits;
  }

  String getPerformance(double sgpa) {
    if (sgpa >= 3.7) return "Excellent 🔥";
    if (sgpa >= 3.0) return "Good 👍";
    if (sgpa >= 2.0) return "Average ⚠️";
    return "Poor ❌";
  }

  List<Map<String, dynamic>> semesterAnalysis() {
    return groupedBySemester.entries.map((entry) {

      final sem = entry.key;
      final sgpa = sgpaBySemester(sem);

      return {
        "semester": sem,
        "sgpa": sgpa,
        "performance": getPerformance(sgpa),
      };
    }).toList();
  }

  // GPA Analysis
  Map<int, double> get semesterGPAChart {
    Map<int, double> data = {};

    for (var sem in allSemesters) {
      data[sem] = sgpaBySemester(sem);
    }

    return data;
  }
}*/


import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../data/hive_boxes.dart';
import '../../model/subject_model.dart';

class GradeViewModel extends ChangeNotifier {
  final Box<SubjectModel> _box =
  Hive.box<SubjectModel>(HiveBoxes.subjectBox);

  // =====================
  // CACHE (IMPORTANT OPTIMIZATION)
  // =====================
  List<SubjectModel>? _cachedSubjects;

  List<SubjectModel> get subjects {
    _cachedSubjects = _box.values.toList();
    return _cachedSubjects!;
  }

  void _refresh() {
    _cachedSubjects = null;
    notifyListeners();
  }

  // =====================
  // GROUP BY SEMESTER (OPTIMIZED)
  // =====================
  Map<int, List<SubjectModel>> get groupedBySemester {
    final Map<int, List<SubjectModel>> data = {};

    for (var s in subjects) {
      (data[s.semester] ??= []).add(s);
    }

    return data;
  }

  // =====================
  // CURRENT SEMESTER
  // =====================
  int get currentSemester {
    if (subjects.isEmpty) return 1;

    return subjects
        .map((s) => s.semester)
        .reduce((a, b) => a > b ? a : b);
  }

  // =====================
  // ALL SEMESTERS
  // =====================
  List<int> get allSemesters {
    final set = subjects.map((e) => e.semester).toSet().toList();
    set.sort();
    return set;
  }

  // =====================
  // FILTER BY SEMESTER
  // =====================
  List<SubjectModel> subjectsBySemester(int sem) {
    return subjects.where((s) => s.semester == sem).toList();
  }

  // =====================
  // ADD SUBJECT
  // =====================
  void addSubject(String name, int credit, String grade, int semester) {
    final subject = SubjectModel(
      name: name,
      credit: credit,
      grade: grade,
      semester: semester,
    );

    _box.add(subject);
    _refresh();
  }

  // =====================
  // DELETE SUBJECT (FIXED + SAFE)
  // =====================
  Future<void> deleteSubject(SubjectModel subject) async {
    final key = subject.key; // Hive object key (BEST WAY)

    await _box.delete(key);
    notifyListeners();
  }

  /// Delete Entire function
  Future<void> deleteSemester(int semester) async {
    final subjectsToDelete = _box.values
        .where((s) => s.semester == semester)
        .toList();

    for (final subject in subjectsToDelete) {
      await subject.delete();
    }

    notifyListeners();
  }

  // =====================
  // GRADE POINT
  // =====================
  double _gradePoint(String grade) {
    switch (grade) {
      case "A":
        return 4.0;
      case "A-":
        return 3.7;
      case "B+":
        return 3.3;
      case "B":
        return 3.0;
      case "C":
        return 2.3;
      case "D":
        return 2.0;
      default:
        return 0.0;
    }
  }

  // =====================
  // CGPA
  // =====================
  double get cgpa {
    double totalPoints = 0;
    int totalCredits = 0;

    for (var s in subjects) {
      totalPoints += s.credit * _gradePoint(s.grade);
      totalCredits += s.credit;
    }

    return totalCredits == 0 ? 0.0 : totalPoints / totalCredits;
  }

  // =====================
  // SGPA
  // =====================
  double sgpaBySemester(int sem) {
    final list = subjectsBySemester(sem);

    double totalPoints = 0;
    int totalCredits = 0;

    for (var s in list) {
      totalPoints += s.credit * _gradePoint(s.grade);
      totalCredits += s.credit;
    }

    return totalCredits == 0 ? 0.0 : totalPoints / totalCredits;
  }

  // =====================
  // PERFORMANCE LABEL
  // =====================
  String getPerformance(double sgpa) {
    if (sgpa >= 3.7) return "Excellent 🔥";
    if (sgpa >= 3.0) return "Good 👍";
    if (sgpa >= 2.0) return "Average ⚠️";
    return "Poor ❌";
  }

  // =====================
  // CHART DATA
  // =====================
  Map<int, double> get semesterGPAChart {
    return {
      for (var sem in allSemesters) sem: sgpaBySemester(sem),
    };
  }

  // =====================
  // ANALYSIS DATA (FOR UI)
  // =====================
  List<Map<String, dynamic>> get semesterAnalysis {
    return groupedBySemester.entries.map((entry) {
      final sgpa = sgpaBySemester(entry.key);

      return {
        "semester": entry.key,
        "sgpa": sgpa,
        "performance": getPerformance(sgpa),
      };
    }).toList();
  }
}