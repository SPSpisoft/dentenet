import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:time_zone_list/time_zone_list.dart';

// import 'package:time_machine/time_machine.dart';
import 'package:window_manager/window_manager.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

// import 'package:timezone/browser.dart' as tzb;
import 'package:shared_preferences/shared_preferences.dart';

import 'data/data_fetch.dart';
import 'gen/assets.gen.dart';
import 'gen/colors.gen.dart';
import 'gen/fonts.gen.dart';
import 'pages/employer_page.dart';
import 'pages/master_menu.dart';
import 'pages/setting_page.dart';
import 'pages/splash_page.dart';
import 'pages/task_info.dart';
import 'pages/task_master.dart';
import 'pages/task_page.dart';
import 'public/modeles.dart';
import 'public/public_functions.dart';
import 'public/public_variables.dart';
import 'public/words_translation.dart';
import 'shop/data_fetch.dart';
import 'shop/main_shop.dart';

Future<void> main() async {
  HttpOverrides.global = HttpOverrideSSL();
  // await Api.init(
  //   urls: [Globals.baseApiAddressDental],
  //   enableUtf8Decoding: true,
  //   //   onAllError: (err) {
  //   //     if (err.code == 401) Get.offAll(() => ToastNormal("", context));
  //   // }
  // );
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.remove();
  tz.initializeTimeZones();
  // await TimeMachine.initialize({'rootBundle': rootBundle});

  initSize();
  // initDB();
  // Globals.objectBox = await ObjectBox.create();
  // await Hive.initFlutter();

  Globals.prefs = await SharedPreferences.getInstance();
  setDefaultPreferences();

  // runApp(const MyApp());
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(), // Wrap your app
    ),
  );

  //***********************SHOP*********************** {
  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    // appName = packageInfo.appName;
    // packageName = packageInfo.packageName;
    Globals.myAppVersion = packageInfo.version;
    Globals.myAppBuildNumber = packageInfo.buildNumber;
  });
  if (kIsWeb) {
    Globals.myTypeID = "WEBA";
  } else if (PlatformDetails().isDesktop) {
    Globals.myTypeID = "WDSK";
  }
  if (!kIsWeb) {
    if (Platform.isAndroid) {
      await FlutterDownloader.initialize(
          debug: false // optional: set false to disable printing logs to console
          , ignoreSsl: true
      );
    }
  }
  Globals.futureStoreTarget = fetchStoreTarget();
//***********************SHOP*********************** }
}

