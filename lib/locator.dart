import 'package:get_it/get_it.dart';
import 'package:shorturl/services/services_client.dart';
import 'package:shorturl/viewModel/shortUrl_viewModel.dart';
import 'package:shorturl/viewModel/urlHistory_viewModel.dart';

GetIt locator = GetIt.instance;
void setupLocator() {
  locator.registerLazySingleton(() => ServicesClient());
  locator.registerLazySingleton(() => UrlHistoryViewModel());
  locator.registerLazySingleton(() => ShortUrlViewModel());
}
