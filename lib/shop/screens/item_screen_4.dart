import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marquee/marquee.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:http/http.dart' as http;
import '../../public/public_functions.dart';
import '../../public/public_variables.dart';
import '../../themes/app_theme.dart';
import '../../themes/master_theme.dart';
import '../classes/ClsProductHead.dart';
import '../data_fetch.dart';
import '../views/carouselproductslist.dart';

class ItemScreen4 extends StatefulWidget {
  final String mProductId;
  final Function(int, int, String?)? goToPage;

  const ItemScreen4({Key? key,
    required this.mProductId,
    this.goToPage,
  }) : super(key: key);

  @override
  _ItemScreen4State createState() => _ItemScreen4State();
}

class _ItemScreen4State extends State<ItemScreen4> {
  // AlignmentGeometry _alignment = Alignment.topLeft;
  // List<String> homeHero = [];
  List<String> homeUrls = [];
  List<Widget> widgetProperties = [];

  // late ClsProductHead mProduct;

  late String vTxtSubTitle;
  late double vTxtPrice;
  late double vTxtOff;
  late bool inState;

  // late List<ClsSpcCatFull> mSPCsOptionList;

  late Future<List<ClsProductHead>> _getDate;

  late List<ClsSpcCatFull> mListSPCsOption;
  late List<ClsSpcCatFull> mListSPCsOther;
  late List<ClsProductInfo> MyLstPrd;
  late ClsProductHead myProduct;
  late ClsProductInfo mItemProduct = ClsProductInfo();
  static const scrollDirection = Axis.horizontal;
  late final List<AutoScrollController> _scrollController = [];

  // late final List<ScrollController> _scrollController = [] ;

  @override
  void initState() {
    // _getDate = fetchProduct(widget.mProductId);
    super.initState();
    inState = true;
    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   refSelect(setSelect(0, 0), inState);
    //   setState(() {});
    // });
    // setState(() {
    //   _alignment = _alignment == Alignment.topLeft
    //       ? Alignment.bottomRight
    //       : _alignment = Alignment.topLeft;
    // });
  }

