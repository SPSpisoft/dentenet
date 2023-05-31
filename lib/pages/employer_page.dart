import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../functions/app_functions.dart';
import '../data/data_fetch.dart';
import '../gen/colors.gen.dart';
import '../public/modeles.dart';
import '../functions/app_components.dart';
import '../public/public_variables.dart';
import 'setting_page.dart';

class EmployerPage extends StatefulWidget {
  bool selectable = false;

  EmployerPage({Key? key , required this.selectable}) : super(key: key);

  @override
  State<EmployerPage> createState() => _EmployerPageState();
}

class _EmployerPageState extends State<EmployerPage> with SingleTickerProviderStateMixin {

  List<MemberSection> mySectionList = [];

  // late Realm realm;

  late bool _isOffline;
  late bool _expandAll;

  static final Animatable<double> _halfTween =
  Tween<double>(begin: 0.0, end: 0.5);
  late AnimationController _controller;
  late Animation _iconTurns;
  late Animation<double> _heightFactor;

  late bool expand;

  @override
  void initState() {
    expand = false;
    _expandAll = true;
    super.initState();
    // LocalConfiguration config = Configuration.local(
    //     [ClsMember.schema, ClsContact.schema, ClsPlace.schema],
    //     schemaVersion: Globals.mySchemaVersion);
    // realm = Realm(config);

    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _iconTurns =
        _controller.drive(_halfTween.chain(CurveTween(curve: Curves.easeIn)));
    _heightFactor = _controller.drive(CurveTween(curve: Curves.easeIn));

    // if (widget.section.isSectionExpanded()) {
    //   _controller.value = 1;
    // }
    //
    // // if(widget.expandAll) {
    // widget.section.setSectionExpanded(widget.expandAll);
    // if (widget.section.isSectionExpanded()) {
    //   widget.onStateChanged();
    //   _controller.forward();
    // } else {
    //   _controller.reverse().then((_) {
    //     widget.onStateChanged();
    //   });
    // }
  }

