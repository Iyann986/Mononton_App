class Person {
  final String? id;
  final String? gender;
  final String? name;
  final String? profilePath;
  final String? knowForDepartment;
  final String? popularity;

  Person(
      {this.id,
      this.gender,
      this.name,
      this.profilePath,
      this.knowForDepartment,
      this.popularity});

  factory Person.fromJson(dynamic json) {
    return Person(
        id: json['id'].toString(),
        gender: json['gender'].toString(),
        name: json['name'].toString(),
        profilePath: json['profile_path'].toString(),
        knowForDepartment: json['known_for_department'].toString(),
        popularity: json['popularity'].toString());
  }
}
