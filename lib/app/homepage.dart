import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shorturl/model/urlHistory.dart';
import 'package:shorturl/utils/databaseHelper.dart';
import 'package:shorturl/viewModel/shortUrl_viewModel.dart';
import 'package:shorturl/viewModel/urlHistory_viewModel.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String _textFieldLongUrl = " ";
  TextEditingController _longUrlController = TextEditingController();
  double deviceWidth;
  double deviceHeight;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> _mapList;
  List<UrlHistoryModel> _urlHistoryModel;
  UrlHistoryViewModel _urlHistoryViewModel;
  ShortUrlViewModel _shortUrlViewModel;
  String _copiedUrl;
  FocusNode focusNode;
  @override
  void initState() {
    // TODO: implement initState
    focusNode = new FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) => _onLoading());
    super.initState();
  }

  _onLoading() async {
    _urlHistoryViewModel =
        Provider.of<UrlHistoryViewModel>(context, listen: false);
    _urlHistoryModel = List<UrlHistoryModel>();
    _mapList = await _urlHistoryViewModel.getHistory();
    if (_mapList.length > 0) {
      for (Map<String, dynamic> a in _mapList) {
        _urlHistoryModel.add(UrlHistoryModel.fromMap(a));
        print(_urlHistoryModel[0].longUrl);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _urlHistoryViewModel = Provider.of<UrlHistoryViewModel>(context);
    _shortUrlViewModel = Provider.of<ShortUrlViewModel>(context);
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: ListView(
        children: [
          _shortUrlViewModel.state == ShortUrlViewState.Busy
              ? dataComing()
              : _shortUrlViewModel.state == ShortUrlViewState.Error
                  ? dataError()
                  : Container(
                      color: Colors.grey.shade300,
                      height: deviceHeight * 2.8 / 4,
                      child: _urlHistoryViewModel.state == ViewState.Loaded
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 40.0, bottom: 10),
                                  child: Text(
                                    "Your link History",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: _urlHistoryModel.length,
                                    itemBuilder: (context, index) =>
                                        _historyBox(
                                            _urlHistoryModel[index].longUrl,
                                            _urlHistoryModel[index].shortUrl,
                                            _urlHistoryModel[index].urlID),
                                  ),
                                ),
                              ],
                            )
                          : _urlHistoryViewModel.state == ViewState.Busy
                              ? dataComing()
                              : _urlHistoryViewModel.state == ViewState.Empty
                                  ? Container(
                                      color: Colors.grey.shade200,
                                      height: deviceHeight * 2.8 / 4,
                                      // color: Colors.red,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SvgPicture.asset(
                                            "images/icons/logo.svg",
                                          ),
                                          SvgPicture.asset(
                                            "images/icons/illustration.svg",
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "Let's Get Started!",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Text(
                                                  "Paste your first link into \n  the field to shorten it",
                                                  style: TextStyle(
                                                    fontSize: 21,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : dataError(),
                    ),
          Container(
            height: deviceHeight * 1.2 / 4,
            color: Colors.deepPurple.shade700,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: SvgPicture.asset(
                    "images/icons/shape.svg",
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        height: 60,
                        width: deviceWidth * 3.1 / 4,
                        child: CupertinoTextField(
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          focusNode: focusNode,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: _textFieldLongUrl == " " &&
                                        !focusNode.hasFocus
                                    ? Colors.white
                                    : Colors.red,
                                width: 2),
                          ),
                          clearButtonMode: OverlayVisibilityMode.editing,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          // showCursor: false,
                          placeholder:
                              _textFieldLongUrl == "" && !focusNode.hasFocus
                                  ? 'Shorten a link here ...'
                                  : "Please add a link here",
                          placeholderStyle: TextStyle(
                            color:
                                _textFieldLongUrl == " " && !focusNode.hasFocus
                                    ? Colors.grey.shade500
                                    : Colors.red,
                          ),
                          onChanged: (s) {
                            setState(() {
                              _textFieldLongUrl = s;
                            });
                          },
                          cursorHeight: 20,
                          controller: _longUrlController,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        height: 60,
                        width: deviceWidth * 3.1 / 4,
                        child: CupertinoButton(
                            color: Colors.tealAccent,
                            child: Text(
                              "SHORTEN IT!",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            onPressed: () async {
                              if (_longUrlController.text.contains(".") && _textFieldLongUrl.length > 4) {
                                await _shortUrlViewModel
                                    .shortUrl(_longUrlController.text);
                                // print("BURADA!!!" + _shortUrlViewModel
                                //     .shortUrlModel.result.shortLink);
                                _urlHistoryViewModel
                                    .addHistory(UrlHistoryModel(
                                        longUrl: _longUrlController.text,
                                        shortUrl: _shortUrlViewModel
                                            .shortUrlModel.result.shortLink))
                                    .then((value) {
                                  if (value > 0) {
                                    showToast("Request Successful",
                                        duration: Duration(seconds: 2),
                                        curve: Curves.elasticOut,
                                        reverseCurve: Curves.elasticOut,
                                        context: context,
                                        axis: Axis.horizontal,
                                        alignment: Alignment.center,
                                        position: StyledToastPosition.center);
                                    setState(() {
                                      _textFieldLongUrl = " ";
                                      focusNode.unfocus();
                                    });
                                    _onLoading();
                                  }
                                });
                              } else {
                                setState(() {
                                  _textFieldLongUrl = "";
                                });
                                showToast("Entered url is not valid",
                                    duration: Duration(seconds: 2),
                                    curve: Curves.elasticOut,
                                    reverseCurve: Curves.elasticOut,
                                    context: context,
                                    axis: Axis.horizontal,
                                    alignment: Alignment.center,
                                    position: StyledToastPosition.center);
                              }
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _historyBox(String _longUrl, String _shortUrl, int urlID) {
    _urlHistoryViewModel =
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
                            showToast("Deleted Successfully!",
                                duration: Duration(seconds: 2),
                                curve: Curves.elasticOut,
                                reverseCurve: Curves.elasticOut,
                                context: context,
                                axis: Axis.horizontal,
                                alignment: Alignment.center,
                                position: StyledToastPosition.center);
                            _onLoading();
                          } else {
                            showToast("Something went wrong",
                                duration: Duration(seconds: 2),
                                curve: Curves.elasticOut,
                                reverseCurve: Curves.elasticOut,
                                context: context,
                                axis: Axis.horizontal,
                                alignment: Alignment.center,
                                position: StyledToastPosition.center);
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

  dataComing() {
    return Container(
      height: deviceHeight * 2.8 / 4,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color:
              Color.fromRGBO(170, 200, 220, 0.3) //  SOFT LAYER FOR OCEAN THEME
          ),
      child: Center(
          // child: CircularProgressIndicator(),
          child: CircularProgressIndicator(
              backgroundColor: Colors.transparent,
              strokeWidth: deviceHeight * 0.0035,
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromRGBO(50, 100, 220, 0.8)))),
    );
  }

  dataError() {
    return Container(
      height: deviceHeight * 2.8 / 4,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color:
              Color.fromRGBO(170, 200, 220, 0.3) //  SOFT LAYER FOR OCEAN THEME
          ),
      child: Center(
          // child: CircularProgressIndicator(),
          child: CircularProgressIndicator(
              backgroundColor: Colors.transparent,
              strokeWidth: deviceHeight * 0.0035,
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromRGBO(50, 100, 220, 0.8)))),
    );
  }
}
