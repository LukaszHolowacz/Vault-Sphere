import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TokenManager {
  static const String _apiUrl = 'http://192.168.0.21:3001/users/refresh';
  Timer? _timer;

  Future<void> startRefreshTokenTimer() async {
    const duration = Duration(minutes: 15);
    _timer?.cancel();
    _timer = Timer.periodic(duration, (Timer t) => refreshToken());
  }

  Future<void> refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String refreshToken = prefs.getString('refreshToken') ?? '';

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        body: jsonEncode(<String, String>{
          'refreshToken': refreshToken,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final accessToken = data['accessToken'];
        final newRefreshToken = data['refreshToken'];

        await prefs.setString('accessToken', accessToken);
        await prefs.setString('refreshToken', newRefreshToken);
      } else {
        // Tutaj można dodać logikę obsługi innych kodów statusu HTTP
      }
    } catch (e) {
      // Tutaj można dodać obsługę wyjątków, np. logowanie błędów
    }
  }

  void dispose() {
    _timer?.cancel();
  }
}
