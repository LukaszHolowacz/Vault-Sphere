import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/navbar.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, String>> credentials = [
    {'site': 'amazon.pl', 'password': 'ABCabc123!!!'},
    {'site': 'ebay.com', 'password': 'Pass123!!!'},
    {'site': 'facebook.com', 'password': 'FBpass456!!'},
    {'site': 'twitter.com', 'password': 'Twit789!!'},
    {'site': 'instagram.com', 'password': 'Insta000!!!'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomNavigationBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: credentials.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(credentials[index]['site']!),
                  trailing:
                      PasswordField(password: credentials[index]['password']!),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  final String password;

  const PasswordField({Key? key, required this.password}) : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isObscured = true;

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.password));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Password copied to clipboard "),
      duration: Duration(seconds: 1),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isObscured)
          Text("•" * widget.password.length,
              style: Theme.of(context).textTheme.bodyText1),
        if (!_isObscured)
          Text(widget.password, style: Theme.of(context).textTheme.bodyText1),
        IconButton(
          icon: Icon(
            _isObscured ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isObscured = !_isObscured;
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.content_copy),
          onPressed: _copyToClipboard,
        ),
      ],
    );
  }
}
