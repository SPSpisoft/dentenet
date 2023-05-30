import 'dart:convert' as convert;
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../public/public_functions.dart';
import '../public/public_variables.dart';
import 'classes/ClsCart.dart';
import 'classes/ClsCartex.dart';
import 'classes/ClsCategoryFull.dart';
import 'classes/ClsCategoryGroup.dart';
import 'classes/ClsProductHead.dart';
import 'classes/ClsSearch.dart';
import 'classes/ClsStore.dart';
import 'classes/ClsTags.dart';
import 'classes/ClsUserSet.dart';

Future<List<ClsStore>> fetchStoreTarget() async {
  List<ClsStore> sRet = [];
  var url =
      Uri.parse('${Globals.baseApiAddressShop}StoreTarget=${Globals.myStoreId}');

  try {
    final response = await http.get(
      url,
      headers: <String, String>{
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': Globals.basicAuth
      },
    );

    if (response.statusCode == 200) {
      print(convert.jsonDecode(response.body));
      List jsonList = convert.jsonDecode(response.body);
      for (int i = 0; i < jsonList.length; i++) {
        sRet.add(ClsStore.fromJson(jsonList[i]));
      }
    } else {
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 426) {
        Globals.myToken = response.body.replaceAll("\"", "");
        return fetchStoreTarget();
      } else {
        return Future.error(response.statusCode);
      }
    }
  } catch (e) {
    print(e);
    return Future.error(e.toString());
  }

  Globals.myStore = sRet[0];
  return sRet;
}

Future<List<ClsTags>> fetchTags(
    String mTagType, String mTagID, bool atPrdInfo) async {
  List<ClsTags> sRet = [];
  var url = Uri.parse('${Globals.baseApiAddressShop}MyToken=${Globals.myToken}&StoreTags=${Globals.myStoreId}&TagType=$mTagType&TagId=$mTagID&atPrdInfo=$atPrdInfo&newFormat=true');

  try {
    final response = await http.get(
      url,
      headers: <String, String>{
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': Globals.basicAuth
      },
    );

    if (response.statusCode == 200) {
      print(convert.jsonDecode(response.body));
      List jsonList = convert.jsonDecode(response.body);
      for (int i = 0; i < jsonList.length; i++) {
        sRet.add(ClsTags.fromJson(jsonList[i]));
      }
    } else {
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 426) {
        Globals.myToken = response.body.replaceAll("\"", "");
        return fetchTags(mTagType, mTagID, atPrdInfo);
      } else {
        return Future.error(response.statusCode);
      }
    }
  } catch (e) {
    print(e);
    return Future.error(e.toString());
  }

  return sRet;
}

Future<String> fetchUserId(
    String myNumber,
    String myCountryCode,
    String verifyCode,
    String myTypeID,
    String myDeviceID,
    String myAppVer,
    String myNetIP) async {
  String ret = '';
  // String url = "MyStore=" +
  //     Globals.myStoreId +
  //     "&MyNumber=" +
  //     myNumber +
  //     "&MyCountryCode=" +
  //     myCountryCode.replaceAll("+", "") +
  //     "&MyVerifyCode=" +
  //     verifyCode +
  //     "&TypeID=" +
  //     myTypeID +
  //     "&DeviceID=" +
  //     myDeviceID +
  //     "&AppVer=" +
  //     myAppVer +
  //     "&NetIP=" +
  //     myNetIP;
  return ret;
}

