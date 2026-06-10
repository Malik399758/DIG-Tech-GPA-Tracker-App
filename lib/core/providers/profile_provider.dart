import 'package:flutter/material.dart';
import '../storage/app_prefs.dart';

class ProfileProvider extends ChangeNotifier {
  final AppPrefs prefs;

  ProfileProvider(this.prefs);

  String get name => prefs.getName();
  String get university => prefs.getUniversity();

  Future<void> updateProfile(String name, String university) async {
    await prefs.setProfileDone(
      name: name,
      university: university,
    );

    notifyListeners();
  }
}