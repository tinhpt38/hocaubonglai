import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:print_ticket/modules/home/home.page.dart';
import 'package:url_launcher/url_launcher.dart';

class RemoteConfigs extends AnimatedWidget {
  const RemoteConfigs({
    super.key,
    required this.remoteConfig,
  }) : super(listenable: remoteConfig);

  final FirebaseRemoteConfig remoteConfig;

  @override
  Widget build(BuildContext context) {
    return remoteConfig.getBool('pay_for_admin') == true
        ? _remoteConfig(context)
        : _loginApp(context);
  }

  Widget _remoteConfig(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Thông báo',
          ),
        ),
        body: AlertDialog(
          title: const Center(
            child: Text('Thông báo'),
          ),
          content: const Text(
            'Vui lòng liên hệ Admin được hỗ trợ!',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                var url = Uri.parse("tel:${0379080398}");
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: const Text('Liên hệ'),
            ),
          ],
        ));
  }

  Widget _loginApp(BuildContext context) {
    return const HomePage();
  }
}

Future<FirebaseRemoteConfig> setupRemoteConfig() async {
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.fetchAndActivate();
  print(remoteConfig.getBool('pay_for_admin'));
  RemoteConfigValue(null, ValueSource.valueStatic);
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 1),
    minimumFetchInterval: const Duration(seconds: 1),
  ));
  return remoteConfig;
}
