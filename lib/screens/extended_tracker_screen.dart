import 'package:flutter/material.dart';
import '../service/health_data_store.dart';
import 'package:intl/intl.dart';

class ExtendedTrackerScreen extends StatefulWidget {
  const ExtendedTrackerScreen({Key? key}) : super(key: key);

  @override
  _ExtendedTrackerScreenState createState() => _ExtendedTrackerScreenState();
}

class _ExtendedTrackerScreenState extends State<ExtendedTrackerScreen> {
  final _formKey = GlobalKey<FormState>();
  double? weight;
  int? heartRate;
  int? sleep;
  int? systolic;
  int? diastolic;

  Future<void> _saveData() async {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now);
    final entry = {
      'date': formattedDate,
      'weight': weight ?? 0,
      'heartRate': heartRate ?? 0,
      'sleep': sleep ?? 0,
      'systolic': systolic ?? 0,
      'diastolic': diastolic ?? 0,
    };
    await HealthDataStore.saveEntry(entry);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Dữ liệu đã được lưu!")),
    );
    _formKey.currentState?.reset();
  }

  Widget _buildNumberField(String label, Function(String?) onSaved) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Vui lòng nhập $label' : null,
        onSaved: onSaved,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Theo dõi sức khỏe mở rộng")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildNumberField("Cân nặng (kg)", (val) => weight = double.tryParse(val ?? '')),
              _buildNumberField("Nhịp tim (bpm)", (val) => heartRate = int.tryParse(val ?? '')),
              _buildNumberField("Giấc ngủ (giờ)", (val) => sleep = int.tryParse(val ?? '')),
              _buildNumberField("Huyết áp tâm thu (mmHg)", (val) => systolic = int.tryParse(val ?? '')),
              _buildNumberField("Huyết áp tâm trương (mmHg)", (val) => diastolic = int.tryParse(val ?? '')),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _saveData();
                  }
                },
                child: const Text("Lưu dữ liệu"),
              )
            ],
          ),
        ),
      ),
    );
  }
}