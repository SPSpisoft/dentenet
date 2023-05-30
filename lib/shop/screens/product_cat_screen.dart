import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import '../../themes/app_theme.dart';
import '../views/search_box.dart';
import 'item_screen_2.dart';
import 'main_tabs/ProductCat/product_cat_view.dart';

class ProductCatPage extends StatefulWidget {
  final String catId;
  final Function(int, int, String?) goToPage;
  final AnimationController? mainScreenAnimationController;
  ScrollController scrollController;

  ProductCatPage(
      {Key? key,
      required this.catId,
      required this.goToPage,
      required this.scrollController,
      this.mainScreenAnimationController})
      : super(key: key);

  @override
  _ProductCatPageState createState() => _ProductCatPageState();
}

class _ProductCatPageState extends State<ProductCatPage> {

  callback(newValue) {
    setState(() {
      widget.goToPage(4,1, null).call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        // leading: Container(),
        title: SearchBox(
          readOnly: true,
          atVoice: true,
          onTap: callback,
          focusNode: FocusNode(),
          onTextChange: (value) => () {},
        ),
      ),
      body: ProductCatView(
        catId: widget.catId,
        goToPage : widget.goToPage,
        mScrollController: widget.scrollController,
        mainScreenAnimationController: widget.mainScreenAnimationController,
      ),
    );
  }
}
