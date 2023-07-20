import 'package:flutter/material.dart';

import '../../api/auth_api.dart';
import '../../models/movie_model.dart';

enum SearchViewState {
  none,
  loading,
  error,
}

class SearchViewModel with ChangeNotifier {
  SearchViewState _state = SearchViewState.none;
  SearchViewState get state => _state;

  List<Movie> _movies = [];
  List<Movie> get movies => _movies;

  changeState(SearchViewState s) {
    _state = s;
    notifyListeners();
  }

  getMovies(String query) async {
    changeState(SearchViewState.loading);
    try {
      final c = await AuthApi.searchMovie(query);
      _movies = c;
      // ignore: avoid_print
      print('data = ${_movies.length}');
      notifyListeners();
      changeState(SearchViewState.none);
    } catch (e) {
      changeState(SearchViewState.error);
    }
  }
}
