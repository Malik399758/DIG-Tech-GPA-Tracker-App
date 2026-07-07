import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/grades/grade_view_model.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> fade;
  late Animation<Offset> slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String getPerformanceLabel(double cgpa) {
    if (cgpa >= 3.6) return "Excellent 🔥";
    if (cgpa >= 3.0) return "Good 👍";
    if (cgpa >= 2.5) return "Average ⚠️";
    return "Needs Improvement ❌";
  }

  Color getPerformanceColor(double cgpa) {
    if (cgpa >= 3.6) return Colors.green;
    if (cgpa >= 3.0) return Colors.teal;
    if (cgpa >= 2.5) return Colors.orange;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GradeViewModel>(context);
    final data = vm.semesterGPAChart;

    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1F3A),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1F3A),
        title: Text(
          "Academic Analytics",
          style: TextStyle(fontSize: w * 0.045),
        ),
      ),

      body: FadeTransition(
        opacity: fade,
        child: SlideTransition(
          position: slide,
          child: Padding(
            padding: EdgeInsets.all(w * 0.04),
            child: data.isEmpty
                ? _emptyState(w)
                : _buildContent(vm, data, w, h),
          ),
        ),
      ),
    );
  }

  // ================= CONTENT =================
  Widget _buildContent(
      GradeViewModel vm,
      Map<int, double> data,
      double w,
      double h,
      ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            "Semester Performance Overview",
            style: TextStyle(
              color: Colors.white,
              fontSize: w * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: h * 0.005),

          Text(
            "Track your GPA progression across semesters",
            style: TextStyle(
              color: Colors.white70,
              fontSize: w * 0.035,
            ),
          ),

          SizedBox(height: h * 0.02),

          _graphCard(data, vm.scale, w, h),

          SizedBox(height: h * 0.02),

          _semesterLabels(data, w),

          SizedBox(height: h * 0.02),

          _performanceCard(vm, w),
        ],
      ),
    );
  }

  // ================= GRAPH =================
  Widget _graphCard(
      Map<int, double> data,
      double scale,
      double w,
      double h,
      ) {
    return Container(
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: SizedBox(
        height: (h * 0.30).clamp(220.0, 320.0),
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: scale,
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),

            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toStringAsFixed(1),
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: w * 0.028,
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      "S${value.toInt()}",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: w * 0.028,
                      ),
                    );
                  },
                ),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),

            lineBarsData: [
              LineChartBarData(
                spots: data.entries
                    .map((e) => FlSpot(e.key.toDouble(), e.value))
                    .toList(),
                isCurved: true,
                barWidth: 3,
                color: const Color(0xFF14B8A6),
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  color: const Color(0xFF14B8A6).withOpacity(0.15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= SEMESTER LABELS =================
  Widget _semesterLabels(Map<int, double> data, double w) {
    return Wrap(
      spacing: w * 0.02,
      runSpacing: w * 0.02,
      children: data.entries.map((e) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.03,
            vertical: w * 0.02,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white12),
          ),
          child: Text(
            "Sem ${e.key}: ${e.value.toStringAsFixed(2)}",
            style: TextStyle(
              color: Colors.white70,
              fontSize: w * 0.03,
            ),
          ),
        );
      }).toList(),
    );
  }

  // ================= PERFORMANCE =================
  Widget _performanceCard(GradeViewModel vm, double w) {
    final cgpa = vm.cgpa;
    final label = getPerformanceLabel(cgpa);
    final color = getPerformanceColor(cgpa);

    return Container(
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: w * 0.04,
                ),
              ),
              const Icon(Icons.insights, color: Colors.teal),
            ],
          ),

          SizedBox(height: w * 0.03),

          Text(
            "Your academic trend is improving with consistency.",
            style: TextStyle(
              color: Colors.white70,
              fontSize: w * 0.032,
            ),
          ),

          SizedBox(height: w * 0.03),

          Text(
            "CGPA: ${cgpa.toStringAsFixed(2)}",
            style: TextStyle(
              color: Colors.white,
              fontSize: w * 0.038,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ================= EMPTY STATE =================
  Widget _emptyState(double w) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * 0.06),
        child: Container(
          padding: EdgeInsets.all(w * 0.05),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.show_chart, size: w * 0.15, color: Colors.white54),
              SizedBox(height: w * 0.03),
              Text(
                "No Performance Data",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: w * 0.045,
                ),
              ),
              SizedBox(height: w * 0.015),
              Text(
                "Add semesters to view analytics",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: w * 0.032,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}