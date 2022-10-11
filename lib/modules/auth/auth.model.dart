import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:print_ticket/models/users.dart';
import 'package:print_ticket/modules/dashboard/dashboard.model.dart';
import 'package:print_ticket/services/authentication/authentication.dart';
import 'package:print_ticket/services/repositories/user_repository.dart';

class AuthModel extends ChangeNotifier {
  User? _user;
  User? get user => _user;

  UserRepository userRepository = UserRepository();

  List<Users> _retrievedUsers = [];
  List<Users> get retrievedUsers => _retrievedUsers;

  List<String> emailList = [];

  Future<List<Users>>? _usersList;
  Future<List<Users>>? get usersList => _usersList;

  final User? _userLogined = FirebaseAuth.instance.currentUser;
  User? get userLogined => _userLogined;

  getUser() async {
    _retrievedUsers = await userRepository.retrieveUser();
    _usersList = userRepository.retrieveUser();
    for (int i = 0; i < _retrievedUsers.length; i++) {
      emailList.add(_retrievedUsers[i].email.toString());
    }
    notifyListeners();
  }

  signInWithGoogle(BuildContext context) async {
    _user = await Authentication.signInWithGoogle(context: context);
    checkAccount(_user!);
    notifyListeners();
  }

  checkAccount(User value) {
    if (_retrievedUsers.isEmpty) {
      addUser('Admin');
    } else {
      checkUserLogined(value);
    }
    notifyListeners();
  }

  checkUserLogined(User value) {
    if (emailList.contains(value.email)) {
    } else {
      addUser('Nhân viên');
    }
    notifyListeners();
  }

  addUser(String role) async {
    userRepository.users.add(({
      'uID': _user!.uid,
      'displayName': _user?.displayName,
      'email': _user?.email,
      'photoUrl': _user?.photoURL,
      'role': role,
    }));

    notifyListeners();
  }

  logout() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.disconnect();
  }
}