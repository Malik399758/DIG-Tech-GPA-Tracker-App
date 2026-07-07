
import '../model/predictor_model.dart';

class PredictorController {
  double calculateRequiredGpa(PredictorModel model) {
    final remainingCredits =
        model.totalCredits - model.completedCredits;

    if (remainingCredits <= 0) return 0;

    return ((model.targetCgpa * model.totalCredits) -
        (model.currentCgpa * model.completedCredits)) /
        remainingCredits;
  }

  String getStatus(double gpa) {
    if (gpa <= 3.0) {
      return "Easy 🟢";
    } else if (gpa <= 3.5) {
      return "Moderate 🟡";
    } else if (gpa <= 4.0) {
      return "Challenging 🟠";
    }
    return "Not Achievable 🔴";
  }

  String getFeedback(double gpa) {
    if (gpa <= 3.0) {
      return "You are on track to achieve your goal.";
    } else if (gpa <= 4.0) {
      return "This target will require exceptional performance.";
    }

    return "Consider adjusting your target CGPA.";
  }
}