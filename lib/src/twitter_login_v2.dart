import 'dart:async';

import 'package:twitter_login_v2/schemes/access_token_v2.dart';
import 'package:twitter_login_v2/schemes/authorization_code_v2.dart';


class TwitterLoginV2 {
  /// Oauth Client Id
  final String clientId;

  /// Callback URL
  final String redirectURI;

  /// Scopes
  final List<String> scopes;

  /// constructor
  TwitterLoginV2({
    required this.clientId,
    required this.redirectURI,
    this.scopes = const ["users.read","tweet.read","follows.read"]
  }) {
    if (this.clientId.isEmpty) {
      throw Exception('clientId is empty');
    }
    if (this.redirectURI.isEmpty) {
      throw Exception('redirectURI is empty');
    }

    print('scopes rcvd: $scopes');

  }

  Future<AccessTokenV2> loginV2({bool forceLogin = false}) async {
    final authorizationCode = await AuthorizationCodeV2.getAuthorizationCode(
        clientId: clientId, redirectURI: redirectURI, scopes: scopes);

    return await AccessTokenV2.getAccessToken(
      clientId: clientId,
      authorizationCode: authorizationCode.code,
      codeVerifier: authorizationCode.codeVerifier,
      redirectURI: redirectURI,
    );
  }
}