Future<int> fetchToken(
    BuildContext context,
    bool reset,
    String myTypeID,
    String myStore,
    String mUserID,
    String mNetIP,
    String mDeviceID,
    String mAppVer,
    String mPass) async {
  int sRet = -1;
  mUserID = mPass.isEmpty ? '' : mUserID;
  var url = Uri.parse("${Globals.baseApiAddressShop}MyKey=${Globals.myPrivateKey}&TypeID=$myTypeID&AccessCD=$myStore&NetIP=$mNetIP&DeviceID=$mDeviceID&UserID=$mUserID&Pass=$mPass&AppVer=$mAppVer");

  try {
    final response = await http.get(
      url,
      headers: <String, String>{'authorization': Globals.basicAuth},
    );

    sRet = response.statusCode;
    if (response.statusCode == 200) {
      // sRet = response.body.replaceAll("\"", "");
      Globals.myToken = response.body.replaceAll("\"", "");

      if (reset) {
        Globals.futureTags = fetchTags(Globals.tagType_SYS, '', false);
        fetchCategories();
        Globals.futureSearch = fetchSearch('', [], 0);

        // loadOpenCart();
        await reloadCart(context, true);
      }
      // Globals.futureProduct = fetchProduct('1009');

    } else {
      print("${response.statusCode} $url");
      ToastNormal(" توکن نامعتبر - سرویس در دسترس نیست :(", context, type: -1);
    }
  } catch (e) {
    ToastNormal(e.toString(), context, type: -1);
    print(e);
  }

  return sRet;
}

Future<List<ClsCategoryGroup>> fetchCategories() async {
  List<ClsCategoryGroup> sRet = [];
  var url = Uri.parse('${Globals.baseApiAddressShop}MyToken=${Globals.myToken}&StoreCategoryGroups=${Globals.myStoreId}&atSPC=TRUE');

  try {
    final response = await http.get(
      url,
      headers: <String, String>{
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': Globals.basicAuth
      },
    );

    if (response.statusCode == 200) {
      print(convert.jsonDecode(response.body));
      List jsonList = convert.jsonDecode(response.body);
      for (int i = 0; i < jsonList.length; i++) {
        sRet.add(ClsCategoryGroup.fromJson(jsonList[i]));
      }
    } else {
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 426) {
        Globals.myToken = response.body.replaceAll("\"", "");
        return fetchCategories();
      } else {
        return Future.error(response.statusCode);
      }
    }
  } catch (e) {
    print(e);
    return Future.error(e.toString());
  }

  return sRet;
}

Future<List<ClsSearch>> fetchSearch(String mTextSearch, List<String>? mListIn,
    [int mCount = 0]) async {
  List<ClsSearch> sRet = [];
  String tInList = '';
  if(mListIn != null && mListIn.isNotEmpty){
    for (var element in mListIn) {
      tInList = "$tInList&InList=$element";
    }
  }
  var url = Uri.parse('${Globals.baseApiAddressShop}MyToken=${Globals.myToken}&StoreSearch=${Globals.myStoreId}&TextSearch=$mTextSearch&TopCount=$mCount$tInList');

  try {
    final response = await http.get(
      url,
      headers: <String, String>{
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': Globals.basicAuth
      },
    );

    if (response.statusCode == 200) {
      print(convert.jsonDecode(response.body));
      List jsonList = convert.jsonDecode(response.body);
      for (int i = 0; i < jsonList.length; i++) {
        sRet.add(ClsSearch.fromJson(jsonList[i]));
      }
    } else {
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 426) {
        Globals.myToken = response.body.replaceAll("\"", "");
        return fetchSearch(mTextSearch, mListIn, mCount);
      } else {
        return Future.error(response.statusCode);
      }
    }
  } catch (e) {
    print(e);
    return Future.error(e.toString());
  }

  Globals.productList = sRet.where((element) => element.typeCode == 3).toList();

  return sRet;
}

Future<List<ClsProductHead>> fetchProduct(String mProductId) async {
  List<ClsProductHead> sRet = [];
  var url = Uri.parse('${Globals.baseApiAddressShop}MyToken=${Globals.myToken}&StoreProduct=${Globals.myStoreId}&ProductId=$mProductId&CustomerId=${Globals.myMemberId}');

  try {
    final response = await http.get(
      url,
      headers: <String, String>{
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': Globals.basicAuth
      },
    );

    if (response.statusCode == 200) {
      print(convert.jsonDecode(response.body));
      List jsonList = convert.jsonDecode(response.body);
      for (int i = 0; i < jsonList.length; i++) {
        sRet.add(ClsProductHead.fromJson(jsonList[0]));
      }
    } else {
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 426) {
        Globals.myToken = response.body.replaceAll("\"", "");
        return fetchProduct(mProductId);
      } else {
        return Future.error(response.statusCode);
      }
    }
  } catch (e) {
    print(e);
    return Future.error(e.toString());
  }

  return sRet;
}

