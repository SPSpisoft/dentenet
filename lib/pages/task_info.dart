import 'dart:io';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rolling_switch/rolling_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';
import 'package:sps_persian_datetime_picker/sps_persian_datetime_picker.dart';
import '../data/app.dart';
import '../data/data_fetch.dart';
import '../public/modeles.dart';
import '../public/public_functions.dart';
import '../public/public_variables.dart';
import '../functions/app_components.dart';
import 'employer_page.dart';
import 'patient_page.dart';

class TaskInfo extends StatelessWidget with ChangeNotifier {

  // RxBool isJalali =
  //     Globals.prefs.getString(Globals.prfMyDate) == "J" ? true.obs : false.obs;
  // String dateFont =
  //     Globals.prefs.getString(Globals.prfMyDate) == "J" ? 'Yekan' : 'Tahoma';

  var md = Globals.myDateTime.obs;

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

  final double _radiusBorder = 8;
  final double _rowHeight = 45;

  // List<ClsMember> _currentModel = [];

  RxBool loadingEmployer = false.obs;

  // late ClsMember currentClsMember;
  RxList<PlatformFile> taskAttachFiles = <PlatformFile>[].obs;
  RxInt activeStep = 0.obs;

  RxString taskDescription = "".obs;

  TaskInfo(this.taskDescription, {Key? key}) : super(key: key);

  // String pDescription;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // taskDescription.value = pDescription;
    // taskDescription.value = sDescription;