void setDefaultPreferences() {
  // Globals.prefs.setBool(Globals.prfWakeUp, false);
  // Globals.prefs.setBool(Globals.prfTaskScrollPage, false);
  // Globals.prefs.setBool(Globals.prfEmployerExpand, false);

  if (Globals.prefs.getString(Globals.prfMyLanguage) == null) {
    Globals.prefs.setString(Globals.prfMyLanguage, languages.first.symbol);
  }

  if (Globals.prefs.getInt(Globals.prfPatientAge) == null) {
    Globals.prefs.setInt(Globals.prfPatientAge, ageTypes.first.code);
  }

  if (Globals.prefs.getString(Globals.prfMyDate) == null) {
    Globals.prefs.setString(Globals.prfMyDate, dateTypes.first.symbol);
  }

  if (Globals.prefs.getString(Globals.prfMyZoneLocation) == null) {
    TimeZoneList.getList().then((timeZoneList) {
      TimeZoneInfo deviceZone = timeZoneList.firstWhere(
          (element) => element.offset == DateTime.now().timeZoneOffset);
      Globals.prefs.setString(
          Globals.prfMyZoneLocation, deviceZone.tag ?? deviceZone.timeZone);
      initDateTime();
    });
  } else {
    TimeZoneList.getList().then((timeZoneList) {
      TimeZoneInfo deviceZone = timeZoneList.firstWhere(
          (element) => element.offset == DateTime.now().timeZoneOffset);

      if (deviceZone.tag !=
          Globals.prefs.getString(Globals.prfMyZoneLocation)) {
        Get.snackbar('TimeZone'.tr, 'TimeZoneIsNotDevice'.tr);
      }
    });
    initDateTime();

  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(">>????>>> " + SettingValues.myLanguage.value.toString());
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: AppTheme.statusBarColor,
    //   statusBarIconBrightness: Brightness.dark,
    //   statusBarBrightness: !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
    //   systemNavigationBarColor: AppTheme.navigationBarColor,
    //   systemNavigationBarDividerColor: AppTheme.navigationBarDividerColor,
    //   systemNavigationBarIconBrightness: Brightness.dark,
    // ));

    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(

          debugShowCheckedModeBanner: false,
          useInheritedMediaQuery: true,
          // translations: WordsTranslations(),
          translationsKeys: AppTranslation.translationsKeys,
          locale: Locale(Globals.prefs.getString(Globals.prfMyLanguage) ??
              languages.first.symbol),
          fallbackLocale: const Locale('en', 'US'),
          builder: DevicePreview.appBuilder,
          title: Globals.appTitle,
          color: ColorName.materialColor,
          initialRoute: "/SplashScreen",
          // onGenerateRoute: RouteGenerator.generateRoute,
          getPages: [
            GetPage(
              name: "/SplashScreen",
              page: () => SplashScreen(),
            ),
            GetPage(
              name: "/",
              page: () => MasterMenu( ),
            ),
            GetPage(
              arguments: SettingKey,
              name: '/Setting',
              // binding: SettingBinding(),
              page: () {
                return SettingPage(callSettingKey: SettingKey.public);
              },
            ),
            GetPage(
              name: '/TaskMaster',
              page: () => TaskMaster(),
            ),
            GetPage(
              name: '/TaskInfo',
              page: () => TaskInfo("".obs),
            ),
            GetPage(
              name: '/Employers',
              page: () => EmployerPage(selectable: false),
            ),
            GetPage(
              name: '/Tasks',
              page: () => TaskPage(),
            ),
            GetPage(
              name: '/Shop',
              page: () => const MainShop(),
            ),
          ],
          theme: ThemeData(
            primarySwatch: ColorName.navigationBarColor,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          darkTheme: ThemeData.dark(),

          // home: const MyHomePage(),
        );
      },
    );
  }
}

