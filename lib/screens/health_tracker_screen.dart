import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HealthTrackerScreen extends StatefulWidget {
  @override
  _HealthTrackerScreenState createState() => _HealthTrackerScreenState();
}

class _HealthTrackerScreenState extends State<HealthTrackerScreen> {
  final _formKey = GlobalKey<FormState>();
  double? weight;
  double? height;
  int? heartRate;
  int? sleepHours;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      weight = prefs.getDouble('weight') ?? 0;
      height = prefs.getDouble('height') ?? 0;
      heartRate = prefs.getInt('heartRate') ?? 0;
      sleepHours = prefs.getInt('sleepHours') ?? 0;
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('weight', weight ?? 0);
    await prefs.setDouble('height', height ?? 0);
    await prefs.setInt('heartRate', heartRate ?? 0);
    await prefs.setInt('sleepHours', sleepHours ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Theo dõi sức khỏe")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildNumberField("Cân nặng (kg)", weight?.toString(), (val) => weight = double.tryParse(val ?? '')),
              _buildNumberField("Chiều cao (cm)", height?.toString(), (val) => height = double.tryParse(val ?? '')),
              _buildNumberField("Nhịp tim (/phút)", heartRate?.toString(), (val) => heartRate = int.tryParse(val ?? '')),
              _buildNumberField("Giấc ngủ (giờ)", sleepHours?.toString(), (val) => sleepHours = int.tryParse(val ?? '')),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    await _saveData();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Dữ liệu đã lưu!")));
                  }
                },
                child: Text("Lưu"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberField(String label, String? initialValue, Function(String?) onSaved) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập $label' : null,
        onSaved: onSaved,
      ),
    );
  }
}