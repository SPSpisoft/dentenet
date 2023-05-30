import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart' as intl;
import 'package:sps_persian_datetime_picker/sps_persian_datetime_picker.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:path_provider/path_provider.dart';

import '../data/data_fetch.dart';
import '../gen/colors.gen.dart';
import 'public_variables.dart';

changeLanguage(String myLanguage){
  // String languageCode = 'fa';
  Globals.prefs.setString(Globals.prfMyLanguage, myLanguage);
  Locale locale = Locale(myLanguage); //languageCode=ru or es
  Get.updateLocale(locale);
}

class OverflowProofText extends StatelessWidget {
  const OverflowProofText({super.key, required this.text, required this.fallback});

  final Text text;
  final Widget fallback;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: LayoutBuilder(builder: (BuildContext context, BoxConstraints size) {
          final TextPainter painter = TextPainter(
            textDirection: TextDirection.ltr,
            maxLines: 1,
            textAlign: TextAlign.left,
            text: TextSpan(
                style: text.style ?? DefaultTextStyle.of(context).style,
                text: text.data
            ),
          );

          painter.layout(maxWidth: size.maxWidth);

          return painter.didExceedMaxLines ? fallback : text;
        })
    );
  }
}

ToastNormal(String _text, BuildContext context, {int? type = 0}) async {

  // if(context != null){
    if(type == 0) {
      showTopSnackBar(
        context,
        CustomSnackBar.info(
          message:
          _text,
          backgroundColor: Colors.white70.withBlue(100),
        ),
      );
    } else if(type! < 0) {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message:
          _text,
          backgroundColor: Colors.white70.withGreen(100),
        ),
      );
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.success(
          message:
          _text,
          backgroundColor: Colors.white70.withRed(100),
        ),
      );
    }
  // }
  // else {
  //   Fluttertoast.showToast(
  //       msg: _text,
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 16.0);
  // }
}

String dateTime2String(DateTime? dt, String? preText){
  String ret = "";
  if(Globals.prefs.getString(Globals.prfMyDate) == "J"){
    dt != null ? ret = Jalali.fromDateTime(dt).formatCompactDate() : "";
  }else {
    dt != null ? ret = intl.DateFormat('yyyy/MM/dd').format(dt) : "";
  }
  preText != null ? ret = "$preText $ret" : ret;
  return ret;
}

// String stringDate2String(String? dt, String? preText){
//   String ret = "";
//   if(Globals.prefs.getString(Globals.prfMyDate) == "J"){
//     dt != null ? ret = Jalali.fromDateTime(dt).formatCompactDate() : "";
//   }else {
//     dt != null ? ret = intl.DateFormat('yyyy/MM/dd').format(dt) : "";
//   }
//   preText != null ? ret = "$preText $ret" : ret;
//   return ret;
// }

Future<bool> deleteFile(File file) async {
  bool ret = false;
  try {
    if (await file.exists()) {
      await file.delete();
      ret = true;
    }
  } catch (e) {
    // Error in getting access to the file.
  }
  return ret;
}

initDateTime() {
  DateTime dateTime = Globals.myDateTime;
  var myZoomTime = Globals.prefs.getString(Globals.prfMyZoneLocation)?? "";
  final myLocation = tz.getLocation(myZoomTime);
  fetchDateTime(myZoomTime).then((mDT) {
    dateTime = DateTime.parse(mDT.datetime!);
    final localizedDt = tz.TZDateTime.from(dateTime, myLocation);
    print("DateTime >  " + localizedDt.toString());
    dateTime = localizedDt;
    Globals.myDateTime = dateTime;
  });
}

bool isDirectionRTL(BuildContext context) {
  return intl.Bidi.isRtlLanguage(Get.deviceLocale!.languageCode);
}

String localCode(BuildContext context) {
  return Get.deviceLocale!.languageCode;
}

class HttpOverrideSSL extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }
}

