import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:print_ticket/modules/auth/auth.model.dart';
import 'package:print_ticket/modules/home/home.page.dart';
import 'package:print_ticket/services/authentication/authentication.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthModel _authModel = AuthModel();

  @override
  void initState() {
  
    super.initState();
    Authentication.initializeFirebase();
  }

  

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthModel>(
      create: ((context) => _authModel),
      builder: ((context, child) =>
          Consumer<AuthModel>(builder: (context, model, child) {
            Future.delayed(Duration.zero, () {
              if (_authModel.user != null) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage()),
                    (route) => false);
              }
            });
            return SafeArea(
                child: Scaffold(
              body: Center(
                child: ElevatedButton(
                    onPressed: () async {
                      await _authModel.signInWithGoogle(context);
                    },
                    child: const Text('Sign in with Google')),
              ),
            ));
          })),
    );
  }
}
