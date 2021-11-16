import 'package:flutter/material.dart';
import 'package:shorturl/model/urlHistory.dart';
import 'package:shorturl/utils/databaseHelper.dart';
import 'package:shorturl/utils/dbHelper_base.dart';

enum ViewState { Idle, Loaded, Busy, Error, Empty }
enum ViewStateDelete { Idle, Busy, Loaded, Error }
enum ViewStateAdd { Idle, Busy, Loaded, Error }

class UrlHistoryViewModel with ChangeNotifier implements DbHeplerBase {
  ViewState _state = ViewState.Idle;
  ViewStateDelete _deleteState = ViewStateDelete.Idle;
  ViewStateAdd _addState = ViewStateAdd.Idle;
  int _delete;
  int _add;
  List<Map<String, dynamic>> _mapList;
  DatabaseHelper databaseHelper = DatabaseHelper();

  int get delete => _delete;
  int get add => _add;
  List<Map<String, dynamic>> get mapList => _mapList;
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

  @override
  Future<int> addHistory(UrlHistoryModel urlHistoryModel) async {
    try {
      addState = ViewStateAdd.Busy;
      _add = await databaseHelper.addHistory(urlHistoryModel);
      addState = ViewStateAdd.Loaded;
    } catch (e) {
      print("Exception: " + e.toString());
      state = ViewState.Error;
    }
    return _add;
  }

  @override
  Future<List<Map<String, dynamic>>> getHistory() async {
    try {
      state = ViewState.Busy;
      _mapList = await databaseHelper.getHistory();
      if (_mapList.length != 0) {
        state = ViewState.Loaded;
      } else {
        state = ViewState.Empty;
      }

      print("BURADA STATE: " + state.toString());
    } catch (e) {
      print("Exception: " + e.toString());
      state = ViewState.Error;
    }
    return _mapList;
  }

  @override
  Future<int> deleteHistory(int urlID) async {
    try {
      deleteState = ViewStateDelete.Busy;
      _delete = await databaseHelper.deleteHistory(urlID);
      deleteState = ViewStateDelete.Loaded;
    } catch (e) {
      print("Exception: " + e.toString());
      deleteState = ViewStateDelete.Error;
    }
    return _delete;
  }
}
