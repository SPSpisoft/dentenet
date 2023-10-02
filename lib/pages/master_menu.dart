import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:spring/spring.dart';

import '../gen/colors.gen.dart';
import '../public/public_functions.dart';
import '../public/public_variables.dart';
import '../shop/main_shop.dart';
import 'employer_page.dart';
import 'setting_page.dart';
import 'task_master.dart';
import 'ttt_page.dart';


class MasterMenu extends StatefulWidget {
  const MasterMenu({Key? key}) : super(key: key);

  @override
  State<MasterMenu> createState() => _MasterMenuState();
}

class _MasterMenuState extends State<MasterMenu> {
  bool _isLandscape = false;

  late int myCrossAxisCount;
  late int totalHeightAxisCount;

  List<RxBool> completedLastAnimate = [
    true.obs,
    false.obs,
    false.obs,
    false.obs,
    false.obs,
    false.obs,
    false.obs
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorName.statusBar,
    ));

    completedLastAnimate = [
      true.obs,
      false.obs,
      false.obs,
      false.obs,
      false.obs,
      false.obs,
      false.obs
    ];

    _isLandscape = MediaQuery.of(context).orientation == Orientation.landscape
        ? true
        : false;

    myCrossAxisCount = _isLandscape ? 9 : 5;
    totalHeightAxisCount = _isLandscape ? 4 : 8;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: kToolbarHeight,
        title: Text(Globals.appTitle),
        backgroundColor: ColorName.appBar,
      ),
      body: SafeArea(
        child: WillPopScope(
          onWillPop: _onWillPop,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              double zW = MediaQuery.of(context).size.width / myCrossAxisCount;
              double zH = (constraints.maxHeight) / totalHeightAxisCount;
              double zHeight = zH / zW;
              return Directionality(
                textDirection:
                _isLandscape ? TextDirection.rtl : TextDirection.ltr,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Stack(
                    children: [
                      StaggeredGrid.count(
                        crossAxisCount: myCrossAxisCount,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        children: [
                          StaggeredGridTile.count(
                            crossAxisCellCount: _isLandscape ? 2 : 2,
                            mainAxisCellCount: 2 * zHeight,
                            child: menuItem(ColorName.menuSetting,
                                Icons.settings, 'settings'.tr, 1),
                          ),
                          StaggeredGridTile.count(
                              crossAxisCellCount: 3,
                              mainAxisCellCount: 2 * zHeight,
                              child: menuItem(
                                  ColorName.menuDoctor,
                                  Icons.supervised_user_circle_outlined,
                                  'doctor'.tr,
                                  2)),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 5,
                            mainAxisCellCount: 2 * zHeight,
                            child: menuItem(ColorName.menuTask, Icons.menu_book,
                                'task'.tr, 3),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: _isLandscape ? 2 : 3,
                            mainAxisCellCount: 2 * zHeight,
                            child: menuItem(ColorName.menuEvent,
                                Icons.event_note_outlined, 'events'.tr, 4),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 2,
                            mainAxisCellCount: 4 * zHeight,
                            child: menuItem(ColorName.menuStore,
                                Icons.shopping_cart_outlined, 'store'.tr, 5),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: _isLandscape ? 2 : 3,
                            mainAxisCellCount: 2 * zHeight,
                            child: menuItem(
                                ColorName.menuMessage,
                                Icons.markunread_mailbox_outlined,
                                'media'.tr,
                                6),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
    return false;
  }

  Widget menuItem1(Color backColor, IconData icon, String text, int index) {
    Color backColor = Colors.black;
    IconData icon = Icons.question_mark;
    String text = "";

    switch (index) {
      case 1:
        backColor = ColorName.menuSetting;
        icon = Icons.settings;
        text = 'settings'.tr;
        break;
      case 2:
        backColor = ColorName.menuDoctor;
        icon = Icons.supervised_user_circle_outlined;
        text = 'doctor'.tr;
        break;
      case 3:
        backColor = ColorName.menuTask;
        icon = Icons.menu_book;
        text = 'task'.tr;
        break;
      case 4:
        backColor = ColorName.menuEvent;
        icon = Icons.event_note_outlined;
        text = 'events'.tr;
        break;
      case 5:
        backColor = ColorName.menuStore;
        icon = Icons.shopping_cart_outlined;
        text = 'store'.tr;
        break;
      case 6:
        backColor = ColorName.menuMessage;
        icon = Icons.markunread_mailbox_outlined;
        text = 'media'.tr;
        break;

        defailt:
        backColor = ColorName.menuMessage;
        icon = Icons.markunread_mailbox_outlined;
        text = 'media'.tr;
        break;
    }
    double menuIconSize = _isLandscape
        ? MediaQuery.of(context).size.height * 0.12
        : MediaQuery.of(context).size.width * 0.12;
    const Alignment menuIconAlignment = Alignment.center;
    TextStyle menuTextStyle = TextStyle(color: Colors.white, fontSize: 17.sp);
    Alignment menuTextAlignment =
    isDirectionRTL(context) ? Alignment.bottomRight : Alignment.bottomLeft;
    var menuTextPadding = EdgeInsets.only(
        top: _isLandscape ? .5.w : .5.h,
        bottom: _isLandscape ? .5.w : .5.h,
        right: _isLandscape ? 2.h : 2.w,
        left: _isLandscape ? 2.h : 2.w);
    const Color menuIconColor = Colors.white;

    return Obx(() {
      return completedLastAnimate[index].isTrue
          ? Spring.slide(
          slideType: isDirectionRTL(context)
              ? SlideType.slide_in_right
              : SlideType.slide_in_left,
          animDuration: const Duration(milliseconds: 70),
          child: InkWell(
            onTap: () async {
              switch (index) {
                case 1:
                // SettingBinding().dependencies();
                  Get.to(SettingPage(callSettingKey: SettingKey.public),
                      transition: Transition.upToDown,
                      duration: const Duration(seconds: 1))!
                      .then((value) => setState(() {}));
                  // Get.toNamed(Routes.Setting, arguments: SettingKey.public);
                  // Get.to(SettingPage(callSettingKey: SettingKey.public),
                  //     binding: SettingBinding(),transition: Transition.leftToRight);
                  // Get.to(SettingPage(callSettingKey: SettingKey.public),
                  //     transition: Transition.leftToRight);
                  break;
                case 2:
                  Get.to(EmployerPage(
                    selectable: false,
                  ));
                  break;
                case 3:
                  Get.to(TaskMaster());
                  break;
                case 5:
                  Get.to(const MainShop());
                  // Get.snackbar(memberBox!.count().toString(), "memberBox!.get(2)!.Name!");
                  // String v = "sps <<<< ";
                  //   memberBox!.getAll().forEach((element) {
                  //     v = v + " - "+ element.id.toString();
                  //   });
                  //   Get.snackbar(memberBox!.count().toString(), v);
                  //   print(v);
                  break;
                case 4:
                  Get.to(TTT());
                  // await TimeMachine.initialize();
                  //
                  // // await TimeMachine.initialize({
                  // //   'rootBundle': rootBundle,
                  // //   'timeZone': await Timezone.getLocalTimezone(),
                  // // });
                  //
                  // print(
                  //     'Hello, ${DateTimeZone.local} from the Dart Time Machine!\n');
                  //
                  // var tzdb = await DateTimeZoneProviders.tzdb;
                  // var paris = await tzdb["Asia/Tehran"];
                  // var now = Instant.now();
                  //
                  // print('UTC Time: $now');
                  // print('Local Time: ${now.inLocalZone()}');
                  // print('Paris Time: ${now.inZone(paris)}\n');
                  //
                  // print('Formatted');
                  // print('UTC Time: ${now.toString('dddd yyyy-MM-dd HH:mm')}');
                  // print('Local Time: ${now.inLocalZone().toString('dddd yyyy-MM-dd HH:mm')}\n');
                  //
                  // var french = await Cultures.getCulture('fr-FR');
                  // print('Formatted and French ($french)');
                  // print('UTC Time: ${now.toString('dddd yyyy-MM-dd HH:mm', french)}');
                  // print('Local Time: ${now.inLocalZone().toString('dddd yyyy-MM-dd HH:mm', french)}\n');
                  //
                  // print('Parse French Formatted ZonedDateTime');
                  break;
                default:
                  Get.snackbar("title", index.toString());
                  break;
              }
            },
            child: Container(
                color: backColor,
                child: Stack(
                  children: [
                    Align(
                      alignment: menuIconAlignment,
                      child: Icon(
                        icon,
                        color: menuIconColor,
                        size: menuIconSize,
                      ),
                    ),
                    Align(
                      alignment: menuTextAlignment,
                      child: Padding(
                        padding: menuTextPadding,
                        child: Text(text, style: menuTextStyle),
                      ),
                    )
                  ],
                )),
          ),
          animStatus: (AnimStatus animStatus) {
            // if (animStatus == AnimStatus.forward) {
            //   completedLastAnimate[index].value = true;
            // }
            if (animStatus == AnimStatus.completed) {
              completedLastAnimate[index].value = true;
            }
          })
          : Container();
    });
  }


menuItem(Color backColor, IconData icon, String text, int index) {
    double menuIconSize = _isLandscape
        ? MediaQuery.of(context).size.height * 0.12
        : MediaQuery.of(context).size.width * 0.12;
    const Alignment menuIconAlignment = Alignment.center;
    TextStyle menuTextStyle = TextStyle(color: Colors.white, fontSize: 17.sp);
    Alignment menuTextAlignment =
    isDirectionRTL(context) ? Alignment.bottomRight : Alignment.bottomLeft;
    var menuTextPadding = EdgeInsets.only(
        top: _isLandscape ? .5.w : .5.h,
        bottom: _isLandscape ? .5.w : .5.h,
        right: _isLandscape ? 2.h : 2.w,
        left: _isLandscape ? 2.h : 2.w);
    const Color menuIconColor = Colors.white;

    return Obx(() {
      return completedLastAnimate[index - 1].isTrue
          ? Spring.slide(
          slideType: isDirectionRTL(context)
              ? SlideType.slide_in_right
              : SlideType.slide_in_left,
          animDuration: const Duration(milliseconds: 70),
          child: InkWell(
            onTap: () async {
              switch (index) {
                case 1:
                // SettingBinding().dependencies();
                  Get.to(SettingPage(callSettingKey: SettingKey.public),
                      transition: Transition.upToDown,
                      duration: const Duration(seconds: 1))!
                      .then((value) => setState(() {}));
                  // Get.toNamed(Routes.Setting, arguments: SettingKey.public);
                  // Get.to(SettingPage(callSettingKey: SettingKey.public),
                  //     binding: SettingBinding(),transition: Transition.leftToRight);
                  // Get.to(SettingPage(callSettingKey: SettingKey.public),
                  //     transition: Transition.leftToRight);
                  break;
                case 2:
                  Get.to(EmployerPage(
                    selectable: false,
                  ));
                  break;
                case 3:
                  Get.to(TaskMaster());
                  break;
                case 5:
                  Get.to(const MainShop());
                  // Get.snackbar(memberBox!.count().toString(), "memberBox!.get(2)!.Name!");
                  // String v = "sps <<<< ";
                  //   memberBox!.getAll().forEach((element) {
                  //     v = v + " - "+ element.id.toString();
                  //   });
                  //   Get.snackbar(memberBox!.count().toString(), v);
                  //   print(v);
                  break;
                case 4:
                  Get.to(TTT());
                  // await TimeMachine.initialize();
                  //
                  // // await TimeMachine.initialize({
                  // //   'rootBundle': rootBundle,
                  // //   'timeZone': await Timezone.getLocalTimezone(),
                  // // });
                  //
                  // print(
                  //     'Hello, ${DateTimeZone.local} from the Dart Time Machine!\n');
                  //
                  // var tzdb = await DateTimeZoneProviders.tzdb;
                  // var paris = await tzdb["Asia/Tehran"];
                  // var now = Instant.now();
                  //
                  // print('UTC Time: $now');
                  // print('Local Time: ${now.inLocalZone()}');
                  // print('Paris Time: ${now.inZone(paris)}\n');
                  //
                  // print('Formatted');
                  // print('UTC Time: ${now.toString('dddd yyyy-MM-dd HH:mm')}');
                  // print('Local Time: ${now.inLocalZone().toString('dddd yyyy-MM-dd HH:mm')}\n');
                  //
                  // var french = await Cultures.getCulture('fr-FR');
                  // print('Formatted and French ($french)');
                  // print('UTC Time: ${now.toString('dddd yyyy-MM-dd HH:mm', french)}');
                  // print('Local Time: ${now.inLocalZone().toString('dddd yyyy-MM-dd HH:mm', french)}\n');
                  //
                  // print('Parse French Formatted ZonedDateTime');
                  break;
                default:
                  Get.snackbar("title", index.toString());
                  break;
              }
            },

            child: Container(
                color: backColor,
                child: Stack(
                  children: [
                    Align(
                      alignment: menuIconAlignment,
                      child: Icon(
                        icon,
                        color: menuIconColor,
                        size: menuIconSize,
                      ),
                    ),
                    Align(
                      alignment: menuTextAlignment,
                      child: Padding(
                        padding: menuTextPadding,
                        child: Text(text, style: menuTextStyle),
                      ),
                    )
                  ],
                )),
          ),
          animStatus: (AnimStatus animStatus) {
            // if (animStatus == AnimStatus.forward) {
            //   completedLastAnimate[index].value = true;
            // }
            if (animStatus == AnimStatus.completed) {
              completedLastAnimate[index].value = true;
            }
          })
          : Container();
    });
  }
}