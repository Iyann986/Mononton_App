import 'package:flutter/material.dart';
import 'package:mononton_app/api/auth_api.dart';
import 'package:mononton_app/models/movie_detail.dart';

enum FinishViewState {
  none,
  loading,
  error,
}

class FinishViewModel with ChangeNotifier {
  FinishViewState _state = FinishViewState.none;
  FinishViewState get state => _state;

  List<MovieDetail> _finish = [];
  List<MovieDetail> get finish => _finish;

  changeState(FinishViewState s) {
    _state = s;
    notifyListeners();
  }

  getMovieById(List id) async {
    changeState(FinishViewState.loading);
    try {
      for (int i = 0; i < id.length; i++) {
        final c = await AuthApi.getMovieDetail(id[i]);
        _finish.add(c);
        // notifyListeners();
      }
      notifyListeners();
      changeState(FinishViewState.none);
    } catch (e) {
      changeState(FinishViewState.error);
    }
  }
}
