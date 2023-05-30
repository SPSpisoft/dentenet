import 'dart:async';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../public/public_functions.dart';
import '../public/public_variables.dart';
import '../themes/app_theme.dart';
import '../themes/master_theme.dart';
import 'classes/ClsStore.dart';
import 'models/tabIcon_data.dart';
import 'screens/main_tabs/ProductCat/product_cat_view.dart';
import 'screens/main_tabs/cart_screen.dart';
import 'screens/main_tabs/tag_screen.dart';
import 'screens/main_tabs/user_screen.dart';
import 'screens/main_tabs/home_screen.dart';
import 'screens/search_screen.dart';
import 'views/bottom_bar_view.dart';
import 'views/scroll_to_hide_widget_getx.dart';


class MasterPageScreen extends StatefulWidget {
  const MasterPageScreen({Key? key}) : super(key: key);

  @override
  _MasterPageScreenState createState() => _MasterPageScreenState();
}

class _MasterPageScreenState extends State<MasterPageScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  late ScrollController scrollController;
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: MasterTheme.background,
  );

  static const int _tabCount = 4;
  int _currentIndex = 0;
  List<int> _badgeCounts =
      List<int>.generate(_tabCount, (index) => (index == 2) ? 1 : 1);
  List<bool> _badgeShows =
      List<bool>.generate(_tabCount, (index) => index.isEven ? false : false);

  // late bool inHome;

  late int _lastPage = 0;

  // late ScrollToHideWidgetGetX scrollToHideWidget;

  @override
  void initState() {
    Get.put(GetXCtrlHideWidget());

    scrollController = ScrollController();
    // inHome = true;
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    // tabBody = MyHomePage(
    //   notifyParent: refresh,
    // );
    jumpToTabPage(0, _lastPage);
    // MyDiaryScreen(animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (_lastPage == 0) {
      return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              // title: Container(
              //     decoration: const BoxDecoration(
              //         shape: BoxShape.rectangle,
              //         color: Colors.orange,
              //         borderRadius: BorderRadius.only(
              //             topLeft: Radius.circular(10),
              //             topRight: Radius.circular(10))),
              //     child: const Padding(
              //       padding: EdgeInsets.all(8.0),
              //       child: Text(
              //         'خــروج',
              //         style: TextStyle(
              //           fontFamily: 'Titraj',
              //           color: Colors.white,
              //           fontSize: 16,
              //         ),
              //         textAlign: TextAlign.center,
              //       ),
              //     )),
              content: const Text(
                'برای خـروج تأیید نمایید.',
                style: TextStyle(fontFamily: 'Yekan2', fontSize: 16),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text(
                    'انصراف',
                    style: TextStyle(fontFamily: 'Yekan', fontSize: 14),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    'خـروج',
                    style: TextStyle(fontFamily: 'Yekan', fontSize: 14),
                  ),
                ),
              ],
            ),
          )) ??
          false;
    } else {
      // setState(() {
      if (_lastPage == 1) {
        if (Globals.stackTag.isEmpty || Globals.stackTag.length <= 1) {
          // scrollToHideWidget.controller.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
          jumpToTabPage(0, _lastPage);
        } else {
          Globals.stackTag.removeAt(Globals.stackTag.length - 1);

          animationController?.reverse().then<dynamic>((data) {
            if (!mounted) {
              return;
            }
            setState(() {
              tabBody = MyTagPage(
                  scrollController: scrollController,
                  goToSearch: goToSearchPage,
                  goToPage: goToPageAsNo,
                  mainScreenAnimationController: animationController);
              // inHome = false;
            });
          });
        }
      } else if (_lastPage == 5) {
        animationController?.reverse().then<dynamic>((data) {
          if (!mounted) {
            return;
          }
          setState(() {
            tabBody = MyTagPage(
                scrollController: scrollController,
                goToSearch: goToSearchPage,
                goToPage: goToPageAsNo,
                mainScreenAnimationController: animationController);
            // inHome = false;
            _lastPage = 1;
          });
        });
      } else if (_lastPage == 4) {
        if (_currentIndex == 1) {
          animationController?.reverse().then<dynamic>((data) {
            if (!mounted) {
              return;
            }
            setState(() {
              tabBody = MyTagPage(
                  scrollController: scrollController,
                  goToSearch: goToSearchPage,
                  goToPage: goToPageAsNo,
                  mainScreenAnimationController: animationController);
              // inHome = false;
              _lastPage = 1;
            });
          });
        } else {
          jumpToTabPage(_currentIndex, _lastPage);
        }
      } else {
        jumpToTabPage(0, _lastPage);
      }
      // tabBody = MyHomePage(notifyParent: refresh);
      // });
      setState(() {
        // tabBody == MyHomePage(notifyParent: refresh);
        // inHome = true;
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final mediaQuery = MediaQuery.of(context);

    _badgeCounts = List<int>.generate(_tabCount, (index) {
      switch (index) {
        case 0:
          return 0;
        case 1:
          return 0;
        case 2:
          return Globals.currentCart.length > 0
              ? Globals.currentCart.first.CountRow
              : 0;
        case 3:
          return Globals.myMemberId.trim().isEmpty ? 0 : 0;
      }
      return 0;
    });

    _badgeShows = List<bool>.generate(_tabCount, (index) {
      switch (index) {
        case 0:
          return false;
        case 1:
          return false;
        case 2:
          return Globals.currentCart.isNotEmpty ? true : false;
        case 3:
          return Globals.myMemberId.trim().isEmpty ? true : false;
      }
      return false;
    });

    // => index.isEven ? true : false);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        color: MasterTheme.background,
        child: FutureBuilder<List<ClsStore>>(
          future: Globals.futureStoreTarget,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: Scaffold(
                  backgroundColor: AppTheme.primarySwatch,
                  resizeToAvoidBottomInset : false,
                  bottomNavigationBar: mBottomNavigationBar(),
                  body: SafeArea(
                    child: tabBody,
                  ),
                ),
              );
              // if (Globals.myStore.category.isEmpty || Globals.myStore.category.substring(0, 1) == '0') {
              //   return Stack(
              //     children: <Widget>[
              //       tabBody,
              //       bottomBar(),
              //     ],
              //   );
              // } else if (Globals.myStore.category.substring(0, 1) == '1') {
              //   return Directionality(
              //     textDirection: TextDirection.rtl,
              //     child: Scaffold(
              //       backgroundColor: AppTheme.primarySwatch,
              //       bottomNavigationBar: convexAppBar(),
              //       body: SafeArea(
              //         child: tabBody,
              //       ),
              //     ),
              //   );
              // } else if (Globals.myStore.category.substring(0, 1) == '2') {
              //   return Directionality(
              //     textDirection: TextDirection.rtl,
              //     child: Scaffold(
              //       backgroundColor: AppTheme.primarySwatch,
              //       bottomNavigationBar: customNavigationBar(),
              //       body: SafeArea(
              //         child: tabBody,
              //       ),
              //     ),
              //   );
              // }
              // return Directionality(
              //   textDirection: TextDirection.rtl,
              //   child: Scaffold(
              //     backgroundColor: AppTheme.primarySwatch,
              //     bottomNavigationBar: bottomNavigationBar(),
              //     body: SafeArea(
              //       child: tabBody,
              //     ),
              //   ),
              // );
            }
          },
        ),
        // ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  goToSearchPage(List<String>? inCat, int? typeCallCode) {
    // if (kIsWeb) {
    animationController?.reverse().then<dynamic>((data) {
      if (!mounted) {
        return;
      }
      setState(() {
        // inHome = false;
        jumpToTabPage(4, _lastPage, listStr: inCat, typeCallCode: typeCallCode);
      });
    });
    // } else {
    //   Navigator.of(context).push(_createRoute());
    // }
  }

  goToPageAsNo(int pagNumber, int lastPage, String? stringVal) {
    // animationController?.reverse().then<dynamic>((data) {
    //   if (!mounted) {
    //     return;
    //   }
    if (mounted) {
      if (pagNumber == lastPage) {
        setState(() {});
      } else {
        setState(() {
          jumpToTabPage(pagNumber, lastPage, strVal: stringVal, listStr: pagNumber==4 ? [stringVal!]:null);
        });
      }
    }
    // });
  }

  refresh(){
    setState(() {});
    print("refresh");
  }

  // Route _createRoute() {
  //   return PageRouteBuilder(
  //     pageBuilder: (context, animation, secondaryAnimation) =>
  //         SearchPage(goToSearch: goToSearchPage, mScrollController: scrollController,),
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       return child;
  //     },
  //   );
  // }

  void jumpToTabPage(int value, int last, {String? strVal, List<String>? listStr, int? typeCallCode}) {
    final GetXCtrlHideWidget ctrl = Get.find();
    ctrl.changeStatus(true, false);

    if (value < _tabCount) {
      _currentIndex = value;
    }

    _lastPage = value;
    if (value == 0) {
      animationController?.reverse().then<dynamic>((data) {
        if (!mounted) {
          return;
        }
        // final GetXController ctrl = Get.find();
        // ctrl.changeStatus(true);
        // scrollToHideWidget.
        // .animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
        setState(() {
          tabBody = MyHomePage(notifyParent: goToSearchPage);
        });
      });
    } else if (value == 1) {
      Globals.stackTag.clear();
      Globals.stackTag.add(StackTag(Globals.tagType_ROOT, 0.0));
      animationController?.reverse().then<dynamic>((data) {
        if (!mounted) {
          return;
        }
        setState(() {
          tabBody = MyTagPage(
              scrollController: scrollController,
              goToSearch: goToSearchPage,
              goToPage: goToPageAsNo,
              mainScreenAnimationController: animationController);
          // inHome = false;
        });
      });
    } else if (value == 2) {
      animationController?.reverse().then<dynamic>((data) {
        if (!mounted) {
          return;
        }
        setState(() {
          tabBody = CartScreen(
            goToSearch: goToSearchPage,
            goToPage: goToPageAsNo,
            refreshMainMaster: refresh,
          );
          // MyDiaryScreen(animationController: animationController);
          // inHome = false;
          // TrainingScreen(animationController: animationController);
        });
      });
    } else if (value == 3) {
      animationController?.reverse().then<dynamic>((data) {
        if (!mounted) {
          return;
        }
        setState(() {
          tabBody = UserScreen(
            goToPage: goToPageAsNo,
            refreshMainMaster: refresh
          );
          // MyDiaryScreen(animationController: animationController);
          // inHome = false;
          // TrainingScreen(animationController: animationController);
        });
      });
    } else if (value == 4) {
      animationController?.reverse().then<dynamic>((data) {
        if (!mounted) {
          return;
        }
        setState(() {
          tabBody = SearchPage(
            // goToSearch: goToSearchPage,
            mScrollController: scrollController,
            lastPage: last,
            goToPage: goToPageAsNo,
            inCat: listStr,
            typeCall: typeCallCode,
          );
          // MyDiaryScreen(animationController: animationController);
          // inHome = false;
          // TrainingScreen(animationController: animationController);
        });
      });
    } else if (value == 5) {
      animationController?.reverse().then<dynamic>((data) {
        if (!mounted) {
          return;
        }
        setState(() {
          if (strVal != null) {
            if (last == 1) {
              Globals.stackTag[Globals.stackTag.length - 1].scrollPosition =
                  scrollController.offset;
            }
            // scrollController.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
            tabBody = ProductCatView(
                catId: strVal,
                mScrollController: scrollController,
                goToPage: goToPageAsNo,
                refreshMainMaster: refresh,
                mainScreenAnimationController: animationController);
            // MyDiaryScreen(animationController: animationController);
            // inHome = false;
            // TrainingScreen(animationController: animationController);
          }
        });
      });
    }
  }

  bottomBar() {
    return KeyboardVisibilityBuilder(
      builder: (context, child, isKeyboardVisible) {
        if (isKeyboardVisible) {
          return const SizedBox();
        } else {
          return Column(
            children: <Widget>[
              const Expanded(
                child: SizedBox(),
              ),
              BottomBarView(
                tabIconsList: tabIconsList,
                addClick: () {
                  ToastNormal("Scanner Click..", context, type: 0);
                },
                changeIndex: (int index) {
                  jumpToTabPage(index, _lastPage);
                },
              ),
            ],
          );
        }
      },
      child: const SizedBox(),
    );
  }

  customNavigationBar() {
    return KeyboardVisibilityBuilder(
      builder: (context, child, isKeyboardVisible) {
        if (isKeyboardVisible) {
          return const SizedBox();
        } else {
          return ScrollToHideWidgetGetX(
            controller: scrollController,
            child: CustomNavigationBar(
              iconSize: 30.0,
              unSelectedColor: const Color(0xff7c7c8b),
              strokeColor: const Color(0x30040307),
              selectedColor: const Color(0xffffffff),
              backgroundColor: Colors.grey.shade800,
              items: [
                CustomNavigationBarItem(
                  icon: const Icon(Icons.home),
                  badgeCount: _badgeCounts[0],
                  showBadge: _badgeShows[0],
                ),
                CustomNavigationBarItem(
                  icon: const Icon(Icons.list_alt_outlined),
                  badgeCount: _badgeCounts[1],
                  showBadge: _badgeShows[1],
                ),
                CustomNavigationBarItem(
                  icon: const Icon(Icons.shopping_cart),
                  badgeCount: _badgeCounts[2],
                  showBadge: _badgeShows[2],
                ),
                CustomNavigationBarItem(
                  icon: const Icon(Icons.account_circle),
                  badgeCount: _badgeCounts[3],
                  showBadge: _badgeShows[3],
                ),
              ],
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                  _badgeShows[index] = false;
                  jumpToTabPage(index, _lastPage);
                });
              },
            ),
          );
        }
      },
      child: const SizedBox(),
    );
  }

  convexAppBar() {
    return KeyboardVisibilityBuilder(
      builder: (context, child, isKeyboardVisible) {
        if (isKeyboardVisible) {
          return const SizedBox();
        } else {
          return ConvexAppBar.badge(
            {

              0: _badgeCounts[0],
              1: _badgeCounts[1],
              2: _badgeCounts[2],
              3: _badgeCounts[3] > 0 ? '*' : '',
              // _currentIndex: _badgeCounts[_currentIndex]
              // 1: Icons.assistant_photo,
              // 0: Colors.yellowAccent
            },
            badgeColor: Colors.red,
            items: const [
              TabItem(
                icon: Icons.home,
                title: 'Home',
              ),
              TabItem(icon: Icons.list_rounded, title: 'Category'),
              // TabItem(icon: Icons.qr_code, title: 'Scan'),
              TabItem(icon: Icons.shopping_cart, title: 'Cart'),
              TabItem(icon: Icons.person, title: 'Profile'),
            ],
            initialActiveIndex: 0,
            style: TabStyle.react,
            backgroundColor: AppTheme.blue,
            //optional, default as 0
            onTap: (int i) {
              _currentIndex = i;
              jumpToTabPage(i, _lastPage);
            },
          );
        }
      },
      child: const SizedBox(),
    );
  }

  bottomNavigationBar() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return KeyboardVisibilityBuilder(
      builder: (context, child, isKeyboardVisible) {
        if (isKeyboardVisible) {
          return const SizedBox();
        } else {
          return BottomNavigationBar(
            // showSelectedLabels: false,
            // showUnselectedLabels: false,
            // iconSize: 30,
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            backgroundColor: colorScheme.surface,
            selectedItemColor: colorScheme.error,
            unselectedItemColor: colorScheme.onSurface.withOpacity(.60),
            selectedLabelStyle: textTheme.caption,
            unselectedLabelStyle: textTheme.caption,
            onTap: (value) {
              // Respond to item press.
              setState(() {
                _currentIndex = value;
                jumpToTabPage(value, _lastPage);
              });
            },
            items: [
              BottomNavigationBarItem(
                label: ('Home'),
                icon: Stack(children: <Widget>[
                  const Icon(Icons.home),
                  Positioned(
                    top: 0.0,
                    right: 0.0,
                    child: Icon(Icons.brightness_1,
                        size: 8.0,
                        color: _badgeShows[0]
                            ? Colors.redAccent
                            : Colors.transparent),
                  )
                ]),
                // Icon(Icons.home),
              ),
              BottomNavigationBarItem(
                label: ('Category'),
                icon: Stack(children: <Widget>[
                  const Icon(Icons.category_outlined),
                  Positioned(
                    top: 0.0,
                    right: 0.0,
                    child: Icon(Icons.brightness_1,
                        size: 8.0,
                        color: _badgeShows[1]
                            ? Colors.redAccent
                            : Colors.transparent),
                  )
                ]),
              ),
              BottomNavigationBarItem(
                  label: ('Cart'),
                  icon: Stack(children: <Widget>[
                    const Icon(Icons.shopping_cart_outlined),
                    Positioned(
                      top: 0.0,
                      right: 0.0,
                      child: Icon(Icons.brightness_1,
                          size: 8.0,
                          color: _badgeShows[2]
                              ? Colors.redAccent
                              : Colors.transparent),
                    )
                  ])),
              BottomNavigationBarItem(
                  label: ('Profile'),
                  icon: Stack(children: <Widget>[
                    const Icon(Icons.account_circle_rounded),
                    Positioned(
                      top: 0.0,
                      right: 0.0,
                      child: Icon(Icons.brightness_1,
                          size: 8.0,
                          color: _badgeShows[3]
                              ? Colors.redAccent
                              : Colors.transparent),
                    )
                  ])),
            ],
          );
        }
      },
      child: const SizedBox(),
    );
  }

  mBottomNavigationBar() {
    if (Globals.myStore.category.isEmpty ||
        Globals.myStore.category.substring(0, 1) == '0') {
      return bottomBar();
    } else if (Globals.myStore.category.substring(0, 1) == '1') {
      return convexAppBar();
    } else if (Globals.myStore.category.substring(0, 1) == '2') {
      return customNavigationBar();
    } else {
      return bottomNavigationBar();
    }
  }

  Widget mBody() {
    if (Globals.myStore.category.isEmpty ||
        Globals.myStore.category.substring(0, 1) == '0') {
      return Stack(
        children: <Widget>[
          tabBody,
          bottomBar(),
        ],
      );
    } else if (Globals.myStore.category.substring(0, 1) == '1') {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppTheme.primarySwatch,
          bottomNavigationBar: convexAppBar(),
          body: SafeArea(
            child: tabBody,
          ),
        ),
      );
    } else if (Globals.myStore.category.substring(0, 1) == '2') {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppTheme.primarySwatch,
          bottomNavigationBar: customNavigationBar(),
          body: SafeArea(
            child: tabBody,
          ),
        ),
      );
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.primarySwatch,
        bottomNavigationBar: bottomNavigationBar(),
        body: SafeArea(
          child: tabBody,
        ),
      ),
    );
  }
}
