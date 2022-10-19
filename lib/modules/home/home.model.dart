import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:print_ticket/models/users.dart';

import '../../services/repositories/user_repository.dart';

class HomeModel extends ChangeNotifier {
  UserRepository userRepository = UserRepository();
  List<Users> _retrievedUsers = [];
  List<Users> get retrievedUsers => _retrievedUsers;

  List<String> emailList = [];

  final User? _userLogined = FirebaseAuth.instance.currentUser;
  User? get userLogined => _userLogined;
  bool _role = false;
  bool get role => _role;
  getUser() async {
    _retrievedUsers = await userRepository.retrieveUser();
    for (int i = 0; i < _retrievedUsers.length; i++) {
      emailList.add(_retrievedUsers[i].email.toString());
    }
    checkUserLogined(_userLogined!);
    notifyListeners();
  }

  checkUserLogined(User value) {
    if (emailList.contains(value.email)) {
      if (_retrievedUsers[emailList.indexOf(value.email.toString())].role ==
          'Nhân viên') {
        _role = false;
        print(_role);
      } else if (_retrievedUsers[emailList.indexOf(value.email.toString())]
              .role ==
          'Admin') {
        _role = true;
        print(_role);
      }
    } else {}
    notifyListeners();
  }

  changeRole() {
    _role = !_role;
    notifyListeners();
  }
}
