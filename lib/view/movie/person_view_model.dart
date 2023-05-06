import 'package:flutter/material.dart';
import 'package:mononton_app/api/auth_api.dart';
import 'package:mononton_app/models/person.dart';

class PersonViewModel with ChangeNotifier {
  List<Person> _persons = [];
  List<Person> get persons => _persons;

  getTrendingPerson() async {
    final c = await AuthApi.getTrendingPerson();
    _persons = c;
    print('person: ${_persons[3].profilePath}');
    notifyListeners();
  }
}
