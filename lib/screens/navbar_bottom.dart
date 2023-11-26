import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:team_manager_app/screens/groups/group_screen.dart';
import 'package:team_manager_app/screens/profile_screen.dart';
import 'package:team_manager_app/screens/tasks/task_screen.dart';

// ignore: use_key_in_widget_constructors
class NavBarBottom extends StatefulWidget {
  @override
  State<NavBarBottom> createState() => _NavBarBottomState();
}

class _NavBarBottomState extends State<NavBarBottom> {
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      decoration: const NavBarDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey, // Màu của bóng
            blurRadius: 5.0, // Bán kính mờ của bóng
            spreadRadius: 2.0, // Độ phân tán của bóng
            offset: Offset(0, 2), // Vị trí bóng
          ),
        ],
        colorBehindNavBar: Colors.transparent,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      backgroundColor: Colors.white,
      navBarStyle: NavBarStyle.style10,
      navBarHeight: 65,
      confineInSafeArea: true,
      context,
      screens: [
        GroupScreen(),
        TaskScreen(),
        ProfileScreen(),
      ],
      items: [
        PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.group_solid),
          title: 'Group',
          textStyle: const TextStyle(fontSize: 14),
          activeColorPrimary: CupertinoColors.systemCyan,
          inactiveColorPrimary: CupertinoColors.systemGrey,
          activeColorSecondary: CupertinoColors.white,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.assignment),
          title: 'Task',
          textStyle: const TextStyle(fontSize: 14),
          activeColorPrimary: CupertinoColors.systemGreen,
          inactiveColorPrimary: CupertinoColors.systemGrey,
          activeColorSecondary: CupertinoColors.white,
        ),
        PersistentBottomNavBarItem(
            icon: const Icon(Icons.person),
            title: 'Profile',
            textStyle: const TextStyle(fontSize: 14),
            activeColorPrimary: CupertinoColors.systemPurple,
            inactiveColorPrimary: CupertinoColors.systemGrey,
            activeColorSecondary: CupertinoColors.white),
      ],
    );
  }
}