Future<ClsProductInfo> fetchProductInfo(String mProductId) async {
  ClsProductInfo sRet = ClsProductInfo();
  var url = Uri.parse('${Globals.baseApiAddressShop}MyToken=${Globals.myToken}&StoreProductInfo=${Globals.myStoreId}&ProductId=$mProductId&CustomerId=${Globals.myMemberId}');

  try {
    final response = await http.get(
      url,
      headers: <String, String>{
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': Globals.basicAuth
      },
    );

    if (response.statusCode == 200) {
      print(convert.jsonDecode(response.body));
      var jsonList = convert.jsonDecode(response.body);
      sRet = ClsProductInfo.fromJson(jsonList);

    } else {
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 426) {
        Globals.myToken = response.body.replaceAll("\"", "");
        return fetchProductInfo(mProductId);
      } else {
        return Future.error(response.statusCode);
      }
    }
  } catch (e) {
    print(e);
    return Future.error(e.toString());
  }

  return sRet;
}

Future<List<ClsCategoryFull>> fetchCategoryFull(
    String mCategoryId, bool atSPC, bool atOPT, bool atPRD) async {
  List<ClsCategoryFull> sRet = [];
  var url = Uri.parse('${Globals.baseApiAddressShop}MyToken=${Globals.myToken}&StoreCat=${Globals.myStoreId}&CategoryID=$mCategoryId&atSPC=$atSPC&atOPT=$atOPT&atPRD=$atPRD&customerId=${Globals.myMemberId}');

  try {
    final response = await http.get(
      url,
      headers: <String, String>{
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': Globals.basicAuth
      },
    );

    if (response.statusCode == 200) {
      print(convert.jsonDecode(response.body));
      List jsonList = convert.jsonDecode(response.body);
      for (int i = 0; i < jsonList.length; i++) {
        sRet.add(ClsCategoryFull.fromJson(jsonList[0]));
      }
    } else {
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 426) {
        Globals.myToken = response.body.replaceAll("\"", "");
        return fetchCategoryFull(mCategoryId, atSPC, atOPT, atPRD);
      } else {
        return Future.error(response.statusCode);
      }
    }
  } catch (e) {
    print(e);
    return Future.error(e.toString());
  }

  return sRet;
}

Future<List<ClsCart>> fetchCart(CartType cartType,
    {int recCount = 0, int lastRecId = 0}) async {
  List<ClsCart> sRet = [];

  if(Globals.myMemberId.isNotEmpty) {
    var url = Uri.parse(
        '${Globals.baseApiAddressShop}MyToken=${Globals.myToken}&StoreCode=${Globals
            .myStoreId}&CustomerId=${Globals.myMemberId}&CartLevel=${cartType
            .codeAsString}&CountRec=$recCount&LastRecId=$lastRecId');

    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'content-type': 'application/json',
          'accept': 'application/json',
          'authorization': Globals.basicAuth
        },
      );

      if (response.statusCode == 200) {
        print(convert.jsonDecode(response.body));
        List jsonList = convert.jsonDecode(response.body);
        for (int i = 0; i < jsonList.length; i++) {
          sRet.add(ClsCart.fromJson(jsonList[i]));
        }
      } else {
        print(response.statusCode);
        print(response.body);
        if (response.statusCode == 426) {
          Globals.myToken = response.body.replaceAll("\"", "");
          return fetchCart(cartType, recCount: recCount, lastRecId: lastRecId);
        } else if (response.statusCode == 204) {
          return sRet;
        } else {
          return Future.error(response.statusCode);
        }
      }
    } catch (e) {
      print(e);
      return Future.error(e.toString());
    }
  }

  return sRet;
}

