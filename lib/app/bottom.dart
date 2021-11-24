import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shorturl/model/urlHistory.dart';
import 'package:shorturl/viewModel/shortUrl_viewModel.dart';
import 'package:shorturl/viewModel/urlHistory_viewModel.dart';

class Bottom extends StatefulWidget {
  @override
  _BottomState createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  double deviceWidth;
  double deviceHeight;
  FocusNode focusNode = new FocusNode();
  String _textFieldLongUrl = " ";
  TextEditingController _longUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return Container(
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
                          color: _textFieldLongUrl == " " && !focusNode.hasFocus
                              ? Colors.white
                              : Colors.red,
                          width: 2),
                    ),
                    clearButtonMode: OverlayVisibilityMode.editing,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    // showCursor: false,
                    placeholder: _textFieldLongUrl == "" && !focusNode.hasFocus
                        ? 'Shorten a link here ...'
                        : "Please add a link here",
                    placeholderStyle: TextStyle(
                      color: _textFieldLongUrl == " " && !focusNode.hasFocus
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
                        _shorten();
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _shorten() async {
    final _urlHistoryViewModel =
        Provider.of<UrlHistoryViewModel>(context, listen: false);
    final _shortUrlViewModel =
        Provider.of<ShortUrlViewModel>(context, listen: false);
    if (_longUrlController.text.contains(".") && _textFieldLongUrl.length > 4) {
      var isInHistory =
          await _urlHistoryViewModel.isInHistory(_longUrlController.text);
      if (isInHistory) {
        _showToast("Url is Already in History");
        return;
      }
      await _shortUrlViewModel.shortUrl(_longUrlController.text);
      _urlHistoryViewModel
          .addHistory(UrlHistoryModel(
              longUrl: _longUrlController.text,
              shortUrl: _shortUrlViewModel.shortUrlModel.result.shortLink))
          .then((value) {
        if (value > 0) {
          _showToast("Request Succesful");
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
      _showToast("Entered Url is Not Valid");
    }
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
