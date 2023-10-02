import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_filter_dialog/flutter_filter_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:scroll_app_bar_2_0_0_custom_fix/scroll_app_bar.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sp_keyboard_shortcut_ns/sp_keyboard_shortcut_ns.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:collection/collection.dart';

import '../../../../public/public_functions.dart';
import '../../../../public/public_variables.dart';
import '../../../../themes/app_theme.dart';
import '../../../../themes/master_theme.dart';
import '../../../classes/ClsCategoryFull.dart';
import '../../../classes/ClsProductHead.dart';
import '../../../data_fetch.dart';
import '../../../views/header_widget_getx.dart';
import '../../../views/product_cat_item.dart';
import '../../../views/scroll_to_hide_widget_getx.dart';
import '../../../views/search_box.dart';
import '../../item_screen_2.dart';
import '../../item_screen_4.dart';
import '../../product_compare.dart';
import 'features_header.dart';
import 'keep_alive.dart';
import 'multi_page.dart';

class ProductCatView extends StatefulWidget {
  final String catId;
  final Function(int, int, String?) goToPage;
  final Function()? refreshMainMaster;
  final AnimationController? mainScreenAnimationController;
  final ScrollController mScrollController;

  ProductCatView(
      {Key? key,
      required this.catId,
      required this.goToPage,
      required this.mScrollController,
        this.refreshMainMaster,
        this.mainScreenAnimationController})
      : super(key: key);

  @override
  _ProductCatViewState createState() => _ProductCatViewState();
}