  @override
  Widget build(BuildContext context) {
    double _hi = MediaQuery.of(context).size.height;
    double radius = 40;
    // ScreenUtil.init(
    //   BoxConstraints(
    //       maxHeight: MediaQuery.of(context).size.height,
    //       maxWidth: MediaQuery.of(context).size.width),
    //   // designSize: const Size(360, 690),
    // );
    return Scaffold(
      backgroundColor: Colors.pink[100]?.withOpacity(0.9),
      body: SafeArea(
        child: FutureBuilder<List<ClsProductHead>>(
          future: fetchProduct(widget.mProductId),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting && inState) {
              return Center(
                child: JumpingDotsProgressIndicator(
                  fontSize: 35.0,
                  color: AppTheme.primarySwatch,
                ),
              );
            }
            // } else {
              if (snapshot.hasError) {
                  if (snapshot.error == 403) {
                    fetchToken(context,
                        false,
                        Globals.myTypeID,
                        Globals.myStoreId,
                        Globals.myMemberId,
                        Globals.myNetIP,
                        Globals.myDeviceId,
                        Globals.myAppVersion,
                        Globals.myPassword)
                      .whenComplete(() => setState(() {}));
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
                            child: Text('${'دوباره سعی کنید \n دریافت اطلاعات با مشکل مواجه شد [${snapshot.error}'}]')),
                        const SizedBox(height: 20,),
                      ],
                    ),
                  );
                }
              } else {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: SizedBox(child: Text('data is empty!')));
                } else if (inState) {
                  myProduct = snapshot.data![0];
                  homeUrls.clear();
                  for (int i = 0; i < myProduct.images.length; i++) {
                    homeUrls.add(Globals.baseUrlShop +
                        myProduct.images[i].serverUrl.toString());
                  }
                  mListSPCsOption = myProduct.spCs.where((element) =>
                          element.optionCustomer && element.lstOpt.length > 1)
                      .toList();
                  mListSPCsOther = myProduct.spCs.where((element) =>
                          !element.optionCustomer || element.lstOpt.length == 1)
                      .toList();

                  // SetPropertiesNew(myProduct.SPCs);
                  MyLstPrd = myProduct.opTs;

                  if (MyLstPrd.length == 1 || mListSPCsOption.isEmpty) {
                    mItemProduct = MyLstPrd[0];
                  }
                  // if (inState) {
                  //   RefSelect(SetSelect(0, 0, 0));
                  inState = false;
                  // }
                }

                return SizedBox(
                  width: 1.sw,
                  height: 1.sh,
                  child: Stack(
                    children: [
                      AnimatedAlign(
                        duration: const Duration(milliseconds: 3000),
                        curve: Curves.elasticIn,
                        alignment: Alignment.topCenter,
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppTheme.statusBarColor,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(radius),
                                  bottomRight: Radius.circular(radius))),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 0.01.sh),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        bottom: .01.sh,
                                        left: 0.05.sw,
                                        right: 0.05.sw),
                                    child: const Icon(
                                      Icons.favorite_outline,
                                      size: 20,
                                      color: AppTheme.statusBarWidgetColor,
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: Text(
                                  //     ReplacePersianChar(myProduct.Title),
                                  //     maxLines: 1,
                                  //     // overflow: TextOverflow.ellipsis,
                                  //     style: Theme.of(context)
                                  //         .textTheme
                                  //         .subtitle1
                                  //         ?.copyWith(
                                  //           fontWeight: FontWeight.normal,
                                  //           fontFamily: 'Yekan',
                                  //           color: AppTheme.statusBarWidgetColor,
                                  //         ),
                                  //   ),
                                  // ),

                                  Flexible(
                                    child: Text(
                                      ReplacePersianChar(myProduct.title),
                                      textDirection: TextDirection.rtl,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          ?.copyWith(
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Yekan',
                                            color:
                                                AppTheme.statusBarWidgetColor,
                                          ),
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.only(
                                        bottom: .01.sh,
                                        left: 0.05.sw,
                                        right: 0.05.sw),
                                    child: const Icon(
                                      Icons.shopping_cart_outlined,
                                      size: 20,
                                      color: AppTheme.statusBarWidgetColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          color: Colors.transparent,
                          width: 1.sw,
                          height: _hi / 2,
                          child: Center(
                            child: CarouselProductsList(
                              height: _hi / 2,
                              topPadding: _hi * 0.14,
                              btnPadding: _hi * 0.02,
                              boxFit: BoxFit.fill,
                              productsUrls: homeUrls,
                              type: CarouselTypes.home,
                              assetImage: 'assets/images/image_not_available.png',
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.only(top: 15),
                          width: 1.sw,
                          height: _hi / 2,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(radius),
                                  topRight: Radius.circular(radius))),
                          child: SingleChildScrollView(
                            child: Column(
                              children:
                                  // ListView(
                                  //   shrinkWrap: true,
                                  createOptionView(),
                              // ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          width: 1.sw,
                          height: 0.08.sh,
                          decoration: BoxDecoration(
                              color: AppTheme.statusBarColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(radius),
                                  topRight: Radius.circular(radius))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [

                              mItemProduct.netRec >= 0 || myProduct.priceMin == myProduct.priceMax ?
                              spTextPrice(context, mItemProduct.price,
                                  format: Globals.storePriceFormat,
                                  mStyle: const TextStyle(
                                      color: Colors.white, fontSize: 14))
                                  :
                              Row(
                                children: [
                                  spTextPrice(context, myProduct.priceMin?? 0,
                                      format: Globals.storePriceFormat,
                                      mStyle: const TextStyle(
                                          color: Colors.white, fontSize: 14)),
                                  const Text('~'),
                                  spTextPrice(context, myProduct.priceMax?? 0,
                                      format: Globals.storePriceFormat,
                                      mStyle: const TextStyle(
                                          color: Colors.white, fontSize: 14)),
                                ],
                              ),

                              // Container(
                              //   child: Text(
                              //     mItemProduct.netRec >= 0
                              //         ? priceString(mItemProduct.price)
                              //         : myProduct.priceMin != myProduct.priceMax
                              //             ? priceString(myProduct.priceMin) +
                              //                 '~' +
                              //                 priceString(myProduct.priceMax)
                              //             : priceString(mItemProduct.price),
                              //     style: const TextStyle(
                              //       color: AppTheme.statusBarWidgetColor,
                              //       fontSize: 16,
                              //     ),
                              //   ),
                              // ),
                              mItemProduct.netRec < 0
                                  ? Container()
                                  : InkWell(
                                onTap: () {
                                  // setCartex(mItemProduct);
                                  setCartex(mItemProduct, true).then((value) {
                                    if(value.statusCode == 200) {
                                      reloadCart(context, false).then((v) {
                                        refreshCart(context, v);
                                        setState(() {});
                                        widget.goToPage!(1, 1, '');
                                      });
                                    }
                                  }
                                  );
                                },
                                child: Container(
                                  height: 0.05.sh,
                                  child: Center(
                                      child: Text(
                                        mItemProduct.title,
                                        style: const TextStyle(
                                            fontSize: 10,
                                            color: AppTheme.statusBarWidgetColor),
                                      )),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50),
                                  decoration: BoxDecoration(
                                      color: Colors.black38,
                                      borderRadius:
                                      BorderRadius.circular(10)),
                                ),
                              ),
                              Container(
                                child: Text(
                                  mItemProduct.netRec < 0
                                      ? (myProduct.invIs ? '' : 'موجود نیست')
                                      : mItemProduct.invAvailable > 0 ? priceString(mItemProduct.invAvailable) : "",
                                  style: const TextStyle(
                                    color: AppTheme.statusBarWidgetColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            // }
          },
        ),
      ),
    );
  }

  Future<http.Response> setCartex(ClsProductInfo itemProduct, bool firstSel) async {
    if((firstSel && itemProduct.invFirst) || (!firstSel && itemProduct.invAdd)) {
      if (Globals.currentCart.length == 0) {
        Globals.TmpCartex.ValidateCD = Globals.myToken;
      } else {
        Globals.TmpCartex.ValidateCD = Globals.currentCart[0].ValidateCD;
        Globals.TmpCartex.CartexId = Globals.currentCart[0].CartId;
      }
      Globals.TmpCartex.NewAmount = (Globals.TmpCartex.Amount! + itemProduct.selJump);

      return postCart(context, Globals.TmpCartex, false);
    }else{
      // ToastNormal("موجود نیست");
      return http.Response('Fail', 500);
    }
  }

  List<Widget> createOptionView() {
    widgetProperties.clear();
    widgetProperties.add(const SizedBox(height: 7.5));
    if (mListSPCsOption.isNotEmpty) {
      for (int i = 0; i < mListSPCsOption.length; i++) {
        // if (mListSPCsOption[i].OptionCustomer && mListSPCsOption[i].LstOpt.length > 1) {
        List<Widget> widgetOptions = [];
        _scrollController.add(AutoScrollController(
            viewportBoundaryGetter: () =>
                Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
            axis: scrollDirection));
        for (int j = 0; j < mListSPCsOption[i].lstOpt.length; j++) {
          // mListSPCsOption[i].LstOpt[j].Disabled = false;
          // widgetOptions[0].runtimeType()
          widgetOptions.add(AutoScrollTag(
            key: ValueKey(j),
            controller: _scrollController[i],
            index: j,
            child: Padding(
              padding: EdgeInsets.only(
                  right: 0.02.sw, top: 0.01.sh, bottom: 0.01.sh),
              child: InkWell(
                onTap: () {
                  SetSelect(i, j);
                  setState(() {});
                },
                // setSelect2(mListSPCsOption, i, i, j),
                // RefSelect(SetSelect(i, j)),

                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastLinearToSlowEaseIn,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      // mListSPCsOption[i].LstOpt[j].Disabled
                      //     ? Colors.grey
                      //     : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      // border: j == mListSPCsOption[i].SelOpt
                      //     ? Border.all(color: Colors.orangeAccent)
                      //     : Border.all(color: Colors.white),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            blurStyle: BlurStyle.normal,
                            color: j == mListSPCsOption[i].selOpt
                                ? Colors.deepOrange
                                : MasterTheme.grey,
                            offset: const Offset(3.0, 3.0),
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
                        ReplaceEnglishChar(
                            mListSPCsOption[i].lstOpt[j].optTitle),
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                          letterSpacing: 0.0,
                          color: mListSPCsOption[i].lstOpt[j].disable
                              ? Colors.grey
                              : MasterTheme.nearlyDarkBlue,
                          // MasterTheme.nearlyDarkBlue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )),
              ),
            ),
          ));
        }
        widgetProperties.add(
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: SizedBox(
                  // width: 0.11.sw,
                  child: Text(
                    '${ReplacePersianChar(mListSPCsOption[i].spcCatTitle)} : ',
                    style: const TextStyle(
                      fontFamily: 'Yekan2',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      letterSpacing: 0.0,
                      color: MasterTheme.nearlyDarkBlue,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                    // margin: EdgeInsets.symmetric(vertical: 0.0.sh),
                    height: 50,
                    child: ListView(
                      controller: _scrollController[i],
                      scrollDirection: scrollDirection,
                      children: widgetOptions,
                    )),
              ),
            ],
          ),
        );
        // }
      }
      // if (inState) {
      //   refSelect(setSelect(0, 0), inState);
      //   inState = false;
      // }
    }
    if (mListSPCsOther.isNotEmpty) {
      for (int i = 0; i < mListSPCsOther.length; i++) {
        widgetProperties.add(
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: SizedBox(
                    child: Text(
                      '${ReplacePersianChar(mListSPCsOther[i].spcCatTitle)} : ',
                      style: const TextStyle(
                        fontFamily: 'Yekan2',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        letterSpacing: 0.0,
                        color: MasterTheme.nearlyDarkBlue,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    mListSPCsOther[i].optionCustomer
                        ? ReplacePersianChar(
                            mListSPCsOther[i].lstOpt[0].optTitle)
                        : ReplacePersianChar(mListSPCsOther[i].spcStrValue),
                    style: const TextStyle(
                      fontFamily: 'Yekan',
                      fontSize: 14,
                      letterSpacing: 0.0,
                      color: Colors.blueGrey,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
    return widgetProperties;
  }

//   RefSelect(List<arrayModel> cSelect) {
//     List<ClsProductInfo> MyProduct = [];
//     if (cSelect.isNotEmpty) {
//       //TODO-> Get All Products IDs as List_string
//       List<String> retFnd = [];
//       MyLstPrd.forEach((clsProductInfo) {
//         retFnd.add(clsProductInfo.ID);
//       });
//       //TODO-> Retain ProductsIDs With selected option(s) products
//       cSelect.forEach((mLst) {
//         if (mLst.list.isNotEmpty) {
//           retFnd.retainWhere((element) => mLst.list.contains(element));
//         }
//       });
//
//       // for (List<String> mLst : cSelect) {
//       //   if (mLst != null && mLst.size() > 0)
//       //     retFnd.retainAll(mLst);
//       // }
//       if (retFnd.length == 1) {
//         int i = 0;
//         while (MyProduct.isEmpty && i < MyLstPrd.length) {
//           ClsProductInfo clsProductInfo = MyLstPrd[1];
//           if (clsProductInfo.ID == retFnd[0]) {
//             MyProduct.add(clsProductInfo);
//           }
//           i++;
//         }
//       }
//     } else {
//       if (MyLstPrd.isNotEmpty) {
//         MyProduct.add(MyLstPrd[0]);
//       }
//     }
//
//     //TODO:>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Manage slider [Slide to current id image] >>> Change slider
//     //TODO:-----------------------------------------------------------------------------------------------------
//     //TODO:-----------------------------------------------------------------------------------------------------
//     //TODO:-----------------------------------------------------------------------------------------------------
// //        ImageGallery MyProductImages = myProduct.getImages().where().equalTo(ImageGallery.Fld_LinkId, MyProduct.getID()).findFirst();
// //        if(MyProductImages != null) {
// //            defaultSliderViews.
// //            vSliderLayout.slider
// //
// //        }
//     if (MyProduct == null && MyLstPrd != null && MyLstPrd.length > 0)
//       MyProduct.add(MyLstPrd[0]);
//     if (MyProduct != null) {
// //       SetPersianText(vTxtSubTitle, "(" + MyProduct.getID() + ") " + MyProduct.getTitle(), TF_BNazanin);
// //       SetPriceText(vTxtPrice, MyProduct.getPrice(), null, true, true);
// //       vTxtPriceTmp.setPaintFlags(vTxtPriceTmp.getPaintFlags() | Paint.STRIKE_THRU_TEXT_FLAG);
// //       if (MyProduct.getPercentOff() > 0) {
// //         vTxtOff.setVisibility(View.VISIBLE);
// //         String tOff = String.valueOf(MyProduct.getPercentOff());
// //         if (MyProduct.getPercentOff() == (int) MyProduct.getPercentOff())
// //     tOff = String.valueOf((int) MyProduct.getPercentOff());
// //     vTxtOff.setText(tOff + "%");
// //     SetPriceText(vTxtInventory, MyProduct.getInvAvailable(), null, true, true);
// // //            double offPrice = GetRound(MyProduct.getPrice() - ((MyProduct.getPercentOff() * MyProduct.getPrice()) / 100), ConfigCountRound);
// //     SetPriceText(vTxtPrice, MyProduct.offPrice(), null, true, true);
// //     vTxtPriceTmp.setVisibility(View.VISIBLE);
// //     SetPriceText(vTxtPriceTmp, MyProduct.getPrice(), null, false, true);
// //     } else {
// //     vTxtOff.setVisibility(View.GONE);
// //     vTxtPriceTmp.setVisibility(View.GONE);
// //     }
// //
// //     SetTmpCartex(myProduct, MyProduct);
// //     } else
// //     Toast.makeText(ItemActivity.this, "Fail : [ اطلاعات کالا دریافت نشد] ", Toast.LENGTH_SHORT).show();
//
//     }
//   }

  void SetSelect(int parent, int element) {
    // List<arrayModel> ListOpts = [];
    if (mListSPCsOption.isNotEmpty) {
      mListSPCsOption[parent].lstOpt[element].disable = false;
      mListSPCsOption[parent].selOpt = element;
      _scrollToCounter(parent, element);
      List<String> myLstPrd = mListSPCsOption[parent].lstOpt[element].lstPrd;
      List<ArrayModel> mListOpts = GetLstPrdSel(myLstPrd);
      List<ArrayModel> mShift = [];
      for (int iParent = 0; iParent < mListSPCsOption.length; iParent++) {
        if (iParent != parent) {
          int mSetShift = -1;
          List<ClsPrdSpcOpt> clsPrdSpcOptList = mListSPCsOption[iParent].lstOpt;
          for (int iElement = 0;
              iElement < clsPrdSpcOptList.length;
              iElement++) {
            ClsPrdSpcOpt clsPrdSpcOpt = clsPrdSpcOptList[iElement];
            if (CheckIsNotInPrd(mListOpts, iParent, clsPrdSpcOpt.lstPrd)) {
              clsPrdSpcOpt.disable = true;
              int mSelOpt = mListSPCsOption[iParent].selOpt;
              if (mSelOpt != null && mSelOpt == iElement) mSetShift = mSelOpt;
            } else {
              clsPrdSpcOpt.disable = false;
            }
          }
          if (mSetShift >= 0) mShift.add(ArrayModel(iParent, mSetShift, []));
          // ShiftSelection(iParent, mSetShift);
        }
      }
      for (int i = 0; i < mShift.length; i++) {
        ShiftSelection(mShift[i].code, mShift[i].selOpt);
      }
      findSelectedItem(GetLstPrdSel(myLstPrd));
      // ListOpts = GetLstPrdSel();
      // notifyDataSetChanged(); ??????????????????????
    }
    // return ListOpts;
  }

  //TODO: Get a list of list_string(list of product id) of select item in all groups
  List<ArrayModel> GetLstPrdSel(List<String> myLstPrd) {
    List<ArrayModel> lstRet = [];
    for (int i = 0; i < mListSPCsOption.length; i++) {
      ClsSpcCatFull clsSpcCatFull = mListSPCsOption[i];
      int mSel = clsSpcCatFull.selOpt;
      int j = -1;
      while (mSel < 0 || mSel >= clsSpcCatFull.lstOpt.length) {
        j++;
        // SetSelect(i, 0);
        List<String> thisLstPrd = [];
        thisLstPrd.addAll(mListSPCsOption[i].lstOpt[j].lstPrd);
        thisLstPrd.retainWhere((element) => myLstPrd.contains(element));
        if (thisLstPrd.isNotEmpty) {
          mSel = j;
          _scrollToCounter(i, j);
          // _scrollController[i].animateTo(_scrollController[i].offset + j, duration: const Duration(milliseconds: 700), curve: Curves.easeOut);
        }
      }
      if (mSel >= 0) {
        clsSpcCatFull.selOpt = mSel;
        lstRet.add(ArrayModel(
            i, clsSpcCatFull.selOpt, clsSpcCatFull.lstOpt[mSel].lstPrd));
      } else {
        lstRet.add(ArrayModel(i, -1, []));
      }
    }
    return lstRet;
  }

  bool CheckIsNotInPrd(
      List<ArrayModel> listMSt, int iParent, List<String> lstPrd) {
    if (listMSt != null && listMSt.length > 0) {
      for (int i = 0; i < listMSt.length; i++) {
        if (i != iParent && listMSt[i] != null) {
          List<String> mStP = [];
          mStP.addAll(listMSt[i].list);
          // mStP.retainAll(lstPrd);
          mStP.retainWhere((element) => lstPrd.contains(element));
          if (mStP.length == 0) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void ShiftSelection(int iParent, int iElement) {
    ClsSpcCatFull clsSpcCatFull = mListSPCsOption[iParent];
    clsSpcCatFull.selOpt = -1;
    int iCounter = iElement + 1;
    if (iCounter >= clsSpcCatFull.lstOpt.length) iCounter = 0;
    if (clsSpcCatFull.lstOpt.isNotEmpty) {
      while (clsSpcCatFull.selOpt < 0 && iCounter != iElement) {
        if (!clsSpcCatFull.lstOpt[iCounter].disable)
          SetSelect(iParent, iCounter);
        iCounter++;
        if (iCounter >= clsSpcCatFull.lstOpt.length) iCounter = 0;
      }
    }
    if (iCounter == iElement && clsSpcCatFull.selOpt < 0) {
      SetSelect(0, 0);
      // Toast.makeText(App.getContext(), R.string.SelOtherOptions, Toast.LENGTH_LONG).show();
    }

//            Toast.makeText(App.getContext(), R.string.CanNotSelected+" Paren: "+iParent+"  element: "+iElement, Toast.LENGTH_SHORT).show();
  }

  void selPosition(int i, int j) {
    mListSPCsOption[i].lstOpt[j].disable = false;
    mListSPCsOption[i].selOpt = j;
    double itemPosition = (_scrollController[i].position.maxScrollExtent /
            mListSPCsOption[i].lstOpt.length) *
        j;
    itemPosition = 1.sw / 2 > itemPosition
        ? itemPosition - 1.sw / 2
        : itemPosition + 1.sw / 2;
    _scrollController[i].animateTo(itemPosition,
        duration: const Duration(milliseconds: 700), curve: Curves.easeOut);
  }

  Future _scrollToCounter(int i, int j) async {
    await _scrollController[i]
        .scrollToIndex(j, preferPosition: AutoScrollPosition.middle);
    _scrollController[i].highlight(j);
    mListSPCsOption[i].lstOpt[j].disable = false;
    mListSPCsOption[i].selOpt = j;
  }

  void findSelectedItem(List<ArrayModel> mLstPrdSel) {
    List<String> mRet = [];
    for (int i = 0; i < mLstPrdSel.length; i++) {
      mListSPCsOption[i].selOpt = mLstPrdSel[i].selOpt;
      if (i == 0) {
        mRet.addAll(mLstPrdSel[i].list);
      } else {
        mRet.retainWhere((element) => mLstPrdSel[i].list.contains(element));
      }
    }
    switch (mRet.length) {
      case 0:
        mItemProduct = ClsProductInfo();
        ToastNormal('هیچ کدی با گزینه های انتخابی هماهنگ نیست', context);
        break;
      case 1:
        mItemProduct =
            myProduct.opTs.firstWhere((element) => element.id == mRet[0]);

        break;
      default:
        mItemProduct = ClsProductInfo();
        ToastNormal('گزینه های انتخابی را بازنگری نمایید', context);
        break;
    }
    setState(() {});
  }
}
