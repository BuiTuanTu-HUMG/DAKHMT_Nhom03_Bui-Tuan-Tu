import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HealthTrackerScreen extends StatefulWidget {
  @override
  _HealthTrackerScreenState createState() => _HealthTrackerScreenState();
}

class _HealthTrackerScreenState extends State<HealthTrackerScreen> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _heartRateController = TextEditingController();
  final _sleepController = TextEditingController();

  Map<String, double> healthData = {
    'Cân nặng': 0,
    'Chiều cao': 0,
    'Nhịp tim': 0,
    'Giấc ngủ': 0,
  };

  void _saveData() {
    setState(() {
      healthData['Cân nặng'] = double.tryParse(_weightController.text) ?? 0;
      healthData['Chiều cao'] = double.tryParse(_heightController.text) ?? 0;
      healthData['Nhịp tim'] = double.tryParse(_heartRateController.text) ?? 0;
      healthData['Giấc ngủ'] = double.tryParse(_sleepController.text) ?? 0;
    });
  }

  void _openChatbot() {
    final prompt = '''
Tôi vừa nhập dữ liệu sức khỏe:
- Cân nặng: ${_weightController.text} kg
- Chiều cao: ${_heightController.text} cm
- Nhịp tim: ${_heartRateController.text} bpm
- Ngủ: ${_sleepController.text} giờ

Bạn có thể cho tôi lời khuyên sức khỏe không?
''';
    Navigator.pushNamed(context, '/chatbot', arguments: prompt);
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

Widget _buildBarChart() {
  final items = healthData.entries.toList();

  // Lấy giá trị lớn nhất để chuẩn hóa
  final maxValue = healthData.values.reduce((a, b) => a > b ? a : b);
  final normalizedData = items.map((e) => e.value / maxValue * 100).toList();

  return BarChart(
    BarChartData(
      barGroups: List.generate(items.length, (index) {
        return BarChartGroupData(x: index, barRods: [
          BarChartRodData(
            toY: normalizedData[index],
            width: 20,
            color: Colors.teal,
            borderRadius: BorderRadius.circular(4),
          )
        ]);
      }),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, _) {
              int index = value.toInt();
              if (index >= 0 && index < items.length) {
                return Text(items[index].key, style: TextStyle(fontSize: 10));
              }
              return Text('');
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, reservedSize: 30),
        ),
      ),
      borderData: FlBorderData(show: false),
      gridData: FlGridData(show: true),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text("Theo dõi sức khỏe"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: _openChatbot,
            tooltip: 'Lấy lời khuyên',
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInputField("Cân nặng (kg)", _weightController),
            _buildInputField("Chiều cao (cm)", _heightController),
            _buildInputField("Nhịp tim (/phút)", _heartRateController),
            _buildInputField("Giấc ngủ (giờ)", _sleepController),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: _saveData,
              child: Text("Lưu"),
            ),
            SizedBox(height: 10),
            Text("Biểu đồ cột các chỉ số", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 300, child: _buildBarChart()),
          ],
        ),
      ),
    );
  }
}
