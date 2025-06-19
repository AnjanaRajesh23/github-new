import 'chess_game_page.dart'; // Make sure this path is correct
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

const LICHESS_CLIENT_ID = 'lichess.org'; // Public client
const REDIRECT_URI = 'com.example.lichessapp://oauthredirect';
const LICHESS_OAUTH_AUTHORIZE = 'https://lichess.org/oauth';
const LICHESS_API = 'https://lichess.org/api';

final FlutterAppAuth appAuth = FlutterAppAuth();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lichess Login',
      home: LichessLoginPage(),
    );
  }
}

class LichessLoginPage extends StatefulWidget {
  @override
  _LichessLoginPageState createState() => _LichessLoginPageState();
}

class _LichessLoginPageState extends State<LichessLoginPage> {
  String? username;
  int? blitzRating;
  String? accessToken;

  Future<void> loginWithLichess() async {
    try {
      final result = await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          'lichess-org',
          'com.example.lichessapp://oauthredirect',
          serviceConfiguration: AuthorizationServiceConfiguration(
            authorizationEndpoint: 'https://lichess.org/oauth',
            tokenEndpoint: 'https://lichess.org/api/token',
          ),
          scopes: ['preference:read'],
        ),
      );

      if (result != null) {
        final token = result.accessToken;
        final userInfo = await fetchUserInfo(token!);

        setState(() {
          username = userInfo['username'];
          blitzRating = userInfo['perfs']?['blitz']?['rating'];
          accessToken = token;
        });
      }
    } catch (e) {
      print('Error during login: $e');
    }
  }

  Future<Map<String, dynamic>> fetchUserInfo(String accessToken) async {
    final response = await http.get(
      Uri.parse('$LICHESS_API/account'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch user info');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login with Lichess')),
      body: Center(
        child: username == null
            ? ElevatedButton(
          onPressed: loginWithLichess,
          child: Text('Login with Lichess'),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello, $username!'),
            Text('Blitz Rating: $blitzRating'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChessGamePage(
                      accessToken: accessToken!,
                    ),
                  ),
                );
              },
              child: Text('Play Game'),
            ),
          ],
        ),
      ),
    );
  }
}
