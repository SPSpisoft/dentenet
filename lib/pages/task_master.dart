import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:xml/xml.dart';
import 'package:badges/badges.dart' as badges;
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../data/app.dart';
import '../functions/app_functions.dart';
import '../gen/colors.gen.dart';
import '../public/public_functions.dart';
import '../public/public_variables.dart';
import '../themes/master_theme.dart';
import 'setting_page.dart';
import 'task_info.dart';
import 'task_page.dart';

class TaskMaster extends StatefulWidget {
  TaskMaster({Key? key}) : super(key: key);

  @override
  State<TaskMaster> createState() => _TaskMasterState();
}

class _TaskMasterState extends State<TaskMaster> with TickerProviderStateMixin {

  Widget tabBody = Container(
    color: MasterTheme.background,
  );
  AnimationController? animationController;

  int _navBarSelectedIndex = 0;

  PageController pageController = PageController(initialPage: 0);

  List<String> navText = ['Task', 'Setup', 'Shade', 'Design'];
  List<Widget> navIcon = [
    const Icon(LineIcons.clipboardList),
    const Icon(LineIcons.tooth),
    const Icon(LineIcons.palette),
    const Icon(LineIcons.horizontalSliders)
  ];

  RxInt myActiveStep = 1.obs;

  RxString description = "".obs;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    return Scaffold(
      appBar: AppBar(backgroundColor: ColorName.appBar, actions: [
        Padding(
          padding:
              const EdgeInsets.only(top: 11, bottom: 11, left: 5, right: 5),
          child: InkWell(
            onTap: () async {
              print(Globals.currentTask);
            },
            child: Lottie.asset(
              'assets/animation/tick.json',
              fit: BoxFit.contain,
            ),
          ),
        ),
        // -- > Fetch data from scanner files
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () async {
              FilePickerResult? result =
                  await FilePicker.platform.pickFiles(allowMultiple: true);

              if (result != null) {
                var dentalProjectFile = result.files.where((element) {
                  return element.extension.toString() == "dentalProject";
                });

                var iftScanFile = result.files.where((element) {
                  return element.extension.toString() == "iftScan";
                });

                if (iftScanFile.length == 1) {
                  File file = File(iftScanFile.first.path ?? "");
                  file.readAsString().then((value) {
                    final document = XmlDocument.parse(value);

                    var member = document.findAllElements("Dentist").first;
                    var patient = document.findAllElements('Patient').first;

                    ClsPatientInfo patientInfo = ClsPatientInfo(
                        "uidMem",
                        "id",
                        patient.findAllElements("Name").first.text,
                        0,
                        0,
                        false,
                        DateTime.now());

                    ClsMember clsMember = ClsMember("UID_Mem", "Mem_ID", "UID_Main", "UID_Plc", "Address_Title");

                    setTaskInfo(clsMember, patientInfo,
                        document.findAllElements('Notes').first.text);
                  });
                }else if (dentalProjectFile.length == 1) {
                  File file = File(dentalProjectFile.first.path ?? "");
                  file.readAsString().then((value) {
                    final document = XmlDocument.parse(value);

                    var member = document.findAllElements('Practice').first;
                    var patient = document.findAllElements('Patient').first;

                    ClsPatientInfo patientInfo = ClsPatientInfo(
                        "uidMem",
                        "id",
                        patient.findAllElements("PatientName").first.text,
                        0,
                        0,
                        false,
                        DateTime.now());

                    ClsMember clsMember = ClsMember("UID_Mem", "Mem_ID", "UID_Main", "UID_Plc", "Address_Title");

                    setTaskInfo(clsMember, patientInfo,
                        document.findAllElements('Notes').first.text);
                  });
                }

              } else {
                // User canceled the picker
              }
            },
            child: const Icon(LineIcons.fileImport),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
              onTap: () {
                // Get.to(SettingPage(callSettingKey: SettingKey.task),
                //       transition: Transition.leftToRight)!
                //   .then((value) => setState(() {}));
                // SettingBinding().dependencies();
                Get.to(SettingPage(callSettingKey: SettingKey.task),
                        transition: Transition.upToDown,
                        duration: const Duration(seconds: 1))!
                    .then((value) => setState(() {}));
              },
              child: const Icon(Icons.settings)),
        )
      ]),
      body: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white38, border: Border.all(color: Colors.lime)),
            child: Obx(
              () => EasyStepper(
                activeStep: myActiveStep.value,
                lineLength: 40,
                stepShape: StepShape.rRectangle,
                stepBorderRadius: 15,
                borderThickness: 2,
                padding: 5,
                stepRadius: 20,
                direction: Axis.vertical,
                finishedStepBorderColor: Colors.deepOrange,
                finishedStepTextColor: Colors.deepOrange,
                finishedStepBackgroundColor: Colors.deepOrange,
                activeStepIconColor: Colors.deepOrange,
                loadingAnimation: myActiveStep.value == 1
                    ? 'assets/animation/tick.json'
                    : myActiveStep.value == 3
                        ? 'assets/animation/tick.json'
                        : 'assets/animation/loading_circle.json',
                steps: [
                  EasyStep(
                    icon: const Icon(Icons.add_task_rounded),
                    title: 'OrderPlaced'.tr,
                  ),
                  EasyStep(
                    icon: const Icon(Icons.send_time_extension_outlined),
                    title: 'Registered'.tr,
                  ),
                  EasyStep(
                    icon: const Icon(Icons.receipt_long),
                    title: 'Reception'.tr,
                  ),
                  EasyStep(
                    icon: const Icon(Icons.settings_suggest_outlined),
                    title: 'Process'.tr,
                  ),
                  EasyStep(
                    icon: const Icon(Icons.check_circle_outline_outlined),
                    title: 'Delivered'.tr,
                  ),
                  EasyStep(
                    icon: const Icon(Icons.payment),
                    title: 'Cashed'.tr,
                  ),
                ],
                onStepReached: (index) {},
              ),
            ),
          ),
          Expanded(
            child: Scaffold(
              body: PageView(
                physics:
                    Globals.prefs.getBool(Globals.prfTaskScrollPage) ?? false
                        ? const ScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                controller: pageController,
                onPageChanged: (pageIndex) {
                  setState(() {
                    _navBarSelectedIndex = pageIndex;
                  });
                },
                children: [
                  Center(child: TaskInfo(description)),
                  Center(child: TaskPage()),
                  const Center(child: const Text('Style')),
                  const Center(child: Text('Profile')),
                ],
              ),
              bottomNavigationBar: myBottomNavigationBar(0),
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     setState(() {
      //     });
      //   },
      //   backgroundColor: Colors.white,
      //   child: const Icon(
      //     LineIcons.save,
      //     color: Colors.red,
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
    );
  }

  // jumpToTabPage(int value) {
  //   if (value == 0) {
  //     animationController?.reverse().then<dynamic>((data) {
  //       if (!mounted) {
  //         return;
  //       }
  //       setState(() {
  //         tabBody = const TaskInfo();
  //       });
  //     });
  //   } else if (value == 1) {
  //     animationController?.reverse().then<dynamic>((data) {
  //       if (!mounted) {
  //         return;
  //       }
  //       setState(() {
  //         tabBody = TaskPage();
  //       });
  //     });
  //   } else if (value == 2) {
  //   } else if (value == 3) {}
  // }

  myBottomNavigationBar(int mode) {
    if (mode == 1) {
      return StylishBottomBar(
          items: [
            BottomBarItem(
              icon: navIcon[0],
              title: Text(navText[0]),
            ),
            BottomBarItem(
              icon: const Icon(Icons.safety_divider),
              title: Text(navText[1]),
            ),
            BottomBarItem(
              icon: const Icon(Icons.safety_divider),
              title: Text(navText[2]),
            ),
            BottomBarItem(
              icon: const Icon(Icons.cabin),
              title: Text(navText[3]),
              showBadge: true,
              badge: badgeCheck(BadgeType.error),
              badgeColor: Colors.transparent,
            ),
          ],
          // fabLocation: StylishBarFabLocation.end,
          hasNotch: true,
          // iconSize: 32,
          currentIndex: _navBarSelectedIndex,
          onTap: (index) {
            setState(() {
              _navBarSelectedIndex = index;
              pageController.jumpToPage(index);
              // controller.jumpToPage(index);
            });
          }, option: BubbleBarOptions(
        barStyle: BubbleBarStyle.horizotnal,
        // barStyle: BubbleBarStyle.vertical,
        bubbleFillStyle: BubbleFillStyle.fill,
        // bubbleFillStyle: BubbleFillStyle.outlined,
        opacity: 0.3,
      ),);
    }
    // else if(mode == 2){
    //   return
    //   ConvexAppBar.badge(
    //     {
    //       0: badgeCheck(BadgeType.ok),
    //       1: badgeCheck(BadgeType.error),
    //       2: badgeCheck(BadgeType.warning),
    //       3: badgeCheck(BadgeType.error)
    //     },
    //     badgeBorderRadius: 8,
    //     badgeMargin: EdgeInsets.only(bottom: 32, left: 32),
    //     items: [
    //       TabItem(icon: Icons.description_outlined, title: "Task"),
    //       TabItem(icon: Icons.settings, title: "Setup"),
    //       TabItem(icon: Icons.color_lens_outlined, title: "Shade"),
    //       TabItem(icon: Icons.design_services, title: "Design"),
    //     ],
    //     backgroundColor: ColorName.navigationBarColor.shade200,
    //     initialActiveIndex: 0,
    //     //optional, default as 0
    //     onTap: (int i) => jumpToTabPage(i),
    //   );
    // }
    else {
      return Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: GNav(
            rippleColor: Colors.blue,
            hoverColor: Colors.red,
            gap: 8,
            activeColor: Colors.blueAccent,
            iconSize: 20,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            duration: const Duration(milliseconds: 400),
            // tabBackgroundColor: Colors.green,
            color: Colors.purple,

            haptic: true,
            // haptic feedback
            tabBorderRadius: 20,
            tabBackgroundGradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [ColorName.gray70, ColorName.statusBarColor[100]!],
            ),
            // tabActiveBorder: Border.all(color: Colors.greenAccent, width: 1),
            // tab button border
            // tabBorder: Border.all(color: Colors.grey, width: 1),
            // tab button border
            // tabShadow: [BoxShadow(color: Colors.blue.withOpacity(0.5), blurRadius: 8)], // tab button shadow
            curve: Curves.linearToEaseOut,
            // tab animation curves

            tabs: [
              GButton(
                icon: Icons.description_outlined,
                text: navText[0],
                leading: badges.Badge(
                  position: BadgePosition.topEnd(top: -12, end: -12),
                  badgeContent: badgeCheck(BadgeType.ok),
                  child: navIcon[0],

                  badgeStyle: badges.BadgeStyle(
                    shape: badges.BadgeShape.square,
                    badgeColor: Colors.transparent,
                    padding: EdgeInsets.all(5),
                    borderRadius: BorderRadius.circular(4),
                    // borderSide: BorderSide(color: Colors.white, width: 2),
                    // borderGradient: badges.BadgeGradient.linear(
                    //     colors: [Colors.red, Colors.black]),
                    badgeGradient: badges.BadgeGradient.linear(
                      colors: [Colors.blue, Colors.yellow],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              GButton(
                icon: Icons.description_outlined,
                text: navText[1],
                leading: badges.Badge(
                  badgeStyle: badges.BadgeStyle(
                    shape: badges.BadgeShape.square,
                    badgeColor: Colors.transparent,
                    padding: EdgeInsets.all(5),
                    // borderRadius: BorderRadius.circular(4),
                    // borderSide: BorderSide(color: Colors.white, width: 2),
                    // borderGradient: badges.BadgeGradient.linear(
                    //     colors: [Colors.red, Colors.black]),
                    badgeGradient: badges.BadgeGradient.linear(
                      colors: [Colors.blue, Colors.yellow],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    elevation: 0,
                  ),
                  position: BadgePosition.topEnd(top: -12, end: -12),
                  badgeContent: badgeCheck(BadgeType.ok),
                  child: navIcon[1],
                ),
              ),
              GButton(
                icon: Icons.description_outlined,
                text: navText[2],
                leading: badges.Badge(
                  badgeStyle: badges.BadgeStyle(
                    shape: badges.BadgeShape.square,
                    badgeColor: Colors.transparent,
                    padding: EdgeInsets.all(5),
                    // borderRadius: BorderRadius.circular(4),
                    // borderSide: BorderSide(color: Colors.white, width: 2),
                    // borderGradient: badges.BadgeGradient.linear(
                    //     colors: [Colors.red, Colors.black]),
                    badgeGradient: badges.BadgeGradient.linear(
                      colors: [Colors.blue, Colors.yellow],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    elevation: 0,
                  ),
                  position: BadgePosition.topEnd(top: -12, end: -12),
                  badgeContent: badgeCheck(BadgeType.ok),
                  child: navIcon[2],
                ),
              ),
              GButton(
                icon: Icons.description_outlined,
                text: navText[3],
                leading: badges.Badge(
                  badgeStyle: badges.BadgeStyle(
                    shape: badges.BadgeShape.square,
                    badgeColor: Colors.transparent,
                    padding: EdgeInsets.all(5),
                    // borderRadius: BorderRadius.circular(4),
                    // borderSide: BorderSide(color: Colors.white, width: 2),
                    // borderGradient: badges.BadgeGradient.linear(
                    //     colors: [Colors.red, Colors.black]),
                    badgeGradient: badges.BadgeGradient.linear(
                      colors: [Colors.blue, Colors.yellow],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    elevation: 0,
                  ),
                  position: BadgePosition.topEnd(top: -12, end: -12),
                  badgeContent: badgeCheck(BadgeType.ok),
                  child: navIcon[3],
                ),
              ),
            ],
            selectedIndex: _navBarSelectedIndex,
            onTabChange: (index) {
              setState(() {
                _navBarSelectedIndex = index;
                pageController.jumpToPage(index);
              });
            },
          ),
        ),
      );
    }
  }

  void setTaskInfo(ClsMember clsMember, ClsPatientInfo clsPatientInfo, String mDescription) {
    setCurrentEmployer(clsMember);
    setCurrentPatient(clsPatientInfo);
    description.value = mDescription;
  }
}
