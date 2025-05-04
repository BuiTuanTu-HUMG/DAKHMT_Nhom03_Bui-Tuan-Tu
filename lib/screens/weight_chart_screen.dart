import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';

class WeightChartScreen extends StatefulWidget {
  @override
  _WeightChartScreenState createState() => _WeightChartScreenState();
}

class _WeightChartScreenState extends State<WeightChartScreen> {
  List<double> weightHistory = [55, 56.2, 55.8, 57.1, 56.5];
  String chartType = 'line';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Biểu đồ cân nặng")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => setState(() => chartType = 'line'),
                  child: Text("Line Chart"),
                ),
                TextButton(
                  onPressed: () => setState(() => chartType = 'bar'),
                  child: Text("Bar Chart"),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: chartType == 'line' ? _buildLineChart() : _buildBarChart(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(weightHistory.length, (i) => FlSpot(i.toDouble(), weightHistory[i])),
            isCurved: true,
            dotData: FlDotData(show: true),
          )
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        barGroups: List.generate(weightHistory.length, (i) =>
          BarChartGroupData(x: i, barRods: [BarChartRodData(toY: weightHistory[i])])),
      ),
    );
  }
}