Future<http.Response> postCart(BuildContext context, ClsCartex cartex, bool reLoad, {bool setMax = false}) async {
  // List<ClsCartex> listCartex = [];
  // listCartex.add(cartex);
  // var mJsonList = clsCartexToJson(listCartex);
  if (cartex.CustomerId!.trim().length == 0) {
    ToastNormal("لطفا ابتدا با حساب کاربری معتبر وارد شوید", context, type: 0);
    return http.Response('Fail', 403);
  } else {
    var mJson = clsCartexToJson(cartex);

    http.Response response = await http.post(
      Uri.parse("${Globals.baseUrlShop}api/PostBuy?setToMax=$setMax"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json',
        'authorization': Globals.basicAuth
      },
      body: mJson,
    );

    if (response.statusCode == 200) {
      // ToastNormal("به سبد خرید اضافه شد");
      if (reLoad) reloadCart(context, true);
    } else {
      if(response.statusCode == 202){
        ToastNormal("سبد خرید حذف شد!",  context , type: 0);
        if (reLoad) reloadCart(context, true);
      }else if(response.statusCode == 411){
        ToastNormal("محدودیت انتخاب!",  context , type: -1);
      }else {
        ToastNormal("عملیات کامل نشد! ${response.body}",  context , type: -1);
        print(response.body);
      }
    }
    return response;
  }
}

// void loadOpenCart() {
//   Globals.currentCart.clear();
//   Globals.futureCurrentCart = fetchCart(CartTypeEnum.cartOpened);
//   Globals.futureCurrentCart.whenComplete(() {
//     Globals.futureCurrentCart.then((value) {
//       if (value.length == 1) {
//         Globals.currentCart.add(value.first);
//       } else if (value.length > 1) {
//         ToastNormal("بیش از یک سبدخرید فعال است.. با پشتیبانی تماس بگیرید.");
//       } else {
//         // ToastNormal("سبد خالی.");
//       }
//     });
//   });
// }

Future<List<ClsCart>> reloadCart(BuildContext context ,bool refresh) async {
  Globals.currentCart.clear();
  // if(Globals.myMemberId.isNotEmpty)
  {
    Globals.futureCurrentCart = fetchCart(CartTypeEnum.cartOpened);
    if (refresh) {
      await Globals.futureCurrentCart.then((value) {
        refreshCart(context, value);
      });
    }
  }
  return Globals.futureCurrentCart;
}

// void clearCart() {
//   if(Globals.futureCurrentCart){
//
//   }
// }

void refreshCart(BuildContext context, List<ClsCart> value) {
  if (value.length == 1) {
    Globals.currentCart.add(value.first);
    // Globals.currentCart.clear();
    // Globals.currentCart.add(value.first);
  } else if (value.length > 1) {
    ToastNormal("بیش از یک سبدخرید فعال است.. با پشتیبانی تماس بگیرید.",  context, type: -1);
  } else {
    // ToastNormal("سبد خالی.");
  }
}

Future<int> changeCartStatus(String cartId, CartType cartType) async {
  int iRet = -1;
  var url = Uri.parse('${Globals.baseApiAddressShop}MyToken=${Globals.myToken}&StoreCode=${Globals.myStoreId}&OnCartId=$cartId&RequestCode=${cartType.codeAsString}');

  try {
    final response = await http.get(
      url,
      headers: <String, String>{
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': Globals.basicAuth
      },
    );
    iRet = response.statusCode;

    if (response.statusCode == 200) {
      // print(convert.jsonDecode(response.body));
      // loadOpenCart();
      // refreshCart(cartId, cartType);
    } else {
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 426) {
        Globals.myToken = response.body.replaceAll("\"", "");
        return changeCartStatus(cartId, cartType);
      } else {
        return Future.error(response.statusCode);
      }
    }
  } catch (e) {
    print(e);
    return Future.error(e.toString());
  }

  return iRet;
}

// void refreshCart(String cartId, CartType cartType) {
// }

Future<http.Response> postUser(ClsUserSet userSet) async {
  var mJson = clsUserSetToJson(userSet);

  http.Response response = await http.post(
    Uri.parse("${Globals.baseUrlShop}api/PostUser?MyToken=${Globals.myToken}&StoreCode=${Globals.myStoreId}"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'accept': 'application/json',
      'authorization': Globals.basicAuth
    },
    body: mJson,
  );

  if (response.statusCode == 200) {}
  return response;
}
