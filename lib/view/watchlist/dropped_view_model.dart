import 'package:flutter/material.dart';
import 'package:mononton_app/api/auth_api.dart';
import 'package:mononton_app/models/movie_detail.dart';

enum DroppedViewState {
  none,
  loading,
  error,
}

class DroppedViewModel with ChangeNotifier {
  DroppedViewState _state = DroppedViewState.none;
  DroppedViewState get state => _state;

  List<MovieDetail> _dropped = [];
  List<MovieDetail> get dropped => _dropped;

  changeState(DroppedViewState s) {
    _state = s;
    notifyListeners();
  }

  getMovieById(List id) async {
    changeState(DroppedViewState.loading);
    try {
      for (int i = 0; i < id.length; i++) {
        final c = await AuthApi.getMovieDetail(id[i]);
        _dropped.add(c);
        // notifyListeners();
      }
      notifyListeners();
      changeState(DroppedViewState.none);
    } catch (e) {
      changeState(DroppedViewState.error);
    }
  }
}
