import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shorturl/app/homepage.dart';
import 'package:shorturl/locator.dart';
import 'package:shorturl/viewModel/shortUrl_viewModel.dart';
import 'package:shorturl/viewModel/urlHistory_viewModel.dart';

void main() async {
  setupLocator();
  runApp(MultiProvider(providers: [
    //1 den fazla Provider kullanacağımız için MultiProvider oluşturduk
    (ChangeNotifierProvider<UrlHistoryViewModel>(
      create: (context) => UrlHistoryViewModel(),
    )),
    (ChangeNotifierProvider<ShortUrlViewModel>(
      create: (context) => ShortUrlViewModel(),
    )),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Short Url Challenge',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Homepage(),
    );
  }
}
