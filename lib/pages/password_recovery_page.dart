import 'package:flutter/material.dart';

class PasswordRecoveryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: PasswordRecoveryForm(),
      ),
    );
  }
}

class PasswordRecoveryForm extends StatefulWidget {
  @override
  _PasswordRecoveryFormState createState() => _PasswordRecoveryFormState();
}

class _PasswordRecoveryFormState extends State<PasswordRecoveryForm> {
  final _emailController = TextEditingController();
  final Color blueShade = Colors.blue.shade400;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder borderStyle = OutlineInputBorder(
      borderSide: BorderSide(color: blueShade),
    );

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
          Text(
            "Recover Password",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: blueShade,
            ),
          ),
          const SizedBox(height: 30),
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
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: blueShade,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {
              // Logika odzyskiwania hasła zostanie dodana później
            },
            child: const Text('Proceed', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
