import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
// import 'package:dart_ipify/dart_ipify.dart';
// import 'package:device_info_plus/device_info_plus.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:open_file/open_file.dart';
// import 'package:package_info/package_info.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:spstore/public_functions.dart';
// import 'data_fetch.dart';
// import 'public_variables.dart';
// import 'themes/app_theme.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' as io;

// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
// import 'main_navigation_screens.dart';

// import 'package:pushe_flutter/pushe.dart';
// import 'package:awesome_dialog/awesome_dialog.dart';

// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:window_manager/window_manager.dart';

import '../public/public_functions.dart';
import '../public/public_variables.dart';
import '../themes/app_theme.dart';
import 'data_fetch.dart';
import 'main_navigation_screens.dart';

class MainShop extends StatefulWidget {
  const MainShop({
    Key? key,
  }) : super(key: key);

  @override
  _MainShopState createState() => _MainShopState();
}

class _MainShopState extends State<MainShop> {
  // late bool _permissionReady;
  late String _localPath;
  late TargetPlatform platform;
  final ReceivePort _port = ReceivePort();

  bool downloadStarted = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb && Platform.isAndroid) {
          FlutterDownloader.registerCallback(downloadCallback as DownloadCallback);
    }
  }

  @override
  Widget build(BuildContext context) {
    platform = Theme.of(context).platform;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppTheme.statusBarColor,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: AppTheme.navigationBarColor,
      systemNavigationBarDividerColor: AppTheme.navigationBarDividerColor,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                backgroundColor: AppTheme.grey,
                body: MaterialApp(
                  // theme: ThemeData(
                  //   primarySwatch: Colors.red,
                  //   textTheme: TextTheme(
                  //     //To support the following, you need to use the first initialization method
                  //       button: TextStyle(fontSize: 35.sp)),
                  // ),
                  useInheritedMediaQuery: true,
                  // Set to true
                  // locale: DevicePreview.locale(context),
                  // title: 'Globals.app_title',
                  // debugShowCheckedModeBanner: false,

                  title: 'فروشگاه',
                  debugShowCheckedModeBanner: false,
                  localizationsDelegates: const [
                    GlobalCupertinoLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  supportedLocales: const [
                    Locale("fa", "IR"),
                    // OR Locale('ar', 'AE') OR Other RTL locales
                  ],
                  locale: const Locale("fa", "IR"),
                  theme: ThemeData(
                    primarySwatch: AppTheme.primarySwatch,
                    // textTheme: AppTheme.textTheme,
                    textTheme: TextTheme(
                        //To support the following, you need to use the first initialization method
                        button: TextStyle(fontSize: 35.sp)),
                    // platform: TargetPlatform.iOS,
                  ),

                  // initialRoute: 'dashboard',
                  // onGenerateRoute: AppRouter.generateRoute,

                  home: Scaffold(
                    body: FutureBuilder<int>(
                        future: fetchToken(
                            context,
                            true,
                            Globals.myTypeID,
                            Globals.myStoreId,
                            Globals.myMemberId.trim(),
                            Globals.myNetIP,
                            Globals.myDeviceId,
                            Globals.myAppVersion,
                            Globals.myPassword),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData && snapshot.data! == 200) {
                              if (!kIsWeb && Platform.isAndroid) {
                                Globals.futureStoreTarget.then((value) async {
                                  if (!downloadStarted && value[0].appVer != Globals.myAppVersion) {
                                    _checkStoragePermission().then((v) {
                                      if (v) {
                                        prepareSaveDir().whenComplete(() {
                                          AwesomeDialog(
                                            context: context,
                                            animType: AnimType.SCALE,
                                            headerAnimationLoop: false,
                                            dialogType: DialogType.INFO,
                                            body: Center(
                                              child: Column(
                                                children: [
                                                  const Text(
                                                    'نسخه جدید در دسترس شماست!',
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  ),
                                                  Text(
                                                    "${value[0].appVer} <- ${Globals.myAppVersion}",
                                                    style: const TextStyle(
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 9),
                                                  ),
                                                  const Text(
                                                    'برای بروزرسانی تأیید نمایید.',
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.normal),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            title: 'بروزرسانی',
                                            // btnCancel: const Text("فعلا نه"),
                                            btnCancelText: "فعلا نه",
                                            btnCancelColor:
                                                Colors.deepOrangeAccent,
                                            btnCancelOnPress: () {
                                              // Navigator.pop(context);
                                            },
                                            btnOkText: "دانلود",
                                            btnOkOnPress: () async {
                                              var stFILE = '$_localPath/${Globals.myFileApk}';
                                              io.File(stFILE).exists().then((isExist) async {
                                                if (isExist) {
                                                  AwesomeDialog(
                                                    context: context,
                                                    animType: AnimType.TOPSLIDE,
                                                    headerAnimationLoop: false,
                                                    dialogType: DialogType.WARNING,
                                                    body: Center(
                                                      child: Column(
                                                        children: const [
                                                          Text(
                                                            'فایل همنام در مسیر دانلود وجود دارد.',
                                                            style: TextStyle(fontStyle: FontStyle.italic),
                                                          ),
                                                          Text(
                                                            'فایل جدید جایگزین خواهد شد!',
                                                            style: TextStyle(fontStyle: FontStyle.normal),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    title: 'فایل همنام',
                                                    btnCancelText: "انصراف",
                                                    btnCancelColor: Colors.deepOrangeAccent,
                                                    btnCancelOnPress: () {
                                                      // Navigator.pop(context);
                                                    },
                                                    btnOkText: "ادامه",
                                                    btnOkOnPress: () {
                                                      deleteFile(File(stFILE)).then((del) {
                                                        if(del) {
                                                          downloadStart();
                                                        }else{
                                                          ToastNormal("فایل حذف نشد", context, type: -1);
                                                        }
                                                      });
                                                    },
                                                  ).show();
                                                } else {
                                                  downloadStart();
                                                }
                                              });
                                            },
                                          ).show();
                                        });
                                      }
                                    });
                                  }
                                });
                              }
                              return const NavigationScreens();
                            } else {
                              String textError = '';
                              if (snapshot.data! == 402) {
                                textError = 'محدودیت دسترسی سرویس';
                              } else if (snapshot.data! == 403) {
                                textError = 'توکن نامعتبر';
                              } else {
                                textError =
                                    ' [${snapshot.data!}]  جهت بررسی مشکل با اپراتور تماس بگیرید  ';
                              }
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.remove_circle_outline,
                                      color: Colors.redAccent,
                                      size: 80,
                                    ),
                                    const Text(
                                        "دریافت اطلاعات با مشکل مواجه شد :(",
                                        style: TextStyle(
                                            fontFamily: 'Yekan', fontSize: 18)),
                                    Text(textError,
                                        style: const TextStyle(
                                            fontFamily: 'Yekan',
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic)),
                                  ],
                                ),
                              );
                            }
                            // }else{

                          } else {
                            // if (snapshot.connectionState ==
                            //     ConnectionState.waiting) {
                            return Center(
                              child:
                                  // Splash(),

                                  JumpingDotsProgressIndicator(
                                fontSize: 35.0,
                                color: AppTheme.primarySwatch,
                              ),
                            );
                          }
                        }),
                  ),
                ),
              ),
            )

        // const NavigationScreens(),
        );
  }

  Future<bool> _checkStoragePermission() async {
    if (Platform.isIOS) return true;

    if (platform == TargetPlatform.android) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (platform == TargetPlatform.android &&
          androidInfo.version.sdkInt! <= 28) {
        final status = await Permission.storage.status;
        if (status != PermissionStatus.granted) {
          final result = await Permission.storage.request();
          if (result == PermissionStatus.granted) {
            return true;
          }
        } else {
          return true;
        }
      } else {
        return true;
      }
    }
    return false;
  }

  downloadCallback(
      String id,
      DownloadTaskStatus status,
      int progress,
      ) {
    print(
      'SPS Callback on background isolate: '
          'task ($id) is in status ($status) and process ($progress)',
    );

    IsolateNameServer.lookupPortByName('downloader_send_port')
        ?.send([id, status, progress]);
  }
  // downloadCallback(String id, DownloadTaskStatus status, int progress,)
  // {
  //   if (status == DownloadTaskStatus.complete) {
  //     // ToastNormal("download completed", context: context, type: 1);
  //     installApkDialog();
  //   } else if (status == DownloadTaskStatus.failed) {
  //     // ToastNormal("download fail", context: context, type: -1);
  //   }
  //   print(
  //     'Callback on background isolate: '
  //     'task ($id) is in status ($status) and process ($progress)',
  //   );
  //
  //   IsolateNameServer.lookupPortByName('downloader_send_port')
  //       ?.send([id, status, progress]);
  // }

  Future<void> prepareSaveDir() async {
    _localPath = (await findLocalPath())!;
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  void installApkDialog() {
    AwesomeDialog(
      context: context,
      animType: AnimType.TOPSLIDE,
      headerAnimationLoop: false,
      dialogType: DialogType.SUCCES,
      body: Center(
        child: Column(
          children: const [
            Text(
              'دانلود کامل شد.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Text(
              'برای نصب تأیید نمایید.',
              style: TextStyle(fontStyle: FontStyle.normal),
            ),
          ],
        ),
      ),
      title: 'بروزرسانی',
      btnCancelText: "انصراف",
      btnCancelColor: Colors.deepOrangeAccent,
      btnCancelOnPress: () {
        // Navigator.pop(context);
      },
      btnOkText: "نصب",
      btnOkOnPress: () {
        OpenFilex.open(_localPath + Globals.myFileApk);
      },
    ).show();
  }

  Future<void> downloadStart() async {
    downloadStarted = true;
    await FlutterDownloader.enqueue(
      url:
      '${Globals.baseUrlDental}download/${Globals.myFileApk}',
      saveInPublicStorage: true,
      savedDir: _localPath,
      showNotification: true,
      openFileFromNotification:
      true,
      requiresStorageNotLow: true,
    );
      //   .then((taskId) {
      // if (taskId != null) {
      //   ToastNormal(
      //       "download started",
      //       context: context,
      //       type: 1);
      //
      //   // installApkDialog();
      // } else {
      //   ToastNormal("download fail",
      //       context: context,
      //       type: -1);
      // }
    // });
  }

// Widget buildNamedRoute(BuildContext context){
//   return MaterialApp(
//     initialRoute: '/',
//     routes: {
//       '/': (context) => NavigationScreens(),
//       '/second': (context) => SecondScreen(),
//     },
//   );
}

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool lightMode =
        MediaQuery.of(context).platformBrightness == Brightness.light;
    return Scaffold(
      backgroundColor:
          lightMode ? const Color(0xffe1f5fe) : const Color(0xff042a49),
      body: Center(
          child: lightMode
              ? Image.asset('assets/mg.gif')
              : Image.asset('assets/splash_dark.png')),
    );
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//       statusBarColor: AppTheme.statusBarColor,
//       statusBarIconBrightness: Brightness.dark,
//       statusBarBrightness:
//           !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
//       systemNavigationBarColor: AppTheme.navigationBarColor,
//       systemNavigationBarDividerColor: AppTheme.navigationBarDividerColor,
//       systemNavigationBarIconBrightness: Brightness.dark,
//     ));
//     return MaterialApp(
//       title: 'فروشگاه',
//       debugShowCheckedModeBanner: false,
//       localizationsDelegates: const [
//         GlobalCupertinoLocalizations.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//       ],
//       supportedLocales: const [
//         Locale("fa", "IR"), // OR Locale('ar', 'AE') OR Other RTL locales
//       ],
//       locale: const Locale("fa", "IR"),
//       theme: ThemeData(
//         primarySwatch: AppTheme.primarySwatch,
//         textTheme: AppTheme.textTheme,
//         // platform: TargetPlatform.iOS,
//       ),
//       home: const NavigationScreens(),
//     );
//   }
// }

// class main_screen2 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         physics: const BouncingScrollPhysics(),
//         slivers: [
//           SliverAppBar(
//             pinned: true,
//             expandedHeight: 200,
//             title: Text('Title'),
//             stretch: true,
//             centerTitle: true,
//             flexibleSpace: FlexibleSpaceBar(
//               background: Image.network(
//                   'https://shop.spisoft.ir/_Files/Images/Banners/tt2.png',
//                   fit: BoxFit.cover),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: Column(
//               children: List.generate(50, (index) {
//                 return Container(
//                   height: 72,
//                   color: Colors.blue[200],
//                   alignment: Alignment.centerLeft,
//                   margin: EdgeInsets.all(8),
//                   child: Text('Item $index'),
//                 );
//               }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
