import 'dart:convert' as convert;

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/app.dart';
import '../shop/classes/ClsCart.dart';
import '../shop/classes/ClsCartex.dart';
import '../shop/classes/ClsSearch.dart';
import '../shop/classes/ClsStore.dart';
import '../shop/classes/ClsTags.dart';
import 'modeles.dart';

//******************* SHOP *************** {
enum TagType {SYS, ROOT}
enum UserStatus {Unknown, Register, WaitSms, SetPass, Login, Stable}
//******************* SHOP *************** }

class Globals {

  static String appTitle = 'SPIDENT';

  static String baseUrlDental = 'https://dental.spisoft.ir/';
  static String baseApiAddressDental = '${baseUrlDental}api/';
  static String myFileApk = 'SPIDENT.apk';

  static int mySchemaVersion = 15;

  static DateTime myDateTime = DateTime.now();

  static const String authorizationUser = 'SPUSER_1';
  static const String authorizationPass = 'SPPASS_123asdASD!@#';
  static String basicAuth = 'Basic ${convert.base64Encode(convert.utf8.encode('$authorizationUser:$authorizationPass'))}';

  // static String myPrivateKey = "ANDxKu0ZyzdlnEEK7HKrKSvImTmmXFmGVqu4dL84kHPupsZvTARxpv8gPxzOcPCHaQyhVhpujcPZW3inYfPcQsQgPA8vBEYg1ASYMbzr7u8YgBljpGui44hTqvQyPTBv";
  static String myTypeID = "ANDA";
  static String myUser = 'TestUser';
  static String myMemberId = 'LB_RAJABI_A';
  static String myPassword = '';
  static String myNetIP = '';
  static String myDeviceId = '_';
  static String myAppVersion = '';
  static String myAppBuildNumber = '';
  static String myToken = '';

  // static List<ClsMember> myMemberList = [];
  // static RxString currentMember = ''.obs;
  static TaskModel currentTask = TaskModel();
  static RxList<ClsPatientInfo> currentPatient = <ClsPatientInfo>[].obs;
  static RxList<ClsMember> currentEmployer = <ClsMember>[].obs;
  // static late Store store;
  // static late ObjectBox objectBox;
  // static late Box<ClsMember> boxMember;

  static late SharedPreferences prefs;
  static String prfTaskScrollPage = 'prfTaskScrollPage';
  static String prfWakeUp = 'prfWakeUp';
  static String prfEmployerExpand = 'prfEmployerExpand';
  static String prfMyLanguage = 'prfMyLanguage';
  static String prfMyDate = 'prfMyDate';
  static String prfMyZoneLocation = 'prfMyZoneLocation';
  static String prfPatientAge = 'prfPatientAge';

  static String? gregorianDateFormat = 'yyyy-MM-dd';
  static String? gregorianDateDayFormat = 'EEEE, d MMM, yyyy';
  static String? gregorianDateDayMonFormat = 'EEEE, d MMMM, yyyy';


  static RxBool isJalali =
  Globals.prefs.getString(Globals.prfMyDate) == "J" ? true.obs : false.obs;
  static String dateFont =
  Globals.prefs.getString(Globals.prfMyDate) == "J" ? 'Yekan' : 'Tahoma';

  static String textFont = 'Tahoma';
  static double textSize = 14;

  // static var md = Globals.myDateTime.obs;
  //
  // static RxString mt1 = Globals.prefs.getString(Globals.prfMyDate) == "J"
  //     ? Globals.myDateTime.toJalali().formatCompactDate().obs
  //     : DateFormat(Globals.gregorianDateFormat).format(Globals.myDateTime).obs;
  //
  // static RxString mt2 = Globals.prefs.getString(Globals.prfMyDate) == "J"
  //     ? Globals.myDateTime.toJalali().formatMediumDate().obs
  //     : DateFormat(Globals.gregorianDateDayFormat)
  //     .format(Globals.myDateTime)
  //     .obs;
  //
  // static RxString mt3 = Globals.prefs.getString(Globals.prfMyDate) == "J"
  //     ? Globals.myDateTime.toJalali().formatFullDate().obs
  //     : DateFormat(Globals.gregorianDateDayMonFormat)
  //     .format(Globals.myDateTime)
  //     .obs;
  //******************* SHOP *************** {
  static String myPrivateKey = "ANDxKu0ZyzdlnEEK7HKrKSvImTmmXFmGVqu4dL84kHPupsZvTARxpv8gPxzOcPCHaQyhVhpujcPZW3inYfPcQsQgPA8vBEYg1ASYMbzr7u8YgBljpGui44hTqvQyPTBv";
  static late ClsStore myStore ;
  static late Future<List<ClsStore>> futureStoreTarget;
  static late Future<List<ClsTags>> futureTags;
  static late Future<List<ClsSearch>> futureSearch;
  static late Future<List<ClsCart>> futureCurrentCart;

  static late ClsCartex TmpCartex;

  static late List<ClsSearch> productList;
  static List<ClsCart> currentCart = [];

  static String baseUrlShop = 'https://shop.spisoft.ir/';
  // static String baseUrl = 'http://199.166.1.6/shop/';
  static String baseApiAddressShop = '${baseUrlShop}api/Master?';
  static String myStoreId = 'SpDentStore';
  static int storePriceFormat = 0;

  static String tagType_SYS = 'SYS';
  static String tagType_ROOT = 'ROOT';
  static List<StackTag> stackTag = [];

  static String prfRemember = 'prfRemember';
  // static String prfUserID = 'prfUserID';
  static String prfCountryCode = 'prfCountryCode';
  static String prfMobile = 'prfMobile';
  static String prfPassword = 'prfPassword';
  //******************* SHOP *************** }
}

//******************* SHOP *************** {
class StackTag {
  String tagId;
  double scrollPosition;

  StackTag(this.tagId, this.scrollPosition);
}

class CartTypeEnum {
  static CartType get cartAll => CartType(code: 9, title: 'CartAll');
  static CartType get cartDelivered => CartType(code: 7, title: 'CartDelivered');
  static CartType get cartPosted => CartType(code: 6, title: 'CartPosted');
  static CartType get cartAccepted => CartType(code: 5, title: 'CartAccepted');
  static CartType get cartEdited => CartType(code: 4, title: 'CartEdited');
  static CartType get cartReceived => CartType(code: 3, title: 'CartReceived');
  static CartType get cartSendSignal => CartType(code: 2, title: 'CartSendSignal');
  static CartType get cartClosed => CartType(code: 1, title: 'CartClosed');
  static CartType get cartOpened => CartType(code: 0, title: 'CartOpened');
  static CartType get cartCanceled => CartType(code: -1, title: 'CartCanceled');
  static CartType get cartDisapproval => CartType(code: -2, title: 'Disapproval');
  static CartType get cartReserved => CartType(code: -3, title: 'CartReserved');
  static CartType get cartRetOff => CartType(code: -7, title: 'CartRetOff');
  static CartType get cartRetInv => CartType(code: -8, title: 'CartRetInv');
  static CartType get cartFavorite => CartType(code: -9, title: 'CartFavorite');
  static CartType get cartDeleted => CartType(code: -10, title: 'CartDeleted');
}

class CartType {
  CartType({
    required this.code,
    required this.title,
  });

  String title ;
  int code ;

  String get codeAsString => code.toString();
}
//******************* SHOP *************** }