class _ProductCatViewState extends State<ProductCatView>
    with TickerProviderStateMixin {
  late final AnimationController _animateController = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..forward();
  late final Animation<double> _animation = CurvedAnimation(
    parent: _animateController,
    curve: Curves.easeIn,
  );
  AnimationController? animationController;

  List<ClsCategoryFull> data = [];
  late ClsCategoryFull catInfo;

  late final GetXCtrlHideWidget ctrl;
  late final GetXCtrlHideWidget ctrlHeader;

  final double _height = kBottomNavigationBarHeight;

  List<List<String>> mySelList = [];
  List<filterItem> myFilterList = [];

  bool resetDialog = false;

  bool _selectionMode = false;
  final List<int> _selectedIndexList = [];

  @override
  void initState() {
    // onLoad = true;
    Get.put(GetXCtrlHideWidget());
    ctrlHeader = Get.find();
    ctrlHeader.changeStatus(true, true);
    // widget.mScrollController.jumpTo(0);

    animationController = AnimationController(
        duration: const Duration(milliseconds: 2500), vsync: this);
    ctrl = Get.find();

    widget.mScrollController.appBar.setPinState(true);
    widget.mScrollController.addListener(() {
      widget.mScrollController.appBar.setPinState(false);
    });

    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    _animateController.dispose();
    super.dispose();
  }

  callback(newValue) {
    setState(() {
      widget.goToPage(4, 1, widget.catId);
    });
  }

  refreshList(List<List<String>?> mList) {
    setState(() {
      // ToastNormal(".......>> " + mList.toString());
    });
  }

  reload(String? productId2Progress){
    if(productId2Progress != null){
      data[0].prDs.firstWhere((element) => element.id == productId2Progress).inProgress = true;
      setState(() {});
    }else {
      fetchCategoryFull(widget.catId, true, true, true).then((value) {
        data = value;
        setState(() {});
        widget.refreshMainMaster!();
      });
    }
  }

  refreshFilterList(List<filterItem> list) {
    myFilterList = list;
    setState(() {
      // ToastNormal(".......>> " + mList.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyBoardShortcuts(
      globalShortcuts: true,
      child: Scaffold(
          backgroundColor: AppTheme.white,
          appBar: AppBar(
            leading: Container(),
            title: SearchBox(
              readOnly: true,
              atVoice: true,
              onTap: callback,
              focusNode: FocusNode(),
              onTextChange: (value) => () {},
            ),
          ),
          body: data.isEmpty
              ?     FutureBuilder<List<ClsCategoryFull>>(
            future: fetchCategoryFull(widget.catId, true, true, true),
            builder: (BuildContext context, snapshot) {
              ctrl.changeStatus(true, true);

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
                data = snapshot.data!;
                return thisBody();
              }
            },
          )
              : thisBody()),
    );
  }

  Widget thisBody() {
    catInfo = ClsCategoryFull.clone(data[0]);
    List<Spc> spCs = [];
    // spCs.add(Spc(spcCode: '101',spcTypeCode: 101, spcCatTitle: 'ترتیب نمایش',
    //     opTs: [],
    //     optIconCode: -1, storeCode: Globals.myStoreId, catGroup: '', optionCustomer: false,
    //     catTitle: '',catId: '', filter: true, ordLevel: -1, toHead: false));

    List<Opt> listOpt = [];
    List<double> listValues = [];

    catInfo.prDs.sort((a, b) {
      if (b.invFirst) {
        return 1;
      } else if (b.inCartHead > 0) {
        return 1;
      } else {
        return -1;
      }
    });

    catInfo.prDs.forEach((prd) {
      listValues.add(prd.price);
      listValues.add(prd.priceMax ?? 0);
      listValues.add(prd.priceMin ?? 0);
    });

    listValues.removeWhere((element) => element == 0);
    listValues.sort((a, b) => a.compareTo(b));

    listValues.forEach((element) {
      listOpt.add(Opt(
          doubleValue: element,
          id: '',
          optCode: '',
          optTitle: '',
          storeCode: '',
          parentCode: '',
          optIco: -1,
          img: -1,
          idMerge: '',
          spcCode: ''));
    });
    // listOpt.add(Opt(doubleValue: prd.price, id: '', optCode: '', optTitle: '', storeCode: '', parentCode: '', optIco: -1, img: -1, idMerge: '', spcCode: ''));
    // listOpt.add(Opt(doubleValue: prd.priceMin, id: '', optCode: '', optTitle: '', storeCode: '', parentCode: '', optIco: -1, img: -1, idMerge: '', spcCode: ''));
    // listOpt.add(Opt(doubleValue: prd.priceMax, id: '', optCode: '', optTitle: '', storeCode: '', parentCode: '', optIco: -1, img: -1, idMerge: '', spcCode: ''));

    spCs.addAll(catInfo.spCs.where((SPC) => SPC.filter));

    spCs.add(Spc(
        spcCode: '201',
        spcTypeCode: 201,
        spcCatTitle: 'نمایش کالاهای موجود',
        opTs: [],
        optIconCode: -1,
        storeCode: Globals.myStoreId,
        catGroup: '',
        optionCustomer: false,
        catTitle: '',
        catId: '',
        filter: true,
        ordLevel: -1,
        toHead: false));
    spCs.add(Spc(
        spcCode: '202',
        spcTypeCode: 202,
        spcCatTitle: 'نمایش کالاهای تخفیف دار',
        opTs: [],
        optIconCode: -1,
        storeCode: Globals.myStoreId,
        catGroup: '',
        optionCustomer: false,
        catTitle: '',
        catId: '',
        filter: true,
        ordLevel: -1,
        toHead: false));

    spCs.add(Spc(
        spcCode: '101',
        spcTypeCode: 101,
        spcCatTitle: 'محدوده قیمت',
        opTs: listOpt,
        optIconCode: -1,
        storeCode: Globals.myStoreId,
        catGroup: '',
        optionCustomer: false,
        catTitle: '',
        catId: '',
        filter: true,
        ordLevel: -1,
        toHead: false));

    catInfo.spCs.clear();
    catInfo.spCs = spCs;

    for (int i = 0; i < mySelList.length; i++) {
      if (mySelList[i].isNotEmpty && mySelList[i].length > 0) {
        // catInfo.prDs.removeWhere((element) => element.invFirst);
        List<String> selListElement = [];
        for (var element in mySelList[i]) {
          selListElement.add('$element^');
        }
        catInfo.prDs.removeWhere((product) => product.spcRep
            .where((spc) => spc.spcCode == catInfo.spCs[i].spcCode)
            .isEmpty);
        catInfo.prDs.removeWhere((product) => product.spcRep
            .firstWhere((spc) => spc.spcCode == catInfo.spCs[i].spcCode)
            .valueList
            .split(',')
            .where((element) => element.trim().isNotEmpty)
            .toList()
            .every((element) => !selListElement.contains(element.trim())));
      }
    }

    for (var filterItem in myFilterList) {
      if (filterItem.code == 101) {
        if (filterItem.id == 'up') {
          catInfo.prDs.removeWhere((product) =>
              product.price > filterItem.value &&
              (product.priceMin.isNull ||
                  (product.priceMin! > filterItem.value)) &&
              (product.priceMax.isNull ||
                  (product.priceMax! > filterItem.value)));
        }
        if (filterItem.id == 'low') {
          catInfo.prDs.removeWhere((product) =>
              product.price < filterItem.value &&
              (product.priceMax.isNull ||
                  (product.priceMax! < filterItem.value)) &&
              (product.priceMin.isNull ||
                  (product.priceMin! < filterItem.value)));
        }
      }
      if (filterItem.code == 201 && filterItem.value) {
        catInfo.prDs.removeWhere((product) => !product.invFirst);
      }
      if (filterItem.code == 202 && filterItem.value) {
        catInfo.prDs.removeWhere((product) => product.percentOff <= 0);
      }
    }

    void _changeSelection({required bool enable, required int index}) {
      _selectionMode = enable;
      _selectedIndexList.add(index);
      if (index == -1) {
        _selectedIndexList.clear();
      }
    }

    return Scaffold(
      appBar: ScrollAppBar(
        controller: widget.mScrollController,
        backgroundColor: Colors.transparent,
        title: headerFloat(catInfo.spCs),
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: InkWell(
                onTap: () async {
                  var result = await filterDialog.displayDialogOKCallBack(
                      context,
                      catInfo.spCs,
                      resetDialog,
                      mySelList,
                      myFilterList,
                      (mList) => refreshList(mList),
                      (mFilterList) => refreshFilterList(mFilterList),
                      animationController);
                  {
                    refreshList(result ?? []);
                  }
                },
                child: const DecoratedIcon(
                  Icons.sort,
                  color: Colors.black54,
                  shadows: [
                    BoxShadow(
                        blurStyle: BlurStyle.normal,
                        color: Colors.grey,
                        offset: Offset(3.0, 4.0),
                        blurRadius: 9.0),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectionMode = !_selectionMode;
                    List<ClsProductHead> mList = [];
                    // catInfo.prDs.forEach((element) {element.in});
                    catInfo.prDs.asMap().forEach((index, value) {
                      if (_selectedIndexList.contains(index)) {
                        mList.add(value);
                      }
                    });
                    if (_selectedIndexList.length > 1) {
                      Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            ProductCompare(mList),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return child;
                        },
                      ));
                    }
                    _selectedIndexList.clear();
                  });
                },
                child: DecoratedIcon(
                  Icons.compare,
                  color: _selectionMode ? Colors.blueAccent : Colors.black54,
                  shadows: const [
                    BoxShadow(
                        blurStyle: BlurStyle.normal,
                        color: Colors.grey,
                        offset: Offset(3.0, 4.0),
                        blurRadius: 9.0),
                  ],
                ),
              ),
            ),
          ),
        ],
        leadingWidth: 30.0,
        leading: Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () async {
                var result = await filterDialog.displayDialogOKCallBack(
                    context,
                    catInfo.spCs,
                    resetDialog,
                    mySelList,
                    myFilterList,
                    (mList) => refreshList(mList),
                    (mFilterList) => refreshFilterList(mFilterList),
                    animationController);
                {
                  refreshList(result ?? []);
                }
              },
              child: const DecoratedIcon(
                Icons.filter_list_outlined,
                color: Colors.black54,
                shadows: [
                  BoxShadow(
                      blurStyle: BlurStyle.normal,
                      color: Colors.grey,
                      offset: Offset(3.0, 4.0),
                      blurRadius: 9.0),
                ],
              ),
            )),
        // optionBar(widget.mScrollController, refreshList),
      ),
      body: Stack(
        children: [
          RawScrollbar(
              thumbColor: Colors.black45,
              radius: const Radius.circular(20),
              thickness: kIsWeb &&
                      (defaultTargetPlatform == TargetPlatform.windows ||
                          defaultTargetPlatform == TargetPlatform.linux)
                  ? 15
                  : 1,
              controller: widget.mScrollController,
              interactive: true,
              // isAlwaysShown: kIsWeb &&
              //     (defaultTargetPlatform == TargetPlatform.windows ||
              //         defaultTargetPlatform == TargetPlatform.linux),
              child: StaggeredGridView.countBuilder(
                padding: EdgeInsets.only(
                    left: 0.01.sw,
                    right: 0.01.sw,
                    top: 0.02.sh,
                    bottom: kBottomNavigationBarHeight),
                crossAxisCount: 4,
                scrollDirection: Axis.vertical,
                physics: const AlwaysScrollableScrollPhysics(),
                controller: widget.mScrollController,
                shrinkWrap: true,
                itemCount: catInfo.prDs.length,
                itemBuilder: (BuildContext context, int index) {
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animationController!,
                      curve: Interval((1 / catInfo.prDs.length) * index, 1.0,
                          curve: Curves.easeInOutQuint),
                    ),
                  );
                  animationController?.forward();
                  return Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: _selectedIndexList.contains(index)
                                  ? Colors.red.shade200
                                  : Colors.teal.shade50,
                              width: 1),
                          color: _selectedIndexList.contains(index)
                              ? Colors.red.shade50
                              : Colors.teal.shade50,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PrdCatItem(
                          goToPage: widget.goToPage,
                          reload: reload,
                          functionOnTap: () {
                            if (_selectionMode) {
                              setState(() {
                                if (_selectedIndexList.contains(index)) {
                                  _selectedIndexList.remove(index);
                                } else {
                                  _selectedIndexList.add(index);
                                }
                              });
                            } else {
                              reload(catInfo.prDs[index].id);
                              Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        ItemScreen2(
                                  mProductId: catInfo.prDs[index].id,
                                  goToPage: widget.goToPage,
                                ),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return child;
                                },
                              )).then((value) => reload(null));
                            }
                          },
                          prd: catInfo.prDs[index],
                          assetImage: 'assets/images/image_not_available.png',
                          animation: animation,
                          animationController: animationController!,
                        ),
                      ));
                },
                staggeredTileBuilder: (int index) => 1.sw < 1.sh
                    ? StaggeredTile.count(4, 2)
                    : StaggeredTile.count(2, 1),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
              )),
          // optionBar(widget.mScrollController, refreshList),
        ],
      ),
    );
  }

  Widget optionBar(
      ScrollController scrollController, Function(List<List<String>>) refresh) {
    // ScrollController scrollController = ScrollController();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: MasterTheme.grey.withOpacity(0.6),
              offset: const Offset(1.1, 1.1),
              blurRadius: 10.0),
        ],
      ),
      height: _height,
      width: double.infinity,
      child: headerFloat(catInfo.spCs),
    );
  }

  headerFloat(List<Spc> spCs) {
    AutoScrollController _scrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.horizontal);
    List<Widget> widgetOptions = [];
    for (int j = 0; j < spCs.length; j++) {
      widgetOptions.add(AutoScrollTag(
        key: ValueKey(j),
        controller: _scrollController,
        index: j,
        child: Padding(
          padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
          child: InkWell(
            onTap: () async {
              var result = await filterDialog.displayDialogOKCallBack(
                  context,
                  spCs,
                  resetDialog,
                  mySelList,
                  myFilterList,
                  (mList) => refreshList(mList),
                  (mFilterList) => refreshFilterList(mFilterList),
                  animationController);
              {
                refreshList(result ?? []);
              }
            },
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastLinearToSlowEaseIn,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                        blurStyle: BlurStyle.normal,
                        color: MasterTheme.grey,
                        offset: Offset(3.0, 3.0),
                        blurRadius: 2.0),
                  ],
                  // : const <BoxShadow>[
                  //     BoxShadow(
                  //         blurStyle: BlurStyle.normal,
                  //         color: MasterTheme.grey,
                  //         offset: Offset(3.0, 3.0),
                  //         blurRadius: 2.0),
                  //   ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                  ),
                  child: Text(
                    ReplaceEnglishChar(spCs[j].spcCatTitle),
                    style: const TextStyle(
                        fontFamily: 'Yekan',
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0,
                        letterSpacing: 0.0,
                        color: Colors.blueGrey
                        // MasterTheme.nearlyDarkBlue,
                        ),
                    textAlign: TextAlign.center,
                  ),
                )),
          ),
        ),
      ));
    }

    return Row(
      children: [
        Expanded(
          child: Container(
              // margin: EdgeInsets.symmetric(vertical: 0.0.sh),
              height: 50,
              child: ListView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                children: widgetOptions,
              )),
        ),
        // InkWell(
        //   onTap: () {
        //
        //   },
        //   child: const DecoratedIcon(
        //     Icons.compare,
        //     color: Colors.black54,
        //     shadows: [
        //       BoxShadow(
        //           blurStyle: BlurStyle.normal,
        //           color: Colors.grey,
        //           offset: Offset(3.0, 4.0),
        //           blurRadius: 9.0),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}

class filterDialog {
  static Future<List<List<String>>?> displayDialogOKCallBack(
      BuildContext context,
      List<Spc> _spCs,
      bool _reset,
      List<List<String>> _selList,
      List<filterItem> _myFilterList,
      Function(List<List<String>?>) callBackRefreshList,
      Function(List<filterItem>) callBackFilterList,
      AnimationController? animationController) async {
    return await showGeneralDialog(
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        // FeaturesMultiPage _featuresMultiPage;
        // List<List<String>?> _reSelList = [];
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 0.55.sh,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 50,
                      child: selListHorizontal(_selList, _spCs, (mList) {
                        _reset = true;
                        // _reSelList = (mList);
                        callBackRefreshList(mList);
                        setState(() {});
                      }, animationController),
                    ),
                    Column(
                      children: [
                        Container(
                          height: 0.55.sh - 50 - kBottomNavigationBarHeight,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(16),
                                  topLeft: Radius.circular(16))),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: FeaturesMultiPage(
                              ispCs: _spCs,
                              selList: _selList,
                              filterList: _myFilterList,
                              reset: _reset,
                              callBack: (mList) {
                                callBackRefreshList(mList);
                                setState(() {});
                              },
                              callBack2: (mFilterItem) {
                                callBackFilterList(mFilterItem);
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: kBottomNavigationBarHeight,
                          child: Container(
                            color: Colors.transparent,
                          ),
                          // Card(
                          //   child: Row(
                          //     children: [
                          //       MaterialButton(
                          //         color: Colors.blueAccent,
                          //         onPressed: () {
                          //           Navigator.of(context)
                          //               .pop(_featuresMultiPage.selList);
                          //         },
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          // child: ,
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }
}

Widget selListHorizontal(
    List<List<String>> selList,
    List<Spc> spCs,
    Function(List<List<String>?> list) callBack,
    AnimationController? animationController) {
  List<OptModel> selListElement = [];
  for (int i = 0; i < selList.length; i++) {
    if (selList[i].isNotEmpty) {
      for (int j = 0; j < selList[i].length; j++) {
        Opt mOpt = spCs[i]
            .opTs
            .firstWhere((element) => element.optCode == selList[i][j]);
        selListElement.add(OptModel(
            parent: spCs[i].spcCode,
            optTitle: mOpt.optTitle,
            optCode: mOpt.optCode));
      }
    }
  }
  return ListView.builder(
    padding: const EdgeInsets.only(top: 0, bottom: 0, right: 16, left: 16),
    itemCount: selListElement.length,
    scrollDirection: Axis.horizontal,
    itemBuilder: (BuildContext context, int index) {
      final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
          .animate(CurvedAnimation(
              parent: animationController!,
              curve: Interval((1 / selListElement.length) * index, 1.0,
                  curve: Curves.fastOutSlowIn)));
      animationController.forward();
      return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: animation,
            child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 50 * (1.0 - animation.value), 0.0),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 1.0, bottom: 10.0, left: 8.0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      selList[spCs.indexWhere((element) =>
                              element.spcCode == selListElement[index].parent)]
                          .removeWhere((element) =>
                              element == selListElement[index].optCode);
                      callBack(selList);
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(16.0),
                        ),
                        // boxShadow: <BoxShadow>[
                        //   BoxShadow(
                        //       color: MasterTheme.grey.withOpacity(0.2),
                        //       offset: Offset(1.1, 1.1),
                        //       blurRadius: 10.0),
                        // ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 4, right: 4),
                              child: Text(
                                ReplacePersianChar(
                                    selListElement[index].optTitle,
                                    withoutDigit: true),
                                style: const TextStyle(
                                    fontFamily: "Roboto", fontSize: 14),
                              ),
                            ),
                            const Icon(
                              Icons.clear,
                              size: 17,
                              color: Colors.grey,
                            )
                          ],
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
    },
  );
}

