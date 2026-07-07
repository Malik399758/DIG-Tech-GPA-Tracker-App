
class PredictorModel {
  final double currentCgpa;
  final int completedCredits;
  final double targetCgpa;
  final int totalCredits;

  PredictorModel({
    required this.currentCgpa,
    required this.completedCredits,
    required this.targetCgpa,
    required this.totalCredits,
  });
}