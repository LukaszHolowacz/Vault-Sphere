import 'package:flutter/material.dart';
import '../components/navbar.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomNavigationBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 1000,
              color: Colors.white,
              child: const Center(
                child: Text(
                  'Przewijalna treść',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
