
import 'package:flutter/material.dart';
import '../storage/app_prefs.dart';

class ProfileProvider extends ChangeNotifier {
  final AppPrefs prefs;

  ProfileProvider(this.prefs) {
    loadProfile();
  }


  String _name = "";
  String _university = "";

  String get name => _name;
  String get university => _university;

  void loadProfile() {
    _name = prefs.getName();
    _university = prefs.getUniversity();
    notifyListeners();
  }

  Future<void> updateProfile(String name, String university) async {
    await prefs.setProfileDone(
      name: name,
      university: university,
    );

    _name = name;
    _university = university;

    notifyListeners();
  }
}