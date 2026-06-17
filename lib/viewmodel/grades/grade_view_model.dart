import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../core/storage/app_prefs.dart';
import '../../data/hive_boxes.dart';
import '../../model/subject_model.dart';

class GradeViewModel extends ChangeNotifier {
  final AppPrefs prefs;

  final Box<SubjectModel> _box =
  Hive.box<SubjectModel>(HiveBoxes.subjectBox);

  GradeViewModel(this.prefs) {
    _scale = prefs.getGpaScale();
  }

  // ================= SCALE =================
  double _scale = 4.0;
  double get scale => _scale;

  Future<void> setGpaScale(double value) async {
    _scale = value;
    await prefs.setGpaScale(value);
    notifyListeners();
  }

  // ================= SUBJECTS =================
  List<SubjectModel> get subjects => _box.values.toList();

  Map<int, List<SubjectModel>> get groupedBySemester {
    final Map<int, List<SubjectModel>> data = {};
    for (var s in subjects) {
      (data[s.semester] ??= []).add(s);
    }
    return data;
  }

  List<int> get allSemesters {
    final list = subjects.map((e) => e.semester).toSet().toList();
    list.sort();
    return list;
  }

  List<SubjectModel> subjectsBySemester(int sem) {
    return subjects.where((s) => s.semester == sem).toList();
  }

  // ================= CURRENT SEMESTER =================
  int get currentSemester {
    if (subjects.isEmpty) return 1;
    return subjects.map((s) => s.semester).reduce((a, b) => a > b ? a : b);
  }

  // ================= ADD SUBJECT =================
  void addSubject(String name, int credit, String grade, int semester) {
    _box.add(SubjectModel(
      name: name,
      credit: credit,
      grade: grade,
      semester: semester,
    ));
    notifyListeners();
  }

  // ================= DELETE SINGLE =================
  Future<void> deleteSubject(SubjectModel subject) async {
    await subject.delete();
    notifyListeners();
  }

  // ================= DELETE SEMESTER =================
  Future<void> deleteSemester(int semester) async {
    final items =
    _box.values.where((s) => s.semester == semester).toList();

    for (final item in items) {
      await item.delete();
    }

    notifyListeners();
  }

  // ================= CLEAR ALL DATA (HIVE RESET) =================
  Future<void> clearAllData() async {
    await _box.clear();
    notifyListeners();
  }

  // ================= GRADE POINT SYSTEM =================
  double gradePoint(String grade) {
    switch (grade) {
      case "A":
        return _scale;
      case "A-":
        return _scale - 0.3;
      case "B+":
        return _scale - 0.7;
      case "B":
        return _scale - 1.0;
      case "C":
        return _scale - 1.7;
      case "D":
        return _scale - 2.0;
      default:
        return 0.0;
    }
  }

  // ================= CGPA =================
  double get cgpa {
    double totalPoints = 0;
    int totalCredits = 0;

    for (var s in subjects) {
      totalPoints += s.credit * gradePoint(s.grade);
      totalCredits += s.credit;
    }

    return totalCredits == 0 ? 0.0 : totalPoints / totalCredits;
  }

  // ================= SGPA =================
  double sgpaBySemester(int sem) {
    final list = subjectsBySemester(sem);

    double totalPoints = 0;
    int totalCredits = 0;

    for (var s in list) {
      totalPoints += s.credit * gradePoint(s.grade);
      totalCredits += s.credit;
    }

    return totalCredits == 0 ? 0.0 : totalPoints / totalCredits;
  }

  /// =====================
  /// UPDATE SEMESTER
  /// =====================
  Future<void> updateSemester(int oldSem, int newSem) async {
    for (final item in _box.values) {
      if (item.semester == oldSem) {
        item.semester = newSem;
        await item.save();
      }
    }

    notifyListeners();
  }

  // ================= PERFORMANCE =================
  String getPerformance(double sgpa) {
    if (sgpa >= 3.7) return "Excellent 🔥";
    if (sgpa >= 3.0) return "Good 👍";
    if (sgpa >= 2.0) return "Average ⚠️";
    return "Poor ❌";
  }

  // ================= CHART DATA =================
  Map<int, double> get semesterGPAChart {
    return {
      for (var sem in allSemesters) sem: sgpaBySemester(sem),
    };
  }

  // ================= ANALYSIS =================
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