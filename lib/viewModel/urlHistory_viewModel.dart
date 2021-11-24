import 'package:flutter/material.dart';
import 'package:shorturl/model/urlHistory.dart';
import 'package:shorturl/utils/databaseHelper.dart';
import 'package:shorturl/utils/dbHelper_base.dart';

enum ViewState { Idle, Loaded, Busy, Error, Empty }
enum ViewStateDelete { Idle, Busy, Loaded, Error }
enum ViewStateAdd { Idle, Busy, Loaded, Error }
enum ViewStateSearch { Idle, Busy, Loaded, Error }

class UrlHistoryViewModel with ChangeNotifier implements DbHeplerBase {
  ViewState _state = ViewState.Idle;
  ViewStateDelete _deleteState = ViewStateDelete.Idle;
  ViewStateAdd _addState = ViewStateAdd.Idle;
  ViewStateSearch _searchState = ViewStateSearch.Idle;
  int _delete;
  int _add;
  List<UrlHistoryModel> _urlHistoryList;
  DatabaseHelper _databaseHelper = DatabaseHelper();

  int get delete => _delete;
  int get add => _add;
  List<UrlHistoryModel> get urlHistoryList => _urlHistoryList;
  ViewState get state => _state;
  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  ViewStateDelete get deleteState => _deleteState;
  set deleteState(ViewStateDelete value) {
    _deleteState = value;
    notifyListeners();
  }

  ViewStateAdd get addState => _addState;
  set addState(ViewStateAdd value) {
    _addState = value;
    notifyListeners();
  }

    ViewStateSearch get searchState => _searchState;
  set searchState(ViewStateSearch value) {
    _searchState = value;
    notifyListeners();
  }

  @override
  Future<int> addHistory(UrlHistoryModel urlHistoryModel) async {
    try {
      addState = ViewStateAdd.Busy;
      _add = await _databaseHelper.addHistory(urlHistoryModel);
      addState = ViewStateAdd.Loaded;
    } catch (e) {
      print("Exception: " + e.toString());
      state = ViewState.Error;
    }
    return _add;
  }

  @override
  Future<List<UrlHistoryModel>> getHistory() async {
    try {
      state = ViewState.Busy;
      _urlHistoryList = await _databaseHelper.getHistory();
      if (_urlHistoryList.length != 0) {
        state = ViewState.Loaded;
      } else {
        state = ViewState.Empty;
      }

      print("BURADA STATE: " + state.toString());
    } catch (e) {
      print("Exception: " + e.toString());
      state = ViewState.Error;
    }
    return _urlHistoryList;
  }

  @override
  Future<int> deleteHistory(int urlID) async {
    try {
      deleteState = ViewStateDelete.Busy;
      _delete = await _databaseHelper.deleteHistory(urlID);
      deleteState = ViewStateDelete.Loaded;
    } catch (e) {
      print("Exception: " + e.toString());
      deleteState = ViewStateDelete.Error;
    }
    return _delete;
  }

  @override
  Future<bool> isInHistory(String url) async{
     try {
      searchState = ViewStateSearch.Busy;
      var value = await _databaseHelper.isInHistory(url);
      searchState = ViewStateSearch.Loaded;
      return value;
    } catch (e) {
      print("Exception: " + e.toString());
      searchState = ViewStateSearch.Error;
    }
    return false;
  }


}
