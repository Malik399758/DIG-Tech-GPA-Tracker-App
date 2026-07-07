
import 'package:flutter/material.dart';
import '../../model/predictor_model.dart';
import '../../viewmodel/predictor_controller.dart';

class GoalGpaPredictorScreen extends StatefulWidget {
  const GoalGpaPredictorScreen({super.key});

  @override
  State<GoalGpaPredictorScreen> createState() =>
      _GoalGpaPredictorScreenState();
}

class _GoalGpaPredictorScreenState extends State<GoalGpaPredictorScreen> {
  final _formKey = GlobalKey<FormState>();

  final _currentCgpaController = TextEditingController();
  final _completedCreditsController = TextEditingController();
  final _targetCgpaController = TextEditingController();
  final _totalCreditsController = TextEditingController();

  final PredictorController _controller = PredictorController();

  double? requiredGpa;
  String? status;
  String? feedback;

  void _predict() {
    if (!_formKey.currentState!.validate()) return;

    final model = PredictorModel(
      currentCgpa: double.parse(_currentCgpaController.text),
      completedCredits: int.parse(_completedCreditsController.text),
      targetCgpa: double.parse(_targetCgpaController.text),
      totalCredits: int.parse(_totalCreditsController.text),
    );

    final result = _controller.calculateRequiredGpa(model);

    setState(() {
      requiredGpa = result;
      status = _controller.getStatus(result);
      feedback = _controller.getFeedback(result);
    });
  }

  @override
  void dispose() {
    _currentCgpaController.dispose();
    _completedCreditsController.dispose();
    _targetCgpaController.dispose();
    _totalCreditsController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1F3A),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1F3A),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Goal GPA Predictor",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: w * 0.045,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(w * 0.04),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                /// HEADER CARD
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(w * 0.05),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF1E3A8A),
                        Color(0xFF14B8A6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(w * 0.05),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.track_changes,
                        color: Colors.white,
                        size: w * 0.10,
                      ),

                      SizedBox(height: h * 0.01),

                      Text(
                        "Academic Goal Planner",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: w * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: h * 0.008),

                      Text(
                        "Predict the GPA required to reach your target CGPA",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: w * 0.033,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: h * 0.025),

                _buildField(
                  controller: _currentCgpaController,
                  label: "Current CGPA",
                  w: w,
                ),

                SizedBox(height: h * 0.018),

                _buildField(
                  controller: _completedCreditsController,
                  label: "Completed Credits",
                  w: w,
                ),

                SizedBox(height: h * 0.018),

                _buildField(
                  controller: _targetCgpaController,
                  label: "Target CGPA",
                  w: w,
                ),

                SizedBox(height: h * 0.018),

                _buildField(
                  controller: _totalCreditsController,
                  label: "Total Degree Credits",
                  w: w,
                ),

                SizedBox(height: h * 0.03),

                /// BUTTON
                SizedBox(
                  width: double.infinity,
                  height: h * 0.06,
                  child: ElevatedButton(
                    onPressed: _predict,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF14B8A6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(w * 0.04),
                      ),
                    ),
                    child: Text(
                      "Predict GPA",
                      style: TextStyle(
                        fontSize: w * 0.040,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: h * 0.03),

                if (requiredGpa != null)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    width: double.infinity,
                    padding: EdgeInsets.all(w * 0.05),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(w * 0.05),
                      border: Border.all(
                        color: const Color(0xFF14B8A6),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.analytics,
                          size: w * 0.10,
                          color: const Color(0xFF14B8A6),
                        ),

                        SizedBox(height: h * 0.015),

                        Text(
                          requiredGpa!.toStringAsFixed(2),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: w * 0.10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: h * 0.008),

                        Text(
                          "Required GPA",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: w * 0.035,
                          ),
                        ),

                        SizedBox(height: h * 0.02),

                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: w * 0.04,
                            vertical: h * 0.012,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(w * 0.03),
                          ),
                          child: Text(
                            status ?? "",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: w * 0.038,
                            ),
                          ),
                        ),

                        SizedBox(height: h * 0.02),

                        Text(
                          feedback ?? "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            height: 1.5,
                            fontSize: w * 0.034,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required double w,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType:
      const TextInputType.numberWithOptions(decimal: true),
      style: TextStyle(
        color: Colors.white,
        fontSize: w * 0.038,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.white70,
          fontSize: w * 0.035,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.06),
        contentPadding: EdgeInsets.symmetric(
          horizontal: w * 0.04,
          vertical: w * 0.04,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(w * 0.04),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Required";
        }

        if (double.tryParse(value) == null) {
          return "Enter valid number";
        }

        return null;
      },
    );
  }
}