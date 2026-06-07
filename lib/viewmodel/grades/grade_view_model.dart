
import 'package:flutter/material.dart';

class GradeViewModel extends ChangeNotifier {

  final List<Map<String, dynamic>> _subjects = [];

  List<Map<String, dynamic>> get subjects => _subjects;

  double _sgpa = 0.0;
  double get sgpa => _sgpa;

  int get currentSemester {
    if (_subjects.isEmpty) return 1;

    return _subjects
        .map((s) => s["semester"] as int)
        .reduce((a, b) => a > b ? a : b);
  }

  List<int> get allSemesters {
    return _subjects
        .map((s) => s["semester"] as int)
        .toSet()
        .toList()
      ..sort();
  }

  List<Map<String, dynamic>> subjectsBySemester(int sem) {
    return _subjects.where((s) {
      return s["semester"].toString() == sem.toString();
    }).toList();
  }

  double sgpaBySemester(int sem) {
    double totalPoints = 0;
    int totalCredits = 0;

    final semSubjects = subjectsBySemester(sem);

    for (var s in semSubjects) {
      int credit = s["credit"] as int;
      String grade = s["grade"];

      totalPoints += credit * _gradePoint(grade);
      totalCredits += credit;
    }

    return totalCredits == 0 ? 0 : totalPoints / totalCredits;
  }

  // ADD SUBJECT
  void addSubject(String name, int credit, String grade,int sem) {
    _subjects.add({
      "name": name,
      "credit": credit,
      "grade": grade,
      "semester" : sem
    });

    calculateSGPA();
    notifyListeners();
  }

  // DELETE SUBJECT
  void deleteSubject(int index) {
    _subjects.removeAt(index);
    calculateSGPA();
    notifyListeners();
  }

  // GPA LOGIC
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

  void calculateSGPA() {
    double totalPoints = 0;
    int totalCredits = 0;

    for (var s in _subjects) {
      int credit = s["credit"];
      String grade = s["grade"];

      totalPoints += credit * _gradePoint(grade);
      totalCredits += credit;
    }

    _sgpa = totalCredits == 0 ? 0 : totalPoints / totalCredits;
  }

  Map<int, List<Map<String, dynamic>>> get groupedBySemester {
    Map<int, List<Map<String, dynamic>>> data = {};

    for (var s in _subjects) {
      int sem = s["semester"];

      if (!data.containsKey(sem)) {
        data[sem] = [];
      }

      data[sem]!.add(s);
    }

    return data;
  }

  double get cgpa {
    double totalPoints = 0;
    int totalCredits = 0;

    for (var s in _subjects) {
      int credit = s["credit"];
      String grade = s["grade"];

      totalPoints += credit * _gradePoint(grade);
      totalCredits += credit;
    }

    return totalCredits == 0 ? 0 : totalPoints / totalCredits;
  }
}