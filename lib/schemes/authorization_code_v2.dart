import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:twitter_login_v2/src/auth_browser.dart';
import 'package:twitter_login_v2/src/utils.dart';

import '../twitter_login_v2.dart';

class AuthorizationCodeV2 {
  static const _channel = MethodChannel('twitter_login');
  static final _eventChannel = EventChannel('twitter_login/event');
  static final Stream<dynamic> _eventStream =
      _eventChannel.receiveBroadcastStream();

  final String code;
  final String codeVerifier;

  AuthorizationCodeV2({required this.code, required this.codeVerifier});

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'codeVerifier': codeVerifier,
    };
  }

  static Future<AuthorizationCodeV2> getAuthorizationCode({
    required String clientId,
    required String redirectURI,
    List<String> scopes = const ["users.read","tweet.read","follows.read"]
  }) async {
    final state = createCryptoRandomString();
    final codeVerifier = createCryptoRandomString();
    final resultURI = await _doRequest(
      clientId: clientId,
      redirectURI: redirectURI,
      state: state,
      codeVerifier: codeVerifier,
      scopes: scopes
    );

    if (resultURI?.isEmpty ?? true) {
      throw CanceledByUserException();
    }

    final queries = Uri.splitQueryString(Uri.parse(resultURI!).query);
    if (queries['error'] != null) {
      throw Exception('Error Response: ${queries['error']}');
    }

    // The user cancelled the login flow.
    if (queries['denied'] != null) {
      throw CanceledByUserException();
    }

    final authorizationCode = queries['code'];
    final resultState = queries['state'];
    if (resultState != state) {
      throw Exception('Error: Invalid state');
    }
    if (authorizationCode == null) {
      throw Exception('Error: No authorization code found');
    }
    return AuthorizationCodeV2(
      code: authorizationCode,
      codeVerifier: codeVerifier,
    );
  }

  /// twitter側でログイン、以下のようなURLを戻す
  /// https://www.example.com?state=state&code=VGNibzFWSWREZm01bjN1N3dicWlNUG1oa2xRRVNNdmVHelJGY2hPWGxNd2dxOjE2MjIxNjA4MjU4MjU6MToxOmFjOjE
  static Future<String?> _doRequest({
    required String clientId,
    required String redirectURI,
    required String state,
    required String codeVerifier,
    required List<String> scopes
  }) async {
    String? resultURI;
    final scheme = Uri.parse(redirectURI).scheme;
    final completer = Completer<String?>();
    late StreamSubscription subscribe;

    if (Platform.isAndroid) {
      await _channel.invokeMethod('setScheme', scheme);
      subscribe = _eventStream.listen((data) async {
        if (data['type'] == 'url') {
          if (!completer.isCompleted) {
            completer.complete(data['url']?.toString());
          } else {
            throw CanceledByUserException();
          }
        }
      });
    }

    final scopeUrl = scopes.where((scope) => isValidScope(scope: scope)).join('+');

    if (scopeUrl.length == 0)
      throw new NoValidScopeSpecified();

    final authorizeURI = '$AUTHORIZE_URI'
        '?response_type=code'
        '&client_id=$clientId'
        '&redirect_uri=$redirectURI'
        '&scope=$scopeUrl'
        '&state=$state'
        '&code_challenge=$codeVerifier'
        '&code_challenge_method=plain';

    final authBrowser = AuthBrowser(
      onClose: () {
        if (!completer.isCompleted) {
          completer.complete(null);
        }
      },
    );

    if (Platform.isIOS) {
      /// Login to Twitter account with SFAuthenticationSession or ASWebAuthenticationSession.
      resultURI = await authBrowser.doAuth(authorizeURI, scheme);
    } else if (Platform.isAndroid) {
      // Login to Twitter account with chrome_custom_tabs.
      final success = await authBrowser.open(authorizeURI, scheme);
      if (!success) {
        throw PlatformException(
          code: '200',
          message:
              'Could not open browser, probably caused by unavailable custom tabs.',
        );
      }
      resultURI = await completer.future;
      subscribe.cancel();
    } else {
      throw PlatformException(
        code: '100',
        message: 'Not supported by this os.',
      );
    }
    return resultURI;
  }
}
