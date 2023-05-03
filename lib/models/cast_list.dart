class CastList {
  final List<Cast> cast;

  CastList(this.cast);
}

class Cast {
  final String? name;
  final String? character;
  final String? profilePath;

  Cast({this.name, this.character, this.profilePath});

  factory Cast.fromJson(dynamic json) {
    return Cast(
      name: json['name'],
      character: json['character'],
      profilePath: json['profile_path'],
    );
  }
}
