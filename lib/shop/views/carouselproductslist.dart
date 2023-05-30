import 'package:extended_image/extended_image.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

import '../components/card_item.dart';
import '../components/hi.dart';

enum CarouselTypes { home, details }

class CarouselProductsList extends StatefulWidget {
  final CarouselTypes type;
  final List<String> productsUrls;
  final BoxFit boxFit;
  final double height;
  final double topPadding;
  final double btnPadding;
  final String assetImage;

  const CarouselProductsList({
    Key? key,
    required this.type,
    required this.productsUrls,
    required this.boxFit,
    required this.height,
    required this.topPadding,
    required this.btnPadding,
    required this.assetImage,
  }) : super(key: key);

  @override
  _CarouselProductsListState createState() => _CarouselProductsListState();
}

class _CarouselProductsListState extends State<CarouselProductsList> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: widget.topPadding,
        bottom: widget.btnPadding,
      ),
      child: SizedBox(
        height: widget.height,
        // width: widget.height*2,
        child: Column(
          children: <Widget>[
            Expanded(
              child: PageView.builder(
                controller: PageController(
                  viewportFraction:
                      widget.type == CarouselTypes.details ? .75 : .95,
                ),
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: widget.productsUrls.isNotEmpty
                    ? widget.productsUrls.length
                    : 1,
                itemBuilder: (ctx, id) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: widget.type == CarouselTypes.details
                          ? Colors.white
                          : Colors.transparent,
                    ),
                    margin: widget.type == CarouselTypes.details &&
                            _currentIndex != id
                        ? EdgeInsets.symmetric(
                            horizontal: widget.btnPadding * 1,
                            vertical: 15,
                          )
                        : EdgeInsets.symmetric(
                            horizontal: widget.btnPadding * 1.5,
                            vertical: 0,
                          ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: widget.productsUrls.isNotEmpty
                          ? InkWell(
                              onTap: () {
                                Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      ImageProvider(
                                    widget.productsUrls,
                                    widget.assetImage,
                                    initialIndex: id,
                                  ),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    return child;
                                  },
                                ));

                                // ImageProvider(widget.productsUrls, initialIndex: id,);
                                // CustomImageProvider customImageProvider = CustomImageProvider(
                                //     imageUrls: widget.productsUrls,
                                //     initialIndex: id);
                                // showImageViewerPager(context, customImageProvider,
                                //     onPageChanged: (page) {
                                //       // print("Page changed to $page");
                                //     }, onViewerDismissed: (page) {
                                //       // print("Dismissed while on page $page");
                                //     });
                              },
                              child:
                              FancyShimmerImage(
                                imageUrl: "${widget.productsUrls[id]}",
                                boxFit: widget.boxFit,
                                errorWidget: Image.asset('assets/images/image_not_available.png', fit: BoxFit.fill),
                              )
                              // CachedNetworkImage(
                              //   imageUrl: "${widget.productsUrls[id]}",
                              //   progressIndicatorBuilder:
                              //       (context, url, downloadProgress) =>
                              //           JumpingDotsProgressIndicator(
                              //     fontSize: 35.0,
                              //     color: AppTheme.primarySwatch,
                              //   ),
                              //   fit: widget.boxFit,
                              //   errorWidget: (context, url, error) =>
                              //       Image.asset(widget.assetImage),
                              // )
                              // Image.network(
                              //   "${widget.productsUrls[id]}",
                              //   fit: widget.boxFit,
                              // ),
                              )
                          : Image.asset(
                              'assets/images/default_back.jpg',
                              fit: BoxFit.fill,
                            ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 9),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.productsUrls.length,
                (i) {
                  return Container(
                    width: 9,
                    height: 9,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == _currentIndex ? Colors.black : Colors.grey,
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

// class CustomImageProvider extends EasyImageProvider {
//   @override
//   final int initialIndex;
//   final List<String> imageUrls;
//
//   CustomImageProvider({required this.imageUrls, this.initialIndex = 0})
//       : super();
//
//   @override
//   ImageProvider<Object> imageBuilder(BuildContext context, int index) {
//     return NetworkImage(imageUrls[index]);
//   }
//
//   @override
//   int get imageCount => imageUrls.length;
// }

class ImageProvider extends StatefulWidget {
  final int initialIndex;
  final List<String> imageUrls;
  String assetImage;

  ImageProvider(this.imageUrls, this.assetImage,
      {Key? key, this.initialIndex = 0})
      : super(key: key);

  @override
  _ImageProviderState createState() => _ImageProviderState();
}

class _ImageProviderState extends State<ImageProvider> with TickerProviderStateMixin {
  late int currentIndex;

  var _animation;

  var animationListener;

  late AnimationController _animationController = AnimationController( duration: const Duration(milliseconds: 300),
    vsync: this,
  )..forward();

  List<double> doubleTapScales = [1, 2];

  @override
  void initState() {
    // TODO: implement initState
    currentIndex = widget.initialIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<CardItem> items = [];
    for (var element in widget.imageUrls) {
      items.add(
        ImageCarditem(
            image: Container(
          child: ExtendedImage.network(
            element,
            fit: BoxFit.contain,
            mode: ExtendedImageMode.gesture,
          ),
          padding: EdgeInsets.all(5.0),
        )),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Stack(
            children: [
                ExtendedImageGesturePageView.builder(
                //   canScrollPage: (gestureDetails) {
                //   return
                // },
                itemBuilder: (BuildContext context, int index) {
                  var item = widget.imageUrls[index];
                  Widget image = ExtendedImage.network(
                    item,
                    fit: BoxFit.contain,
                    mode: ExtendedImageMode.gesture,
                    onDoubleTap: (ExtendedImageGestureState state) {
                      ///you can use define pointerDownPosition as you can,
                      ///default value is double tap pointer down postion.
                      var pointerDownPosition = state.pointerDownPosition;
                      double? begin = state.gestureDetails!.totalScale;
                      double end;

                      _animation?.removeListener(animationListener);
                      _animationController.stop();
                      _animationController.reset();

                      if (begin == doubleTapScales[0]) {
                        end = doubleTapScales[1];
                      } else {
                        end = doubleTapScales[0];
                      }

                      animationListener = () {
                        state.handleDoubleTap(
                            scale: _animation.value,
                            doubleTapPosition: pointerDownPosition);
                      };
                      _animation = _animationController
                          .drive(Tween<double>(begin: begin, end: end));

                      _animation.addListener(animationListener);

                      _animationController.forward();
                    },
                  );
                  image = Container(
                    child: image,
                    padding: EdgeInsets.all(5.0),
                  );
                  if (index == currentIndex) {
                    return Hero(
                      tag: item + index.toString(),
                      child: image,
                    );
                  } else {
                    item = widget.imageUrls[currentIndex];
                    image = ExtendedImage.network(
                      item,
                      fit: BoxFit.contain,
                      mode: ExtendedImageMode.gesture,
                    );
                    image = Container(
                      child: image,
                      padding: EdgeInsets.all(5.0),
                    );

                    return Hero(
                      tag: item + currentIndex.toString(),
                      child: image,
                    );
                  }
                },
                itemCount: widget.imageUrls.length,
                onPageChanged: (int index) {
                  setState(() {
                    currentIndex = index;
                  });
                  // rebuild.add(index);
                },
                controller: ExtendedPageController(
                  initialPage: currentIndex,
                ),
                scrollDirection: Axis.horizontal,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: HorizontalCardPager(
                  items: items,
                  initialPage: currentIndex,
                  onPageChanged: (page) {
                    print("page : $page");
                    // if (page.floor() - page == 0)
                    {
                      setState(() {
                        currentIndex = page.toInt();
                      });
                    }
                  },
                  onSelectedItem: (page) {
                    setState(() {
                      currentIndex = page;
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
    //   ExtendedImageGesturePageView.builder(
    //   itemBuilder: (BuildContext context, int index) {
    //     var item = widget.imageUrls[index];
    //     Widget image =
    //
    //         // CachedNetworkImage(
    //         //   imageUrl: item,
    //         //   progressIndicatorBuilder: (context, url, downloadProgress) =>
    //         //       JumpingDotsProgressIndicator(
    //         //         fontSize: 35.0,
    //         //         color: AppTheme.primarySwatch,
    //         //       ),
    //         //   fit: BoxFit.contain,
    //         //   errorWidget: (context, url, error) => Image.asset(widget.assetImage!),
    //         // );
    //
    //         ExtendedImage.network(
    //       item,
    //       fit: BoxFit.contain,
    //       mode: ExtendedImageMode.gesture,
    //
    //       // gestureConfig: GestureConfig(
    //       //     inPageView: true, initialScale: 1.0,
    //       //     //you can cache gesture state even though page view page change.
    //       //     //remember call clearGestureDetailsCache() method at the right time.(for example,this page dispose)
    //       //     cacheGesture: false
    //       // ),
    //     );
    //     image = Container(
    //       child: image,
    //       padding: EdgeInsets.all(5.0),
    //     );
    //     if (index == currentIndex) {
    //       return Hero(
    //         tag: item + index.toString(),
    //         child: image,
    //       );
    //     } else {
    //       return image;
    //     }
    //   },
    //   itemCount: widget.imageUrls.length,
    //   onPageChanged: (int index) {
    //     currentIndex = index;
    //     // rebuild.add(index);
    //   },
    //   controller: ExtendedPageController(
    //     initialPage: currentIndex,
    //   ),
    //   scrollDirection: Axis.horizontal,
    // );
  }
}
