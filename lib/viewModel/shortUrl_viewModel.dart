import 'package:flutter/material.dart';
import 'package:shorturl/locator.dart';
import 'package:shorturl/model/shortUrl_model.dart';
import 'package:shorturl/services/services_base.dart';
import 'package:shorturl/services/services_client.dart';

enum ShortUrlViewState { Idle, Loaded, Busy, Error }

class ShortUrlViewModel with ChangeNotifier implements ServicesBase {
  ShortUrlViewState _state = ShortUrlViewState.Idle;
  ServicesClient _servicesClient = locator<ServicesClient>();
  ShortUrlModel _shortUrlModel;

  ShortUrlModel get shortUrlModel => _shortUrlModel;
  ShortUrlViewState get state => _state;
  set state(ShortUrlViewState value) {
    _state = value;
    notifyListeners();
  }

  @override
  Future<ShortUrlModel> shortUrl(String url) async {
    try {
      state = ShortUrlViewState.Busy;
      _shortUrlModel = await _servicesClient.shortUrl(url);
      state = ShortUrlViewState.Loaded;
    } catch (e) {
      print("Exception: " + e.toString());
      state = ShortUrlViewState.Error;
    }
    return _shortUrlModel;
  }
}
