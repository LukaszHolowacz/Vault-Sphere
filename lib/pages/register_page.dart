import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_page.dart';
import 'package:logging/logging.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: RegisterForm(),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _logger = Logger('RegisterUserLogger');
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final List<String> countryCodes = ['+1', '+48', '+44', '+91', '+81'];
  String selectedCountryCode = '+1';
  final Color blueShade = Colors.blue.shade400;

  void _navigateToLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
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
                _navigateToLogin();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _registerUser() async {
    final url = Uri.parse('http://192.168.0.21:3001/users/register');
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      "first_name": _firstNameController.text,
      "last_name": _lastNameController.text,
      "email": _emailController.text,
      "phone_number": selectedCountryCode + _phoneController.text,
      "birth_Date": _dateOfBirthController.text,
      "password": _passwordController.text,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 201) {
        _logger.info("User registered successfully");
        _showPopup(context, Icons.check_circle_outline,
            'Registration successful! You can now proceed to log in.');
      } else {
        _logger.warning("Failed to register user: ${response.body}");
        _showPopup(context, Icons.error_outline, 'Registration Failed');
      }
    } catch (e) {
      _logger.severe("Error connecting to the server: $e");
      _showPopup(context, Icons.error_outline, 'Connection Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder borderStyle = OutlineInputBorder(
      borderSide: BorderSide(color: blueShade),
    );

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 50),
            Text(
              "Create Account",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: blueShade,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      border: borderStyle,
                      enabledBorder: borderStyle,
                      focusedBorder: borderStyle.copyWith(
                        borderSide: BorderSide(color: Colors.blue.shade700),
                      ),
                      prefixIcon: Icon(Icons.person, color: blueShade),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      border: borderStyle,
                      enabledBorder: borderStyle,
                      focusedBorder: borderStyle.copyWith(
                        borderSide: BorderSide(color: Colors.blue.shade700),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
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
              validator: (value) {
                if (value!.isEmpty ||
                    !value.contains('@') ||
                    value.length > 255) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Country Code',
                      border: borderStyle,
                      enabledBorder: borderStyle,
                      focusedBorder: borderStyle.copyWith(
                        borderSide: BorderSide(color: Colors.blue.shade700),
                      ),
                    ),
                    value: selectedCountryCode,
                    items: countryCodes.map((String code) {
                      return DropdownMenuItem<String>(
                        value: code,
                        child: Text(code),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCountryCode = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  flex: 6,
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: borderStyle,
                      enabledBorder: borderStyle,
                      focusedBorder: borderStyle.copyWith(
                        borderSide: BorderSide(color: Colors.blue.shade700),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value!.isEmpty || value.length > 15) {
                        return 'Enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _dateOfBirthController,
              decoration: InputDecoration(
                labelText: 'Date Of Birth',
                border: borderStyle,
                enabledBorder: borderStyle,
                focusedBorder: borderStyle.copyWith(
                  borderSide: BorderSide(color: Colors.blue.shade700),
                ),
                prefixIcon: Icon(Icons.calendar_month, color: blueShade),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    _dateOfBirthController.text =
                        "${pickedDate.toLocal()}".split(' ')[0];
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
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
              validator: (value) {
                if (value!.isEmpty ||
                    value.length < 8 ||
                    value.length > 255 ||
                    !value.contains(RegExp(r'[A-Z]')) ||
                    !value.contains(RegExp(r'[a-z]')) ||
                    !value.contains(RegExp(r'[0-9]')) ||
                    !value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                  return 'Password must include at least 8 chars, a number, a special \n char, and a mix of upper and lower case letters.';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: borderStyle,
                enabledBorder: borderStyle,
                focusedBorder: borderStyle.copyWith(
                  borderSide: BorderSide(color: Colors.blue.shade700),
                ),
                prefixIcon: Icon(Icons.lock, color: blueShade),
              ),
              validator: (value) {
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: blueShade,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _registerUser();
                }
              },
              child: const Text('Sign Up', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _navigateToLogin,
              child: const Text(
                "Already have an account? Sign in",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
