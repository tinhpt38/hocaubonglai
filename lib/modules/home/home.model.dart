

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
  bool _isAdmin = false;
  bool get isAdmin => _isAdmin;

  getUser() async {
    _retrievedUsers = await userRepository.retrieveUser();
    for (int i = 0; i < _retrievedUsers.length; i++) {
      emailList.add(_retrievedUsers[i].email.toString());
    }
    checkUserLogined(_userLogined!);
    notifyListeners();
  }

  checkUserLogined(User value) {

    String? selectedEmail = emailList.firstWhere((e) => e == value.email);
    // ignore: unnecessary_null_comparison
    if (selectedEmail != null) {
      int indexOf = emailList.indexOf(selectedEmail);
      _isAdmin = _retrievedUsers[indexOf].role == "Admin";
    } else {
      _isAdmin = false;
    
    }
    notifyListeners();
  }

  changeRole() {
    _isAdmin = !_isAdmin;
    notifyListeners();
  }
}
