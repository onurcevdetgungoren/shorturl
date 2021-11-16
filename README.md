
SHORTURL APP

This is URL Shortening App. Developed with Flutter. integrated the shortcode API. 

(Note: Run this project in flutter version 1.22.6)


EXPLANATION

This project designed with MVVM pattern and used Provider package for State Management. 

There is an abstract class in Service document which is used for creating http and viewModel functions. In viewModel and Network classes, applied abstract classes and functions. Used http library for http request and local storage with sqflite for URL records. 

Created a table which is include urldd, shortUrl and longUrl in sqFlite and records are adding into this table.There is a dbHelper_base abstract class in Utils document which is used for functions belongs to databaseHelper and viewModel. dbHelper_base abstract class implemented in these class.

All states designed and set in viewmodel.

Created model classes for api and local database datas in Model document.



The following libraries were used


 * get_it: ^5.0.1 => This is a simple service locator for Dart and Flutter projects with some additional goodies highly inspired by Splat. It can be used instead of InheritedWidget or Provider to access objects e.g. from your UI

 * provider: ^4.3.2+2 => This is for state management

 * flutter_svg: ^0.19.1 => Used for assets with svg extension

 * sqflite: ^1.3.2+3 => Used for local database

 * path_provider: ^1.6.27 => A Flutter plugin for finding commonly used locations on the filesystem. This used for local database

 * flutter_styled_toast: ^1.5.2+3 => Used for toast messages

 * http: ^0.12.2 => Used for http request 

