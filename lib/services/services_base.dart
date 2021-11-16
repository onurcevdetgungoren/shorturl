import 'package:shorturl/model/shortUrl_model.dart';

abstract class ServicesBase {
  Future<ShortUrlModel> shortUrl(String url);
}
