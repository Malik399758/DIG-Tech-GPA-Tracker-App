import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  final SharedPreferences prefs;

  AppPrefs(this.prefs);

  // ================= KEYS =================
  static const onboardingDone = "onboardingDone";
  static const profileDone = "profileDone";

  static const userName = "userName";
  static const userUniversity = "userUniversity";

  // ================= FLAGS =================
  bool get isOnboardingDone =>
      prefs.getBool(onboardingDone) ?? false;

  bool get isProfileDone =>
      prefs.getBool(profileDone) ?? false;

  // ================= ONBOARDING =================
  Future<void> setOnboardingDone() async {
    await prefs.setBool(onboardingDone, true);
  }

  // ================= PROFILE =================
  Future<void> setProfileDone({
    required String name,
    required String university,
  }) async {
    await prefs.setBool(profileDone, true);

    await prefs.setString(userName, name);
    await prefs.setString(userUniversity, university);
  }

  // ================= GET PROFILE DATA =================
  String getName() {
    return prefs.getString(userName) ?? "Student";
  }

  String getUniversity() {
    return prefs.getString(userUniversity) ?? "Unknown University";
  }

  // ================= OPTIONAL RESET =================
  Future<void> clearAll() async {
    await prefs.clear();
  }

  /// GPA Scale
  static const String gpaScaleKey = "gpaScale";

  double getGpaScale() {
    return prefs.getDouble(gpaScaleKey) ?? 4.0;
  }

  Future<void> setGpaScale(double value) async {
    await prefs.setDouble(gpaScaleKey, value);
  }
}