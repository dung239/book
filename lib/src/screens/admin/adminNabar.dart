import 'package:flutter/material.dart';
import 'package:store/src/screens/admin/categoryAdmin.dart';
import 'package:store/src/screens/admin/home_admin.dart';
import 'package:store/src/screens/admin/invoiceAdmin.dart';
import 'package:store/src/screens/admin/setting_admin.dart';
import 'package:store/src/screens/home_page.dart';
import 'package:store/src/screens/setting.dart';


class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    HomePageAdmin(),
    CategoryAdmin(),
    InvoiceAdmin(),
    SettingAdmin(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Thể loại'),
          BottomNavigationBarItem(icon: Icon(Icons.toc), label: 'Thống kê'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Cài đặt')
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