    // var config = CalendarDatePicker2WithActionButtonsConfig(
    //   calendarType: CalendarDatePicker2Type.single,
    //   currentDate: Globals.myDateTime,
    //   selectedDayHighlightColor: Colors.purple[800],
    //   shouldCloseDialogAfterCancelTapped: true,
    // );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
                      child: InkWell(
                          onTap: () => Globals.prefs
                                      .getString(Globals.prfMyDate) ==
                                  "J"
                              ? showPersianDatePicker(
                                  context: context,
                                  initialDate: md.value.toJalali(),
                                  currentDate: Globals.myDateTime,
                                  firstDate: Jalali(1385, 8),
                                  lastDate: Jalali(1450, 9),
                                ).then((value) {
                                  md.value = value!.toDateTime();
                                  mt3.value = value.formatFullDate();
                                  mt2.value = value.formatMediumDate();
                                  mt1.value = value.formatCompactDate();

                                  Globals.currentTask.date = md.value;
                                })
                              : showCalendarDatePicker2Dialog(
                                  context: context,
                                  config:
                                      CalendarDatePicker2WithActionButtonsConfig(
                                    calendarType:
                                        CalendarDatePicker2Type.single,
                                    currentDate: Globals.myDateTime,
                                    selectedDayHighlightColor:
                                        Colors.purple[800],
                                    closeDialogOnCancelTapped: true,
                                  ),
                                  dialogSize: const Size(325, 400),
                                  borderRadius: BorderRadius.circular(15),
                                  initialValue: [md.value],
                                  dialogBackgroundColor: Colors.white,
                                ).then((value) {
                                  md.value = value![0] ?? DateTime.now();
                                  mt3.value = DateFormat(
                                          Globals.gregorianDateDayMonFormat)
                                      .format(value[0] ?? DateTime.now());
                                  mt2.value =
                                      DateFormat(Globals.gregorianDateDayFormat)
                                          .format(value[0] ?? DateTime.now());
                                  mt1.value =
                                      DateFormat(Globals.gregorianDateFormat)
                                          .format(value[0] ?? DateTime.now());

                                  Globals.currentTask.date = md.value;
                          }),
                          child: Obx(() => Container(
                              height: _rowHeight,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(_radiusBorder)),
                                  border: Border.all(
                                      color: Colors.black54, width: 2)),
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
                                        style: TextStyle(fontFamily: Globals.dateFont, fontSize: 12)),
                                    fallback: OverflowProofText(
                                      text: Text(mt2.value,
                                          textAlign: TextAlign.start,
                                          style:
                                              TextStyle(fontFamily: Globals.dateFont, fontSize: 12)),
                                      fallback: Text(mt1.value,
                                          textAlign: TextAlign.start,
                                          style:
                                              TextStyle(fontFamily: Globals.dateFont, fontSize: 12),
                                          overflow: TextOverflow.fade),
                                    ),
                                  ))),
                                ],
                              )))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
                    child: SizedBox(
                        height: _rowHeight,
                        // decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.all(
                        //         Radius.circular(_radiusBorder)),
                        //     border:
                        //         Border.all(color: Colors.black54, width: 2)),
                        child: Padding(
                          padding: const EdgeInsets.all(1),
                          child: RollingSwitch.icon(
                            onChanged: (bool state) {
                              Globals.currentTask.isRemovable = state;
                              print('turned ${(state) ? 'on' : 'off'}');
                            },
                            rollingInfoRight: RollingIconInfo(
                              icon: LineIcons.teeth,
                              iconColor: Colors.green,
                              backgroundColor: Colors.green,
                              text: Text('Removable'.tr),
                            ),
                            rollingInfoLeft: RollingIconInfo(
                              icon: LineIcons.tooth,
                              iconColor: Colors.blueAccent,
                              backgroundColor: Colors.blueAccent,
                              text: Text('Fixed'.tr),
                            ),
                          ),
                          // ToggleSwitch(
                          //   initialLabelIndex: 0,
                          //   totalSwitches: 2,
                          //   cornerRadius: _radiusBorder,
                          //   customWidths: [70,70],
                          //   labels: ['Fix', 'Rem'],
                          //   animationDuration: 400,
                          //   animate: true,
                          //   onToggle: (index) {
                          //     print('switched to: $index');
                          //   },
                          // ),
                        )),
                  ),
                ],
              ),
            ),
            IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
                child: InkWell(onTap: () {
                  Get.to(EmployerPage(
                    selectable: true,
                  ));
                  // employerDialog(context);
                }, child: Obx(() {
                  if (Globals.currentEmployer.isNotEmpty) {
                    // currentClsMember = Globals.currentEmployer.first;
                    Globals.currentTask.clsMember = Globals.currentEmployer.first;

                    // getEmployerAsCode(realm, Globals.currentMember.value);
                  }
                  // if (Globals.currentPatient.value.isNotEmpty) {
                  //   currentClsPatient =
                  //       getPatientAsCode(realm, Globals.currentPatient.value);
                  // }
                  return Container(
                      height: _rowHeight,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.all(Radius.circular(_radiusBorder)),
                          border: Border.all(color: Colors.black54, width: 2)),
                      child: Shimmer.fromColors(
                        baseColor: Colors.black,
                        highlightColor: Colors.redAccent,
                        period: const Duration(milliseconds: 800),
                        enabled: loadingEmployer.value,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 8, left: 8),
                              child: Icon(LineIcons.accusoft,
                                  size: 28, color: Colors.black54),
                            ),
                            Expanded(
                                flex: 1,
                                child: Text(
                                    textAlign: TextAlign.start,
                                    Globals.currentEmployer.isNotEmpty
                                        ? ("${Globals.currentEmployer.first.MidName!} ${Globals.currentEmployer.first.Name!}")
                                        : 'doctor'.tr)),
                            const Padding(
                              padding: EdgeInsets.only(right: 8, left: 8),
                              child: Icon(Icons.location_on_outlined,
                                  size: 28, color: Colors.black54),
                            ),
                            Expanded(
                                flex: 1,
                                child: Text(
                                    textAlign: TextAlign.start,
                                    Globals.currentEmployer.isNotEmpty
                                        ? (Globals.currentEmployer.first.Address_Title)
                                        : 'location'.tr)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                              Icon(Globals.currentEmployer.isEmpty ? Icons.search : Globals.currentEmployer.first.UID_Mem.isNotEmpty ? Icons.check : Icons.save_outlined,
                                  size: 20, color: Colors.black26) ,
                            ),
                          ],
                        ),
                      ));
                })),
              ),
            ),
            IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
                child: InkWell(onTap: () {
                  Get.to(const PatientPage(
                  ));
                  // employerDialog(context);
                }, child: Obx(() {
                  if (Globals.currentPatient.isNotEmpty) {
                    // currentClsMember = Globals.currentEmployer.first;
                    Globals.currentTask.clsPatientInfo = Globals.currentPatient.first;

                    // currentClsMember =
                    //     getEmployerAsCode(realm, Globals.currentMember.value);
                  }
                  return Container(
                      height: _rowHeight,
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(_radiusBorder)),
                          border: Border.all(color: Colors.black54, width: 2)),
                      child: Shimmer.fromColors(
                        baseColor: Colors.black,
                        highlightColor: Colors.redAccent,
                        period: const Duration(milliseconds: 800),
                        enabled: loadingEmployer.value,
                        child: Obx(() => Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 8, left: 8),
                                child: Icon(LineIcons.personEnteringBooth,
                                    size: 28, color: Colors.black54),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                      textAlign: TextAlign.start,
                                      Globals.currentPatient.isNotEmpty
                                          ? (Globals.currentPatient.first.name)
                                          :
                                      'PatientName'.tr)),
                              const Padding(
                                padding: EdgeInsets.only(right: 8, left: 8),
                                child: Icon(Icons.perm_contact_calendar_outlined,
                                    size: 28, color: Colors.black54),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                      textAlign: TextAlign.start,
                                      Globals.currentPatient.isNotEmpty
                                          ? (Globals.currentPatient.first.age.toString())
                                          :
                                      'PatientAge'.tr)),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                  Icon(Globals.currentPatient.isEmpty ? Icons.search : Globals.currentPatient.first.idRec! > 0 ? Icons.check : Icons.save_outlined,
                                      size: 20, color: Colors.black26) ,
                                ),
                            ],
                          ),
                        ),
                      ));
                })),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.all(Radius.circular(_radiusBorder)),
                    border: Border.all(color: Colors.black54, width: 2)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.attach_email_outlined, color: Colors.grey, size: 26,),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("attachments".tr),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(onPressed: () async {
                              }, icon: const Icon(Icons.textsms_outlined, color: Colors.redAccent, size: 25,)),
                              IconButton(onPressed: () async {
                              }, icon: const Icon(Icons.keyboard_voice_outlined, color: Colors.redAccent, size: 25,)),
                              IconButton(onPressed: () async {
                                FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

                                if (result != null) {

                                  taskAttachFiles.value = result.files;

                                  Globals.currentTask.attachFiles = taskAttachFiles;

                                  List<File> files = result.paths.map((path) {
                                    print(path);
                                    return File(path?? "");
                                  }).toList();

                                } else {
                                  // User canceled the picker
                                }
                              }, icon: const Icon(Icons.file_upload_outlined, color: Colors.redAccent, size: 25,))
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Obx(() => Text(taskDescription.value)),
                    ),
                    Obx(() {
                      return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: taskAttachFiles.length,
                        itemBuilder: (BuildContext context, int index) => InkWell(
                          onTap: () {
                            // // Globals.currentMember.value = section.clsMembers[index].UID_Mem;
                            // // setState(() {});
                            // print(">> Index >> " + index.toString());
                            // patientSelId.value = myPatientListFilter[index].idRec!;
                            // selPatient();
                            //
                            // WidgetsBinding.instance.addPostFrameCallback((_) =>
                            //     Scrollable.ensureVisible(
                            //         duration: const Duration(seconds: 1),
                            //         topViewKey.currentContext!));
                          },
                          child: Card(
                            margin: const EdgeInsets.all(2),
                            shadowColor: Colors.white,
                            // (Globals.currentMember.value.isEmpty || (section.clsMembers[index].UID_Mem != Globals.currentMember.value)) ? Colors.white : Colors.red,
                            color: Colors.white,
                            // (Globals.currentMember.value.isEmpty || (section.clsMembers[index].UID_Mem != Globals.currentMember.value)) ? Colors.white : Colors.red.shade50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(taskAttachFiles[index].name),
                                Text(taskAttachFiles[index].extension.toString()?? ""),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget body(bool isOffline, bool isExpandAll, List<ClsMember>? lstMembers) {
    List<MemberSection> mySectionList =
        MemberData.getMemberSections(lstMembers);
    return Stack(
      children: [
        ExpandableListView(
          builder: SliverExpandableChildDelegate<String, MemberSection>(
            sectionList: mySectionList,
            // headerBuilder: _buildHeader,
            itemBuilder: (context, sectionIndex, itemIndex, index) {
              String item = mySectionList[sectionIndex].items[itemIndex];
              return ListTile(
                // leading: CircleAvatar(
                //   child: Text("$index"),
                // ),
                title: Text(item),
              );
            },
            sectionBuilder: (context, containerInfo) => MemberSectionWidget(
              section: mySectionList[containerInfo.sectionIndex],
              containerInfo: containerInfo,
              onStateChanged: () {
                //notify ExpandableListView that expand state has changed.
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // if (mounted) {
                  // }
                });
              },
              expandAll: isExpandAll,
            ),
          ),
        ),
        offlineBanner(isOffline),
      ],
    );
  }

  employerDialog(BuildContext context) {
    loadingEmployer.value = true;
    fetchMembers(Globals.myMemberId).then((retMemberModel) {
      loadingEmployer.value = false;
      // Globals.myMemberList = retMemberModel.retList;
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: body(false, false, retMemberModel.retList),
          actions: <Widget>[
            MaterialButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ); // remove the dialog on success upload
    }); // we can use task(which returned from
    // mediaUpload()) to get the values like downloadUrl.

    // await fetchMembers(realm, Globals.myMemberId).then((retMemberModel) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     showDialog<String>(
    //       context: context,
    //       builder: (BuildContext context) => AlertDialog(
    //         title: Text("title"),
    //         content: body(false, false, retMemberModel.retList),
    //         actions: <Widget>[
    //           MaterialButton(
    //             child: Text("OK"),
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //           ),
    //         ],
    //       ),
    //     );
    //   });
    // });
  }

  waitingDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new Center(
          child: new SizedBox(
            width: 40.0,
            height: 40.0,
            child: const CircularProgressIndicator(
              value: null,
              strokeWidth: 2.0,
            ),
          ),
        );
      },
    );
  }
}
