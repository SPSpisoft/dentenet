import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spring/spring.dart';

import '../gen/assets.gen.dart';
import '../gen/colors.gen.dart';
import '../gen/fonts.gen.dart';
import '../public/public_variables.dart';
import '../themes/app_theme.dart';
import 'setting_page.dart';

class SplashScreen extends StatelessWidget {
  bool _isLandscape = false;
  SpringController pageSpringController = SpringController();
  var endFadeIn = false.obs;
  var endAnimText = false.obs;
  var endAnimBranding = false.obs;
  var endAnimSetting = false.obs;
  double logoWidth = 140.0;
  double shimmerWidth = 200.0;

  SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values); // to re-show bars
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorName.statusBar,
    ));
    _isLandscape = MediaQuery.of(context).orientation == Orientation.landscape
        ? true
        : false;
    logoWidth = _isLandscape ? MediaQuery.of(context).size.width / 6 : MediaQuery.of(context).size.width / 3;

    return Scaffold(
      backgroundColor: AppTheme.screenColor,
      body: Spring.fadeIn(
        animDuration: const Duration(seconds: 2),
        // springController: pageSpringController,
        animStatus: (AnimStatus animStatus) {
          if (animStatus == AnimStatus.completed) {
            endFadeIn.value = true;
          }
        },
        child: SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: !_isLandscape ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                    color: AppTheme.screenColor,
                    image: DecorationImage(
                      // colorFilter: ColorFilter.mode(
                      //     Colors.black.withOpacity(0.4),
                      //     BlendMode.darken),
                      image: AssetImage(Assets.images.splash.splashBg.path),
                      // fit: BoxFit.fitWidth,
                      alignment: Alignment.topRight,
                    ),
                  ),
                  // child: ,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 8,
                  left: _isLandscape ? ((MediaQuery.of(context).size.width / 4) - shimmerWidth / 2) : 0,
                  right:
                  _isLandscape ? ((MediaQuery.of(context).size.width / 4) - shimmerWidth / 2) : 0,
                ),
                child: Align(
                  alignment:
                  !_isLandscape ? Alignment.topCenter : Alignment.topLeft,
                  child: Obx(
                        () {
                      return endFadeIn.isFalse
                          ? Container()
                          : Column(
                        children: [
                          Spring.fadeIn(
                              child: Image(
                                  image: AssetImage(
                                      Assets.images.logoTrans.path),
                                  width: logoWidth),
                              animDuration: const Duration(seconds: 3)),
                          Spring.bubbleButton(
                            animDuration: const Duration(seconds: 2),
                            animStatus: (AnimStatus animStatus) {
                              if (animStatus == AnimStatus.completed) {
                                endAnimText.value = true;
                              }
                            },
                            child: Shimmer.fromColors(
                              period: const Duration(seconds: 3),
                              baseColor: ColorName.navigationBarColor,
                              highlightColor: ColorName.yellowOcher,
                              child: SizedBox(
                                width: shimmerWidth,
                                child: AutoSizeText(
                                  maxLines: 1,
                                  Globals.appTitle,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: FontFamily.tahoma,
                                    fontSize: 60.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: !_isLandscape ? 0 : MediaQuery.of(context).size.height / 20),
                            child: Obx(() => Visibility(
                              visible: endAnimText.isTrue,
                              child: Spring.fadeIn(
                                child: const Text(
                                  "Design by Spring Software ™",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontFamily: FontFamily.adell),
                                  textDirection: TextDirection.ltr,
                                ),
                              ),
                            )),
                          ),
                          _isLandscape
                              ? const SizedBox(width: 0, height: 0)
                              : Padding(
                              padding:
                              EdgeInsets.all(MediaQuery.of(context).size.height / 20),
                              child: buttonControl(context)),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding:
                  const EdgeInsets.only(left: 10, bottom: 5, right: 10),
                  child: Obx(() => Visibility(
                    visible: endAnimText.isTrue,
                    child: Spring.slide(
                      animStatus: (AnimStatus animStatus) {
                        if (animStatus == AnimStatus.completed) {
                          endAnimBranding.value = true;
                        }
                      },
                      child: SizedBox(
                        width: !_isLandscape ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width / 2,
                        child: Row(
                          textDirection: TextDirection.ltr,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              "Version 1.0",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontFamily: FontFamily.tahoma),
                              textDirection: TextDirection.ltr,
                            ),
                            Text(
                              "© 2022 SPISOFT",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontFamily: FontFamily.tahoma),
                              textDirection: TextDirection.ltr,
                            ),
                          ],
                        ),
                      ),
                      slideType: SlideType.slide_in_bottom,
                    ),
                  )),
                ),
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(() => Visibility(
                      visible: endAnimBranding.isTrue,
                      child: Spring.opacity(
                          animDuration: const Duration(seconds: 5),
                          startOpacity: 0,
                          endOpacity: 1,
                          animStatus: (AnimStatus animStatus) {
                            if (animStatus == AnimStatus.completed) {
                              endAnimSetting.value = true;
                            }
                          },
                          child: Spring.rotate(
                              animDuration: const Duration(seconds: 15),
                              child: InkWell(
                                  onTap: () {
                                    // Get.snackbar(
                                    //     'Setting', 'go to login setting');

                                    // SettingBinding().dependencies();
                                    Get.to(SettingPage(callSettingKey: SettingKey.login),
                                        transition: Transition.upToDown, duration: const Duration(seconds: 1));
                                    // Get.to(SettingPage( callSettingKey: SettingKey.login),
                                    //     transition: Transition.leftToRight);
                                  },
                                  child: const Icon(
                                    Icons.settings,
                                    color: Colors.grey,
                                  )))),
                    )),
                  )),
              Align(
                alignment: Alignment.bottomRight,
                child: !_isLandscape
                    ? Container()
                    : SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 2,
                    child: Padding(
                        padding: EdgeInsets.all(MediaQuery.of(context).size.height / 20),
                        child: buttonControl(context))),
              )
            ],
          ),
        ),
      ),
    );
  }

  buttonControl(BuildContext context) {
    return Obx(() => Visibility(
      visible: endAnimText.isTrue,
      child: Spring.slide(
        animDuration: const Duration(milliseconds: 800),
        slideType: SlideType.slide_in_bottom,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Column(
            children: [
              MaterialButton(
                  child: const Text("enter"),
                  onPressed: () {
                    // Get.toEnd(() => Routes.MasterMenu);
                    Get.offAndToNamed("/",
                    //   // transition: Transition.downToUp,
                    //   // duration: const Duration(milliseconds: 700)
                    );
                  })
            ],
          ),
        ),
      ),
    ));
  }
}

// class HomeView extends StatelessWidget {
//   final HomeController _controller = Get.find<HomeController>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Translation"),
//           centerTitle: false,
//           actions: [languageChooser()],
//         ),
//         body: ListView(shrinkWrap: true, children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               "Device Locale :${Get.locale!.languageCode}",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//             ),
//           ),
//           Center(
//             child: Text(
//               'greeting'.tr,
//               style: TextStyle(fontSize: 16),
//             ),
//           ),
//           RaisedButton(
//             onPressed: () => Get.toNamed("/details"),
//             child: Text("Go To Next Page"),
//           )
//         ]));
//   }
//
//   // DropdownButton languageChooser() {
//   //   return DropdownButton<String>(
//   //       isExpanded: false,
//   //       hint: Text('Please choose a location'), // Not necessary for Option 1
//   //       value: _controller.selectedLanguage.value,
//   //       onChanged: (symbol) {
//   //         _controller.changeLanguage = symbol!;
//   //       },
//   //       items: languages.map((LanguageModel _language) {
//   //         print(_language.language);
//   //         return DropdownMenuItem<String>(
//   //           child: new Text(_language.language),
//   //           value: _language.symbol,
//   //         );
//   //       }).toList());
//   // }
// }
