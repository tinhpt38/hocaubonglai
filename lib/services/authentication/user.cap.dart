import 'package:firebase_auth/firebase_auth.dart';
import 'package:print_ticket/models/users.dart';

import '../repositories/user_repository.dart';

class UserCap {
  static final UserCap _instanse = UserCap._interal();

  factory UserCap() => _instanse;
  UserRepository userRepository = UserRepository();
  late List<Users> _users;

  Future<bool> isAdmin() async {
    // ignore: no_leading_underscores_for_local_identifiers
    final User? _userLogined = FirebaseAuth.instance.currentUser;
    if(_userLogined == null){
      return false;
    }
    _users = await userRepository.retrieveUser();
    Users compareUser =
        _users.firstWhere((element) => element.email == _userLogined.email);
    return compareUser.role == "Admin";

    // String? selectedEmail = emailList.firstWhere((e) => e == value.email);
    // // ignore: unnecessary_null_comparison
    // if (selectedEmail != null) {
    //   int indexOf = emailList.indexOf(selectedEmail);
    //   _isAdmin = _retrievedUsers[indexOf].role == "Admin";
    // } else {
    //   _isAdmin = false;
    // }
  }

  UserCap._interal();
}
