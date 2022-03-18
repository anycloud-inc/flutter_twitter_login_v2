
import 'package:twitter_login_v2/src/utils.dart';

/// The access token for Twitter API.
class AccessTokenV2 {
  final String? tokenType;
  final int? expiresIn;
  final String? accessToken;
  final String? scope;

  AccessTokenV2(Map<String, dynamic> params)
      : this.tokenType = params.get<String>('token_type'),
        this.expiresIn = params.get<int>('expires_in'),
        this.accessToken = params.get<String>('access_token'),
        this.scope = params.get<String>('scope');

  Map<String, dynamic> toJson() {
    return {
      'tokenType': tokenType,
      'expiresIn': expiresIn,
      'accessToken': accessToken,
      'scope': scope,
    };
  }

  static Future<AccessTokenV2> getAccessToken({
    required String clientId,
    required String authorizationCode,
    required String codeVerifier,
    required String redirectURI,
  }) async {
    final body = {
      "grant_type": "authorization_code",
      "client_id": clientId,
      "code": authorizationCode,
      "redirect_uri": redirectURI,
      "code_verifier": codeVerifier,
    };
    final params = await httpPost(
      ACCESS_TOKEN_URI,
      body,
    );
    if (params == null) {
      throw Exception('Unexpected Response');
    }
    return AccessTokenV2(params);
  }
}
