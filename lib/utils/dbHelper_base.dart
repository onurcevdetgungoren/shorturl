import 'package:shorturl/model/urlHistory.dart';

abstract class DbHeplerBase {
  Future<List<UrlHistoryModel>> getHistory();
  Future<int> deleteHistory(int urlID);
  Future<int> addHistory(UrlHistoryModel urlHistoryModel);
  Future<bool> isInHistory(String url);
}
