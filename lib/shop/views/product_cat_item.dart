import 'package:cached_network_image/cached_network_image.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_indicators/progress_indicators.dart';

import '../../public/public_functions.dart';
import '../../public/public_variables.dart';
import '../../themes/app_theme.dart';
import '../../themes/master_theme.dart';
import '../classes/ClsProductHead.dart';
import '../data_fetch.dart';
import '../data_set.dart';
import '../screens/item_screen_2.dart';

class PrdCatItem extends StatefulWidget {const PrdCatItem({
    Key? key,
    required this.prd,
    required this.functionOnTap,
    required this.goToPage,
    this.reload,
    this.assetImage,
    this.animationController,
    this.animation,
  }) : super(key: key);

  final ClsProductHead prd;
  final VoidCallback functionOnTap;
  final Function(int, int, String?) goToPage;
  final Function(String? mId)? reload;
  final String? assetImage;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  _PrdCatItemState createState() => _PrdCatItemState();
}

class _PrdCatItemState extends State<PrdCatItem> {
  String txtInCart = "";

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        String ratCount = '0';
        String rat = '0.0';
        IconData icon;
        String text;
        int status;
        // double inCart = 0;

        // String price = widget.prd.priceMin != widget.prd.priceMax
        //     ? priceString(widget.prd.priceMin) +
        //         '~' +
        //         priceString(widget.prd.priceMax)
        //     : priceString(widget.prd.price);

        // if (Globals.currentCart.length > 0) {
        //   ClsCart mCurrentCart = Globals.currentCart[0];
        //   if (widget.prd.prdIDs.isNotEmpty) {
        //     mCurrentCart.CartDetails.where((element) => element.StatusCode == 0 &&
        //         element.IDMerge == widget.prd.idMerge).forEach((element) { inCart = inCart + element.Amount;});
        //   } else {
        //     mCurrentCart.CartDetails.where((element) => element.StatusCode == 0 &&
        //         element.PrdCode == widget.prd.id).forEach((element) { inCart = inCart + element.Amount;});
        //   }
        // }
        int cntDP = getDecimalPlaces(widget.prd.inCartHead);
        txtInCart = widget.prd.inCartHead.toStringAsFixed(cntDP);