String replaceArabicChar(String mySearchQuery) {
  mySearchQuery = mySearchQuery.replaceAll("ی", "ي");
  mySearchQuery = mySearchQuery.replaceAll("۰", "0");
  mySearchQuery = mySearchQuery.replaceAll("۱", "1");
  mySearchQuery = mySearchQuery.replaceAll("۲", "2");
  mySearchQuery = mySearchQuery.replaceAll("۳", "3");
  mySearchQuery = mySearchQuery.replaceAll("۴", "4");
  mySearchQuery = mySearchQuery.replaceAll("۵", "5");
  mySearchQuery = mySearchQuery.replaceAll("۶", "6");
  mySearchQuery = mySearchQuery.replaceAll("۷", "7");
  mySearchQuery = mySearchQuery.replaceAll("۸", "8");
  mySearchQuery = mySearchQuery.replaceAll("۹", "9");
  return mySearchQuery;
}

String replacePersianChar(String mySearchQuery, {withoutDigit = false}) {
  mySearchQuery = mySearchQuery.replaceAll("ي", "ی");
  if (!withoutDigit) {
    mySearchQuery = mySearchQuery.replaceAll("0", "۰");
    mySearchQuery = mySearchQuery.replaceAll("1", "۱");
    mySearchQuery = mySearchQuery.replaceAll("2", "۲");
    mySearchQuery = mySearchQuery.replaceAll("3", "۳");
    mySearchQuery = mySearchQuery.replaceAll("4", "۴");
    mySearchQuery = mySearchQuery.replaceAll("5", "۵");
    mySearchQuery = mySearchQuery.replaceAll("6", "۶");
    mySearchQuery = mySearchQuery.replaceAll("7", "۷");
    mySearchQuery = mySearchQuery.replaceAll("8", "۸");
    mySearchQuery = mySearchQuery.replaceAll("9", "۹");
  } else {
    mySearchQuery = mySearchQuery.replaceAll("۰", "0");
    mySearchQuery = mySearchQuery.replaceAll("۱", "1");
    mySearchQuery = mySearchQuery.replaceAll("۲", "2");
    mySearchQuery = mySearchQuery.replaceAll("۳", "3");
    mySearchQuery = mySearchQuery.replaceAll("۴", "4");
    mySearchQuery = mySearchQuery.replaceAll("۵", "5");
    mySearchQuery = mySearchQuery.replaceAll("۶", "6");
    mySearchQuery = mySearchQuery.replaceAll("۷", "7");
    mySearchQuery = mySearchQuery.replaceAll("۸", "8");
    mySearchQuery = mySearchQuery.replaceAll("۹", "9");
  }
  return mySearchQuery;
}

String replaceEnglishChar(String mySearchQuery) {
  mySearchQuery = mySearchQuery.replaceAll("ي", "ی");
  mySearchQuery = mySearchQuery.replaceAll("۰", "0");
  mySearchQuery = mySearchQuery.replaceAll("۱", "1");
  mySearchQuery = mySearchQuery.replaceAll("۲", "2");
  mySearchQuery = mySearchQuery.replaceAll("۳", "3");
  mySearchQuery = mySearchQuery.replaceAll("۴", "4");
  mySearchQuery = mySearchQuery.replaceAll("۵", "5");
  mySearchQuery = mySearchQuery.replaceAll("۶", "6");
  mySearchQuery = mySearchQuery.replaceAll("۷", "7");
  mySearchQuery = mySearchQuery.replaceAll("۸", "8");
  mySearchQuery = mySearchQuery.replaceAll("۹", "9");
  return mySearchQuery;
}

String priceString(var mPrice) {
  var formatter = intl.NumberFormat('###,###,###');
  return formatter.format(mPrice);
}

Widget spTextPrice(BuildContext context, double mPrice,
    {int? format, TextStyle? mStyle}) {
  var formatter = intl.NumberFormat('###,###,###');
  switch (format) {
    case 1:
      mPrice = mPrice / 10;
      int M = mPrice ~/ 1000000;
      int H = (mPrice % 1000000) ~/ 1000;
      int T = (mPrice % 1000).toInt();
      String? sM = M > 0 ? '$M/' : '';
      String sH = '$H.';
      String sT = T.toString();
      return RichText(
        text: TextSpan(
          style: mStyle,
          children: <TextSpan>[
            TextSpan(
                text: sM, style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: sH),
            TextSpan(
                text: sT, style: TextStyle(fontSize: mStyle!.fontSize! / 1.3)),
          ],
        ),
      );
    default:
      return Text(
        formatter.format(mPrice),
        style: mStyle,
      );
  }
}

