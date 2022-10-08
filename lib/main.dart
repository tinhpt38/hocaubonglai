import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:print_ticket/modules/auth/login.page.dart';
import 'package:print_ticket/modules/customer/customer.model.dart';
import 'package:print_ticket/modules/ticket/ticket.model.dart';
import 'package:provider/provider.dart';
import 'modules/dashboard/dashboard.model.dart';
import 'services/authentication/authentication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Authentication.initializeFirebase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DashboardModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => CustomerModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => TicketModel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hồ Câu Bồng Lai',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LoginPage(),
      ),
    );
  }
}