        if (!widget.prd.invFirst && widget.prd.inCartHead == 0) {
          if (widget.prd.inventoryTemp || widget.prd.priceTemp) {
            status = -2;
            icon = Icons.question_answer_outlined;
            text = 'استعلام      ';
          } else {
            status = -1;
            icon = Icons.not_interested;
            text = ' موجود نیست      ';
          }
        } else if (widget.prd.inProgress?? false) {
          status = 100;
          icon = Icons.access_time;
          text = "PLEASE WAIT";
        } else if (widget.prd.prdIDs.isNotEmpty) {
          if (widget.prd.inCartHead == 0) {
            status = 0;
            icon = Icons.assignment_turned_in_outlined;
            text = ' مشاهده جزئیات  ';
          } else {
            status = 2;
            icon = Icons.shopping_cart;
            text = 'مشاهده سبد خرید';
          }
        } else {
          if (widget.prd.inCartHead == 0) {
            status = 1;
            icon = Icons.add_shopping_cart;
            text = 'افزودن به سبد خرید';
          } else {
            status = 2;
            icon = Icons.shopping_cart;
            text = 'مشاهده سبد خرید';
          }
        }
        return FadeTransition(
          opacity: widget.animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - widget.animation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.all(1),
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
                    onTap: widget.functionOnTap,
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
                                  child: Column(
                                    children: [
                                      Text(
                                        ReplacePersianChar(widget.prd.title),
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontFamily: 'Yekan',
                                          fontSize: 13.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 6, right: 8, bottom: 4),
                                      child: Row(
                                        textDirection: TextDirection.ltr,
                                        verticalDirection:
                                            VerticalDirection.down,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        textBaseline: TextBaseline.alphabetic,
                                        children: [
                                          RatingBarIndicator(
                                            rating: 0.5,
                                            itemBuilder: (context, index) =>
                                                const Icon(
                                              Icons.star_outlined,
                                              color: Colors.amber,
                                            ),
                                            itemCount: 1,
                                            itemSize: 18.0,
                                            direction: Axis.horizontal,
                                          ),
                                          Text(
                                            rat,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.blueGrey),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            ratCount,
                                            style: const TextStyle(
                                                fontSize: 8,
                                                color: Colors.black45),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, bottom: 4),
                                      child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child:

                                          widget.prd.priceMin == widget.prd.priceMax ?
                                          spTextPrice(context, widget.prd.price,
                                              format: Globals.storePriceFormat,
                                              mStyle: const TextStyle(
                                                  color: Colors.black, fontSize: 14))
                                              :
                                          Row(
                                            children: [
                                              spTextPrice(context, widget.prd.priceMin?? 0,
                                                  format: Globals.storePriceFormat,
                                                  mStyle: const TextStyle(
                                                      color: Colors.black, fontSize: 14)),
                                              const Text('~'),
                                              spTextPrice(context, widget.prd.priceMax?? 0,
                                                  format: Globals.storePriceFormat,
                                                  mStyle: const TextStyle(
                                                      color: Colors.black, fontSize: 14)),
                                            ],
                                          )
                                          // Text(
                                          //   price,
                                          //   textDirection: TextDirection.ltr,
                                          // )
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 10,
                                          left: 10,
                                          right: 10,
                                          top: 6),
                                      child: AspectRatio(
                                        aspectRatio: 0.45 / 0.1,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: OutlinedButton(
                                                onPressed: () {
                                                  switch (status) {
                                                    case 0:
                                                      Navigator.of(context)
                                                          .push(
                                                              PageRouteBuilder(
                                                        pageBuilder: (context,
                                                                animation,
                                                                secondaryAnimation) =>
                                                            ItemScreen2(
                                                                mProductId: widget.prd.id, goToPage: widget.goToPage),
                                                        transitionsBuilder:
                                                            (context,
                                                                animation,
                                                                secondaryAnimation,
                                                                child) {
                                                          return child;
                                                        },
                                                      ));
                                                      break;
                                                    case 1:
                                                      // addToCart(widget.prd.id);
                                                      fetchProduct(
                                                              widget.prd.id)
                                                          .then((prdHead) {
                                                        widget.reload!(widget.prd.id);
                                                        // prdHead[0].inProgress = true;
                                                        //     setState((){ });
                                                        SetTmpCartex(context, prdHead[0], prdHead[0].opTs[0]);
                                                        setCartex(context, prdHead[0].opTs[0], true).then((value) {
                                                          if(value.statusCode == 200) {
                                                            reloadCart(context, false).then((v) {
                                                              // prdHead[0].inProgress = false;
                                                              refreshCart(context, v);
                                                              widget.reload!(null);
                                                              // setState(() {});
                                                              // widget.goToPage(1, 1, '');
                                                            });
                                                          }else{
                                                            if(value.statusCode == 403) {
                                                              status = 1;
                                                              ToastNormal("لطفا ابتدا با حساب کاربری معتبر وارد شوید", context, type: 0);
                                                              setState((){});
                                                            // } else {
                                                            //   ToastNormal('Error ${value.statusCode}', context: context, type: -1);
                                                            }
                                                          }
                                                        }
                                                        );
                                                      });
                                                      break;
                                                    case 2:
                                                      goToCart(widget.prd.id);
                                                      break;
                                                    default:
                                                      () {};
                                                      break;
                                                  }
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  elevation: 10,
                                                  primary: Colors.black,
                                                  backgroundColor: status >= 0
                                                      ? Colors.red
                                                          .withOpacity(0.4)
                                                      : Colors.grey
                                                          .withOpacity(0.4),
                                                  side: BorderSide(
                                                      color: status >= 0
                                                          ? Colors.redAccent
                                                          : Colors.grey),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: <Widget>[
                                                        // Positioned(
                                                        //   left: 0.0,
                                                        //   top: 0.0,
                                                        //   child: Icon(_icon,
                                                        //       color: Colors.black38,
                                                        //       size: 21),
                                                        // ),
                                                        FittedBox(
                                                          fit: BoxFit.fitHeight,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10,
                                                                    bottom: 10),
                                                            child:
                                                                DecoratedIcon(
                                                              icon ,
                                                              color:
                                                                  Colors.white,
                                                              shadows: const [
                                                                BoxShadow(
                                                                  blurRadius:
                                                                      12.0,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ],
                                                            ) ,
                                                          ),
                                                        ),
                                                        widget.prd.inCartHead > 0
                                                            ? Positioned(
                                                                left: 7.0,
                                                                top: 3.0,
                                                                child: SizedBox(
                                                                  height: 13,width: 13,
                                                                  child: CircleAvatar(
                                                                    backgroundColor: Colors.indigo,
                                                                    child: Text(txtInCart,
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              8,
                                                                          color: Colors
                                                                              .white),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(),
                                                      ],
                                                    ),
                                                    Expanded(
                                                      child:
                                                      status != 100 ?
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 7,
                                                                left: 7,
                                                                top: 10,
                                                                bottom: 10),
                                                        child: FittedBox(
                                                          fit: BoxFit.fitHeight,
                                                          child:
                                                          Text(
                                                            text,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'Yekan',
                                                              color:
                                                                  Colors.white,
                                                              shadows: <Shadow>[
                                                                Shadow(
                                                                  offset:
                                                                      Offset(
                                                                          2.0,
                                                                          2.0),
                                                                  blurRadius:
                                                                      10.0,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ],
                                                            ),
                                                          ) // LinearProgressIndicator(
                                                          //   minHeight: 5,
                                                          //   color: AppTheme.primarySwatch,
                                                          // ),
                                                        ),
                                                      ):
                                                          Padding(
                                                            padding: const EdgeInsets.only(bottom: 10),
                                                            child: JumpingDotsProgressIndicator(
                                                              fontSize: 20,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 0, right: 8),
                                              child: FittedBox(
                                                fit: BoxFit.fitHeight,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: const [
                                                    FittedBox(
                                                      fit: BoxFit.fitHeight,
                                                      child: Icon(
                                                        Icons.favorite_border,
                                                        color: Colors.redAccent,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    FittedBox(
                                                      fit: BoxFit.fitHeight,
                                                      child: Icon(
                                                        FontAwesomeIcons.bell,
                                                        color: Colors.amber,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        AspectRatio(
                          aspectRatio: 1,
                          child: SizedBox(
                            width: double.infinity,
                            child: Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: widget.prd.images.length > 0
                                    ?

                                // FancyShimmerImage(
                                //   imageUrl: Globals.baseUrl + widget.prd.images[0].serverUrl,
                                //   boxFit: BoxFit.fill,
                                //   errorWidget: Image.asset(widget.assetImage!, fit: BoxFit.fill),
                                // )
                                CachedNetworkImage(
                                  imageUrl: Globals.baseUrlShop + widget.prd.images[0].serverUrl,
                                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                                      JumpingDotsProgressIndicator(
                                              fontSize: 35.0,
                                              color: AppTheme.primarySwatch,
                                            ),
                                  errorWidget: (context, url, error) => Image.asset(widget.assetImage!),
                                )
                                // Image.network(
                                //         Globals.baseUrl + widget.prd.images[0].serverUrl,
                                //   errorBuilder: (context, error, stackTrace) {
                                //     return Image.asset(widget.assetImage!);
                                //   },
                                //   loadingBuilder: (context, child, loadingProgress) {
                                //     return JumpingDotsProgressIndicator(
                                //       fontSize: 35.0,
                                //       color: AppTheme.primarySwatch,
                                //     );
                                //   },)
                                    : Image.asset(widget.assetImage!),
                              ),
                            ),
                          ),
                        ),
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

  // void addToCart(String id) {
  //   postCart(TmpCartex);**
  // }

  void goToCart(String id) {
    widget.goToPage(2,1,null);
  }
}
