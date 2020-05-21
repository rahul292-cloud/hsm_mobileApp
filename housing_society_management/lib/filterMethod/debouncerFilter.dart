import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action){
    if(null != _timer){
      _timer.cancel();
    }
    _timer = Timer(Duration(microseconds: milliseconds), action);
  }


}