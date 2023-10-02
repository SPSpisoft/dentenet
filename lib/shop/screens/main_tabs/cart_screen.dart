import 'package:cached_network_image/cached_network_image.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:spflutter_number_picker/spflutter_number_picker.dart';

import '../../../public/public_functions.dart';
import '../../../public/public_variables.dart';
import '../../../themes/app_theme.dart';
import '../../../themes/master_theme.dart';
import '../../classes/ClsCart.dart';
import '../../classes/ClsCartDetail.dart';
import '../../classes/ClsProductHead.dart';
import '../../classes/ClsStore.dart';
import '../../classes/ClsTags.dart';
import '../../data_fetch.dart';
import '../../data_set.dart';
import '../../views/pulsing_button.dart';
import '../../views/search_box.dart';
import '../item_screen_2.dart';
import 'home_screen.dart';

class CartScreen extends StatefulWidget {
  final Function(List<String>?, int?) goToSearch;
  final Function()? refreshMainMaster;
  final Function(int, int, String?)? goToPage;

  const CartScreen({
    Key? key,
    required this.goToSearch,
    this.refreshMainMaster,
    this.goToPage
  }) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin {
  AnimationController? animationController;
  final ScrollController _controller = ScrollController();

  List<ClsCartDetail> homeList = [];

  callback(callTypeCode) {
    setState(() {
      widget.goToSearch([], callTypeCode);
    });
  }

  @override
  void initState() {
    fetchToken(context,
        true,
        Globals.myTypeID,
        Globals.myStoreId,
        Globals.myMemberId.trim(),
        Globals.myNetIP,
        Globals.myDeviceId,
        Globals.myAppVersion,
        Globals.myPassword);
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SafeArea(
          child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: RawScrollbar(
              thumbColor: Colors.black45,
              radius: const Radius.circular(20),
              thickness: kIsWeb &&
                      (defaultTargetPlatform == TargetPlatform.windows ||
                          defaultTargetPlatform == TargetPlatform.linux)
                  ? 15
                  : 1,
              controller: _controller,
              // isAlwaysShown: kIsWeb &&
              //     (defaultTargetPlatform == TargetPlatform.windows ||
              //         defaultTargetPlatform == TargetPlatform.linux),
              child: CustomScrollView(
                controller: _controller,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 1.sw > 1.sh ? 0.2.sw : 0.2.sh,
                    collapsedHeight: 1,
                    toolbarHeight: 1,
                    backgroundColor: AppTheme.statusBarColor,
                    shadowColor: Colors.transparent,
                    stretch: true,
                    centerTitle: true,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      stretchModes: const [
                        StretchMode.fadeTitle,
                        StretchMode.zoomBackground
                      ],
                      background: FutureBuilder<List<ClsCart>>(
                          future: Globals.futureCurrentCart,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Container(
                                decoration: const BoxDecoration(
                                  color: AppTheme.screenColor,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 0.1.sw,
                                      right: 0.1.sw,
                                      bottom: 0.02.sh),
                                  child: Center(
                                    child: JumpingDotsProgressIndicator(
                                      fontSize: 35.0,
                                      color: AppTheme.primarySwatch,
                                    ),
                                  ),
                                ),
                              );
                            }
                            else if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data!.isNotEmpty)
                            {
                              // if (snapshot.hasData &&
                              //     snapshot.data!.isNotEmpty) {
                                ClsCart clsCart = snapshot.data![0];
                                return Container(
                                  decoration: const BoxDecoration(
                                    color: AppTheme.screenColor,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 0.1.sw,
                                        right: 0.1.sw,
                                        bottom: 0.02.sh),
                                    // const EdgeInsets.fromLTRB(30, 100, 30, 0),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              priceString(clsCart.TotalPrice)),
                                        ),
                                        Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Row(
                                              children: [
                                                IconButton(onPressed: (){
                                                  changeCartStatus(
                                                      Globals.currentCart[0]
                                                          .CartId,
                                                      CartTypeEnum.cartCanceled)
                                                      .then((value) {
                                                    if (value == 200) {
                                                      // loadOpenCart();
                                                      reloadCart(context, true).whenComplete(() {
                                                        setState(() {});
                                                        widget.goToPage!(1,1,'');
                                                      });
                                                    } else {
                                                      ToastNormal(
                                                          "Refresh Cart $value", context, type: 0);
                                                    }
                                                  });
                                                }, icon: const Icon(Icons.delete, color: Colors.redAccent, size: 30,)),
                                                CupertinoButton(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.lightGreen,
                                                  onPressed: () {
                                                    changeCartStatus(
                                                            Globals.currentCart[0]
                                                                .CartId,
                                                            CartTypeEnum.cartClosed)
                                                        .then((value) {
                                                      if (value == 200) {
                                                        // loadOpenCart();
                                                        reloadCart(context, true).whenComplete(() {
                                                          setState(() {});
                                                          widget.goToPage!(1,1,'');
                                                        });
                                                      } else {
                                                        ToastNormal(
                                                            "Refresh Cart $value", context, type: 0);
                                                      }
                                                    });
                                                    //     onError: (){
                                                    //   ToastNormal("Error ");
                                                    // });
                                                  },
                                                  child: const Text("ثبت و ارسال"),
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ),
                                );
                              // } else {
                              //   return Container();
                              }
                            return Container(
                              decoration: const BoxDecoration(
                                color: AppTheme.screenColor,
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 0.1.sw,
                                    right: 0.1.sw,
                                    bottom: 0.02.sh),
                                child: const Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Text("سبد خرید خالیست!", style: TextStyle(color: Colors.blueGrey, fontFamily: 'Yekan2', fontWeight: FontWeight.w500)),),
                              ),
                            );
                          }),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // Text('تست فارسی'),
                        // FutureBuilder<bool>(
                        FutureBuilder<List<ClsCart>>(
                          // future: getData(),
                          future: Globals.futureCurrentCart,
                          builder: (BuildContext context, snapshot) {
                            if (!snapshot.hasData) {
                              return Align(
                                alignment: Alignment.center,
                                child:
                                Image.asset('assets/images/cart_empty.png', fit: BoxFit.none),);
                            } else {
                              if (snapshot.hasData &&
                                  snapshot.data!.isNotEmpty) {
                                homeList = snapshot.data![0].CartDetails;
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
                                      return CartRowView(
                                        cartDetail: homeList[index],
                                        animation: animation,
                                        animationController:
                                            animationController,
                                      );
                                    }),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 60,
            child: Container(),
          ),
        ],
      )),
    );
  }

  Widget CartRowView(
      {required ClsCartDetail cartDetail,
      Animation<double>? animation,
      AnimationController? animationController}) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        String _ratCount = '0';
        String _rat = '0.0';
        String price = priceString(cartDetail.Price);
        String totalRowPrice = priceString(cartDetail.PriceTotal > 0
            ? cartDetail.PriceTotal
            : cartDetail.Price * cartDetail.Amount);
        String amount = cartDetail.Amount.toString();
        String unit = cartDetail.UnitNet ?? "--";

        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: InkWell(
                onLongPress: (){
                  Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        ItemScreen2(
                            mProductId: cartDetail.IDMerge.isNotEmpty? cartDetail.IDMerge : cartDetail.PrdCode,
                            goToPage: widget.goToPage, idSelect: cartDetail.PrdCode,
                            callBack: (){
                              Future.delayed(Duration.zero, () async {
                                setState(() {});
                              });
                        }),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return child;
                    },
                  ));

                },
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
                      onTap: () {},
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 12, left: 8, top: 8),
                                    child: Column(mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ReplacePersianChar(cartDetail.Title),
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontFamily: 'Yekan',
                                            fontSize: 13.0,
                                          ),
                                        ),
                                        const SizedBox(height: 30,),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  height: 35, width: 80,
                                                  child: NumberPicker(
                                                      theme: NumberSelectionTheme(
                                                          draggableCircleColor: Colors.blue,
                                                          iconsColor: Colors.white,
                                                          numberColor: Colors.white,
                                                          iconsDisableColor: Colors.grey,
                                                          backgroundColor:
                                                          Colors.deepPurpleAccent,
                                                          outOfConstraintsColor:
                                                          Colors.deepOrange),
                                                      iconMin: Icons.delete,
                                                      iconEmpty: Icons.add_shopping_cart,
                                                      progressWidth: 4,
                                                    resetValue: cartDetail.Amount,
                                                      intCheck: true,
                                                      direction: Axis.horizontal,
                                                      withSpring: true,
                                                      callOnSet: (val) async {
                                                        NumberPicker myNumberPicker = NumberPicker();
                                                        await fetchProductInfo(
                                                            cartDetail.PrdCode).then((
                                                            myProduct) {
                                                          ClsProductInfo mItemProduct = myProduct;
                                                          SetTmpCartex(context, null, mItemProduct);
                                                          myNumberPicker = NumberPicker(
                                                            initialValue: cartDetail.Amount,
                                                            minValue: mItemProduct
                                                                .selMinLimit,
                                                            maxValue: mItemProduct
                                                                .selMaxLimit > 0
                                                                ? mItemProduct
                                                                .selMaxLimit
                                                                : -1,
                                                            interval: mItemProduct
                                                                .selJump,
                                                            callBack: (val) async {
                                                              double mRet = val;
                                                              // return true;
                                                              // if((_inCartThis == 0 && mItemProduct.invFirst) || (_inCartThis > 0 && mItemProduct.invAdd)) {
                                                              await setCartexWithVal(context, mItemProduct, cartDetail.Amount == 0, val, cartDetail.Amount > val).then((ret) async {
                                                                if (ret.statusCode == 200) {
                                                                  await reloadCart(context, false).then((v) {
                                                                    refreshCart(context, v);
                                                                    widget.refreshMainMaster!();
                                                                    setState(() {});
                                                                    // widget.goToPage!(1, 1, '');
                                                                    if(mRet > 0) {
                                                                      mRet = v[0].CartDetails.firstWhere((element) => element.PrdCode == mItemProduct.id).Amount;
                                                                    }
                                                                    // widget.goToPage!(1, 1, '');
                                                                  });
                                                                }else{
                                                                  mRet = -1;
                                                                }
                                                              });
                                                              // }else {
                                                              //   ToastNormal("موجود نیست");
                                                              // }
                                                              return mRet;
                                                            },
                                                          );
                                                        });
                                                        return myNumberPicker;
                                                      },
                                                      onChanged: (double value) =>
                                                          print("value: $value"),
                                                      enableOnOutOfConstraintsAnimation: true,
                                                      onOutOfConstraints: () => print(
                                                          "This value is too high or too low"),
                                                  ),
                                                ),
                                                Text(cartDetail.UnitNet?? "")
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  price,
                                                  textDirection: TextDirection.ltr,
                                                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                                                ),
                                                Text(
                                                  totalRowPrice,
                                                  textDirection: TextDirection.ltr,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                            // callBack: (val) async {
                                            //   double mRet = val;
                                            //   // return true;
                                            //   // if((_inCartThis == 0 && mItemProduct.invFirst) || (_inCartThis > 0 && mItemProduct.invAdd)) {
                                            //   await setCartexWithVal(mItemProduct, cartDetail.Amount == 0, val, cartDetail.Amount > val).then((ret) async {
                                            //     if (ret.statusCode == 200) {
                                            //       await reloadCart(false).then((v) {
                                            //         refreshCart(v);
                                            //         setState(() {});
                                            //         // widget.goToPage!(1, 1, '');
                                            //         if(mRet > 0) {
                                            //           mRet = v[0].CartDetails.firstWhere((element) => element.PrdCode == mItemProduct.id).Amount;
                                            //         }
                                            //         // widget.goToPage!(1, 1, '');
                                            //       });
                                            //     }else{
                                            //       await Future.delayed(const Duration(seconds: 1));
                                            //       mRet = -1;
                                            //     }
                                            //   });
                                            //   // }else {
                                            //   //   ToastNormal("موجود نیست");
                                            //   // }
                                            //   return mRet;
                                            // }),

                                        // NumberPicker(
                                        //     theme: NumberSelectionTheme(
                                        //         draggableCircleColor: Colors.blue,
                                        //         iconsColor: Colors.white,
                                        //         numberColor: Colors.white,
                                        //         iconsDisableColor: Colors.grey,
                                        //         backgroundColor:
                                        //         Colors.deepPurpleAccent,
                                        //         outOfConstraintsColor:
                                        //         Colors.deepOrange),
                                        //     initialValue: cartDetail.Amount,
                                        //     iconMin: Icons.delete,
                                        //     iconEmpty: Icons.add_shopping_cart,
                                        //     minValue: cartDetail.selMinLimit,
                                        //     maxValue: cartDetail.selMaxLimit > 0 ? cartDetail.selMaxLimit : -1,
                                        //     progressWidth: 4,
                                        //     intCheck: true,
                                        //     interval: cartDetail.selJump,
                                        //     direction: Axis.horizontal,
                                        //     withSpring: true,
                                        //     callOnSet: (val) async {
                                        //       return NumberPicker(
                                        //         initialValue: 3,
                                        //         minValue: 1,
                                        //         maxValue: 20,
                                        //         interval: 1,
                                        //       );
                                        //     },
                                        //     onChanged: (double value) =>
                                        //         print("value: $value"),
                                        //     enableOnOutOfConstraintsAnimation: true,
                                        //     onOutOfConstraints: () => print(
                                        //         "This value is too high or too low"),
                                        //     callBack: (val) {
                                        //       double mRet = val;
                                        //       // fetchProduct(cartDetail.PrdCode).then((myProduct) async {
                                        //         await setCartexWithVal(myProduct[0].opTs[0], cartDetail.Amount == 0, val, cartDetail.Amount > val).then((ret) async {
                                        //           if (ret.statusCode == 200) {
                                        //             await reloadCart(false).then((v) {
                                        //               refreshCart(v);
                                        //               setState(() {});
                                        //               // widget.goToPage!(1, 1, '');
                                        //               if(mRet > 0) {
                                        //                 mRet = v[0].CartDetails.firstWhere((element) => element.PrdCode == cartDetail.PrdCode).Amount;
                                        //               }
                                        //               // widget.goToPage!(1, 1, '');
                                        //             });
                                        //           }else{
                                        //             await Future.delayed(const Duration(seconds: 1));
                                        //             mRet = -1;
                                        //           }
                                        //         });
                                        //         return mRet;
                                        //       // });
                                        //       return Future(() => cartDetail.Amount);
                                        //       // return true;
                                        //       // if((_inCartThis == 0 && mItemProduct.invFirst) || (_inCartThis > 0 && mItemProduct.invAdd)) {
                                        //
                                        //       // }else {
                                        //       //   ToastNormal("موجود نیست");
                                        //       // }
                                        //     })
                                        //*****************************
                                        // Padding(
                                        //   padding: const EdgeInsets.all(8.0),
                                        //   child: Row(mainAxisAlignment: MainAxisAlignment.start,
                                        //     crossAxisAlignment: CrossAxisAlignment.start,
                                        //     children: [
                                        //     // RawMaterialButton(onPressed: (){}, ),
                                        //       GestureDetector(
                                        //         onTap: () {
                                        //           //  ontap = true;
                                        //         },
                                        //         onLongPress: () {
                                        //         },
                                        //         onLongPressEnd: (_) {
                                        //           setState(() {
                                        //           });
                                        //         },
                                        //         child: Container(
                                        //           width: 30,
                                        //           height: 30,
                                        //           decoration: BoxDecoration(
                                        //             shape: BoxShape.circle,
                                        //             color: Colors.green,
                                        //           ),
                                        //           child: Icon(Icons.add, color: Colors.white, size: 20,),
                                        //         ),
                                        //       ),
                                        //       SizedBox(
                                        //         width: 10,
                                        //       ),
                                        //       GestureDetector(
                                        //         onTap: () {
                                        //         },
                                        //         onLongPress: () {
                                        //         },
                                        //         onLongPressEnd: (_) {
                                        //           setState(() {
                                        //           });
                                        //         },
                                        //         child: Container(
                                        //           width: 30,
                                        //           height: 30,
                                        //           decoration: BoxDecoration(
                                        //             shape: BoxShape.circle,
                                        //             color: Colors.red,
                                        //           ),
                                        //           child: Icon(cartDetail.Amount == cartDetail.SelMinLimit ? Icons.delete : Icons.remove, color: Colors.white, size: 20),
                                        //         ),
                                        //       )
                                        //   ],),
                                        // )
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
  }
}
