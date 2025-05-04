import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cài đặt")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text("Bật nhắc nhở"),
              value: true,
              onChanged: (value) {},
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text("Đơn vị đo lường"),
              subtitle: Text("kg, cm"),
              trailing: Icon(Icons.chevron_right),
              onTap: () {},
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Đã reset toàn bộ dữ liệu!")),
                );
              },
              child: Text("Reset dữ liệu"),
            )
          ],
        ),
      ),
    );
  }
}