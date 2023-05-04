import 'package:equatable/equatable.dart';
import 'package:mononton_app/models/images.dart';

class MovieImage extends Equatable {
  final List<Images>? backdrops;
  final List<Images>? posters;

  const MovieImage({this.backdrops, this.posters});

  factory MovieImage.fromJson(Map<String, dynamic> result) {
    return MovieImage(
      backdrops:
          (result['backdrops'] as List).map((e) => Images.fromJson(e)).toList(),
      posters:
          (result['posters'] as List).map((e) => Images.fromJson(e)).toList(),
    );
  }

  @override
  List<Object?> get props => [backdrops!, posters!];
}
