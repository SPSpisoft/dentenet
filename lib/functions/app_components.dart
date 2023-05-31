import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';

import '../data/app.dart';
import '../public/modeles.dart';
import '../public/public_variables.dart';


offlineBanner(bool isOffline) {
  return Align(
    alignment: Alignment.topLeft,
    child: isOffline ? Padding(
      padding: const EdgeInsets.only(top: 22, left: 5),
      child: RotationTransition(turns: const AlwaysStoppedAnimation(-35 / 360),
          child: Container(
              decoration: const BoxDecoration(color: Colors.transparent),
              child: const Text("OFFLINE", style: TextStyle(
                  fontSize: 15, color: Colors.yellowAccent)))),
    ) : Container(),
  );
}

class MemberSectionWidget extends StatefulWidget {
  final MemberSection section;
  final ExpandableSectionContainerInfo containerInfo;
  final VoidCallback onStateChanged;
  bool expandAll;

  MemberSectionWidget({required this.section,
    required this.containerInfo,
    required this.onStateChanged,
    required this.expandAll
  });

  @override
  _MemberSectionWidgetState createState() => _MemberSectionWidgetState();
}

class _MemberSectionWidgetState extends State<MemberSectionWidget>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _halfTween =
  Tween<double>(begin: 0.0, end: 0.5);
  late AnimationController _controller;
  late Animation _iconTurns;
  late Animation<double> _heightFactor;

  late bool expand;

  @override
  void initState() {
    expand = false;
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _iconTurns =
        _controller.drive(_halfTween.chain(CurveTween(curve: Curves.easeIn)));
    _heightFactor = _controller.drive(CurveTween(curve: Curves.easeIn));

    if (widget.section.isSectionExpanded()) {
      _controller.value = 1;
    }

    // if(widget.expandAll) {
    widget.section.setSectionExpanded(widget.expandAll);
    if (widget.section.isSectionExpanded()) {
      widget.onStateChanged();
      _controller.forward();
    } else {
      _controller.reverse().then((_) {
        widget.onStateChanged();
      });
    }
    // }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.containerInfo
      ..header = _buildHeader(context)
      ..content = _buildContent(context);
    return ExpandableSectionContainer(
      info: widget.containerInfo,
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.red,
          child: Text(widget.section.headerName.substring(0, 1),
              style: const TextStyle(color: Colors.white)),
        ),
        title: Text(
          widget.section.header,
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
            _onTap(!expand);
          }
          // expand = !expand;
        },
      ),
    );
  }

  _onTap(bool setExpand) {
    if (setExpand) {
      widget.section.setSectionExpanded(!widget.section.isSectionExpanded());
      if (widget.section.isSectionExpanded()) {
        widget.onStateChanged();
        _controller.forward();
      } else {
        _controller.reverse().then((_) {
          widget.onStateChanged();
        });
      }
    }
  }

  Widget _buildContent(BuildContext context) {
    return SizeTransition(
      sizeFactor: _heightFactor,
      child: SliverExpandableChildDelegate.buildDefaultContent(
          context, widget.containerInfo),
    );
  }
}

class MemberData {
  static List<MemberSection> getMemberSections(List<ClsMember>? lstMembers) {
    var sections = List<MemberSection>.empty(growable: true);
    for (int i = 0; i < lstMembers!.length; i++) {
      int vIdx = sections
          .indexWhere((element) => element.uidMain == lstMembers[i].UID_Main);
      if (vIdx >= 0) {
        sections[vIdx].items.add(lstMembers[i].Address_Title);
        sections[vIdx].clsMembers.add(lstMembers[i]);
      } else {
        var section = MemberSection()
          ..uidMain = lstMembers[i].UID_Main
          ..imgUrl = lstMembers[i].ImgUrl
          ..headerName = lstMembers[i].Name!
          ..header =
              '${lstMembers[i].PerName!} ${lstMembers[i]
              .MidName!} ${lstMembers[i].Name!}'
          ..items.add(lstMembers[i].Address_Title.isNotEmpty
              ? lstMembers[i].Address_Title
              : '>')
          ..clsMembers.add(lstMembers[i])
        // ..items = List.generate(1,
        //      (index) => "ListTile #$index")
          ..expanded = true;
        sections.add(section);
      }
    }
    return sections;
  }
}