class OptModel {
  String parent;
  String optCode;
  String optTitle;

  OptModel({
    required this.parent,
    required this.optCode,
    required this.optTitle,
  });
}

// wSoFiList(List<Spc> spCs) {
//   ListView.builder(
//     itemCount: spCs.length,
//     scrollDirection: Axis.vertical,
//     itemBuilder: (context, i) {
//       return
//         filterItemHeader(spCs[i]);
//     },
//   );
// }
//
// filterItemHeader(Spc spC) {
//   List<S2Choice<String>> _choiceItems = [];
//   _choiceItems.add(S2Choice(value: 'AA', title: 'test'));
//   for(int i=0; i<spC.opTs.length; i++){
//     _choiceItems.add(S2Choice(value: spC.opTs[i].optCode, title: spC.opTs[i].optTitle));
//   }
//   List<String>? _selectedValue = [];
//
//   Container( color: Colors.redAccent, height: 100,
//     child: Column(
//       children: <Widget>[
//         const SizedBox(height: 7),
//         SmartSelect<String?>.multiple(
//           title: spC.spcCatTitle,
//           selectedValue: _selectedValue,
//           choiceItems: _choiceItems,
//           onChange: (selected) {},
//           // modalType: S2ModalType.bottomSheet,
//           // tileBuilder: (context, state) {
//           //   return S2Tile.fromState(
//           //     state,
//           //     isTwoLine: true,
//           //     leading: Container(
//           //       width: 40,
//           //       alignment: Alignment.center,
//           //       child: const Icon(Icons.shopping_cart),
//           //     ),
//           //   );
//           // },
//         ),
//         const Divider(indent: 20),
//       ],
//     ),
//   );
// }