class KeyboardVisibilityBuilder extends StatefulWidget {
  final Widget? child;
  final Widget Function(
    BuildContext context,
    Widget? child,
    bool isKeyboardVisible,
  ) builder;

  const KeyboardVisibilityBuilder({
    Key? key,
    this.child,
    required this.builder,
  }) : super(key: key);

  @override
  KeyboardVisibilityBuilderState createState() =>
      KeyboardVisibilityBuilderState();
}

class KeyboardVisibilityBuilderState extends State<KeyboardVisibilityBuilder>
    with WidgetsBindingObserver {
  var _isKeyboardVisible =
      WidgetsBinding.instance.window.viewInsets.bottom > 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    if (newValue != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(
        context,
        widget.child,
        _isKeyboardVisible,
      );
}

class CustomPageViewScrollPhysics extends ScrollPhysics {
  const CustomPageViewScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  CustomPageViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPageViewScrollPhysics(parent: buildParent(ancestor)!);
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 150,
        stiffness: 200,
        damping: 2.8,
      );
}

// Auto Scroll
class CustomScrollPhysics extends ScrollPhysics {
  const CustomScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(parent: buildParent(ancestor)!);
  }

  @override
  Simulation createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    final tolerance = this.tolerance;
    if ((velocity.abs() < tolerance.velocity) ||
        (velocity > 0.0 && position.pixels >= position.maxScrollExtent) ||
        (velocity < 0.0 && position.pixels <= position.minScrollExtent)) {}
    return ClampingScrollSimulation(
      position: position.pixels,
      velocity: 1200,
      friction: 2.5, // <--- HERE
      tolerance: tolerance,
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}

// Future<String?> findLocalPath() async {
//   String? externalStorageDirPath;
//   if (Platform.isAndroid) {
//     try {
//       externalStorageDirPath = await AndroidPathProvider.downloadsPath;
//     } catch (e) {
//       final directory = await getExternalStorageDirectory();
//       externalStorageDirPath = directory?.path;
//     }
//   } else if (Platform.isIOS) {
//     externalStorageDirPath =
//         (await getApplicationDocumentsDirectory()).absolute.path;
//   }
//   return externalStorageDirPath;
// }

Future<String?> findLocalPath() async {
  String? externalStorageDirPath;
  if (Platform.isAndroid) {
    try {
      await getTemporaryDirectory().then((value) => externalStorageDirPath = value.path);
      // externalStorageDirPath = await AndroidPathProvider.downloadsPath;
    } catch (e) {
      final directory = await getExternalStorageDirectory();
      externalStorageDirPath = directory?.path;
    }
  } else if (Platform.isIOS) {
    externalStorageDirPath =
        (await getApplicationDocumentsDirectory()).absolute.path;
  }
  return externalStorageDirPath;
}

class PlatformDetails {
  static final PlatformDetails _singleton = PlatformDetails._internal();

  factory PlatformDetails() {
    return _singleton;
  }

  PlatformDetails._internal();

  bool get isDesktop =>
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.windows;

  bool get isMobile =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android;
}

int getDecimalPlaces(double number) {
  int decimals = 0;
  List<String> substr = number.toString().split('.');
  if (number != number.round() && substr.isNotEmpty) {
    decimals = substr[1].length;
  }
  return decimals;
}

