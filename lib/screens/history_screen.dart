import 'package:flutter/material.dart';
import '../service/health_data_store.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final history = HealthDataStore.getAllEntries();

    return Scaffold(
      appBar: AppBar(title: Text("Lịch sử sức khỏe")),
      body: history.isEmpty
          ? Center(child: Text("Chưa có dữ liệu."))
          : ListView.separated(
              itemCount: history.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                final entry = history[index];
                return ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text("Ngày ${entry['date']}"),
                  subtitle: Text(
                      "Cân nặng: ${entry['weight']}kg\nChiều cao: ${entry['height']}cm\nNhịp tim: ${entry['heartRate']}bpm\nNgủ: ${entry['sleep']} giờ"),
                );
              },
            ),
    );
  }
}