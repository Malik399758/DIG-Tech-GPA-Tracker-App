
import '../core/storage/app_prefs.dart';

class AuthFlowViewModel {
  final AppPrefs prefs;

  AuthFlowViewModel(this.prefs);

  String getNextRoute() {
    if (!prefs.isOnboardingDone) {
      return "/onboarding";
    }

    if (!prefs.isProfileDone) {
      return "/profile";
    }

    return "/dashboard";
  }
}