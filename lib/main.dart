import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('accessToken');

  runApp(MyApp(token: token ?? ""));
}

class MyApp extends StatelessWidget {
  final String token;

  const MyApp({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vault Sphere',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: token.isNotEmpty ? HomePage() : LoginPage(),
    );
  }
}
