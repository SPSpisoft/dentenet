import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

// import 'package:numberpicker/numberpicker.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:rolling_switch/rolling_switch.dart';
import 'package:spflutter_number_picker/spflutter_number_picker.dart';
import 'package:flutter_switch_clipper/flutter_switch_clipper.dart';
import 'package:spring_button/spring_button.dart';
import 'package:sps_persian_datetime_picker/sps_persian_datetime_picker.dart';

import '../data/app.dart';
import '../data/data_fetch.dart';
import '../gen/colors.gen.dart';
import '../public/public_functions.dart';
import '../public/public_variables.dart';
import '../public/modeles.dart';
import 'setting_page.dart';

class PatientPage extends StatefulWidget {
  const PatientPage({Key? key}) : super(key: key);

  @override
  State<PatientPage> createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  RxList<ClsPatientInfo> myPatientList = <ClsPatientInfo>[].obs;
  RxList<ClsPatientInfo> myPatientListFilter = <ClsPatientInfo>[].obs;

  RxInt patientSelId = (-1).obs;

  late bool _isOffline;

  // RxBool patientNameRefresh = false.obs;

  RxInt patientGender = 0.obs;
  RxBool patientInfectious = false.obs;
  RxString patientNamePrefix = "".obs;
  RxString patientName = "".obs;
  RxString patientDesc = "".obs;
  RxInt patientRecId = 0.obs;
  RxInt patientAge = 0.obs;
  RxInt patientBirthYear = Globals.prefs.getString(Globals.prfMyDate) == "J"
      ? Jalali.fromDateTime(DateTime.now()).year.obs
      : DateTime.now().year.obs;

  RxBool nwPatientAge = false.obs;
  RxBool nwPatientBirthday = false.obs;
  RxBool nwPatientYear = false.obs;
  RxBool nwPatientYearRange = false.obs;
  RxBool nwPatientDesc = false.obs;
  RxBool nwPatientInfectious = false.obs;

  // DateTime.now().year.obs;

  var txtController = TextEditingController();

  final double _rowHeight = 45;
  final double _radiusBorder = 20;

  // late NumberPicker agePicker;
  // late NumberPicker birthYearPicker;
  RxDouble birthYear = 0.0.obs;
  RxDouble ageReset = 0.0.obs;

  var patientBirthday = Globals.myDateTime.obs;

  RxString mt1 = Globals.prefs.getString(Globals.prfMyDate) == "J"
      ? Globals.myDateTime.toJalali().formatCompactDate().obs
      : DateFormat(Globals.gregorianDateFormat).format(Globals.myDateTime).obs;

  RxString mt2 = Globals.prefs.getString(Globals.prfMyDate) == "J"
      ? Globals.myDateTime.toJalali().formatMediumDate().obs
      : DateFormat(Globals.gregorianDateDayFormat)
          .format(Globals.myDateTime)
          .obs;

  RxString mt3 = Globals.prefs.getString(Globals.prfMyDate) == "J"
      ? Globals.myDateTime.toJalali().formatFullDate().obs
      : DateFormat(Globals.gregorianDateDayMonFormat)
          .format(Globals.myDateTime)
          .obs;

  RxInt rangeAgeValue = 0.obs;

  TextEditingController editingControllerPatientName = TextEditingController();
  TextEditingController editingControllerPatientDesc = TextEditingController();

  var topViewKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    setNwCheck();

    editingControllerPatientName.text = patientName.value;
    editingControllerPatientDesc.text = patientDesc.value;

    //     .addListener(() {
    //   patientName.value = editingControllerPatientName.text;
    // });
    // editingControllerPatientName.selection = editingControllerPatientName.selection.copyWith(extentOffset:
    // editingControllerPatientName.text.length);

