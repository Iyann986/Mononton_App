import 'package:flutter/material.dart';
import 'package:mononton_app/api/auth_api.dart';
import 'package:mononton_app/models/movie_detail.dart';

enum DetailViewState {
  none,
  loading,
  error,
}

class DetailViewModel with ChangeNotifier {
  DetailViewState _state = DetailViewState.none;
  DetailViewState get state => _state;

  MovieDetail? movieDetail;

  changeState(DetailViewState s) {
    _state = s;
    notifyListeners();
  }

  getMovieDetail(int id) async {
    changeState(DetailViewState.loading);
    try {
      final c = await AuthApi.getMovieDetail(id);
      movieDetail = c;
      notifyListeners();
      changeState(DetailViewState.none);
    } catch (e) {
      changeState(DetailViewState.error);
    }
  }
}
