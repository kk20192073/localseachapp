import 'dart:convert';
import 'package:http/http.dart' as http;

class NaverApiService {
  static const String _baseUrl =
      'https://openapi.naver.com/v1/search/local.json';
  final String clientId;
  final String clientSecret;

  NaverApiService({
    this.clientId = 'CPqLZ5WMXtR9h3kfF2ux',
    this.clientSecret = 'ib6uLDYoo5',
  });

  Future<List<dynamic>> searchLocal(String query, {int display = 10}) async {
    final url = Uri.parse(
      '$_baseUrl?query=${Uri.encodeQueryComponent(query)}&display=$display',
    );

    final response = await http.get(
      url,
      headers: {
        'X-Naver-Client-Id': clientId,
        'X-Naver-Client-Secret': clientSecret,
      },
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return jsonBody['items'] as List<dynamic>;
    } else {
      throw Exception('Failed to fetch data from Naver Open API');
    }
  }
}
