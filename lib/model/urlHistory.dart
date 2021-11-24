// To parse this JSON data, do
//
//     final urlHistoryModel = urlHistoryModelFromMap(jsonString);
class UrlHistoryModel {
  UrlHistoryModel({this.longUrl, this.shortUrl});
  UrlHistoryModel.withID({this.urlID, this.longUrl, this.shortUrl});

  int urlID;
  String longUrl;
  String shortUrl;

  UrlHistoryModel.fromMap(Map<String, dynamic> map) {
    this.urlID = map['urlID'];
    this.longUrl = map['longUrl'];
    this.shortUrl = map['shortUrl'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['urlID'] = urlID;
    map['longUrl'] = longUrl;
    map['shortUrl'] = shortUrl;

    return map;
  }
}
