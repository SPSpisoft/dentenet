import 'dart:async';
import 'dart:ui';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:sp_keyboard_shortcut_ns/sp_keyboard_shortcut_ns.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../../../public/public_functions.dart';
import '../../../public/public_variables.dart';
import '../../../themes/app_theme.dart';
import '../../../themes/master_theme.dart';
import '../../classes/ClsTags.dart';
import '../../data_fetch.dart';
import '../../views/scroll_to_hide_widget_getx.dart';
import '../../views/search_box.dart';
import '../../views/sub_tag_list_view.dart';
import '../../views/tag_area_view.dart';

class MyTagPage extends StatefulWidget {
  final void Function(List<String>?, int? typeCallCode) goToSearch;
  final void Function(int, int, String?) goToPage;
  final AnimationController? mainScreenAnimationController;
  ScrollController scrollController;

  MyTagPage(
      {Key? key,
      required this.goToSearch,
      required this.goToPage,
      required this.scrollController,
      this.mainScreenAnimationController})
      : super(key: key);

  @override
  _MyTagPageState createState() => _MyTagPageState();
}

class _MyTagPageState extends State<MyTagPage> with TickerProviderStateMixin {
  List<ClsTags> tagList = [];
  List<tagLink> linkList = [];
  List<String> catList = [];
  AnimationController? animationController;
  bool multiple = false;

  late final GetXCtrlHideWidget ctrl;

  // final ScrollController _controller = ScrollController();

  // late Future<List<ClsTags>> _getDate;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    // _getDate = fetchTags();
    ctrl = Get.find();

    super.initState();

    // widget.scrollController.initialScrollOffset
        //.jumpTo(Globals.stackTag[Globals.stackTag.length - 1].scrollPosition);
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  callback(callTypeCode) {
    setState(() {
      widget.goToSearch(catList, callTypeCode);
    });
  }

  callGoToPage(String tagId) {
    widget.goToPage(5, 1, tagId);
  }

  void _scrollToPosition() {
    if (widget.scrollController.hasClients) {
      widget.scrollController.animateTo(Globals.stackTag[Globals.stackTag.length - 1].scrollPosition,
          duration: const Duration(milliseconds: 900), curve: Curves.easeInOutCubicEmphasized);
    } else {
      Timer(const Duration(milliseconds: 900), () => _scrollToPosition());
    }
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToPosition());

