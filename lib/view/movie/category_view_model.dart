import 'package:flutter/material.dart';
import 'package:mononton_app/api/auth_api.dart';
import 'package:mononton_app/models/genre.dart';

class CategoryViewModel with ChangeNotifier {
  List<Genre> _genres = [];
  List<Genre> get genres => _genres;

  getGenreList() async {
    final c = await AuthApi.getGenreList();
    _genres = c;
    notifyListeners();
  }
}
