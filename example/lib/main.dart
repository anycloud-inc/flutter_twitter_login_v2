import 'package:flutter/material.dart';
import 'package:twitter_login_v2/twitter_login_v2.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('twitter_login example app'),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: TextButton(
              child: Text('use Twitter API v2.0'),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blueAccent),
                minimumSize: MaterialStateProperty.all<Size>(Size(160, 48)),
              ),
              onPressed: () async {
                await loginV2();
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Use Twitter API v2.
  Future loginV2() async {
    final twitterLogin = TwitterLoginV2(
      /// Consumer API keys
      clientId: const String.fromEnvironment("CLIENT_ID"),

      /// Registered Callback URLs in TwitterApp
      /// Android is a deeplink
      /// iOS is a URLScheme
      redirectURI: const String.fromEnvironment("REDIRECT_URI"),
    );

    /// Forces the user to enter their credentials
    /// to ensure the correct users account is authorized.
    /// If you want to implement Twitter account switching, set [force_login] to true
    /// login(forceLogin: true);
    try {
      final accessToken = await twitterLogin.loginV2();
      print('login successed');
      print(accessToken.toJson());
    } catch (e) {
      print('login failed');
      print(e);
    }
  }
}
