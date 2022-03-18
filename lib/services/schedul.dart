import 'dart:async';
import 'package:flutter/foundation.dart';

class Schedule with ChangeNotifier{
  bool _removeAll = false;
  int _len = 0;

  bool get isRemoveAllActive => _removeAll;
  int get len=>_len;

  set changeRemoveAllStatuse(bool removeall){
    _removeAll = removeall;
    notifyListeners();
    Timer(const Duration(milliseconds: 100), (){_removeAll = false;});
    
  }

  set changeLen(int len){
    _len = len;
  }

  String _pageName = '';
  bool _didNameChange = false;
  String get pageName => _pageName;
  bool get didNameChange => _didNameChange;
  set pageNameSet(String newName){
    _pageName = newName;
    
  }
  set changeNameStatus(bool status){
    _didNameChange = status;
    notifyListeners();
    Timer(const Duration(milliseconds: 100), (){
      _didNameChange = false;
    });
  }
}