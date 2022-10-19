import 'package:flutter/material.dart';

import 'package:print_ticket/modules/customer/customer.page.dart';
import 'package:print_ticket/modules/dashboard/dashboard.page.dart';
import 'package:print_ticket/modules/home/home.model.dart';

import '../fishingrod/fishingrod.page.dart';

class HomePage extends StatefulWidget {
  final bool isAdmin;
  const HomePage({super.key, required this.isAdmin});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final HomeModel _modelHome = HomeModel();
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
    }
  }

  getPage1() {
    switch (_selectedIndex) {
      case 0:
        {
          return const DashboardPage();
        }
      case 1:
        {
          return const FishingrodPage();
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> listBottom = const [
      BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
      BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Khách'),
      BottomNavigationBarItem(icon: Icon(Icons.line_axis), label: 'Cần câu'),
    ];

    List<BottomNavigationBarItem> listBottom1 = const [
      BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
      BottomNavigationBarItem(icon: Icon(Icons.line_axis), label: 'Cần câu'),
    ];

    return Scaffold(
      body: widget.isAdmin == true ? getPage() : getPage1(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        items: widget.isAdmin == true ? listBottom : listBottom1,
      ),
    );
  }
}
