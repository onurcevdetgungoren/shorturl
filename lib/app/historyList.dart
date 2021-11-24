import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shorturl/app/dataComing.dart';
import 'package:shorturl/app/dataError.dart';
import 'package:shorturl/app/emptyHistory.dart';
import 'package:shorturl/viewModel/urlHistory_viewModel.dart';

class HistoryList extends StatefulWidget {
  @override
  _HistoryListState createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  String _copiedUrl;
  double deviceWidth;
  double deviceHeight;
  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
      final  _urlHistoryViewModel = Provider.of<UrlHistoryViewModel>(context);
    return Container(
      color: Colors.grey.shade300,
      height: deviceHeight * 2.8 / 4,
      child: _urlHistoryViewModel.state == ViewState.Loaded
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, bottom: 10),
                  child: Text(
                    "Your link History",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _urlHistoryViewModel.urlHistoryList.length,
                    itemBuilder: (context, index) => _historyBox(
                        _urlHistoryViewModel.urlHistoryList[index].longUrl,
                        _urlHistoryViewModel.urlHistoryList[index].shortUrl,
                        _urlHistoryViewModel.urlHistoryList[index].urlID),
                  ),
                ),
              ],
            )
          : _urlHistoryViewModel.state == ViewState.Busy
              ? DataComing()
              : _urlHistoryViewModel.state == ViewState.Empty
                  ? EmptyHistory()
                  : DataError()
    );
  }

  Widget _historyBox(String _longUrl, String _shortUrl, int urlID) {
    final _urlHistoryViewModel =
        Provider.of<UrlHistoryViewModel>(context, listen: false);
    return Padding(
      padding: EdgeInsets.only(
        right: 20,
        left: 20,
      ),
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: deviceWidth * 3.1 / 4,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Expanded(
                        flex: 10,
                        child: Text(
                          _longUrl.length > 30
                              ? _longUrl.substring(0, 30) + "..."
                              : _longUrl,
                          maxLines: 1,
                          style: TextStyle(fontSize: 18),
                        )),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () async {
                          int a;
                          a = await _urlHistoryViewModel.deleteHistory(urlID);
                          if (a > 0) {
                            _showToast("Deleted Succesfully!");
                            _onLoading();
                          } else {
                            _showToast("Something went wrong!");
                          }
                        },
                        child: SvgPicture.asset(
                          "images/icons/del.svg",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 5),
                child: Divider(
                  color: Colors.grey.shade600,
                ),
              ),
              Container(
                width: deviceWidth * 3.1 / 4,
                child: Row(
                  children: [
                    Text(
                      _shortUrl,
                      maxLines: 1,
                      style: TextStyle(fontSize: 18, color: Colors.indigo),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 50,
                    width: deviceWidth * 3.1 / 4,
                    child: CupertinoButton(
                        color: _copiedUrl == _shortUrl
                            ? Colors.deepPurple.shade900
                            : Colors.tealAccent,
                        child: Text(
                          _copiedUrl == _shortUrl ? "COPIED!" : "COPY",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        onPressed: () async {
                          Clipboard.setData(ClipboardData(text: _shortUrl));

                          await Clipboard.getData('text/plain').then((value) {
                            setState(() {
                              _copiedUrl = value.text.toString();
                            });
                          });
                          print(_copiedUrl);
                        }),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


    _onLoading() async {
    final _urlHistoryViewModel =
        Provider.of<UrlHistoryViewModel>(context, listen: false);
    await _urlHistoryViewModel.getHistory();
  }

    void _showToast(String message) {
    showToast(message,
        duration: Duration(seconds: 2),
        curve: Curves.elasticOut,
        reverseCurve: Curves.elasticOut,
        context: context,
        axis: Axis.horizontal,
        alignment: Alignment.center,
        position: StyledToastPosition.center);
  }
}
