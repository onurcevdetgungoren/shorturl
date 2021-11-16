import 'dart:convert';
import 'package:shorturl/model/shortUrl_model.dart';
import 'package:shorturl/services/services_base.dart';
import 'package:http/http.dart' as http;

class ServicesClient implements ServicesBase {
  final String baseURL = "https://api.shrtco.de/v2/shorten?url=";
  final http.Client httpClient = http.Client();
  @override
  Future<ShortUrlModel> shortUrl(String url) async {
    ShortUrlModel _data;
    String newUrl = baseURL + url;
    try {
      final response = await httpClient.get(newUrl);
      _data = ShortUrlModel.fromMap(jsonDecode(response.body));
    } catch (e) {
      throw e;
    }
    return _data;
  }
}
