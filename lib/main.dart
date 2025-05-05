import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/chatbot_screen.dart';
import 'service/health_data_store.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HealthDataStore.init(); 
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health Tracker',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Color(0xFFF8F9FA),
      ),
      home: HomeScreen(), // Trang đầu tiên là màn hình chính
      routes: {
        '/login': (context) => LoginScreen(),
        '/chatbot': (context) => ChatbotScreen(),
      },
    );
  }
}