    return KeyBoardShortcuts(
      globalShortcuts: true,
      child: Scaffold(
        backgroundColor: AppTheme.white,
        appBar: AppBar(
          // actions: [
          //   Padding(
          //     padding: EdgeInsets.only(left: 20 , right: 10),
          //     child: const Icon(
          //       Icons.shopping_cart_outlined,
          //       color: AppTheme.menuMasterIconColor,
          //     ),
          //   )
          // ],
          leading: Container(),
          title: SearchBox(
            readOnly: true,
            atVoice: true,
            onTap: callback,
            focusNode: FocusNode(),
            onTextChange: (value) => () {},
          ),
        ),
        body: FutureBuilder<List<ClsTags>>(
          future:
              // fetchTags(Globals.stackTag[Globals.stackTag.length - 1], '', true),
              Globals.stackTag.length == 1
                  ? fetchTags(Globals.tagType_ROOT, '', false)
                  : fetchTags(
                      '',
                      Globals.stackTag[Globals.stackTag.length - 1].tagId
                          .replaceAll('#', ''),
                      true),
          builder: (BuildContext context, snapshot) {
            ctrl.changeStatus(true, Globals.stackTag.length > 1);

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: JumpingDotsProgressIndicator(
                  fontSize: 55.0,
                  color: AppTheme.primarySwatch,
                ),
              );
            }
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              // currentTag == Globals.tagType_ROOT
              Globals.stackTag.length == 1
                  ? tagList = snapshot.data!.toList()
                  : tagList = snapshot.data![0].subset;

              Globals.stackTag.length == 1
                  ? linkList.clear()
                  : linkList = snapshot.data![0].links;

              catList.clear();

              for (var link in linkList) { catList.add(link.id);}
              for (var element in tagList) {for (var link in element.links) { catList.add(link.id);} }
              // bool _itemListHorizontal = (Globals.stackTag.length > 1);
              // && snapshot.data![0].modelShowType == 1);
              
              int _itemCount = 0;
              return RawScrollbar(
                thumbColor: Colors.black45,
                radius: const Radius.circular(20),
                thickness: kIsWeb &&
                        (defaultTargetPlatform == TargetPlatform.windows ||
                            defaultTargetPlatform == TargetPlatform.linux)
                    ? 15
                    : 1,
                controller: widget.scrollController,
                // isAlwaysShown: kIsWeb &&
                //     (defaultTargetPlatform == TargetPlatform.windows ||
                //         defaultTargetPlatform == TargetPlatform.linux),
                child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: StaggeredGridView.countBuilder(
                      padding: EdgeInsets.only(
                          left: 0.01.sw,
                          right: 0.01.sw,
                          top: 0.02.sh,
                          bottom: 0.3.sh),
                      crossAxisCount: 4,
                      scrollDirection: Axis.vertical,
                      controller: widget.scrollController,
                      shrinkWrap: true,
                      itemCount: _itemCount =
                          tagList.length + 1 + linkList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Animation<double> animation =
                            Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: animationController!,
                            curve: Interval((1 / _itemCount) * index > 1 ? 1 : (1 / _itemCount) * index, 1.0,
                                curve: Curves.fastOutSlowIn),
                          ),
                        );
                        animationController?.forward();
                        return viewSet(index, animation, snapshot.data![0],
                            Globals.stackTag.length == 1, index >= tagList.length + 1);
                      },
                      staggeredTileBuilder: (int index) => setSize(1.sw > 1.sh,
                          index, Globals.stackTag.length == 1, index >= tagList.length + 1),
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                    )),
              );
            }
          },
        ),
      ),
    );
  }

  Widget viewSet(int index, Animation<double> animation, ClsTags clsTags, bool isRootPage, bool isLink) {
    if (index == 0) {
      if (isRootPage) {
        return HeaderView(
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                  parent: animationController!,
                  curve: const Interval((0) * 3, 1.0,
                      curve: Curves.fastOutSlowIn))),
          animationController: widget.mainScreenAnimationController!,
        );
      } else {
        return TitleView(
          clsTags: clsTags,
        );
      }
    } else {
      if (isLink) {
        return LinkView(
          functionOnTap: () {
            // ToastNormal(linkList[index - tagList.length - 1].title);
            Globals.stackTag[Globals.stackTag.length-1].scrollPosition = widget.scrollController.offset;
            // Navigator.of(context).push(_createRoutePrdLst(
            //     linkList[index - tagList.length - 1].id,
            //     widget.goToSearch,
            //     widget.scrollController,
            //     widget.mainScreenAnimationController));
            callGoToPage(linkList[index - tagList.length - 1].id);
            // setState(() {});
          },
          link: linkList[index - tagList.length - 1],
          assetImage: 'assets/images/image_not_available.png',
          animation: animation,
          animationController: animationController!,
        );
      } else {
        if (!isRootPage && tagList[index - 1].modelShowType == 1) {
          return AreaListView(
            tag: tagList[index - 1],
            goToPage: widget.goToPage,
            goToSearch: widget.goToSearch,
            scrollController: widget.scrollController,
            animationController: animationController!,
            animation: animation,
          );
        } else {
          return TagAreaView(
            functionOnTap: () {
              // ToastNormal(tagList[index - 1].tagId + ' >> ' + tagList[index - 1].tagTitle);
              Globals.stackTag[Globals.stackTag.length-1].scrollPosition = widget.scrollController.offset;
              Globals.stackTag.add(StackTag(tagList[index - 1].tagId, 0.0));

              setState(() {});
            },
            tag: tagList[index - 1],
            assetImage: 'assets/images/image_not_available.png',

            animation: animation,
            animationController: animationController!,
          );
        }
      }
    }

    // return index == 0
    //     ? (Globals.stackTag.length == 1
    //         ? HeaderView(
    //             animation: Tween<double>(begin: 0.0, end: 1.0).animate(
    //                 CurvedAnimation(
    //                     parent: animationController!,
    //                     curve: const Interval((0) * 3, 1.0,
    //                         curve: Curves.fastOutSlowIn))),
    //             animationController: widget.mainScreenAnimationController!,
    //           )
    //         : TitleView(
    //             clsTags: clsTags,
    //           ))
    //     : index < tagList.length + 1
    //         ? Globals.stackTag.length > 1 &&
    //                 tagList[index - 1].modelShowType == 1
    //             ? AreaListView(
    //                 tag: tagList[index - 1],
    //                 notifyParent: widget.goToSearch,
    //                 scrollController: widget.scrollController,
    //                 animationController: animationController!,
    //                 animation: animation,
    //               )
    //             : TagAreaView(
    //                 functionOnTap: () {
    //                   // ToastNormal(tagList[index - 1].tagId + ' >> ' + tagList[index - 1].tagTitle);
    //                   Globals.stackTag.add(tagList[index - 1].tagId);
    //
    //                   setState(() {});
    //                 },
    //                 tag: tagList[index - 1],
    //                 assetImage: 'assets/images/image_not_available.png',
    //                 animation: animation,
    //                 animationController: animationController!,
    //               )
    //         : LinkView(
    //             functionOnTap: () {
    //               ToastNormal(linkList[index - tagList.length - 1].title);
    //
    //               setState(() {});
    //             },
    //             link: linkList[index - tagList.length - 1],
    //             assetImage: 'assets/images/image_not_available.png',
    //             animation: animation,
    //             animationController: animationController!,
    //           );
  }

  StaggeredTile setSize(bool isLandscape, int index, bool isRootPage, bool isLink) {
    int _width = 4;
    double _height = 4.0;

    if (isLandscape) {
      // index == 0 ? 4 : 1, index == 0 ? 0.7 : 1.2
      if (index == 0) {
        _width = 4;
        _height = 0.7;
      } else if (isRootPage) {
        _width = 1;
        _height = 1.2;
      } else if(isLink) {
        _width = 4;
        _height = 1.5;
      } else {
        _width = 4;
        _height = 1.7;
      }
    } else {
      if (index == 0) {
        _width = 4;
        _height = 1.7;
      } else if (isRootPage) {
        _width = 2;
        _height = 2.4;
      } else if(isLink) {
        _width = 4;
        _height = 1.5;
      } else {
        _width = 4;
        _height = 2.8;
      }
    }

    return StaggeredTile.count(_width, _height);
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
//       goToPage: goToPa,
//       scrollController: scrollController,
//       mainScreenAnimationController: mainScreenAnimationController,
//     ),
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       return child;
//     },
//   );
// }

class AreaListView extends StatelessWidget {
  const AreaListView({
    Key? key,
    required this.tag,
    required this.scrollController,
    required this.goToSearch,
    required this.goToPage,
    this.animationController,
    this.animation,
  }) : super(key: key);

  final ClsTags tag;
  final Function(List<String>?, int?) goToSearch;
  final Function(int, int, String?) goToPage;
  final ScrollController scrollController;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: Padding(
              padding: EdgeInsets.all(0.01.sw),
              child: Container(
                decoration: BoxDecoration(
                  color: MasterTheme.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
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
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8, bottom: 10, left: 20, right: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ReplacePersianChar(tag.tagTitle),
                            style: const TextStyle(
                                fontFamily: 'Yekan', fontSize: 14),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: Colors.deepOrangeAccent,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: SubTagListView(
                          links: tag.links,
                          goToPage: goToPage,
                          goToSearch: goToSearch,
                          scrollController: scrollController,
                          mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0)
                              .animate(CurvedAnimation(
                                  parent: animationController!,
                                  curve: Interval((1 / tag.links.length) * 3 > 1 ? 1 : (1 / tag.links.length) * 3, 1.0,
                                      curve: Curves.fastOutSlowIn))),
                          mainScreenAnimationController: animationController,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// class AreaView extends StatelessWidget {
//   const AreaView({
//     Key? key,
//     required this.tag,
//     required this.functionOnTap,
//     this.assetImage,
//     this.animationController,
//     this.animation,
//   }) : super(key: key);
//
//   final ClsTags tag;
//   final VoidCallback functionOnTap;
//   final String? assetImage;
//   final AnimationController? animationController;
//   final Animation<double>? animation;
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: animationController!,
//       builder: (BuildContext context, Widget? child) {
//         return FadeTransition(
//           opacity: animation!,
//           child: Transform(
//             transform: Matrix4.translationValues(
//                 0.0, 50 * (1.0 - animation!.value), 0.0),
//             child: Padding(
//               padding: EdgeInsets.all(0.01.sw),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: MasterTheme.white,
//                   borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(8.0),
//                       bottomLeft: Radius.circular(8.0),
//                       bottomRight: Radius.circular(8.0),
//                       topRight: Radius.circular(8.0)),
//                   boxShadow: <BoxShadow>[
//                     BoxShadow(
//                         color: MasterTheme.grey.withOpacity(0.4),
//                         offset: const Offset(1.1, 1.1),
//                         blurRadius: 10.0),
//                   ],
//                 ),
//                 child: Material(
//                   color: Colors.transparent,
//                   child: InkWell(
//                     focusColor: Colors.transparent,
//                     highlightColor: Colors.transparent,
//                     hoverColor: Colors.transparent,
//                     borderRadius: const BorderRadius.all(Radius.circular(8.0)),
//                     splashColor: MasterTheme.nearlyDarkBlue.withOpacity(0.1),
//                     onTap: functionOnTap,
//                     child: Stack(
//                       children: <Widget>[
//                         AspectRatio(
//                           aspectRatio: 1,
//                           child: Container(
//                             width: double.infinity,
//                             child: Align(
//                               alignment: Alignment.center,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: tag.bannerUrl.isNotEmpty
//                                     ? Image.network(
//                                         Globals.baseUrl + tag.bannerUrl)
//                                     : Image.asset(assetImage!),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Align(
//                           alignment: Alignment.bottomCenter,
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               ReplacePersianChar(tag.tagTitle),
//                               style: const TextStyle(
//                                 color: Colors.black54,
//                                 fontFamily: 'Yekan',
//                                 fontSize: 13.0,
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

class LinkView extends StatelessWidget {
  const LinkView({
    Key? key,
    required this.link,
    required this.functionOnTap,
    this.assetImage,
    this.animationController,
    this.animation,
  }) : super(key: key);

  final tagLink link;
  final VoidCallback functionOnTap;
  final String? assetImage;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: Padding(
              padding: EdgeInsets.all(0.01.sw),
              child: Container(
                decoration: BoxDecoration(
                  color: MasterTheme.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
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
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    splashColor: MasterTheme.nearlyDarkBlue.withOpacity(0.1),
                    onTap: functionOnTap,
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: link.parentUrl.isNotEmpty
                              ? ClipRRect(borderRadius: BorderRadius.circular(6.0),
                                child:
                                // CachedNetworkImage(
                                //   imageUrl: Globals.baseUrl + link.parentUrl,
                                //   fit: BoxFit.fill,
                                //   progressIndicatorBuilder: (context, url, downloadProgress) =>
                                //       JumpingDotsProgressIndicator(
                                //         fontSize: 35.0,
                                //         color: AppTheme.primarySwatch,
                                //       ),
                                //   errorWidget: (context, url, error) => Image.asset(assetImage!),
                                // ),

                                FancyShimmerImage(
                                  width: double.infinity,
                                  height: double.infinity,
                                  boxFit: BoxFit.fill,
                                  imageUrl:
                                  Globals.baseUrlShop + link.parentUrl,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            colorFilter: ColorFilter.mode(
                                                Colors.black.withOpacity(0.0),
                                                BlendMode.darken),
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                  errorWidget: Image.asset(
                                    'assets/images/image_not_available.png',
                                    fit: BoxFit.fill,
                                  ),
                                )

                                // CachedNetworkImage(
                                //   imageUrl: Globals.baseUrl + link.parentUrl,
                                //   fit: BoxFit.fill,
                                //   imageBuilder: (context, imageProvider) => Container(
                                //     decoration: BoxDecoration(
                                //       image: DecorationImage(
                                //         image: imageProvider,
                                //         fit: BoxFit.fill,
                                //         // colorFilter:
                                //         // const ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                                //       ),
                                //     ),
                                //   ),
                                //   placeholder: (context, url) => JumpingDotsProgressIndicator(
                                //     fontSize: 35.0,
                                //     color: AppTheme.primarySwatch,
                                //   ),
                                //   errorWidget: (context, url, error) => Center(child: Image.asset(assetImage!, fit: BoxFit.cover, alignment: Alignment.center)),
                                // )

                                // Image.network(
                                // Globals.baseUrl + link.parentUrl, fit: BoxFit.cover,
                                //   height: double.infinity,
                                //   width: double.infinity, alignment: Alignment.center,),
                              )
                              : Center(child: Image.asset(assetImage!, fit: BoxFit.cover, alignment: Alignment.center, )),
                        ),
                        // AspectRatio(
                        //   aspectRatio: 1,
                        //   child: Container(
                        //     width: double.infinity,
                        //     child: ,
                        //   ),
                        // ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.only(top: 5.h ,right: 20.w, left: 20.w),
                            child: Text(
                              ReplacePersianChar(link.title),
                              style: TextStyle(
                                color: Colors.white                                                                                                                                                      ,
                                fontFamily: 'Yekan2',
                                fontSize: 16.sp,
                                shadows: const <Shadow>[
                                  Shadow(
                                    offset: Offset(4.0, 4.0),
                                    blurRadius: 20.0,
                                    color: Colors.black,
                                  ),
                                  Shadow(
                                    offset: Offset(4.0, -4.0),
                                    blurRadius: 20.0,
                                    color: Colors.black,
                                  ),
                                  Shadow(
                                    offset: Offset(-4.0, -4.0),
                                    blurRadius: 20.0,
                                    color: Colors.black,
                                  ),
                                  Shadow(
                                    offset: Offset(-4.0, 4.0),
                                    blurRadius: 20.0,
                                    color: Colors.black,
                                  ),
                                ],
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
        );
      },
    );
  }
}

class HeaderView extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const HeaderView({Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - animation!.value), 0.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 0, bottom: 0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: MasterTheme.white,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                bottomLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),
                                topRight: Radius.circular(8.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: MasterTheme.grey.withOpacity(0.4),
                                  offset: Offset(1.1, 1.1),
                                  blurRadius: 10.0),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.topLeft,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                child: SizedBox(
                                  height: 74,
                                  child: AspectRatio(
                                    aspectRatio: 1.714,
                                    child: Image.asset(
                                        "assets/images/teeth_color.png"),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: const <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 100,
                                          right: 16,
                                          top: 16,
                                        ),
                                        child: Text(
                                          "You're doing great",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontFamily: MasterTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            letterSpacing: 0.0,
                                            color: MasterTheme.nearlyDarkBlue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 100,
                                      bottom: 12,
                                      top: 4,
                                      right: 16,
                                    ),
                                    child: Text(
                                      "Keep it up\nand stick to your plan",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: MasterTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10,
                                        letterSpacing: 0.0,
                                        color:
                                            MasterTheme.grey.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Positioned(
                      //   top: -16,
                      //   left: 0,
                      //   child: SizedBox(
                      //     width: 110,
                      //     height: 110,
                      //     child: Image.asset("assets/images/teeth_color.png"),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TitleView extends StatefulWidget {
  final ClsTags clsTags;

  const TitleView({Key? key, required this.clsTags}) : super(key: key);

  @override
  _TitleView createState() => _TitleView();
}

class _TitleView extends State<TitleView> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..forward();
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {});
    // _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child:
          FancyShimmerImage(
            imageUrl: Globals.baseUrlShop + widget.clsTags.backgroundUrl,
            width: double.infinity,
            boxFit: BoxFit.fill,
            errorWidget: Image.asset('assets/images/image_not_available.png', fit: BoxFit.fill),
          ),

          // CachedNetworkImage(
          //   imageUrl: Globals.baseUrl + widget.clsTags.backgroundUrl,
          //   fit: BoxFit.fill,
          //   imageBuilder: (context, imageProvider) => Container(
          //     decoration: BoxDecoration(
          //       image: DecorationImage(
          //         image: imageProvider,
          //         fit: BoxFit.fill,
          //         // colorFilter:
          //         // const ColorFilter.mode(Colors.red, BlendMode.colorBurn)
          //       ),
          //     ),
          //   ),
          //   placeholder: (context, url) => JumpingDotsProgressIndicator(
          //     fontSize: 35.0,
          //     color: AppTheme.primarySwatch,
          //   ),
          //   errorWidget: (context, url, error) => Image.asset('assets/images/image_not_available.png'),
          // ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: FadeTransition(
                  opacity: _animation.drive(CurveTween(curve: Curves.easeOut)),
                  child: Container(
                    // duration: Duration(milliseconds: 2000), curve: Curves.easeIn,
                    height: 0.1.sh,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 7.0),
                    decoration: BoxDecoration(
                      color: Colors.white12.withOpacity(0.1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          ReplacePersianChar(widget.clsTags.tagTitle),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Titraj',
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(2.0, 2.0),
                                blurRadius: 10.0,
                                color: Colors.black,
                              ),
                              // Shadow(
                              //   offset: Offset(0.0, 15.0),
                              //   blurRadius: 1.0,
                              //   color: Colors.yellow,
                              // ),
                            ],
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
