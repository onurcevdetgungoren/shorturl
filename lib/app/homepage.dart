import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shorturl/app/bottom.dart';
import 'package:shorturl/app/dataComing.dart';
import 'package:shorturl/app/dataError.dart';
import 'package:shorturl/app/historyList.dart';
import 'package:shorturl/viewModel/shortUrl_viewModel.dart';
import 'package:shorturl/viewModel/urlHistory_viewModel.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  double deviceWidth;
  double deviceHeight;
  UrlHistoryViewModel _urlHistoryViewModel;
  ShortUrlViewModel _shortUrlViewModel;
  FocusNode focusNode;
  @override
  void initState() {
    focusNode = new FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) => _onLoading());
    super.initState();
  }

  _onLoading() async {
    _urlHistoryViewModel =
        Provider.of<UrlHistoryViewModel>(context, listen: false);
    await _urlHistoryViewModel.getHistory();
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
              ? DataComing()
              : _shortUrlViewModel.state == ShortUrlViewState.Error
                  ? DataError()
                  : HistoryList(),
          Bottom(),
        ],
      ),
    );
  }
}
