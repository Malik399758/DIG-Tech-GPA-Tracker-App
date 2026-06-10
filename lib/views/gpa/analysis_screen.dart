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
      duration: const Duration(milliseconds: 800),
    );

    fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    slide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

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

    return Scaffold(
      backgroundColor: const Color(0xFF0B1F3A),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1F3A),
        title: const Text("Academic Analytics"),
      ),

      body: FadeTransition(
        opacity: fade,
        child: SlideTransition(
          position: slide,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: data.isEmpty
                ? _emptyState()
                : _buildContent(vm, data),
          ),
        ),
      ),
    );
  }

  // ================= CONTENT =================
  Widget _buildContent(GradeViewModel vm, Map<int, double> data) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Semester Performance Overview",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            "Track your GPA progression across semesters",
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),

          const SizedBox(height: 18),

          // ================= GRAPH =================
          _graphCard(data),

          const SizedBox(height: 20),

          // ================= SEMESTER LABELS =================
          _semesterLabels(data),

          const SizedBox(height: 20),

          // ================= PERFORMANCE CARD =================
          _performanceCard(vm),
        ],
      ),
    );
  }

  // ================= GRAPH =================
  Widget _graphCard(Map<int, double> data) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        height: 280,
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: 4,

            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),

            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
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
                      "S ${value.toInt()}",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
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
                    .map((e) => FlSpot(
                  e.key.toDouble(),
                  e.value,
                ))
                    .toList(),

                isCurved: true,
                barWidth: 3,
                color: const Color(0xFF14B8A6),

                dotData: FlDotData(show: true),

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
  Widget _semesterLabels(Map<int, double> data) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: data.entries.map((e) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white12),
          ),
          child: Text(
            "Sem ${e.key}: ${e.value.toStringAsFixed(2)}",
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        );
      }).toList(),
    );
  }

  // ================= PERFORMANCE =================
  Widget _performanceCard(GradeViewModel vm) {
    final cgpa = vm.cgpa;
    final label = getPerformanceLabel(cgpa);
    final color = getPerformanceColor(cgpa);

    return Container(
      padding: const EdgeInsets.all(16),
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
                  fontSize: 16,
                ),
              ),

              const Icon(Icons.insights, color: Colors.teal),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            "Your academic trend is being tracked across semesters.",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            "CGPA: ${cgpa.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ================= EMPTY STATE =================
  Widget _emptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.show_chart, size: 60, color: Colors.white54),
            SizedBox(height: 10),
            Text(
              "No Performance Data",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 6),
            Text(
              "Add semesters to view analytics",
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}