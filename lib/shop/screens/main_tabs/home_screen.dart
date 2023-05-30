import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progress_indicators/progress_indicators.dart';

import '../../../public/public_functions.dart';
import '../../../public/public_variables.dart';
import '../../../themes/app_theme.dart';
import '../../../themes/master_theme.dart';
import '../../classes/ClsStore.dart';
import '../../classes/ClsTags.dart';
import '../../data_fetch.dart';
import '../../views/search_box.dart';

class MyHomePage extends StatefulWidget {
  final Function(List<String>?, int?) notifyParent;

  const MyHomePage({Key? key, required this.notifyParent}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  // List<HomeList> homeList = HomeList.homeList;
  List<ClsTags> homeList = [];
  AnimationController? animationController;
  bool multiple = false;
  final ScrollController _controller = ScrollController();

  // late final Function notifyParent;
  // _MyHomePageState({required this.notifyParent});

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    // _futureStoreTarget = fetchStoreTarget();
    // _futureTags = fetchTags();
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  callback(callTypeCode) {
    setState(() {
      widget.notifyParent([], callTypeCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return RawScrollbar(
              thumbColor: Colors.black45,
              radius: const Radius.circular(20),
              thickness: kIsWeb &&
                      (defaultTargetPlatform == TargetPlatform.windows ||
                          defaultTargetPlatform == TargetPlatform.linux)
                  ? 15
                  : 1,
              controller: _controller,
              isAlwaysShown: kIsWeb &&
                  (defaultTargetPlatform == TargetPlatform.windows ||
                      defaultTargetPlatform == TargetPlatform.linux),
              child: CustomScrollView(
                controller: _controller,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 1.sw > 1.sh ? 0.2.sw : 0.2.sh,
                    collapsedHeight: 55,
                    toolbarHeight: 55,
                    backgroundColor: AppTheme.statusBarColor,
                    shadowColor: Colors.transparent,
                    stretch: true,
                    centerTitle: true,
                    // floating: true,
                    // snap: true,
                    // actions: <Widget>[
                    //   IconButton(
                    //     icon: const Icon(
                    //       Icons.shopping_cart_outlined,
                    //       color: AppTheme.menuMasterIconColor, // Here
                    //     ),
                    //     onPressed: () {},
                    //   ),
                    // ],
                    // actions: [
                    //   IconButton(
                    //     padding: const EdgeInsets.fromLTRB(0.0, 6.0, 6.0, 6.0),
                    //     constraints: const BoxConstraints(),
                    //     icon: const Icon(Icons.ac_unit_sharp),
                    //     color: const Color(0xffffffff),
                    //     onPressed: () {
                    //       ToastNormal('Voice Search.. ');
                    //       // _onVoiceSearchButtonPressed();
                    //     },
                    //   ),
                    // ],
                    // leading: Row( children: [
                    //   IconButton(
                    //     padding: const EdgeInsets.fromLTRB(0.0, 6.0, 6.0, 6.0),
                    //     constraints: const BoxConstraints(),
                    //     icon: const Icon(Icons.mic_rounded),
                    //     color: const Color(0xffbdbdc1),
                    //     onPressed: () {
                    //       ToastNormal('Voice Search..11 ');
                    //       // _onVoiceSearchButtonPressed();
                    //     },
                    //   ),
                    // ],),
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      stretchModes: const [
                        StretchMode.fadeTitle,
                        StretchMode.zoomBackground
                      ],
                      background: FutureBuilder<List<ClsStore>>(
                          future: Globals.futureStoreTarget,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData &&
                                  snapshot.data!.isNotEmpty) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: AppTheme.screenColor,
                                    image: DecorationImage(
                                      colorFilter: ColorFilter.mode(
                                          Colors.black.withOpacity(0.4),
                                          BlendMode.darken),
                                      image: CachedNetworkImageProvider(
                                          Globals.baseUrlShop +
                                              Globals.myStore.banner),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 0.1.sw,
                                        right: 0.1.sw,
                                        bottom: 0.02.sh),
                                    // const EdgeInsets.fromLTRB(30, 100, 30, 0),
                                    child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: SearchBox(
                                          readOnly: true,
                                          atVoice: true,
                                          onTap: callback,
                                          focusNode: FocusNode(),
                                          onTextChange: (value) => () {},
                                        )),
                                  ),
                                );
                                // Image.network(Globals.baseUrl + snapshot.data![0].logo);
                              }
                            }
                            return Container(
                              decoration: const BoxDecoration(
                                color: AppTheme.screenColor,
                                // image: DecorationImage(
                                //   image: AssetImage(
                                //       'assets/images/default_back.jpg'),
                                //   fit: BoxFit.cover,
                                // ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 0.1.sw,
                                    right: 0.1.sw,
                                    bottom: 0.02.sh),
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: SearchBox(
                                      readOnly: true,
                                      atVoice: true,
                                      onTap: callback,
                                      focusNode: FocusNode(),
                                      onTextChange: (value) => () {},
                                    )),
                              ),
                            );

