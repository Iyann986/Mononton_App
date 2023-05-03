class Users {
  String? id;
  String? name;
  String? email;
  String? password;
  List? movieWatch;
  List? movieDropped;
  List? movieFinish;

  Users({
    this.id,
    this.name,
    this.email,
    this.password,
    this.movieWatch,
    this.movieDropped,
    this.movieFinish,
  });

  factory Users.fromMap(map) {
    return Users(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      movieWatch: map['movieWatch'],
      movieDropped: map['movieDropped'],
      movieFinish: map['movieFinish'],
    );
  }

  //sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'movieWatch': movieWatch,
      'movieDropped': movieDropped,
      'movieFinish': movieFinish,
    };
  }
}
