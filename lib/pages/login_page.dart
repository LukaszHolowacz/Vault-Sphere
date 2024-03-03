import 'package:flutter/material.dart';
import 'register_page.dart';
import 'password_recovery_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'home_page.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final Color blueShade = Colors.blue.shade400;

  void _navigateToRegister() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterPage()));
  }

  void _navigateToPasswordRecovery() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => PasswordRecoveryPage()));
  }

  void _navigateToHome() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  void _showPopup(BuildContext context, IconData icon, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  message,
                  softWrap: true,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loginUser() async {
    final String apiUrl = 'http://192.168.0.21:3001/users//login';
    final String email = _emailController.text;
    final String password = _passwordController.text;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final accessToken = data['accessToken'];
        final refreshToken = data['refreshToken'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('accessToken', accessToken);
        prefs.setString('refreshToken', refreshToken);

        _navigateToHome();
      } else if (response.statusCode == 401) {
        _showPopup(context, Icons.error_outline, response.body);
      } else {
        throw Exception('Failed to log in');
      }
    } catch (e) {
      _showPopup(context, Icons.error_outline, 'Login Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder borderStyle = OutlineInputBorder(
      borderSide: BorderSide(color: blueShade),
    );

    final availableHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
        child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: availableHeight,
            ),
            child: IntrinsicHeight(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: blueShade,
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: borderStyle,
                    enabledBorder: borderStyle,
                    focusedBorder: borderStyle.copyWith(
                      borderSide: BorderSide(color: Colors.blue.shade700),
                    ),
                    prefixIcon: Icon(Icons.email, color: blueShade),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: borderStyle,
                    enabledBorder: borderStyle,
                    focusedBorder: borderStyle.copyWith(
                      borderSide: BorderSide(color: Colors.blue.shade700),
                    ),
                    prefixIcon: Icon(Icons.lock, color: blueShade),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _navigateToPasswordRecovery,
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(color: blueShade),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blueShade,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: _loginUser,
                  child: const Text('Sign In', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 50),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Divider(color: blueShade),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('or continue with',
                          style: TextStyle(color: blueShade)),
                    ),
                    Expanded(
                      child: Divider(color: blueShade),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: IconButton(
                        icon: Image.asset('lib/images/google.png',
                            width: 50, height: 50),
                        onPressed: () {},
                      ),
                    ),
                    Flexible(
                      child: IconButton(
                        icon: Image.asset('lib/images/apple.png',
                            width: 50, height: 50),
                        onPressed: () {},
                      ),
                    ),
                    Flexible(
                      child: IconButton(
                        icon: Image.asset('lib/images/facebook.png',
                            width: 50, height: 50),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: _navigateToRegister,
                  child: const Text(
                    "Don't have an account? Create one",
                    style: TextStyle(color: Colors.blue),
                  ),
                )
              ],
            ))));
  }
}