                            JumpingDotsProgressIndicator(
                              fontSize: 15.0,
                              color: Colors.white,
                            );
                          }),

                      // Container(
                      //   child: const Padding(
                      //     padding: EdgeInsets.fromLTRB(30, 100, 30, 0),
                      //     child: Center(child:
                      //     SearchBox(atVoice: true)),
                      //   ),
                      //   decoration:
                      //   const BoxDecoration(
                      //     image: DecorationImage(
                      //       image: NetworkImage(
                      //           'https://shop.spisoft.ir/_Files/Images/Banners/tt2.png'),
                      //       fit: BoxFit.cover,
                      //     ),
                      //   ),
                      // ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // Text('تست فارسی'),
                        // FutureBuilder<bool>(
                        FutureBuilder<List<ClsTags>>(
                          // future: getData(),
                          future: Globals.futureTags,
                          builder: (BuildContext context, snapshot) {
                            if (!snapshot.hasData) {
                              return const SizedBox();
                            } else {
                              homeList = snapshot.data!
                                  .where((ClsTags clsTags) =>
                                      clsTags.tagType == Globals.tagType_SYS &&
                                      clsTags.lstType == 0)
                                  .toList();
                              return Padding(
                                padding: const EdgeInsets.all(0),
                                child: Column(
                                  children: List.generate(homeList.length,
                                      (int index) {
                                    final int count = homeList.length;
                                    final Animation<double> animation =
                                        Tween<double>(begin: 0.0, end: 1.0)
                                            .animate(
                                      CurvedAnimation(
                                        parent: animationController!,
                                        curve: Interval(
                                            (1 / count) * index, 1.0,
                                            curve: Curves.fastOutSlowIn),
                                      ),
                                    );
                                    animationController?.forward();
                                    return HomeListView(
                                      animation: animation,
                                      animationController: animationController,
                                      listData: homeList[index],
                                      callBack: () {
                                        ToastNormal('GoTo Page Tag.. ' +
                                            homeList[index].tagTitle, context,type: 1);
                                        // Navigator.push<dynamic>(
                                        //   context,
                                        //   MaterialPageRoute<dynamic>(
                                        //     builder: (BuildContext context) =>
                                        //         homeList[index].navigateScreen!,
                                        //   ),
                                        // );
                                      },
                                    );
                                  }),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget appBar() {
    return SizedBox(
      height: AppBar().preferredSize.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: Container(
              width: AppBar().preferredSize.height - 8,
              height: AppBar().preferredSize.height - 8,
            ),
          ),
          const Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Flutter UI',
                  style: TextStyle(
                    fontSize: 22,
                    color: AppTheme.darkText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 8),
            child: Container(
              width: AppBar().preferredSize.height - 8,
              height: AppBar().preferredSize.height - 8,
              color: Colors.white,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius:
                      BorderRadius.circular(AppBar().preferredSize.height),
                  child: Icon(
                    multiple ? Icons.dashboard : Icons.view_agenda,
                    color: AppTheme.dark_grey,
                  ),
                  onTap: () {
                    setState(() {
                      multiple = !multiple;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeListView extends StatelessWidget {
  const HomeListView(
      {Key? key,
      this.listData,
      this.callBack,
      this.animationController,
      this.animation})
      : super(key: key);

  final ClsTags? listData;
  final VoidCallback? callBack;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: AnimatedBuilder(
        animation: animationController!,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: animation!,
            child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 50 * (1.0 - animation!.value), 0.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
                    child: Row(
                      children: [
                        Text(
                          ReplacePersianChar(listData!.tagTitle),
                          textScaleFactor:
                              mediaQuery.textScaleFactor.clamp(1.0, 1.5),
                          style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600,
                              fontFamily:
                                  mediaQuery.boldText ? 'Yekan' : 'Yekan',
                              color: AppTheme.lightText),
                        ),
                      ],
                    ),
                  ),
                  AspectRatio(
                    aspectRatio: 2.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4.0)),
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: <Widget>[
                              Positioned.fill(
                                child: FancyShimmerImage(
                                  imageUrl:
                                      Globals.baseUrlShop + listData!.bannerUrl,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        colorFilter: ColorFilter.mode(
                                            Colors.black.withOpacity(0.0),
                                            BlendMode.darken),
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  errorWidget: Image.asset(
                                    'assets/images/image_not_available.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                // CachedNetworkImage(
                                //   imageUrl:
                                //       Globals.baseUrl + listData!.bannerUrl,
                                //   fit: BoxFit.fill,
                                //   imageBuilder: (context, imageProvider) =>
                                //       Container(
                                //     decoration: BoxDecoration(
                                //       image: DecorationImage(
                                //         image: imageProvider,
                                //         fit: BoxFit.fill,
                                //         // colorFilter:
                                //         // const ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                                //       ),
                                //     ),
                                //   ),
                                //   placeholder: (context, url) =>
                                //       JumpingDotsProgressIndicator(
                                //     fontSize: 35.0,
                                //     color: AppTheme.primarySwatch,
                                //   ),
                                //   errorWidget: (context, url, error) =>
                                //       const Icon(Icons.error),
                                // ),

                                // Image.network(
                                //   Globals.baseUrl + listData!.bannerUrl,
                                //   fit: BoxFit.fill,
                                //   loadingBuilder: (BuildContext context,
                                //       Widget child,
                                //       ImageChunkEvent? loadingProgress) {
                                //     if (loadingProgress == null) {
                                //       return child;
                                //     }
                                //     return Center(
                                //       child: CircularProgressIndicator(
                                //         value: loadingProgress
                                //                     .expectedTotalBytes !=
                                //                 null
                                //             ? loadingProgress
                                //                     .cumulativeBytesLoaded /
                                //                 loadingProgress
                                //                     .expectedTotalBytes!
                                //             : null,
                                //       ),
                                //     );
                                //   },
                                // ),

                                //   child: Image.network(
                                //     Globals.baseUrl + listData!.bannerUrl,
                                //     fit: BoxFit.fill,
                                //   ),
                                // ),
                                // Material(
                                //   color: Colors.transparent,
                                //   child: InkWell(
                                //     splashColor: Colors.grey.withOpacity(0.2),
                                //     borderRadius: const BorderRadius.all(
                                //         Radius.circular(4.0)),
                                //     onTap: callBack,
                                //   ),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  splashColor: Colors.grey.withOpacity(0.2),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4.0)),
                                  onTap: callBack,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// class AreaView extends StatelessWidget {
//   const AreaView({
//     Key? key,
//     this.imagepath,
//     this.animationController,
//     this.animation,
//   }) : super(key: key);
//
//   final String? imagepath;
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
//             child: Container(
//               decoration: BoxDecoration(
//                 color: MasterTheme.white,
//                 borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(8.0),
//                     bottomLeft: Radius.circular(8.0),
//                     bottomRight: Radius.circular(8.0),
//                     topRight: Radius.circular(8.0)),
//                 boxShadow: <BoxShadow>[
//                   BoxShadow(
//                       color: MasterTheme.grey.withOpacity(0.4),
//                       offset: const Offset(1.1, 1.1),
//                       blurRadius: 10.0),
//                 ],
//               ),
//               child: Material(
//                 color: Colors.transparent,
//                 child: InkWell(
//                   focusColor: Colors.transparent,
//                   highlightColor: Colors.transparent,
//                   hoverColor: Colors.transparent,
//                   borderRadius: const BorderRadius.all(Radius.circular(8.0)),
//                   splashColor: MasterTheme.nearlyDarkBlue.withOpacity(0.2),
//                   onTap: () {},
//                   child: Column(
//                     children: <Widget>[
//                       Padding(
//                         padding:
//                             const EdgeInsets.only(top: 16, left: 16, right: 16),
//                         child: Image.asset(imagepath!),
//                       ),
//                     ],
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
