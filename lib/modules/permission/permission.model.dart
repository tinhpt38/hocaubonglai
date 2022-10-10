import 'package:flutter/material.dart';

import '../../models/users.dart';
import '../../services/repositories/user_repository.dart';

class PermissionModel extends ChangeNotifier {
  UserRepository userRepository = UserRepository();

  List<Users> _retrievedUsers = [];
  List<Users> get retrievedUsers => _retrievedUsers;

  Future<List<Users>>? _usersList;
  Future<List<Users>>? get usersList => _usersList;

  getUser() async {
    _retrievedUsers = await userRepository.retrieveUser();
    _usersList = userRepository.retrieveUser();
    notifyListeners();
  }

  deleteUser(String userID) async {
    await userRepository.users.doc(userID).delete();
    getUser();
    notifyListeners();
  }

  updateRole(String userID, String role) async {
    if (role == 'Nhân viên') {
      role = 'Admin';
    } else {
      role = 'Nhân viên';
    }
    await userRepository.users.doc(userID).update({'role': role});
    getUser();
    notifyListeners();
  }
}
