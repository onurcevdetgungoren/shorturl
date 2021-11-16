// To parse this JSON data, do
//
//     final shortUrlModel = shortUrlModelFromMap(jsonString);

import 'dart:convert';

ShortUrlModel shortUrlModelFromMap(String str) => ShortUrlModel.fromMap(json.decode(str));

String shortUrlModelToMap(ShortUrlModel data) => json.encode(data.toMap());

class ShortUrlModel {
    ShortUrlModel({
        this.ok,
        this.result,
    });

    bool ok;
    Result result;

    factory ShortUrlModel.fromMap(Map<String, dynamic> json) => ShortUrlModel(
        ok: json["ok"] == null ? null : json["ok"],
        result: json["result"] == null ? null : Result.fromMap(json["result"]),
    );

    Map<String, dynamic> toMap() => {
        "ok": ok == null ? null : ok,
        "result": result == null ? null : result.toMap(),
    };
}

class Result {
    Result({
        this.code,
        this.shortLink,
        this.fullShortLink,
        this.shortLink2,
        this.fullShortLink2,
        this.shortLink3,
        this.fullShortLink3,
        this.shareLink,
        this.fullShareLink,
        this.originalLink,
    });

    String code;
    String shortLink;
    String fullShortLink;
    String shortLink2;
    String fullShortLink2;
    String shortLink3;
    String fullShortLink3;
    String shareLink;
    String fullShareLink;
    String originalLink;

    factory Result.fromMap(Map<String, dynamic> json) => Result(
        code: json["code"] == null ? null : json["code"],
        shortLink: json["short_link"] == null ? null : json["short_link"],
        fullShortLink: json["full_short_link"] == null ? null : json["full_short_link"],
        shortLink2: json["short_link2"] == null ? null : json["short_link2"],
        fullShortLink2: json["full_short_link2"] == null ? null : json["full_short_link2"],
        shortLink3: json["short_link3"] == null ? null : json["short_link3"],
        fullShortLink3: json["full_short_link3"] == null ? null : json["full_short_link3"],
        shareLink: json["share_link"] == null ? null : json["share_link"],
        fullShareLink: json["full_share_link"] == null ? null : json["full_share_link"],
        originalLink: json["original_link"] == null ? null : json["original_link"],
    );

    Map<String, dynamic> toMap() => {
        "code": code == null ? null : code,
        "short_link": shortLink == null ? null : shortLink,
        "full_short_link": fullShortLink == null ? null : fullShortLink,
        "short_link2": shortLink2 == null ? null : shortLink2,
        "full_short_link2": fullShortLink2 == null ? null : fullShortLink2,
        "short_link3": shortLink3 == null ? null : shortLink3,
        "full_short_link3": fullShortLink3 == null ? null : fullShortLink3,
        "share_link": shareLink == null ? null : shareLink,
        "full_share_link": fullShareLink == null ? null : fullShareLink,
        "original_link": originalLink == null ? null : originalLink,
    };
}
