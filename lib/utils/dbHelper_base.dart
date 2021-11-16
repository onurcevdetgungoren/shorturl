import 'package:shorturl/model/urlHistory.dart';

abstract class DbHeplerBase {
  Future<List<Map<String, dynamic>>> getHistory();
  Future<int> deleteHistory(int urlID);
  Future<int> addHistory(UrlHistoryModel urlHistoryModel);
}