badgeCheck(BadgeType badgeType) {
  if (badgeType == BadgeType.hide) {
    return Container();
  } else {
    return Padding(
      padding: const EdgeInsets.only(left: 27, top: 3),
      child: Container(
        width: 9.0,
        height: 9.0,
        decoration: BoxDecoration(
          color: badgeType == BadgeType.ok
              ? Colors.green
              : badgeType == BadgeType.error
              ? Colors.red.shade500
              : Colors.orange,
          borderRadius: const BorderRadius.all(Radius.circular(50.0)),
          border: Border.all(
            color: ColorName.white,
            width: 1.0,
          ),
        ),
      ),
    );
  }
}

enum BadgeType { ok, error, warning, hide }

String ReplacePersianChar(String mySearchQuery, {withoutDigit = false}) {
  mySearchQuery = mySearchQuery.replaceAll("ي", "ی");
  if (!withoutDigit) {
    mySearchQuery = mySearchQuery.replaceAll("0", "۰");
    mySearchQuery = mySearchQuery.replaceAll("1", "۱");
    mySearchQuery = mySearchQuery.replaceAll("2", "۲");
    mySearchQuery = mySearchQuery.replaceAll("3", "۳");
    mySearchQuery = mySearchQuery.replaceAll("4", "۴");
    mySearchQuery = mySearchQuery.replaceAll("5", "۵");
    mySearchQuery = mySearchQuery.replaceAll("6", "۶");
    mySearchQuery = mySearchQuery.replaceAll("7", "۷");
    mySearchQuery = mySearchQuery.replaceAll("8", "۸");
    mySearchQuery = mySearchQuery.replaceAll("9", "۹");
  }else{
    mySearchQuery = mySearchQuery.replaceAll("۰", "0");
    mySearchQuery = mySearchQuery.replaceAll("۱", "1");
    mySearchQuery = mySearchQuery.replaceAll("۲", "2");
    mySearchQuery = mySearchQuery.replaceAll("۳", "3");
    mySearchQuery = mySearchQuery.replaceAll("۴", "4");
    mySearchQuery = mySearchQuery.replaceAll("۵", "5");
    mySearchQuery = mySearchQuery.replaceAll("۶", "6");
    mySearchQuery = mySearchQuery.replaceAll("۷", "7");
    mySearchQuery = mySearchQuery.replaceAll("۸", "8");
    mySearchQuery = mySearchQuery.replaceAll("۹", "9");
  }
  return mySearchQuery;
}

String ReplaceArabicChar(String mySearchQuery) {
  mySearchQuery = mySearchQuery.replaceAll("ی", "ي");
  mySearchQuery = mySearchQuery.replaceAll("۰", "0");
  mySearchQuery = mySearchQuery.replaceAll("۱", "1");
  mySearchQuery = mySearchQuery.replaceAll("۲", "2");
  mySearchQuery = mySearchQuery.replaceAll("۳", "3");
  mySearchQuery = mySearchQuery.replaceAll("۴", "4");
  mySearchQuery = mySearchQuery.replaceAll("۵", "5");
  mySearchQuery = mySearchQuery.replaceAll("۶", "6");
  mySearchQuery = mySearchQuery.replaceAll("۷", "7");
  mySearchQuery = mySearchQuery.replaceAll("۸", "8");
  mySearchQuery = mySearchQuery.replaceAll("۹", "9");
  return mySearchQuery;
}

String ReplaceEnglishChar(String mySearchQuery) {
  mySearchQuery = mySearchQuery.replaceAll("ي", "ی");
  mySearchQuery = mySearchQuery.replaceAll("۰", "0");
  mySearchQuery = mySearchQuery.replaceAll("۱", "1");
  mySearchQuery = mySearchQuery.replaceAll("۲", "2");
  mySearchQuery = mySearchQuery.replaceAll("۳", "3");
  mySearchQuery = mySearchQuery.replaceAll("۴", "4");
  mySearchQuery = mySearchQuery.replaceAll("۵", "5");
  mySearchQuery = mySearchQuery.replaceAll("۶", "6");
  mySearchQuery = mySearchQuery.replaceAll("۷", "7");
  mySearchQuery = mySearchQuery.replaceAll("۸", "8");
  mySearchQuery = mySearchQuery.replaceAll("۹", "9");
  return mySearchQuery;
}

