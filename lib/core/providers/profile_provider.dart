import 'package:flutter/material.dart';
import '../storage/app_prefs.dart';

class ProfileProvider extends ChangeNotifier {
  final AppPrefs prefs;

  ProfileProvider(this.prefs) {
    loadProfile();
  }

  // 🔥 LOCAL STATE (IMPORTANT FIX)
  String _name = "";
  String _university = "";

  String get name => _name;
  String get university => _university;

  // ================= LOAD FROM STORAGE =================
  void loadProfile() {
    _name = prefs.getName();
    _university = prefs.getUniversity();
    notifyListeners();
  }

  // ================= UPDATE PROFILE =================
  Future<void> updateProfile(String name, String university) async {
    await prefs.setProfileDone(
      name: name,
      university: university,
    );

    // 🔥 UPDATE LOCAL STATE (THIS IS THE FIX)
    _name = name;
    _university = university;

    notifyListeners();
  }
}