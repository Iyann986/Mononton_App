import 'package:flutter/material.dart';
import 'package:mononton_app/api/auth_api.dart';
import 'package:mononton_app/models/movie_detail.dart';

// enum WatchlistViewState {
//   none,
//   loading,
//   error,
// }

// class WatchlistViewModel with ChangeNotifier {
//   WatchlistViewModel _state = WatchlistViewState.none as WatchlistViewModel;
//   WatchlistViewModel get state => _state;

//   List<MovieDetail> _watchlist = [];
//   List<MovieDetail> get watchlist => _watchlist;

//   changeState(WatchlistViewState s) {
//     _state = s as WatchlistViewModel;
//     notifyListeners();
//   }

//   getMovieById(List id) async {
//     changeState(WatchlistViewState.loading);
//     try {
//       for (int i = 0; i < id.length; i++) {
//         final c = await AuthApi.getMovieDetail(id[i]);
//         _watchlist.add(c);
//         notifyListeners();
//       }
//       changeState(WatchlistViewState.none);
//     } catch (e) {
//       changeState(WatchlistViewState.error);
//     }
//   }
// }

enum WatchlistViewState {
  none,
  loading,
  error,
}

class WatchlistViewModel with ChangeNotifier {
  WatchlistViewState _state = WatchlistViewState.none;
  WatchlistViewState get state => _state;

  final List<MovieDetail> _watchlist = [];
  List<MovieDetail> get watchlist => _watchlist;

  // bool _isLoading = false;
  // bool get isLoading => _isLoading;

  changeState(WatchlistViewState s) {
    _state = s;
    notifyListeners();
  }

  getMovieById(List id) async {
    // _isLoading = true;
    changeState(WatchlistViewState.loading);
    try {
      for (int i = 0; i < id.length; i++) {
        final c = await AuthApi.getMovieDetail(id[i]);
        _watchlist.add(c);
        // notifyListeners();
      }
      // _isLoading = false;
      // Future.microtask(() {
      //   notifyListeners();
      //   (WatchlistViewState.none);
      // });
      notifyListeners();
      changeState(WatchlistViewState.none);
    } catch (e) {
      // _isLoading = false;
      // Future.microtask(() {
      //   notifyListeners();
      //   changeState(WatchlistViewState.error);
      // });
      changeState(WatchlistViewState.error);
    }
  }
}
