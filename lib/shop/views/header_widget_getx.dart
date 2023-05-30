import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';


class HeaderWidgetGetX extends StatefulWidget {
  final Widget child;
  final ScrollController controller;
  final Duration duration;

  const HeaderWidgetGetX(
      {Key? key,
      required this.child,
      required this.controller,
      this.duration = const Duration(milliseconds: 300)})
      : super(key: key);

  @override
  _HeaderWidgetGetXState createState() => _HeaderWidgetGetXState();
}

class GetXHeaderWidget extends GetxController {
  bool active = true;
  bool visible = true;
  void changeStatus(bool _visible, bool _active) {
    // ToastNormal(_visible.toString());
    visible = _visible;
    active = _active;
    update();
  }
}

class _HeaderWidgetGetXState extends State<HeaderWidgetGetX> {
  final getXController = Get.put(GetXHeaderWidget());
  // bool isVisible = true;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(listen);
  }

  @override
  void dispose() {
    widget.controller.removeListener(listen);
    super.dispose();
  }

  void listen() {
    final direction = widget.controller.position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      show();
    } else if (direction == ScrollDirection.reverse) {
      hide();
    }
    // getXController.changeStatus(getXController.visible);

    // if(widget.controller.position.pixels >= 200){
    //   hide();
    // }else{
    //   show();
    // }
  }

  void show() {
    // if (!isVisible) setState(() => isVisible = true);
    if (!getXController.visible) setState(() => getXController.changeStatus(true, getXController.active));
  }

  void hide() {
    // if (isVisible) setState(() => isVisible = false);
    if (getXController.active && getXController.visible) setState(() => getXController.changeStatus(false, getXController.active));

  }

  @override
  Widget build(BuildContext context) => AnimatedContainer(
      duration: widget.duration,
      height: !getXController.active || getXController.visible ? kBottomNavigationBarHeight : 0,
      child: Wrap(children: [widget.child]));
}
