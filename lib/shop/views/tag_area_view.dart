import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../public/public_functions.dart';
import '../../public/public_variables.dart';
import '../../themes/master_theme.dart';
import '../classes/ClsTags.dart';


class TagAreaView extends StatefulWidget {
  const TagAreaView({
    Key? key,
    required this.tag,
    required this.functionOnTap,
    this.assetImage,
    this.animationController,
    this.animation,
  }) : super(key: key);

  final ClsTags tag;
  final VoidCallback functionOnTap;
  final String? assetImage;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  _TagAreaViewState createState() => _TagAreaViewState();
}

class _TagAreaViewState extends State<TagAreaView> {
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
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: widget.tag.bannerUrl.isNotEmpty
                                  ? ClipRRect(
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                                    child:

                                    FancyShimmerImage(
                                      imageUrl: Globals.baseUrlShop + widget.tag.bannerUrl, boxFit: BoxFit.cover,
                                      errorWidget: Image.asset(widget.assetImage!, fit: BoxFit.fill),
                                    )
                                    // CachedNetworkImage(
                                    //   imageUrl: Globals.baseUrl + widget.tag.bannerUrl,
                                    //   fit: BoxFit.cover,
                                    //   progressIndicatorBuilder: (context, url, downloadProgress) =>
                                    //       JumpingDotsProgressIndicator(
                                    //         fontSize: 35.0,
                                    //         color: AppTheme.primarySwatch,
                                    //       ),
                                    //   errorWidget: (context, url, error) => Image.asset(widget.assetImage!, fit: BoxFit.fill),
                                    // ),
                                    // Image.network(
                                    // Globals.baseUrl + widget.tag.bannerUrl, fit: BoxFit.cover,),
                                  )
                                  : Center(child: Image.asset(widget.assetImage!, fit: BoxFit.fill)),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              ReplacePersianChar(widget.tag.tagTitle),
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