    ageReset.listen((p0) {
      patientAge.value = p0.toInt();
    });

  }

  @override
  void dispose() {
    editingControllerPatientName.dispose();
    editingControllerPatientDesc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'patient'.tr,
          ),
          backgroundColor: ColorName.appBar,
          actions: [
            // SettingValues.employerExpand.value ?
            // Padding(
            //   padding: EdgeInsets.all(8.0),
            //   child: InkWell(
            //       onTap: () {
            //         _expandAll = !_expandAll;
            //         setState(() {
            //         });
            //       },
            //       child: Icon(Icons.arrow_drop_down_circle_outlined)),
            // ): Container(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () {
                    // SettingBinding().dependencies();
                    // Get.to(SettingPage(callSettingKey: SettingKey.patient),
                    //         transition: Transition.upToDown,
                    //         duration: const Duration(seconds: 1))!
                    //     .then((value) => setState(() {}));
                    Get.to(SettingPage(callSettingKey: SettingKey.patient),
                            transition: Transition.upToDown,
                            duration: const Duration(seconds: 1))!
                        .then((value) => setState(() {}));
                  },
                  child: const Icon(Icons.settings)),
            ),
          ]),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: myPatientList.isNotEmpty
            ? body(_isOffline)
            : FutureBuilder<RetPatientModel>(
                future: fetchPatients(Globals.myMemberId, ""),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState.index == 1) {
                    //waiting
                    return Center(
                      child: JumpingDotsProgressIndicator(
                        fontSize: 35.0,
                        color: Colors.blueAccent,
                      ),
                    );
                  }
                  // } else {
                  if (snapshot.hasError) {
                    if (snapshot.error == 403) {
                      // fetchToken(context,
                      //     false,
                      //     Globals.myTypeID,
                      //     Globals.myStoreId,
                      //     Globals.myMemberId,
                      //     Globals.myNetIP,
                      //     Globals.myDeviceId,
                      //     Globals.myAppVersion,
                      //     Globals.myPassword)
                      //     .whenComplete(() => setState(() {}));
                      return const Center(
                        child: SizedBox(
                            child: Text(
                                'لطفا چند لحظه صبر کنید \n در حال اتصال به سرور')),
                      );
                    } else {
                      return Center(
                        child: Column(
                          children: [
                            SizedBox(
                                child: Text(
                                    '${snapshot.error}\n دوباره سعی کنید \n دریافت اطلاعات با مشکل مواجه شد')),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      );
                    }
                  } else {
                    // if (!snapshot.hasData || snapshot.data!.retList.isEmpty) {
                    //   return const Center(
                    //       child: SizedBox(child: Text('data is empty!')));
                    // } else
                    {
                      // Globals.myMemberList = snapshot.data!.retList;
                      myPatientList.value = (snapshot.data!.retList);
                      myPatientListFilter.addAll(myPatientList);

                      // String v = "SPS>> ";
                      // snapshot.data!.toList().forEach((element) {
                      //   v = v + " - "+ element.UID_Mem.toString();
                      // });
                      // print(v);
                      // Get.snackbar("snapshot.data!.toList().toString()", v);
                      // widget.memberBox!.removeAll();
                      // widget.memberBox!.putMany(snapshot.data!);
                      // snapshot.data!.forEach((element) {
                      //   widget.memberBox!.put(element);
                      // });
                      _isOffline = snapshot.data!.retCode != 200;
                      return body(_isOffline);
                    }
                  }
                  // }
                },
              ),
      ),
    );
  }

  body(bool isOffline) {
    Rx<ButtonState> stateSetUserButton = ButtonState.idle.obs;
    Rx<ButtonState> stateBackButton = ButtonState.idle.obs;
    RxBool warningButtonState = false.obs;
    return SingleChildScrollView(
      child: Column(
        key: topViewKey,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.white10, width: 2)),
              child: Column(
                children: [
                  IntrinsicHeight(
                    child: Obx(() {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          patientGender.value == 0
                              ? InkWell(
                                  onTap: () {
                                    patientGender.value = 1;
                                  },
                                  child: SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: Image.asset(
                                          "assets/images/icons/gender.png")),
                                )
                              : SpringButton(
                                  SpringButtonType.OnlyScale,
                                  Obx(() {
                                    return SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: patientGender.value == 1
                                            ? Image.asset(
                                                "assets/images/icons/female.png")
                                            : Image.asset(
                                                "assets/images/icons/male.png"));
                                  }),
                                  onTapDown: (_) {
                                    patientGender.value == 1
                                        ? patientGender.value = 2
                                        : patientGender.value = 1;

                                    patientSelId.value = -1;
                                    setNwCheck();
                                  },
                                  onLongPressEnd: (_) {
                                    patientGender.value = 0;
                                  },
                                ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Obx(
                                () => TextField(
                                  style: TextStyle(
                                      fontSize: Globals.textSize,
                                      fontFamily: Globals.textFont,
                                      color: Colors.black87),

                                  controller: editingControllerPatientName,
                                  // TextEditingController()
                                  //   ..text = patientName.value ,

                                  onChanged: (text) {
                                    // patientNameRefresh.value = false;
                                    patientName.value = text;
                                    myPatientListFilter.clear();
                                    myPatientListFilter.addAll(myPatientList
                                        .where((p) => p.name.contains(text)));
                                    patientSelId.value = -1;
                                    setNwCheck();
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            _radiusBorder)),
                                    prefixStyle: TextStyle(
                                        fontSize: Globals.textSize,
                                        fontFamily: Globals.textFont,
                                        color: Colors.blueGrey),
                                    prefixText: patientGender.value == 2
                                        ? "Male".tr
                                        : patientGender.value == 1
                                            ? "Female".tr
                                            : "",
                                    labelText: 'PatientName'.tr,
                                    // hintText: "  ${'EnterPatientNameHere'.tr}"
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                  SizedBox(
                    height: 80,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: (Globals.prefs.getInt(Globals.prfPatientAge) ==
                                  ageTypes.elementAt(0).code)
                              ? ageRange()
                              : (Globals.prefs.getInt(Globals.prfPatientAge) ==
                                      ageTypes.elementAt(1).code)
                                  ? birthdayFull()
                                  : (Globals.prefs
                                              .getInt(Globals.prfPatientAge) ==
                                          ageTypes.elementAt(2).code)
                                      ? birthdayYear()
                                      : Container(),
                        ),
                        Expanded(
                          flex: 1,
                          child: agePicker(),
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SpringButton(
                            SpringButtonType.OnlyScale,
                            Obx(() {
                              return SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Container(
                                    decoration: warningDecoration(
                                        nwPatientInfectious.value),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: patientInfectious.value
                                          ? Image.asset(
                                              "assets/images/icons/do_not_touch.png")
                                          : Image.asset(
                                              "assets/images/icons/like_green_circle.png"),
                                    ),
                                  ));
                            }),
                            onTapDown: (_) {
                              patientInfectious.value
                                  ? patientInfectious.value = false
                                  : patientInfectious.value = true;

                              setNwCheck();
                            },
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Obx(
                                () => TextField(
                                  style: TextStyle(
                                      fontSize: patientDesc.value != null
                                          ? Globals.textSize
                                          : 2,
                                      fontFamily: Globals.textFont,
                                      color: Colors.black87),

                                  controller: editingControllerPatientDesc,
                                  // controller: TextEditingController()
                                  //   ..text = patientName.value,
                                  // onChanged: (text) => {
                                  //   patientName.value = text,
                                  // },
                                  onChanged: (text) {
                                    patientDesc.value = text;
                                    setNwCheck();
                                  },
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(_radiusBorder),
                                      borderSide: BorderSide(
                                        color: nwPatientDesc.value
                                            ? Colors.orangeAccent
                                            : Colors.blue,
                                        width: 1.0,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(_radiusBorder),
                                      borderSide: BorderSide(
                                        color: nwPatientDesc.value
                                            ? Colors.red
                                            : Colors.grey,
                                        width: 1.0,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            _radiusBorder),
                                        borderSide: const BorderSide(
                                            color: Colors.redAccent, width: 1)),
                                    prefixStyle: TextStyle(
                                        fontSize: Globals.textSize,
                                        fontFamily: Globals.textFont,
                                        color: Colors.blueGrey),
                                    labelText: 'Description'.tr,
                                    // hintText: "  ${'EnterPatientNameHere'.tr}"
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Obx(() {
                                return ProgressButton.icon(
                                    radius: 20.0,
                                    iconedButtons: {
                                      ButtonState.idle: IconedButton(
                                          text: "Cancel".tr,
                                          icon: const Icon(
                                              Icons.cancel_outlined,
                                              color: Colors.white),
                                          color: Colors.blueGrey.shade200),
                                      ButtonState.loading: IconedButton(
                                          text: "Loading".tr,
                                          color: Colors.deepPurple.shade700),
                                      ButtonState.fail: IconedButton(
                                          text: "Failed".tr,
                                          icon: const Icon(Icons.cancel,
                                              color: Colors.white),
                                          color: Colors.red.shade300),
                                      ButtonState.success: IconedButton(
                                          text: "Back".tr,
                                          icon: const Icon(
                                            Icons.check_circle,
                                            color: Colors.white,
                                          ),
                                          color: Colors.red.shade400)
                                    },
                                    onPressed: () {
                                      stateBackButton.value =
                                          ButtonState.success;
                                      if (Navigator.canPop(context)) {
                                        Navigator.pop(context);
                                      } else {
                                        SystemNavigator.pop();
                                      }
                                    },
                                    state: stateBackButton.value);
                              })),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Obx(() {
                                return ProgressButton.icon(
                                    radius: 20.0,
                                    iconedButtons: {
                                      ButtonState.idle: patientRecId.value > 0
                                          ? comparePatient()
                                              ? IconedButton(
                                                  text: "Select".tr,
                                                  icon: const Icon(Icons.check,
                                                      color: Colors.white),
                                                  color: Colors.green.shade300)
                                              : IconedButton(
                                                  text: "Update".tr,
                                                  icon: const Icon(
                                                      Icons.save_as_outlined,
                                                      color: Colors.white),
                                                  color: Colors.orange.shade300)
                                          : IconedButton(
                                              text: "Save".tr,
                                              icon: const Icon(
                                                  Icons.save_outlined,
                                                  color: Colors.white),
                                              color: Colors.blueGrey.shade300),
                                      ButtonState.loading: IconedButton(
                                          text: "Loading".tr,
                                          color: Colors.deepPurple.shade700),
                                      ButtonState.fail: IconedButton(
                                          text: "Failed".tr,
                                          icon: const Icon(Icons.cancel,
                                              color: Colors.white),
                                          color: Colors.red.shade300),
                                      ButtonState.success: warningButtonState
                                              .value
                                          ? IconedButton(
                                              text: "Repeat".tr,
                                              icon: const Icon(
                                                Icons.warning_rounded,
                                                color: Colors.white,
                                              ),
                                              color:
                                                  Colors.orangeAccent.shade400)
                                          : IconedButton(
                                              text: "Success".tr,
                                              icon: const Icon(
                                                Icons.check_circle,
                                                color: Colors.white,
                                              ),
                                              color: Colors.green.shade400),
                                    },
                                    onPressed: () async {
                                      // onPressedCustomButton();
                                      // setState(() {
                                      switch (stateSetUserButton.value) {
                                        case ButtonState.idle:
                                          if (patientRecId.value > 0 &&
                                              comparePatient()) {
                                            Globals.currentPatient.clear();
                                            Globals.currentPatient.add( myPatientList
                                                .firstWhere((element) => element.idRec == patientRecId.value));
                                            Navigator.pop(context);
                                          } else {
                                            stateSetUserButton.value =
                                                ButtonState.loading;
                                            ClsPatientInfo clsPatientInfo =
                                                ClsPatientInfo(
                                                    Globals.myMemberId,
                                                    "temp",
                                                    patientName.value,
                                                    patientGender.value,
                                                    patientAge.value,
                                                    patientInfectious.value,
                                                    DateTime.now(),
                                                    idRec: patientRecId.value,
                                                    userId: Globals.myUser,
                                                    birthday: patientBirthday
                                                                .value !=
                                                            Globals.myDateTime
                                                        ? patientBirthday.value
                                                        : null,
                                                    description:
                                                        patientDesc.value);
                                            if (!checkPatientInfo(
                                                clsPatientInfo)) {
                                              stateSetUserButton.value =
                                                  ButtonState.fail;
                                              await Future.delayed(
                                                  const Duration(seconds: 2));
                                              stateSetUserButton.value =
                                                  ButtonState.idle;
                                            } else {
                                              putPatient(clsPatientInfo)
                                                  .then((vRet) async {
                                                if (vRet.retCode == 200) {
                                                  stateSetUserButton.value =
                                                      ButtonState.success;
                                                  await Future.delayed(
                                                      const Duration(
                                                          seconds: 2));
                                                  stateSetUserButton.value =
                                                      ButtonState.idle;
                                                  clsPatientInfo.idRec = vRet
                                                      .retList.first["IdRec"];
                                                  myPatientList
                                                      .add(clsPatientInfo);
                                                  myPatientListFilter
                                                      .add(clsPatientInfo);

                                                  patientSelId.value = vRet
                                                      .retList.first["IdRec"];
                                                  selPatient();
                                                } else if (vRet.retCode ==
                                                    202) {
                                                  warningButtonState.value =
                                                      true;
                                                  stateSetUserButton.value =
                                                      ButtonState.success;
                                                  await Future.delayed(
                                                      const Duration(
                                                          seconds: 2));
                                                  warningButtonState.value =
                                                      false;
                                                  await Future.delayed(
                                                      const Duration(
                                                          seconds: 1));
                                                  stateSetUserButton.value =
                                                      ButtonState.idle;

                                                  int index = myPatientList
                                                      .indexWhere((element) =>
                                                          element.idRec ==
                                                          clsPatientInfo.idRec);
                                                  myPatientList[index] =
                                                      clsPatientInfo;
                                                  myPatientListFilter[index] =
                                                      clsPatientInfo;
                                                } else if (vRet.retCode ==
                                                    201) {
                                                  stateSetUserButton.value =
                                                      ButtonState.fail;

                                                  if (clsPatientInfo.age ==
                                                          vRet.retList
                                                              .first["Age"] &&
                                                      clsPatientInfo
                                                              .description ==
                                                          vRet.retList.first[
                                                              "Description"]) {
                                                    ToastNormal(
                                                        "RecordInserted".tr,
                                                        context,
                                                        type: -1);
                                                    warningButtonState.value =
                                                        true;
                                                    stateSetUserButton.value =
                                                        ButtonState.success;
                                                    await Future.delayed(
                                                        const Duration(
                                                            seconds: 2));
                                                    warningButtonState.value =
                                                        false;
                                                    stateSetUserButton.value =
                                                        ButtonState.idle;
                                                  } else {
                                                    AwesomeDialog(
                                                      context: context,
                                                      animType:
                                                          AnimType.topSlide,
                                                      headerAnimationLoop:
                                                          false,
                                                      dialogType:
                                                          DialogType.question,
                                                      body: Center(
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              'RepeatPatient'
                                                                  .tr,
                                                              style: const TextStyle(
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                dateTime2String(
                                                                    DateTime.parse(vRet
                                                                        .retList
                                                                        .first["SetDate"]),
                                                                    "${'SetDate'.tr} : "),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: const TextStyle(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontSize:
                                                                        9),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "${vRet.retList.first["Gender"] == 2 ? 'Male'.tr : vRet.retList.first["Gender"] == 1 ? 'Female'.tr : ""} ${vRet.retList.first["Name"]}",
                                                                    style: const TextStyle(
                                                                        fontStyle:
                                                                            FontStyle.normal),
                                                                  ),
                                                                  clsPatientInfo
                                                                              .age ==
                                                                          vRet.retList
                                                                              .first["Age"]
                                                                      ? Container()
                                                                      : Row(
                                                                          children: [
                                                                            Text(" ${'OnlyAge'.tr} : ",
                                                                                style: const TextStyle(fontStyle: FontStyle.normal, color: Colors.blueGrey, fontSize: 10)),
                                                                            (vRet.retList.first["Age"] ?? 0) > 0
                                                                                ? Text(
                                                                                    (vRet.retList.first["Age"] ?? 0).toString(),
                                                                                    style: const TextStyle(fontStyle: FontStyle.normal, color: Colors.grey),
                                                                                  )
                                                                                : Container(),
                                                                            const Padding(
                                                                              padding: EdgeInsets.all(3.0),
                                                                              child: Icon(
                                                                                Icons.cached,
                                                                                color: Colors.blue,
                                                                                size: 12,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              clsPatientInfo.age.toString(),
                                                                              style: const TextStyle(fontStyle: FontStyle.normal, fontSize: 10, color: Colors.green),
                                                                            )
                                                                          ],
                                                                        ),
                                                                ],
                                                              ),
                                                            ),
                                                            clsPatientInfo
                                                                        .description ==
                                                                    vRet.retList
                                                                            .first[
                                                                        "Description"]
                                                                ? Container()
                                                                : Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      patientInfectious.value !=
                                                                              vRet.retList.first[
                                                                                  "Infectious"]
                                                                          ? SizedBox(
                                                                              height: 20,
                                                                              width: 20,
                                                                              child: patientInfectious.value ? Image.asset("assets/images/icons/do_not_touch.png") : Image.asset("assets/images/icons/like_green_circle.png"))
                                                                          : Container(),
                                                                      vRet.retList.first["Description"] !=
                                                                              null
                                                                          ? Text(
                                                                              vRet.retList.first["Description"] ?? "",
                                                                              style: const TextStyle(fontStyle: FontStyle.normal, fontSize: 11, color: Colors.grey),
                                                                            )
                                                                          : Container(),
                                                                      const Padding(
                                                                        padding:
                                                                            EdgeInsets.all(3.0),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .cached,
                                                                          color:
                                                                              Colors.blue,
                                                                          size:
                                                                              12,
                                                                        ),
                                                                      ),
                                                                      clsPatientInfo.description !=
                                                                              null
                                                                          ? Text(
                                                                              clsPatientInfo.description ?? "",
                                                                              style: const TextStyle(fontStyle: FontStyle.normal, fontSize: 11, color: Colors.redAccent),
                                                                            )
                                                                          : Container(),
                                                                    ],
                                                                  ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                'PatientUpdate'
                                                                    .tr,
                                                                style: const TextStyle(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          8),
                                                              child: Text(
                                                                'PatientReset'
                                                                    .tr,
                                                                style: const TextStyle(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      title: 'Update'.tr,
                                                      btnCancelText:
                                                          "Cancel".tr,
                                                      btnCancelColor: Colors
                                                          .deepOrangeAccent,
                                                      btnCancelOnPress: () {
                                                        // Navigator.pop(context);
                                                        stateSetUserButton
                                                                .value =
                                                            ButtonState.idle;
                                                      },
                                                      btnOkText: 'Update'.tr,
                                                      btnOkOnPress: () {
                                                        clsPatientInfo.idRec =
                                                            vRet.retList
                                                                .first["IdRec"];
                                                        putPatient(
                                                                clsPatientInfo)
                                                            .then((vRet) async {
                                                          if (vRet.retCode ==
                                                              202) {
                                                            // warningButtonState
                                                            //     .value =
                                                            // true;
                                                            stateSetUserButton
                                                                    .value =
                                                                ButtonState
                                                                    .success;
                                                            await Future.delayed(
                                                                const Duration(
                                                                    seconds:
                                                                        2));
                                                            // warningButtonState
                                                            //     .value =
                                                            // false;
                                                            await Future.delayed(
                                                                const Duration(
                                                                    seconds:
                                                                        1));
                                                            stateSetUserButton
                                                                    .value =
                                                                ButtonState
                                                                    .idle;

                                                            int index = myPatientList
                                                                .indexWhere((element) =>
                                                                    element
                                                                        .idRec ==
                                                                    clsPatientInfo
                                                                        .idRec);
                                                            myPatientList[
                                                                    index] =
                                                                clsPatientInfo;
                                                            myPatientListFilter[
                                                                    index] =
                                                                clsPatientInfo;
                                                          } else {
                                                            stateSetUserButton
                                                                    .value =
                                                                ButtonState
                                                                    .fail;
                                                          }
                                                          setNwCheck();
                                                          return null;
                                                        });
                                                      },
                                                    ).show();
                                                  }
                                                } else if (vRet.retCode == 0) {
                                                  ToastNormal(
                                                      "ServerNotFound".tr,
                                                      context,
                                                      type: -1);
                                                  stateSetUserButton.value =
                                                      ButtonState.fail;
                                                  await Future.delayed(
                                                      const Duration(
                                                          seconds: 4));
                                                  stateSetUserButton.value =
                                                      ButtonState.idle;
                                                } else {
                                                  ToastNormal(
                                                      "Error code : ${vRet.retCode}",
                                                      context,
                                                      type: -1);
                                                  stateSetUserButton.value =
                                                      ButtonState.fail;
                                                }
                                                setNwCheck();
                                                return null;
                                              });
                                            }
                                          }
                                          break;
                                        case ButtonState.loading:
                                          stateSetUserButton.value =
                                              ButtonState.fail;
                                          break;
                                        case ButtonState.success:
                                          stateSetUserButton.value =
                                              ButtonState.idle;
                                          break;
                                        case ButtonState.fail:
                                          stateSetUserButton.value =
                                              ButtonState.idle;
                                          break;
                                      }
                                      // });
                                    },
                                    state: stateSetUserButton.value);
                              })),
                        ),
                      ],
                    ),
                  )
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 15, left: 5, right: 5),
                  //   child: TextField(
                  //     style: TextStyle(
                  //         fontSize: Globals.textSize,
                  //         fontFamily: Globals.textFont,
                  //         color: Colors.black87),
                  //
                  //     // controller: TextEditingController()
                  //     //   ..text = patientName.value,
                  //     // onChanged: (text) => {
                  //     //   patientName.value = text,
                  //     // },
                  //     decoration: InputDecoration(
                  //       border: const OutlineInputBorder(),
                  //       prefixStyle: TextStyle(
                  //           fontSize: Globals.textSize,
                  //           fontFamily: Globals.textFont,
                  //           color: Colors.blueGrey),
                  //       labelText: 'Description'.tr,
                  //       // hintText: "  ${'EnterPatientNameHere'.tr}"
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
          Obx(() {
            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: myPatientListFilter.length,
              itemBuilder: (BuildContext context, int index) => InkWell(
                onTap: () {
                  // Globals.currentMember.value = section.clsMembers[index].UID_Mem;
                  // setState(() {});
                  print(">> Index >> " + index.toString());
                  patientSelId.value = myPatientListFilter[index].idRec!;
                  selPatient();

                  WidgetsBinding.instance.addPostFrameCallback((_) =>
                      Scrollable.ensureVisible(
                          duration: const Duration(seconds: 1),
                          topViewKey.currentContext!));
                },
                child: Card(
                  margin: const EdgeInsets.all(2),
                  shadowColor: Colors.white,
                  // (Globals.currentMember.value.isEmpty || (section.clsMembers[index].UID_Mem != Globals.currentMember.value)) ? Colors.white : Colors.red,
                  color: Colors.white,
                  // (Globals.currentMember.value.isEmpty || (section.clsMembers[index].UID_Mem != Globals.currentMember.value)) ? Colors.white : Colors.red.shade50,
                  child: Text(myPatientListFilter[index].name),
                ),
              ),
            );
          })
        ],
      ),
    );
  }

  // Widget row(String text, Color color) {
  //   return Padding(
  //     padding: EdgeInsets.all(12.5),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: color,
  //         borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
  //       ),
  //       child: Center(
  //         child: Text(
  //           text,
  //           style: const TextStyle(
  //             color: Colors.white,
  //             fontWeight: FontWeight.bold,
  //             fontSize: 12.5,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  birthdayFull() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('BirthdayFull'.tr),
          SizedBox(
            height: _rowHeight,
            child: InkWell(
                onTap: () {
                  Globals.prefs.getString(Globals.prfMyDate) == "J"
                      ? showPersianDatePicker(
                          context: context,
                          initialDate: patientBirthday.value.toJalali(),
                          currentDate: Globals.myDateTime,
                          firstDate: Jalali(1300, 1),
                          lastDate: Jalali.fromDateTime(DateTime.now()),
                        ).then((value) {
                          patientBirthday.value = value!.toDateTime();
                          mt3.value = value.formatFullDate();
                          mt2.value = value.formatMediumDate();
                          mt1.value = value.formatCompactDate();

                          ageReset.value =
                              // Jalali.fromDateTime(
                              (DateTime.now().year - value.toDateTime().year)
                                  .toDouble();
                          // (Jalali.fromDateTime(DateTime.now()).year -
                          // patientBirthday.value.year)
                          // .toDouble();
                          // agePicker.resetValue =
                          //     (DateTime.now().year -
                          //             patientBirthday.value.year)
                          //         .toDouble();
                          setNwCheck();
                        })
                      : showCalendarDatePicker2Dialog(
                          context: context,
                          config: CalendarDatePicker2WithActionButtonsConfig(
                            calendarType: CalendarDatePicker2Type.single,
                            currentDate: Globals.myDateTime,
                            selectedDayHighlightColor: Colors.purple[800],closeDialogOnCancelTapped: true,
                          ),
                          dialogSize: const Size(325, 400),
                          borderRadius: BorderRadius.circular(15),
                          initialValue: [patientBirthday.value],
                          dialogBackgroundColor: Colors.white,
                        ).then((value) {
                          patientBirthday.value = value![0] ?? DateTime.now();
                          mt3.value =
                              DateFormat(Globals.gregorianDateDayMonFormat)
                                  .format(value[0] ?? DateTime.now());
                          mt2.value = DateFormat(Globals.gregorianDateDayFormat)
                              .format(value[0] ?? DateTime.now());
                          mt1.value = DateFormat(Globals.gregorianDateFormat)
                              .format(value[0] ?? DateTime.now());

                          ageReset.value =
                              // agePicker.resetValue =
                              (DateTime.now().year - patientBirthday.value.year)
                                  .toDouble();

                          setNwCheck();
                        });
                },
                child: Obx(() => Container(
                      decoration: warningDecoration(nwPatientBirthday.value),
                      child: Container(
                          height: _rowHeight,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(_radiusBorder)),
                              border:
                                  Border.all(color: Colors.black54, width: 2)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 8, left: 8),
                                child: Icon(Icons.calendar_month_outlined,
                                    size: 28, color: Colors.black54),
                              ),
                              Expanded(
                                  child: Center(
                                      child: OverflowProofText(
                                text: Text(mt3.value,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontFamily: Globals.dateFont,
                                        fontSize: 12)),
                                fallback: OverflowProofText(
                                  text: Text(mt2.value,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontFamily: Globals.dateFont,
                                          fontSize: 12)),
                                  fallback: Text(mt1.value,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontFamily: Globals.dateFont,
                                          fontSize: 12),
                                      overflow: TextOverflow.fade),
                                ),
                              ))),
                            ],
                          )),
                    ))),
          ),
        ],
      ),
    );
  }

  birthdayYear() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("BirthdayYear".tr),
          SizedBox(
            height: _rowHeight,
            child: Obx(() => Container(
                  decoration: warningDecoration(nwPatientYear.value),
                  child: NumberPicker(
                    theme: NumberSelectionTheme(
                        draggableCircleColor: Colors.blue,
                        iconsColor: Colors.indigo,
                        numberColor: Colors.white,
                        iconsDisableColor: Colors.grey,
                        backgroundColor: Colors.black12,
                        outOfConstraintsColor: Colors.deepOrange),
                    // initialValue: mItemProduct.inCart?? 0,
                    // iconMin: Icons.delete,
                    initialValue: Globals.prefs.getString(Globals.prfMyDate) ==
                            "J"
                        ? Jalali.fromDateTime(DateTime.now()).year.toDouble()
                        : DateTime.now().year.toDouble(),
                    resetValue: birthYear.value > 0
                        ? birthYear.value
                        : Globals.prefs.getString(Globals.prfMyDate) == "J"
                            ? Jalali.fromDateTime(DateTime.now())
                                .year
                                .toDouble()
                            : DateTime.now().year.toDouble(),
                    iconEmpty: Icons.remove,
                    minValue: Globals.prefs.getString(Globals.prfMyDate) == "J"
                        ? Jalali.fromDateTime(DateTime.now()).year.toDouble() -
                            120
                        : DateTime.now().year.toDouble() - 120,
                    maxValue: Globals.prefs.getString(Globals.prfMyDate) == "J"
                        ? Jalali.fromDateTime(DateTime.now()).year.toDouble()
                        : DateTime.now().year.toDouble(),
                    progressWidth: 4,
                    intCheck: true,
                    interval: 1,
                    direction: Axis.horizontal,
                    withSpring: true,
                    wide: 180,
                    callBack: (double value) {
                      if (Globals.prefs.getString(Globals.prfMyDate) == "J") {
                        ageReset.value =
                            (Jalali.fromDateTime(DateTime.now()).year - value)
                                .toDouble();
                      } else {
                        ageReset.value =
                            (DateTime.now().year - value).toDouble();
                      }
                      setBirth(ageReset.value);
                      return Future(() => value);
                    },
                    onChanged: (double value) {
                      if (Globals.prefs.getString(Globals.prfMyDate) == "J") {
                        ageReset.value =
                            (Jalali.fromDateTime(DateTime.now()).year - value)
                                .toDouble();
                      } else {
                        ageReset.value =
                            (DateTime.now().year - value).toDouble();
                      }
                      setBirth(ageReset.value);
                      print("value: $value");
                    },
                    enableOnOutOfConstraintsAnimation: true,
                    onOutOfConstraints: () =>
                        print("This value is too high or too low"),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  agePicker() {
    return Padding(
        padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("PatientAge".tr),
            SizedBox(
              height: _rowHeight,
              child: Obx(() => Container(
                        decoration: warningDecoration(nwPatientAge.value),
                        child: NumberPicker(
                          theme: NumberSelectionTheme(
                              draggableCircleColor: Colors.blue,
                              iconsColor: Colors.indigo,
                              numberColor: Colors.white,
                              iconsDisableColor: Colors.grey,
                              backgroundColor: Colors.black12,
                              outOfConstraintsColor: Colors.deepOrange),
                          // initialValue: mItemProduct.inCart?? 0,
                          // iconMin: Icons.delete,
                          initialValue: patientAge.value.toDouble(),
                          resetValue: ageReset.value,
                          iconEmpty: Icons.remove,
                          minValue: 1,
                          maxValue: 120,
                          progressWidth: 4,
                          intCheck: true,
                          interval: 1,
                          direction: Axis.horizontal,
                          withSpring: true,
                          callBack: (double value) {
                            print("=======value: $value");

                            setBirth(value);

                            return Future(() => value);
                          },
                          onChanged: (double value) {
                            // patientAge.value = value.toInt();
                            setBirth(value);
                            // if (Globals.prefs.getString(Globals.prfMyDate) == "J") {
                            //   birthYear.value =
                            //       Jalali.fromDateTime(DateTime.now()).year - value;
                            // } else {
                            //   birthYear.value = DateTime.now().year - value;
                            // }
                            //
                            // if (value <= 20) {
                            //   rangeAgeValue.value = 0;
                            // } else if (value > 20 && value <= 40) {
                            //   rangeAgeValue.value = 1;
                            // } else if (value > 40 && value < 60) {
                            //   rangeAgeValue.value = 2;
                            // } else if (value >= 60) {
                            //   rangeAgeValue.value = 3;
                            // }
                            // patientBirthYear.value = patientBirthday.value.year;
                            // try {
                            //   birthYear.value = patientBirthday.value.year.toDouble();
                            // }catch(Ex){}
                            print("***********value: $value");
                          },
                          enableOnOutOfConstraintsAnimation: true,
                          onOutOfConstraints: () =>
                              print("This value is too high or too low"),
                          // callBack: (val) async {
                          //   double mRet = val;
                          //   // return true;
                          //   // if((_inCartThis == 0 && mItemProduct.invFirst) || (_inCartThis > 0 && mItemProduct.invAdd)) {
                          //   await setCartexWithVal(context, mItemProduct, mItemProduct.inCart! == 0, val, mItemProduct.inCart! > val).then((ret) async {
                          //     if (ret.statusCode == 200) {
                          //       await reloadCart(context, false).then((v) {
                          //         refreshCart(context, v);
                          //         setState(() {});
                          //         // widget.goToPage!(1, 1, '');
                          //         if(mRet > 0) {
                          //           mRet = v[0].CartDetails.firstWhere((element) => element.PrdCode == mItemProduct.id).Amount;
                          //           mItemProduct.inCart = mRet;
                          //           SetTmpCartex(context, myProduct, mItemProduct);
                          //         }
                          //         // widget.goToPage!(1, 1, '');
                          //       });
                          //     }else{
                          //       mRet = -1;
                          //     }
                          //   });
                          //   // }else {
                          //   //   ToastNormal("موجود نیست");
                          //   // }
                          //   return mRet;
                          // }
                        ),
                      )
                  // NumberPicker(itemWidth: 40,
                  //   textStyle: TextStyle(fontSize: 10),
                  //   selectedTextStyle: TextStyle(fontSize: 15),
                  //   value: _currentHorizontalIntValue,
                  //   minValue: 0,
                  //   maxValue: 100,
                  //   step: 1,
                  //   itemHeight: 80,
                  //   axis: Axis.horizontal,
                  //   onChanged: (value) =>
                  //       setState(() => _currentHorizontalIntValue = value),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(16),
                  //     border: Border.all(color: Colors.black26),
                  //   ),
                  // ),
                  ),
            ),
          ],
        ));
  }

  ageRange() {
    return Padding(
        padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('AgeRange'.tr),
            SizedBox(
              height: _rowHeight,
              child: Obx(() => AnimatedToggleSwitch<int>.rollingByHeight(
                    height: 25.0,
                    borderRadius: BorderRadius.circular(20),
                    borderWidth: 0,
                    current: rangeAgeValue.value,
                    indicatorBorderRadius: BorderRadius.circular(20),
                    indicatorSize: const Size.fromWidth(10),
                    values: const [0, 1, 2, 3],
                    onChanged: (i) {
                      rangeAgeValue.value = i;

                      switch (i) {
                        case 0:
                          ageReset.value = 20;
                          break;
                        case 1:
                          ageReset.value = 30;
                          break;
                        case 2:
                          ageReset.value = 50;
                          break;
                        case 3:
                          ageReset.value = 60;
                          break;
                      }
                      setNwCheck();
                    },
                    iconBuilder: rollingIconBuilder,
                    innerColor: Colors.grey.shade400,
                    // indicatorSize: const Size.fromWidth(2),
                    foregroundBoxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 1.5),
                      )
                    ],
                    borderColor: nwPatientYearRange.value
                        ? Colors.redAccent
                        : Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white,
                        spreadRadius: 10,
                        blurRadius: 2,
                        offset: Offset(0, 1.5),
                      )
                    ],
                  )),
            ),
          ],
        ));
  }

  Widget rollingIconBuilder(int value, Size iconSize, bool foreground) {
    switch (value) {
      case 0:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "T",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Text(
              "..20",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w100,
                  fontSize: 8),
            )
          ],
        );

      //   Icon(
      //   LineIcons.,
      //   color: Colors.white,
      //   size: iconSize.shortestSide,
      // );
      case 1:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Y",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Text(
              "21~40",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w100,
                  fontSize: 8),
            )
          ],
        );
      //   Icon(
      //   Icons.account_circle_outlined,
      //   color: Colors.white,
      //   size: iconSize.shortestSide,
      // );
      case 2:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "M",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Text(
              "41~60",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w100,
                  fontSize: 8),
            )
          ],
        );
      //   Icon(
      //   Icons.admin_panel_settings_outlined,
      //   color: Colors.white,
      //   size: iconSize.shortestSide,
      // );
      case 3:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "O",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Text(
              "60..",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w100,
                  fontSize: 8),
            )
          ],
        );
      //   Icon(
      //   LineIcons.hiking,
      //   color: Colors.white,
      //   size: iconSize.shortestSide,
      // );
    }
    IconData data = Icons.date_range;
    if (value.isEven) data = Icons.cancel;
    return Icon(
      data,
      size: iconSize.shortestSide,
    );
  }

  void setBirth(double value) {
    ageReset.value = value;
    patientAge.value = value.toInt();
    if (Globals.prefs.getString(Globals.prfMyDate) == "J") {
      birthYear.value = Jalali.fromDateTime(DateTime.now()).year - value;
    } else {
      birthYear.value = DateTime.now().year - value;
    }

    rangeAgeValue.value = getRangeAgeValue(value);

    if (Globals.prefs.getString(Globals.prfMyDate) == "J") {
      patientBirthday.value = DateTime(DateTime.now().year - value.toInt(),
          DateTime.now().month, DateTime.now().day);
      mt3.value = Jalali.fromDateTime(patientBirthday.value).formatFullDate();
      mt2.value = Jalali.fromDateTime(patientBirthday.value).formatMediumDate();
      mt1.value =
          Jalali.fromDateTime(patientBirthday.value).formatCompactDate();
    } else {
      patientBirthday.value = DateTime(DateTime.now().year - value.toInt(),
          DateTime.now().month, DateTime.now().day);
      mt3.value = DateFormat(Globals.gregorianDateDayMonFormat)
          .format(patientBirthday.value);
      mt2.value = DateFormat(Globals.gregorianDateDayFormat)
          .format(patientBirthday.value);
      mt1.value =
          DateFormat(Globals.gregorianDateFormat).format(patientBirthday.value);
    }

    patientBirthYear.value = Globals.prefs.getString(Globals.prfMyDate) == "J"
        ? Jalali.fromDateTime(patientBirthday.value).year
        : (patientBirthday.value).year;

    setNwCheck();
  }

  void selPatient() {
    if (patientSelId.value >= 0) {
      ClsPatientInfo myPatient = myPatientListFilter
          .firstWhere((element) => element.idRec == patientSelId.value);

      // ClsPatientInfo myPatient = myPatientListFilter.firstWhere((element) => element.idRec == id);
      // ClsPatientInfo myPatient = myPatientListFilter[patientListSel.value];
      print(">>>>>>>>>>>>> " + myPatient.idRec.toString());
      patientName.value = myPatient.name;
      editingControllerPatientName.text = patientName.value;
      patientDesc.value = myPatient.description ?? "";
      editingControllerPatientDesc.text = patientDesc.value;
      patientGender.value = myPatient.gender;
      patientInfectious.value = myPatient.isInfectious;
      patientRecId.value = myPatient.idRec ?? 0;
      patientAge.value = myPatient.age;
      ageReset.value = patientAge.value.toDouble();
      setBirth(ageReset.value);

      if (myPatient.birthday != null) {
        patientBirthYear.value =
            Globals.prefs.getString(Globals.prfMyDate) == "J"
                ? Jalali.fromDateTime(myPatient.birthday ?? DateTime.now()).year
                : (myPatient.birthday ?? DateTime.now()).year;

        patientBirthday.value = myPatient.birthday!;

        mt1 = Globals.prefs.getString(Globals.prfMyDate) == "J"
            ? patientBirthday.value.toJalali().formatCompactDate().obs
            : DateFormat(Globals.gregorianDateFormat)
                .format(patientBirthday.value)
                .obs;

        mt2 = Globals.prefs.getString(Globals.prfMyDate) == "J"
            ? patientBirthday.value.toJalali().formatMediumDate().obs
            : DateFormat(Globals.gregorianDateDayFormat)
                .format(patientBirthday.value)
                .obs;

        mt3 = Globals.prefs.getString(Globals.prfMyDate) == "J"
            ? patientBirthday.value.toJalali().formatFullDate().obs
            : DateFormat(Globals.gregorianDateDayMonFormat)
                .format(patientBirthday.value)
                .obs;

        ageReset.value =
            (DateTime.now().year - patientBirthday.value.year).toDouble();
      }

      setNwCheck();
    }
  }

  bool checkPatientInfo(ClsPatientInfo clsPatientInfo) {
    if (clsPatientInfo.name.isEmpty) {
      ToastNormal("enterPatientName".tr, context, type: -1);
      return false;
    } else if (clsPatientInfo.gender == 0) {
      ToastNormal("enterPatientGender".tr, context, type: -1);
      return false;
    } else if (clsPatientInfo.age == 0) {
      ToastNormal("enterPatientAge".tr, context, type: -1);
      return false;
    }

    return true;
  }

  bool comparePatient() {
    if (patientSelId.value >= 0) {
      ClsPatientInfo myPatient = myPatientListFilter
          .firstWhere((element) => element.idRec == patientSelId.value);
      // [patientListSel.value];

      if (patientName.value == myPatient.name &&
              // editingControllerPatientName.text == patientName.value &&
              patientDesc.value == myPatient.description &&
              // editingControllerPatientDesc.text == patientDesc.value &&
              patientGender.value == myPatient.gender &&
              patientInfectious.value == myPatient.isInfectious &&
              patientRecId.value == myPatient.idRec &&
              patientAge.value == myPatient.age
          // && ageReset.value == patientAge.value.toDouble()
          ) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  void setNwCheck() {
    if (patientSelId.value >= 0) {
      // ClsPatientInfo myPatient = myPatientListFilter[patientListSel.value];
      ClsPatientInfo myPatient = myPatientListFilter
          .firstWhere((element) => element.idRec == patientSelId.value);

      nwPatientAge.value = (patientAge.value != myPatient.age) ? true : false;

      nwPatientBirthday.value =
          (patientBirthday.value != myPatient.birthday) ? true : false;

      int mPatientBirthYear = Globals.prefs.getString(Globals.prfMyDate) == "J"
          ? Jalali.fromDateTime(myPatient.birthday ?? DateTime.now()).year
          : (myPatient.birthday ?? DateTime.now()).year;

      // print(rangeAgeValue.value);
      // print(getRangeAgeValue(myPatient.age.toDouble()));

      nwPatientYear.value =
          (patientBirthYear.value != mPatientBirthYear) ? true : false;

      nwPatientYearRange.value =
          (rangeAgeValue.value != getRangeAgeValue(myPatient.age.toDouble()))
              ? true
              : false;

      nwPatientDesc.value =
          (patientDesc.value != myPatient.description) ? true : false;

      nwPatientInfectious.value =
          (patientInfectious.value != myPatient.isInfectious) ? true : false;
    } else {
      patientRecId.value = 0;

      nwPatientAge.value = false;
      nwPatientBirthday.value = false;
      nwPatientYear.value = false;
      nwPatientYearRange.value = false;
      nwPatientDesc.value = false;
      nwPatientInfectious.value = false;

      // print("ffffff");
    }
  }

  int getRangeAgeValue(double value) {
    if (value <= 20) {
      return 0;
    } else if (value > 20 && value <= 40) {
      return 1;
    } else if (value > 40 && value < 60) {
      return 2;
    } else if (value >= 60) {
      return 3;
    } else {
      return -1;
    }
  }

  warningDecoration(bool on) {
    return DottedDecoration(
        color: on ? Colors.orange : Colors.white, shape: Shape.box);
  }
}
