import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomNavigationBar extends StatelessWidget
    implements PreferredSizeWidget {
  Future<void> _onLogout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('accessToken');
    prefs.remove('refreshToken');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'lib/images/logo.webp',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          PopupMenuButton(
            icon: Icon(Icons.menu,
                color: Colors.blue.shade400,
                size: 35), // Zmieniona ikonka na trzy poziome paski
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                value: 'account',
                child: Row(
                  children: [
                    Icon(
                      Icons.account_circle,
                      color: Colors.blue.shade400,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Account',
                      style: TextStyle(color: Colors.blue.shade400),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'subscriptions',
                child: Row(
                  children: [
                    Icon(
                      Icons.subscriptions,
                      color: Colors.blue.shade400,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Subscriptions',
                      style: TextStyle(color: Colors.blue.shade400),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(
                      Icons.settings,
                      color: Colors.blue.shade400,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Settings',
                      style: TextStyle(color: Colors.blue.shade400),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'contact_support',
                child: Row(
                  children: [
                    Icon(
                      Icons.contact_support,
                      color: Colors.blue.shade400,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Contact Support',
                      style: TextStyle(color: Colors.blue.shade400),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.blue.shade400,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Logout',
                      style: TextStyle(color: Colors.blue.shade400),
                    ),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'logout') {
                _onLogout(
                    context); // Wywołanie funkcji _onLogout po wybraniu opcji Logout
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
