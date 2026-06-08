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
  // DELETE SUBJECT
  // =====================
  void deleteSubject(int index) {
    final key = _box.keyAt(index);
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


}*/


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
  void deleteSubject(int index) {
    _box.deleteAt(index);
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
}