// class SplashScreen extends StatelessWidget {
//   bool _isLandscape = false;
//   SpringController pageSpringController = SpringController();
//   var endFadeIn = false.obs;
//   var endAnimText = false.obs;
//   var endAnimBranding = false.obs;
//   var endAnimSetting = false.obs;
//   double logoWidth = 140.0;
//   double shimmerWidth = 200.0;
//
//   SplashScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
//         overlays: SystemUiOverlay.values); // to re-show bars
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: ColorName.statusBar,
//     ));
//     _isLandscape = MediaQuery.of(context).orientation == Orientation.landscape
//         ? true
//         : false;
//     logoWidth = _isLandscape ? MediaQuery.of(context).size.width / 6 : MediaQuery.of(context).size.width / 3;
//
//     return Scaffold(
//       backgroundColor: AppTheme.screenColor,
//       body: Spring.fadeIn(
//         animDuration: const Duration(seconds: 2),
//         // springController: pageSpringController,
//         animStatus: (AnimStatus animStatus) {
//           if (animStatus == AnimStatus.completed) {
//             endFadeIn.value = true;
//           }
//         },
//         child: SafeArea(
//           child: Stack(
//             children: [
//               Align(
//                 alignment: Alignment.topRight,
//                 child: Container(
//                   width: !_isLandscape ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width / 2,
//                   decoration: BoxDecoration(
//                     color: AppTheme.screenColor,
//                     image: DecorationImage(
//                       // colorFilter: ColorFilter.mode(
//                       //     Colors.black.withOpacity(0.4),
//                       //     BlendMode.darken),
//                       image: AssetImage(Assets.images.splash.splashBg.path),
//                       // fit: BoxFit.fitWidth,
//                       alignment: Alignment.topRight,
//                     ),
//                   ),
//                   // child: ,
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(
//                   top: MediaQuery.of(context).size.height / 8,
//                   left: _isLandscape ? ((MediaQuery.of(context).size.width / 4) - shimmerWidth / 2) : 0,
//                   right:
//                       _isLandscape ? ((MediaQuery.of(context).size.width / 4) - shimmerWidth / 2) : 0,
//                 ),
//                 child: Align(
//                   alignment:
//                       !_isLandscape ? Alignment.topCenter : Alignment.topLeft,
//                   child: Obx(
//                     () {
//                       return endFadeIn.isFalse
//                           ? Container()
//                           : Column(
//                               children: [
//                                 Spring.fadeIn(
//                                     child: Image(
//                                         image: AssetImage(
//                                             Assets.images.logoTrans.path),
//                                         width: logoWidth),
//                                     animDuration: const Duration(seconds: 3)),
//                                 Spring.bubbleButton(
//                                   animDuration: const Duration(seconds: 2),
//                                   animStatus: (AnimStatus animStatus) {
//                                     if (animStatus == AnimStatus.completed) {
//                                       endAnimText.value = true;
//                                     }
//                                   },
//                                   child: Shimmer.fromColors(
//                                     period: const Duration(seconds: 3),
//                                     baseColor: ColorName.navigationBarColor,
//                                     highlightColor: ColorName.yellowOcher,
//                                     child: SizedBox(
//                                       width: shimmerWidth,
//                                       child: AutoSizeText(
//                                         maxLines: 1,
//                                         Globals.appTitle,
//                                         textAlign: TextAlign.center,
//                                         style: const TextStyle(
//                                           fontFamily: FontFamily.tahoma,
//                                           fontSize: 60.0,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.only(
//                                       top: !_isLandscape ? 0 : MediaQuery.of(context).size.height / 20),
//                                   child: Obx(() => Visibility(
//                                         visible: endAnimText.isTrue,
//                                         child: Spring.fadeIn(
//                                           child: const Text(
//                                             "Design by Spring Software ™",
//                                             style: TextStyle(
//                                                 color: Colors.grey,
//                                                 fontSize: 12,
//                                                 fontFamily: FontFamily.adell),
//                                             textDirection: TextDirection.ltr,
//                                           ),
//                                         ),
//                                       )),
//                                 ),
//                                 _isLandscape
//                                     ? const SizedBox(width: 0, height: 0)
//                                     : Padding(
//                                         padding:
//                                             EdgeInsets.all(MediaQuery.of(context).size.height / 20),
//                                         child: buttonControl(context)),
//                               ],
//                             );
//                     },
//                   ),
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.bottomLeft,
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.only(left: 10, bottom: 5, right: 10),
//                   child: Obx(() => Visibility(
//                         visible: endAnimText.isTrue,
//                         child: Spring.slide(
//                           animStatus: (AnimStatus animStatus) {
//                             if (animStatus == AnimStatus.completed) {
//                               endAnimBranding.value = true;
//                             }
//                           },
//                           child: SizedBox(
//                             width: !_isLandscape ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width / 2,
//                             child: Row(
//                               textDirection: TextDirection.ltr,
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: const [
//                                 Text(
//                                   "Version 1.0",
//                                   style: TextStyle(
//                                       color: Colors.grey,
//                                       fontSize: 12,
//                                       fontFamily: FontFamily.tahoma),
//                                   textDirection: TextDirection.ltr,
//                                 ),
//                                 Text(
//                                   "© 2022 SPISOFT",
//                                   style: TextStyle(
//                                       color: Colors.grey,
//                                       fontSize: 12,
//                                       fontFamily: FontFamily.tahoma),
//                                   textDirection: TextDirection.ltr,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           slideType: SlideType.slide_in_bottom,
//                         ),
//                       )),
//                 ),
//               ),
//               Align(
//                   alignment: Alignment.topLeft,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Obx(() => Visibility(
//                           visible: endAnimBranding.isTrue,
//                           child: Spring.opacity(
//                               animDuration: const Duration(seconds: 5),
//                               startOpacity: 0,
//                               endOpacity: 1,
//                               animStatus: (AnimStatus animStatus) {
//                                 if (animStatus == AnimStatus.completed) {
//                                   endAnimSetting.value = true;
//                                 }
//                               },
//                               child: Spring.rotate(
//                                   animDuration: const Duration(seconds: 15),
//                                   child: InkWell(
//                                       onTap: () {
//                                         // Get.snackbar(
//                                         //     'Setting', 'go to login setting');
//                                         Get.to(SettingPage( callSettingKey: SettingKey.login),
//                                             transition: Transition.leftToRight);
//                                       },
//                                       child: const Icon(
//                                         Icons.settings,
//                                         color: Colors.grey,
//                                       )))),
//                         )),
//                   )),
//               Align(
//                 alignment: Alignment.bottomRight,
//                 child: !_isLandscape
//                     ? Container()
//                     : SizedBox(
//                         width: MediaQuery.of(context).size.width / 2,
//                         height: MediaQuery.of(context).size.height / 2,
//                         child: Padding(
//                             padding: EdgeInsets.all(MediaQuery.of(context).size.height / 20),
//                             child: buttonControl(context))),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   buttonControl(BuildContext context) {
//     return Obx(() => Visibility(
//           visible: endAnimText.isTrue,
//           child: Spring.slide(
//             animDuration: const Duration(milliseconds: 800),
//             slideType: SlideType.slide_in_bottom,
//             child: Container(
//               decoration: BoxDecoration(
//                 border: Border.all(color: Theme.of(context).dividerColor, width: 2),
//                 borderRadius: const BorderRadius.all(Radius.circular(5)),
//               ),
//               child: Column(
//                 children: [
//                   MaterialButton(
//                       child: const Text("enter"),
//                       onPressed: () {
//                         Get.offAndToNamed('MasterMenu',
//                             // transition: Transition.downToUp,
//                             // duration: const Duration(milliseconds: 700)
//                         );
//                       })
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }
// }

Future<void> initSize() async {
  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = WindowOptions(
        size: const Size(400, 600),
        center: true,
        backgroundColor: Colors.transparent,
        skipTaskbar: false,
        titleBarStyle: TitleBarStyle.normal,
        title: Globals.appTitle);

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
}

// Future<void> initDB() async {
//   // print("path : "+ objectBox.store.directoryPath);
//   ObjectBox objectBox = await ObjectBox.create();
//   print("path : "+ objectBox.store.directoryPath);
//   Globals.store = await openStore();
//   Globals.boxMember = Globals.store.box<ClsMember>();
// Globals.boxMember.put(ClsMember(Mem_ID: "Mem_ID00", UID_Mem: "UID_Mem11", UID_Main: "UID_Main", UID_Plc: "UID_Plc", Address_Title: "Address_Title"));
//   print('re-read note: ${Globals.boxMember.get(0)}');
//   Globals.store.close();
// }

// class ObjectBox {
//   /// The Store of this app.
//   late final Store store;
//
//   ObjectBox._create(this.store) {
//     // Add any additional setup code, e.g. build queries.
//     Globals.boxMember = store.box<ClsMember>();
//     Globals.boxMember.put(ClsMember(Mem_ID: "Mem_ID00", UID_Mem: "UID_Mem11", UID_Main: "UID_Main", UID_Plc: "UID_Plc", Address_Title: "Address_Title"));
//     print('re-read note: ${Globals.boxMember.get(0)}');
//     store.close();
//   }
//
//   /// Create an instance of ObjectBox to use throughout the app.
//   static Future<ObjectBox> create() async {
//     // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
//     final store = await openStore();
//     return ObjectBox._create(store);
//   }
// }
