import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../public/public_variables.dart';
import '../../themes/master_theme.dart';
import '../classes/ClsTags.dart';

class TagLinkAreaView extends StatefulWidget {
  const TagLinkAreaView({
    Key? key,
    required this.tag,
    required this.functionOnTap,
    this.assetImage,
    this.animationController,
    this.animation,
  }) : super(key: key);

  final tagLink tag;
  final VoidCallback functionOnTap;
  final String? assetImage;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  _TagLinkAreaViewState createState() => _TagLinkAreaViewState();
}

class _TagLinkAreaViewState extends State<TagLinkAreaView> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - widget.animation!.value), 0.0),
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
                    onTap: widget.functionOnTap,
                    child: Stack(
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            width: double.infinity,
                            child: Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: widget.tag.imgUrl.isNotEmpty
                                    ?
                                FancyShimmerImage(
                                  imageUrl: Globals.baseUrlShop + widget.tag.imgUrl, boxFit: BoxFit.cover,
                                  errorWidget: Image.asset('assets/images/image_not_available.png', fit: BoxFit.cover),
                                )
                                // CachedNetworkImage(
                                //   imageUrl: Globals.baseUrl + widget.tag.imgUrl,
                                //   fit: BoxFit.cover,
                                //   progressIndicatorBuilder: (context, url, downloadProgress) =>
                                //       JumpingDotsProgressIndicator(
                                //         fontSize: 35.0,
                                //         color: AppTheme.primarySwatch,
                                //       ),
                                //   errorWidget: (context, url, error) => Image.asset('assets/images/image_not_available.png'),
                                // )
                                // Image.network(
                                //     Globals.baseUrl + widget.tag.imgUrl)
                                    : Image.asset(widget.assetImage!),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.tag.title,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontFamily: 'Yekan',
                                fontSize: 13.0,
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
