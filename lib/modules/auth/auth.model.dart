import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:print_ticket/services/authentication/authentication.dart';

class AuthModel extends ChangeNotifier {
  bool? _isSigningIn = false;
  bool? get isSigningIn => _isSigningIn;

  User? _user;
  User? get user => _user;

  setUser(User? value) {
    _user = value;
    notifyListeners();
  }

  void setIsSigningIn(bool value) {
    _isSigningIn = value;
    notifyListeners();
  }

  signInWithGoogle(BuildContext context) async {
    setIsSigningIn(true);
    User? user = await Authentication.signInWithGoogle(context: context);
    setIsSigningIn(false);
    setUser(user);
  }

}
