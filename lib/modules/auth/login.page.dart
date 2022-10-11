import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:print_ticket/modules/auth/auth.model.dart';
import 'package:print_ticket/modules/home/home.page.dart';
import 'package:print_ticket/modules/remote_config/remote_config.dart';
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
    initData();
  }

  initData() async {
    Authentication.initializeFirebase();
    await _authModel.getUser();
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
                    MaterialPageRoute(
                        builder: (_) => FutureBuilder<FirebaseRemoteConfig>(
                            future: setupRemoteConfig(),
                            builder: (BuildContext context,
                                AsyncSnapshot<FirebaseRemoteConfig> snapshot) {
                              return snapshot.hasData
                                  ? RemoteConfigs(
                                      remoteConfig: snapshot.requireData,
                                    )
                                  : Container();
                            })),
                    (route) => false);
              }
            });
            return SafeArea(
                child: Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                      'https://iweb.tatthanh.com.vn/pic/3/blog/images/image(2088).png'),
                  const SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await _authModel.signInWithGoogle(context);
                      },
                      child: const Text('Đăng nhập')),
                ],
              ),
            ));
          })),
    );
  }
}