import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/grades/grade_view_model.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GradeViewModel>(context);
    final data = vm.semesterGPAChart;

    final hasData = data.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1F3A),
      appBar: AppBar(
        title: const Text("Performance Analysis"),
        backgroundColor: const Color(0xFF0B1F3A),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: hasData
            ? SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ================= HEADER =================
              const Text(
                "📊 Academic Performance Overview",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // ================= CHART =================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: SizedBox(
                  height: 280,
                  child: LineChart(
                    LineChartData(
                      minY: 0,
                      maxY: 4,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) =>
                        const FlLine(
                          color: Colors.white12,
                          strokeWidth: 1,
                        ),
                      ),
                      borderData: FlBorderData(show: false),

                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
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
                                "S${value.toInt()}",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                ),
                              );
                            },
                          ),
                        ),

                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),

                      lineBarsData: [
                        LineChartBarData(
                          spots: data.entries.map((e) {
                            return FlSpot(
                              e.key.toDouble(),
                              e.value,
                            );
                          }).toList(),
                          isCurved: true,
                          barWidth: 3,
                          color: Colors.teal,
                          dotData: FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.teal.withOpacity(0.2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),
              _semesterSummary(vm),
              const SizedBox(height: 25),

              const Text(
                "📌 Performance Insight",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              _performanceCard(vm),
            ],
          ),
        )

        // ================= EMPTY STATE =================
            : Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.bar_chart,
                  size: 60,
                  color: Colors.white54,
                ),
                SizedBox(height: 10),
                Text(
                  "No Semester GPA Added",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Add subjects to view performance analysis",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= PERFORMANCE CARD =================
  Widget _performanceCard(GradeViewModel vm) {
    final cgpa = vm.cgpa;
    final trend = vm.semesterGPAChart.values.toList();

    String status;
    Color color;
    String message;

    if (cgpa >= 3.5) {
      status = "Excellent 🔥";
      color = Colors.green;
      message = "Outstanding performance. Keep it up!";
    } else if (cgpa >= 3.0) {
      status = "Good 👍";
      color = Colors.teal;
      message = "Good performance. Slight improvement needed.";
    } else if (cgpa >= 2.5) {
      status = "Average ⚠️";
      color = Colors.orange;
      message = "Focus on consistency to improve GPA.";
    } else {
      status = "Weak ❌";
      color = Colors.redAccent;
      message = "Need serious improvement in academics.";
    }

    final improving = trend.length > 1 && trend.last > trend.first;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                status,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              Icon(
                improving ? Icons.trending_up : Icons.trending_down,
                color: improving ? Colors.green : Colors.red,
              )
            ],
          ),

          const SizedBox(height: 10),

          Text(
            message,
            style: const TextStyle(
              color: Colors.white70,
              height: 1.4,
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

  Widget _semesterSummary(GradeViewModel vm) {
    final data = vm.semesterGPAChart;

    if (data.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
        ),
        child: const Text(
          "No semester performance data available",
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    final best = data.entries.reduce((a, b) => a.value > b.value ? a : b);
    final worst = data.entries.reduce((a, b) => a.value < b.value ? a : b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.06),
            Colors.white.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.insights, color: Colors.teal, size: 20),
              SizedBox(width: 8),
              Text(
                "Semester Performance",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _infoTile(
            icon: Icons.emoji_events,
            color: Colors.green,
            title: "Best Performance",
            subtitle: "Semester ${best.key}",
            value: "SGPA: ${best.value.toStringAsFixed(2)}",
          ),

          const SizedBox(height: 12),

          _infoTile(
            icon: Icons.warning_amber_rounded,
            color: Colors.redAccent,
            title: "Needs Improvement",
            subtitle: "Semester ${worst.key}",
            value: "SGPA: ${worst.value.toStringAsFixed(2)}",
          ),
        ],
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 18),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}