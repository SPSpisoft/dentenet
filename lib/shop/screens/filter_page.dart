import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  // late Animation<Offset> slideAnimation;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    // controller =
    //     AnimationController(vsync: this, duration: Duration(milliseconds: 950));
    // slideAnimation = Tween<Offset>(begin: Offset(0.0, -4.0), end: Offset.zero)
    //     .animate(CurvedAnimation(parent: controller, curve: Curves.decelerate));
    // controller.addListener(() {
    //   setState(() {});
    // });
    // controller.forward();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    slideAnimation = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.0))
        .animate(controller);
    controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        // appBar: AppBar(.......)
        body: Align(
          alignment: Alignment.bottomCenter,
          child: SlideTransition(
            position: slideAnimation,
            child: Container(
              padding: const EdgeInsets.all(13.0),
              height: MediaQuery.of(context).size.height / 2.7,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              child: Column( children: [
                Text("data"),
              ],),
            ),
          ),
        ));
  }
}
