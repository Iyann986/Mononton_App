import 'package:flutter/material.dart';
import 'package:mononton_app/api/auth_api.dart';
import 'package:mononton_app/models/movie_model.dart';

class MovieViewModel with ChangeNotifier {
  List<Movie> _movies = [];
  List<Movie> get movies => _movies;

  getCurrentPlayMovies(int id) async {
    if (id == 0) {
      final c = await AuthApi.getNowPlayingMovie();
      _movies = c;
    } else {
      final c = await AuthApi.getMovieByGenre(id);
      _movies = c;
    }
    notifyListeners();
  }
}
