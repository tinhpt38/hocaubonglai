import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:print_ticket/models/fishingrod.dart';
import 'package:print_ticket/modules/auth/login.page.dart';
import 'package:print_ticket/services/authentication/authentication.dart';

import 'models/customer.dart';
import 'models/ticket.dart';
import 'modules/home/home.page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive
    ..init(appDocumentDirectory.path)
    ..registerAdapter(FishingRodAdapter())
    ..registerAdapter(CustomerAdapter())
    ..registerAdapter(TicketAdapter());

    // await Authentication.initializeFirebase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hồ Câu Bồng Lai',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
