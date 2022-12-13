import 'package:flutter_test/flutter_test.dart';
import 'package:twitter_login_v2/twitter_login_v2.dart';

void main() {
  // TestWidgetsFlutterBinding.ensureInitialized();

  test("testing the url creation", () {
    final twitterLogin = TwitterLoginV2(
        clientId: "XXXXXXXXX",
        redirectURI: "https://abc.com",
        scopes: ["tweet.read", "tweet.write", "follows.read", "follows.write", "users.read","offline.access"]
    );

    final accessToken = twitterLogin.loginV2();

    accessToken.then((value) {
      print(value.accessToken);
    }).onError((error, stackTrace) {
      print(error);
      print(stackTrace.toString());
    });
  });
}

