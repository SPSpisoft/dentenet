import 'package:flutter/material.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';

import '../themes/app_theme.dart';
import 'drawers/drawer_user_controller.dart';
import 'drawers/home_drawer.dart';
import 'master_screen.dart';
import 'screens/feedback_screen.dart';
import 'screens/help_screen.dart';
import 'screens/invite_friend_screen.dart';

class NavigationScreens extends StatefulWidget {
  const NavigationScreens({Key? key}) : super(key: key);

  @override
  _NavigationScreensState createState() => _NavigationScreensState();
}

class _NavigationScreensState extends State<NavigationScreens> {
  Widget? screenView;
  DrawerIndex? drawerIndex;

  @override
  void initState() {

    drawerIndex = DrawerIndex.HOME;
    screenView = const MasterPageScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FocusWatcher(
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          resizeToAvoidBottomInset: false,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: 200,
            //MediaQuery.of(context).size.width * 0.6,
            onDrawerCall: (DrawerIndex drawerIndexData) {
              changeIndex(drawerIndexData);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexData) {
    if (drawerIndex != drawerIndexData) {
      drawerIndex = drawerIndexData;
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {
          screenView = const MasterPageScreen();
        });
      } else if (drawerIndex == DrawerIndex.Help) {
        setState(() {
          screenView = HelpScreen();
        });
      } else if (drawerIndex == DrawerIndex.FeedBack) {
        setState(() {
          screenView = FeedbackScreen();
        });
      } else if (drawerIndex == DrawerIndex.Invite) {
        setState(() {
          screenView = InviteFriend();
        });
      } else {
        //do in your way......
      }
    }
  }
}
