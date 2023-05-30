import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../public/public_functions.dart';
import '../../public/public_variables.dart';
import '../../themes/master_theme.dart';
import '../classes/ClsTags.dart';

class SubTagListView extends StatefulWidget {
  final List<tagLink> links;
  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final Function(List<String>?, int?) goToSearch;
  final Function(int, int, String?) goToPage;
  ScrollController scrollController;

  SubTagListView(
      {Key? key,
      required this.links,
      required this.goToSearch,
      required this.goToPage,
      required this.scrollController,
      this.mainScreenAnimationController,
      this.mainScreenAnimation})
      : super(key: key);

  @override
  _SubTagListViewState createState() => _SubTagListViewState();
}

class _SubTagListViewState extends State<SubTagListView>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  callback(callTypeCode) {
    setState(() {
      widget.goToSearch([], callTypeCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child: Container(
              width: double.infinity,
              child: ScrollConfiguration(
                behavior: MyCustomScrollBehavior(),
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 0, right: 12, left: 12),
                  itemCount: widget.links.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    final int count = widget.links.length;
                    final Animation<double> animation =
                        Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: animationController,
                                curve: Interval((1 / count) * index, 1.0,
                                    curve: Curves.fastOutSlowIn)));
                    animationController.forward();
                    // return TagLinkAreaView(
                    //   functionOnTap: () {
                    //     ToastNormal(widget.links[index].id + ' >> ' + widget.links[index].title);
                    //     // Globals.stackTag
                    //     //     .add(widget.links[index].tagId);
                    //     setState(() {});
                    //   },
                    //   tag: widget.links[index],
                    //   assetImage:
                    //   'assets/images/image_not_available.png',
                    //   animation: animation,
                    //   animationController: animationController!,
                    // );
                    return MealsView(
                      tag: widget.links[index],
                      functionOnTap: () {
                        // ToastNormal(widget.links[index].id +
                        //     ' >> ' +
                        //     widget.links[index].title);
                        Globals.stackTag[Globals.stackTag.length-1].scrollPosition = widget.scrollController.offset;
                        // Navigator.of(context).push(_createRoutePrdLst(
                        //     widget.links[index].id,
                        //     widget.goToSearch,
                        //     ScrollController(),
                        //     widget.mainScreenAnimationController));
                        widget.goToPage(5,1, widget.links[index].id);
                      },
                      animation: animation,
                      animationController: animationController,
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Route _createRoutePrdLst(
//     String catId,
//     Function() goToSearch,
//     ScrollController scrollController,
//     AnimationController? mainScreenAnimationController) {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) => ProductCatPage(
//       catId: catId,
//       goToPage : goToPa,
//       scrollController: scrollController,
//       mainScreenAnimationController: mainScreenAnimationController,
//     ),
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       return child;
//     },
//   );
// }

class MealsView extends StatelessWidget {
  const MealsView(
      {Key? key,
      required this.tag,
      required this.functionOnTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final tagLink tag;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final VoidCallback functionOnTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation!.value), 0.0, 0.0),
            child: SizedBox(
              height: double.infinity,
              child: AspectRatio(
                aspectRatio: 0.7,
                child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 50 * (1.0 - animation!.value), 0.0),
                  child: Padding(
                    padding: EdgeInsets.only(left: 8, right: 8,bottom: 16, top: 8,),
                    child: Container(
                      decoration: BoxDecoration(
                        color: MasterTheme.white,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24.0),
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                            topRight: Radius.circular(8.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: MasterTheme.grey.withOpacity(0.4),
                              offset: const Offset(1.1, 1.1),
                              blurRadius: 10.0),
                        ],
                      ),
                      child:
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                          splashColor:
                              MasterTheme.nearlyDarkBlue.withOpacity(0.1),
                          onTap: functionOnTap,
                          child: Stack(
                            children: <Widget>[
                              AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: tag.imgUrl.isNotEmpty
                                        ? ClipRRect(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(6)),
                                          child:
                                          FancyShimmerImage(
                                            imageUrl: Globals.baseUrlShop + tag.imgUrl,
                                            boxFit: BoxFit.fill,
                                            errorWidget: Image.asset('assets/images/image_not_available.png', fit: BoxFit.fill),
                                          )

                                      // CachedNetworkImage(
                                          //   imageUrl: Globals.baseUrl + tag.imgUrl,
                                          //   fit: BoxFit.fill,
                                          //   progressIndicatorBuilder: (context, url, downloadProgress) =>
                                          //       JumpingDotsProgressIndicator(
                                          //         fontSize: 35.0,
                                          //         color: AppTheme.primarySwatch,
                                          //       ),
                                          //   errorWidget: (context, url, error) => Image.asset('assets/images/image_not_available.png', fit: BoxFit.fill,),
                                          // ),

                                      // Image.network(
                                      //         Globals.baseUrl + tag.imgUrl, fit: BoxFit.fill,),
                                        )
                                        : Image.asset(
                                            'assets/images/image_not_available.png', fit: BoxFit.fill,),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    ReplacePersianChar(tag.title),
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontFamily: 'Yekan',
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