  @override
  void dispose() {
    super.dispose();
    // realm.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('doctor'.tr,),
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
              padding: EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () {
                    // SettingBinding().dependencies();
                    Get.to(SettingPage(callSettingKey: SettingKey.employer),
                        transition: Transition.upToDown, duration: const Duration(seconds: 1))!
                      .then((value) => setState(() {}));
                  },
                  child: Icon(Icons.settings)),
            ),
          ]),
      backgroundColor: Colors.white,
      body: SafeArea(
        child:
        mySectionList.isNotEmpty
            ? body(_isOffline, _expandAll)
            :
        FutureBuilder<RetMemberModel>(
          future: fetchMembers(Globals.myMemberId),
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
                          child: Text(snapshot.error.toString() +
                              '\n دوباره سعی کنید \n دریافت اطلاعات با مشکل مواجه شد')),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                );
              }
            } else {
              if (!snapshot.hasData || snapshot.data!.retList.isEmpty) {
                return const Center(
                    child: SizedBox(child: Text('data is empty!')));
              } else {
                // Globals.myMemberList = snapshot.data!.retList;
                mySectionList =
                    MemberData.getMemberSections(snapshot.data!.retList);
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
                return body(_isOffline, _expandAll);
              }
            }
            // }
          },
        ),
      ),
    );
  }

  Widget body(bool isOffline, bool isExpandAll) {
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
            sectionBuilder: _buildSection,
            // sectionBuilder: (context, containerInfo) =>
            //     MemberSectionWidget(
            //       section: mySectionList[containerInfo.sectionIndex],
            //       containerInfo: containerInfo,
            //       onStateChanged: () {
            //         //notify ExpandableListView that expand state has changed.
            //         WidgetsBinding.instance.addPostFrameCallback((_) {
            //           if (mounted) {
            //             setState(() {});
            //           }
            //         });
            //       }, expandAll: isExpandAll,
            //     ),
          ),
        ),
        offlineBanner(isOffline),
      ],
    );
  }


  Widget _buildSection(
      BuildContext context, ExpandableSectionContainerInfo containerInfo) {
    containerInfo
      ..header = _buildHeader(context, containerInfo)
      ..content = _buildContent(context, containerInfo);
    return ExpandableSectionContainer(
      info: containerInfo,
    );
  }

  // Widget _buildHeader(BuildContext context, int sectionIndex, int index) {
  //   MemberSection section = mySectionList[sectionIndex];
  //   return InkWell(
  //       child: Container(
  //           color: Colors.lightBlue,
  //           height: 48,
  //           padding: EdgeInsets.only(left: 20),
  //           alignment: Alignment.centerLeft,
  //           child: Text(
  //             section.header,
  //             style: TextStyle(color: Colors.white),
  //           )),
  //       onTap: () {
  //         //toggle section expand state
  //         setState(() {
  //           section.setSectionExpanded(!section.isSectionExpanded());
  //         });
  //       });
  // }

  Widget _buildHeader(
      BuildContext context, ExpandableSectionContainerInfo containerInfo) {
    MemberSection section = mySectionList[containerInfo.listIndex];
    return Container(
      color: Colors.blueGrey,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.red,
          child: Text(section.headerName.substring(0, 1),
              style: const TextStyle(color: Colors.white)),
        ),
        title: Text(
          section.header,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: RotationTransition(
          turns: _iconTurns as Animation<double>,
          child: Icon(
            Icons.expand_more,
            color: Globals.prefs.getBool(Globals.prfEmployerExpand)?? false ? Colors.white70 : Colors.transparent,
          ),
        ),
        onTap: (){
          if(Globals.prefs.getBool(Globals.prfEmployerExpand)?? false) {
            if (!expand) {
              section.setSectionExpanded(!section.isSectionExpanded());
              if (section.isSectionExpanded()) {
                section.setSectionExpanded(!section.isSectionExpanded());
                _controller.forward();
              } else {
                _controller.reverse().then((_) {
                  section.setSectionExpanded(!section.isSectionExpanded());
                });
              }
            }
          }
          // expand = !expand;
        },
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, ExpandableSectionContainerInfo containerInfo) {
    MemberSection section = mySectionList[containerInfo.listIndex];
    if (!section.isSectionExpanded()) {
      return Container();
    }
    return
      widget.selectable ?
      SizedBox(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: section.items.length,
            itemBuilder: (BuildContext context, int index) => InkWell(
              onTap: () {
                // Globals.currentMember.value = section.clsMembers[index].UID_Mem;
                setCurrentEmployer(section.clsMembers[index]);
                setState(() {});
                // if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                // } else {
                //   SystemNavigator.pop();
                // }
              },
              child: Card(
                margin: EdgeInsets.all(2),
                shadowColor: (getCurrentEmployer() == null || (section.clsMembers[index].UID_Mem != getCurrentEmployer()!.UID_Mem)) ? Colors.white : Colors.red,
                color: (getCurrentEmployer() == null || (section.clsMembers[index].UID_Mem != getCurrentEmployer()!.UID_Mem)) ? Colors.white : Colors.red.shade50,
                // color: (section.clsMember == Globals.currentMember) ? Colors.red : Colors.white,
                child: Center(child: Text(section.items[index])),
              ),
            ),
          ),
        ),
      )
    :
      Padding(
        padding: const EdgeInsets.all(3.0),
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: section.items.length,
          itemBuilder: (BuildContext context, int index) => InkWell(
            onTap: () {
              // Globals.currentMember.value = section.clsMembers[index].UID_Mem;
              setCurrentEmployer(section.clsMembers[index]);
              setState(() {
              });
            },
            child: Card(
              margin: EdgeInsets.all(2),
              shadowColor: Colors.white,
              // (Globals.currentMember.value.isEmpty || (section.clsMembers[index].UID_Mem != Globals.currentMember.value)) ? Colors.white : Colors.red,
              color: Colors.white,
              // (Globals.currentMember.value.isEmpty || (section.clsMembers[index].UID_Mem != Globals.currentMember.value)) ? Colors.white : Colors.red.shade50,
              child: Text(section.items[index]),
            ),
          ),
        ),
      );
    //   GridView.builder(
    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount: section.items.length,
    //     childAspectRatio: 3,
    //   ),
    //   shrinkWrap: true,
    //   physics: NeverScrollableScrollPhysics(),
    //   itemBuilder: (BuildContext context, int index) =>
    //       Container(child: Text(section.items[index]),),
    //   // containerInfo.childDelegate!.builder as Widget Function(BuildContext, int),
    //   itemCount: containerInfo.childDelegate!.childCount,
    // );
  }

}

// class MockData {
//   static List<MemberSection> getMemberSections(List<ClsMember>? lstMembers) {
//     var sections = List<MemberSection>.empty(growable: true);
//     for (int i = 0; i < lstMembers!.length; i++) {
//       int vIdx = sections
//           .indexWhere((element) => element.uidMain == lstMembers[i].UID_Main);
//       if (vIdx >= 0) {
//         sections[vIdx].items.add(lstMembers[i].Address_Title);
//       } else {
//         var section = MemberSection()
//           ..uidMain = lstMembers[i].UID_Main
//           ..imgUrl = lstMembers[i].ImgUrl
//           ..header =
//               '${lstMembers[i].PerName!} ${lstMembers[i]
//               .MidName!} ${lstMembers[i].Name!}'
//           ..items.add(lstMembers[i].Address_Title.isNotEmpty
//               ? lstMembers[i].Address_Title
//               : '>')
//         // ..items = List.generate(1,
//         //      (index) => "ListTile #$index")
//           ..expanded = true;
//         sections.add(section);
//       }
//     }
//     return sections;
//   }
// }

