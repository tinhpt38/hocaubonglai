import 'package:flutter/material.dart';

import 'package:print_ticket/modules/customer/customer.page.dart';
import 'package:print_ticket/modules/dashboard/dashboard.page.dart';

import '../fishingrod/fishingrod.page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  getPage() {
    switch (_selectedIndex) {
      case 0:
        {
          return const DashboardPage();
        }
      case 1:
        {
          return const CustomerPage();
        }
      case 2:
        {
          return const FishingrodPage();
        }
      case 3:
        {
          // return  MyHomePage(title: 'Print config',);
          // return  PrintApp();
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getPage(),
      // floatingActionButton: FloatingActionButton(
      //   heroTag: "printApp",
      //   onPressed: () {
      //     Navigator.push(context,
      //         MaterialPageRoute(builder: (context) =>  DemoPrintPage(title: 'Demo Print Page',)));
      //   },
      //   child: const Icon(Icons.add),
      // ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Khách'),
          BottomNavigationBarItem(
              icon: Icon(Icons.line_axis), label: 'Cần câu'),
          // BottomNavigationBarItem(icon: Icon(Icons.print), label: 'Config')
        ],
      ),
    );
  }
}
