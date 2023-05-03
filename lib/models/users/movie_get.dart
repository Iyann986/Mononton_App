import 'package:equatable/equatable.dart';

class GetMovie extends Equatable {
  int id;

  GetMovie({required this.id});

  factory GetMovie.fromMap(map) {
    return GetMovie(id: map['movieWatch']);
  }

  @override
  List<Object?> get props => [id];
}
