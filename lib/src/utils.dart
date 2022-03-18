import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;

const AUTHORIZE_URI = 'https://twitter.com/i/oauth2/authorize';

const ACCESS_TOKEN_URI = 'https://api.twitter.com/2/oauth2/token';

/// send http request
Future<Map<String, dynamic>>? httpPost(
  String url,
  Map<String, dynamic> params,
) async {
  final http.Client _httpClient = http.Client();
  final http.Response res = await _httpClient.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': "application/x-www-form-urlencoded"
    },
    body: params,
  );
  if (res.statusCode != 200) {
    throw HttpException("Failed ${res.reasonPhrase}: ${res.body}");
  }

  return jsonDecode(res.body);
}

String createCryptoRandomString([int length = 8]) {
  var values = List<int>.generate(length, (i) => Random.secure().nextInt(256));

  return base64Url.encode(values);
}

extension MapExt on Map {
  T? get<T>(String key) => this.containsKey(key) ? this[key] as T : null;
}
