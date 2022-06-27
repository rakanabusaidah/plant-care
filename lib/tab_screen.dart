import 'package:flutter/material.dart';
import 'package:plant_care/my_profile.dart';
import 'my_farm.dart';
import 'my_notifications.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class TabScreen extends StatefulWidget {
  static const routeName = '/tabscreen';
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final List<Map<String, Object>> _pages = [
    {
      'page': MyNotifications(),
      'title': 'تنبيهاتي',
    },
    {
      'page': MyFarm(),
      'title': 'نباتاتي',
    },
    {
      'page': MyProfile(),
      'title': 'حسابي',
    },
  ];
  int _selectedPageIndex = 1;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: ConvexAppBar(
        onTap: _selectPage,
        backgroundColor: Color(0XFF4e6b4e),
        initialActiveIndex: 1,
        style: TabStyle.reactCircle,
        activeColor: Colors.white,
        color: Colors.grey[400],
        items: const [
          TabItem(
            icon: Icons.notifications,
            title: 'تنبيهاتي',
          ),
          TabItem(
            icon: Icons.grass,
            title: 'نباتاتي',
          ),
          TabItem(
            icon: Icons.person,
            title: 'حسابي',
          ),
        ],
      ),
    );
  }
}
