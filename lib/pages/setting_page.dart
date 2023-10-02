import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:time_zone_list/time_zone_list.dart';
// import 'package:wakelock/wakelock.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:wakelock_plus/wakelock_plus.dart';

import '../gen/colors.gen.dart';
import '../public/modeles.dart';
import '../public/public_functions.dart';
import '../public/public_variables.dart';
import '../public/public_variables.dart';

class SettingPage extends StatefulWidget {
  // final SettingController _controller = Get.find<SettingController>();
  SettingKey callSettingKey;

  SettingPage({Key? key, required this.callSettingKey}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

enum SettingKey { public, login, task, employer, patient, other }

// class SettingValues {
//   // static bool wakeUp = false.obs;
//   // static RxBool taskScrollPage = false.obs;
//   // static RxBool employerExpand = false.obs;
// }

class _SettingPageState extends State<SettingPage> {
  List<GlobalKey> _globalKey = [];

  List<LocationModel> listLocation = [];

  late Future<List<TimeZoneInfo>> listTimeZone;

  // List<TimeZoneInfo> zoneList = [];

  // List<LanguageModel> languagesList = languages;
  // ["English", "فارسی"];

  @override
  void initState() {
    for (int i=0; i<SettingKey.values.length; i++) {
      _globalKey.add(GlobalKey());
    }
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) =>
        Scrollable.ensureVisible(
            duration: Duration(seconds: 1),
            _globalKey[widget.callSettingKey.index].currentContext!));
    // Scrollable.ensureVisible(_globalKey[widget.callSettingKey.index].currentContext!);
    tz.initializeTimeZones();
    tz.timeZoneDatabase.locations
        .forEach((k, v) => listLocation.add(LocationModel(k, v)));

    listTimeZone = TimeZoneList.getList();
    // .then((value) => listTimeZone.addAll(value));

    // await TimeZoneList.getList().then((listZone) {
    //   listZone.forEach((element) {
    //     listLocation.add(element.timeZone, element);
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr),
        backgroundColor: ColorName.appBar,
      ),
      body: SafeArea(
        child: Container(
          child: SettingsList(
            sections: [
              SettingsSection(
                key: _globalKey[SettingKey.public.index],
                title: Text('publicSetting'.tr),
                tiles: [
                  SettingsTile.navigation(
                    leading: const Icon(Icons.language),
                    title: Text('Language'.tr),
                    value: Text(languages
                        .firstWhere((element) =>
                            element.symbol ==
                            Globals.prefs.getString(Globals.prfMyLanguage))
                        .language),
                    onPressed: (context) {
                      SelectDialog.showModal<LanguageModel>(
                        context,
                        showSearchBox: false,
                        label: 'Language'.tr,
                        useRootNavigator: true,
                        autofocus: true,
                        items: languages,
                        // selectedValue: widget._controller.selectedLanguage.value,
                        // items: List.generate(languages.length, (index) => languages[index]),
                        itemBuilder: (BuildContext context, LanguageModel item,
                            bool isSelected) {
                          return Container(
                            decoration: (item.symbol !=
                                    Globals.prefs
                                        .getString(Globals.prfMyLanguage))
                                ? null
                                : BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Theme.of(context).primaryColor),
                                  ),
                            child: ListTile(
                              // leading: CircleAvatar(backgroundImage: item.avatar == null ? null : NetworkImage(item.avatar!)),
                              selected: isSelected,
                              title: Text(item.language),
                              subtitle: Text(item.symbol),
                            ),
                          );
                        },
                        // List.generate(10, (index) => "Item $index"),
                        onChange: (LanguageModel selected) {
                          setState(() {
                            changeLanguage(selected.symbol);
                          });
                        },
                      );
                    },
                  ),
                  SettingsTile.navigation(
                    leading: const Icon(Icons.calendar_month_outlined),
                    title: Text('Date'.tr),
                    value: Text(dateTypes
                        .firstWhere(
                            (element) =>
                                element.symbol ==
                                Globals.prefs.getString(Globals.prfMyDate),
                            orElse: () => dateTypes.first)
                        .description),
                    onPressed: (context) {
                      SelectDialog.showModal<dateModel>(
                        context,
                        showSearchBox: false,
                        label: 'Date'.tr,
                        useRootNavigator: true,
                        autofocus: true,
                        items: dateTypes,
                        // selectedValue: widget._controller.selectedLanguage.value,
                        // items: List.generate(languages.length, (index) => languages[index]),
                        itemBuilder: (BuildContext context, dateModel item,
                            bool isSelected) {
                          return Container(
                            decoration: (item.symbol !=
                                    Globals.prefs.getString(Globals.prfMyDate))
                                ? null
                                : BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Theme.of(context).primaryColor),
                                  ),
                            child: ListTile(
                              // leading: CircleAvatar(backgroundImage: item.avatar == null ? null : NetworkImage(item.avatar!)),
                              selected: isSelected,
                              title: Text(item.dateType),
                              subtitle: Text(item.description),
                            ),
                          );
                        },
                        // List.generate(10, (index) => "Item $index"),
                        onChange: (dateModel selected) {
                          setState(() {
                            Globals.prefs
                                .setString(Globals.prfMyDate, selected.symbol);
                          });
                        },
                      );
                    },
                  ),
                  SettingsTile.navigation(
                    leading: const Icon(Icons.access_time),
                    title: Text('TimeZone'.tr),
                    value: Text(
                        Globals.prefs.getString(Globals.prfMyZoneLocation) ??
                            "No Set"),
                    onPressed: (context) {
                      listTimeZone.then((retListTimeZone) {
                        SelectDialog.showModal<TimeZoneInfo>(
                          context,
                          showSearchBox: true,
                          label: 'TimeZone'.tr,
                          useRootNavigator: false,
                          autofocus: false,
                          items: retListTimeZone,
                          itemBuilder: (BuildContext context, TimeZoneInfo item,
                              bool isSelected) {
                            return Container(
                              decoration: (item.tag !=
                                      Globals.prefs
                                          .getString(Globals.prfMyZoneLocation))
                                  ? null
                                  : BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      border: Border.all(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                              child: ListTile(
                                // leading: CircleAvatar(backgroundImage: item.avatar == null ? null : NetworkImage(item.avatar!)),
                                selected: isSelected,
                                title: Text(item.tag?? "--"),
                                subtitle: Text(item.timeZone),
                                // DateTime.now().timeZoneOffset.toString()
                              ),
                            );
                          },
                          // List.generate(10, (index) => "Item $index"),
                          onChange: (TimeZoneInfo selected) {
                            setState(() {
                              Globals.prefs.setString(
                                  Globals.prfMyZoneLocation, selected.tag?? selected.timeZone);
                            });
                          },
                        );
                      });
                    },
                  ),
                  SettingsTile.switchTile(
                      initialValue: Globals.prefs.getBool(Globals.prfWakeUp),
                      activeSwitchColor: Colors.red,
                      onToggle: (val) {
                        Globals.prefs.setBool(Globals.prfWakeUp, val);
                        WakelockPlus.toggle(enable: val);
                        setState(() {});
                      },
                      title: Text('WakeUp'.tr)),
                  SettingsTile.switchTile(
                      initialValue: false,
                      onToggle: (s) {},
                      title: Text('DarkTheme'.tr))
                ],
              ),
              SettingsSection(
                key: _globalKey[SettingKey.login.index],
                title: Text('LoginPageSetting'.tr),
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    leading: const Icon(Icons.account_circle),
                    title: Text('UserName'.tr),
                  ),
                  SettingsTile.navigation(
                    leading: const Icon(Icons.password),
                    title: Text('Password'.tr),
                  ),
                ],
              ),
              SettingsSection(
                key: _globalKey[SettingKey.task.index],
                title: Text('TaskPageSetting'.tr),
                tiles: <SettingsTile>[
                  SettingsTile.switchTile(
                      initialValue:
                          Globals.prefs.getBool(Globals.prfTaskScrollPage),
                      activeSwitchColor: Colors.red,
                      onToggle: (val) {
                        Globals.prefs.setBool(Globals.prfTaskScrollPage, val);
                        WakelockPlus.toggle(enable: val);
                        setState(() {});
                      },
                      leading: const Icon(Icons.compare_arrows_sharp),
                      title: Text('ScrollPage'.tr)),
                ],
              ),
              SettingsSection(
                key: _globalKey[SettingKey.patient.index],
                title: Text('PatientPageSetting'.tr),
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    leading: const Icon(Icons.calendar_month_outlined),
                    title: Text('PatientAge'.tr),
                    value: Text(ageTypes
                        .firstWhere(
                            (element) =>
                        element.code ==
                            Globals.prefs.getInt(Globals.prfPatientAge),
                        orElse: () => ageTypes.first)
                        .title),
                    onPressed: (context) {
                      SelectDialog.showModal<AgeModel>(
                        context,
                        showSearchBox: false,
                        label: 'PatientAge'.tr,
                        useRootNavigator: true,
                        autofocus: true,
                        items: ageTypes,
                        // selectedValue: widget._controller.selectedLanguage.value,
                        // items: List.generate(languages.length, (index) => languages[index]),
                        itemBuilder: (BuildContext context, AgeModel item,
                            bool isSelected) {
                          return Container(
                            decoration: (item.code !=
                                Globals.prefs.getInt(Globals.prfPatientAge))
                                ? null
                                : BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              border: Border.all(
                                  color: Theme.of(context).primaryColor),
                            ),
                            child: ListTile(
                              // leading: CircleAvatar(backgroundImage: item.avatar == null ? null : NetworkImage(item.avatar!)),
                              selected: isSelected,
                              title: Text(item.title),
                              subtitle: Text(item.description?? ""),
                            ),
                          );
                        },
                        // List.generate(10, (index) => "Item $index"),
                        onChange: (AgeModel selected) {
                          setState(() {
                            Globals.prefs
                                .setInt(Globals.prfPatientAge, selected.code);
                          });
                        },
                      );
                    },
                  ),
                  // SettingsTile.switchTile(
                  //     initialValue:
                  //     Globals.prefs.getBool(Globals.prfPatientAge),
                  //     activeSwitchColor: Colors.red,
                  //     onToggle: (val) {
                  //       Globals.prefs.setBool(Globals.prfPatientAge, val);
                  //       Wakelock.toggle(enable: val);
                  //       setState(() {});
                  //     },
                  //     leading: const Icon(Icons.calendar_month_rounded),
                  //     title: Text('PatientBirthday'.tr)),
                ],
              ),
              SettingsSection(
                key: _globalKey[SettingKey.employer.index],
                title: Text('EmployerPageSetting'.tr),
                tiles: <SettingsTile>[
                  SettingsTile.switchTile(
                      initialValue:
                          Globals.prefs.getBool(Globals.prfEmployerExpand),
                      activeSwitchColor: Colors.red,
                      onToggle: (val) {
                        Globals.prefs.setBool(Globals.prfEmployerExpand, val);
                        WakelockPlus.toggle(enable: val);
                        setState(() {});
                      },
                      leading: const Icon(Icons.expand),
                      title: Text('ExpandList'.tr)),
                ],
              ),
              SettingsSection(
                key: _globalKey[SettingKey.other.index],
                title: Text('Setting'.tr),
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    leading: const Icon(Icons.refresh),
                    title: Text('other'.tr),
                    value: Text(""),
                    onPressed: (context) {
                    },
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
