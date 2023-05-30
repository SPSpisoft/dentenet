import 'package:flutter/cupertino.dart';

import '../public/public_functions.dart';
import '../public/public_variables.dart';
import 'classes/ClsCart.dart';
import 'classes/ClsCartDetail.dart';
import 'classes/ClsCartex.dart';
import 'classes/ClsProductHead.dart';
import 'data_fetch.dart';
import 'package:http/http.dart' as http;

SetTmpCartex(BuildContext context, ClsProductHead? myItemProduct,
    ClsProductInfo myProduct) {
  Globals.TmpCartex = ClsCartex(
    PrdCode: myProduct.id,
    PercentOff: myProduct.percentOff,
    FromDeviceId: Globals.myDeviceId,
    CustomerId: Globals.myMemberId,
    StoreCode: Globals.myStoreId,
    Price: myProduct.price,
    Amount: 0,
    IDMerge: myProduct.idMerge,
  );

  if (Globals.currentCart.length > 0) {
    ClsCart mCurrentCart = Globals.currentCart[0];

    Globals.TmpCartex.CartexId = mCurrentCart.CartId;
    Globals.TmpCartex.TotalAmount = mCurrentCart.TotalAmount;

    double sumOtherAmount = 0;
    double currentAmount = 0;
    if (myItemProduct != null && myItemProduct.prdIDs.isNotEmpty) {
      // List<String> textIds_Split = myItemProduct.prdIDs.split(",").toList();
      // List<String> textIds_Split_trim = [];
      // for (var element in textIds_Split) {textIds_Split_trim.add(element.trim());}

      var clsCartDetail = mCurrentCart.CartDetails.where((element) =>
          element.StatusCode == 0 && element.IDMerge == myItemProduct.idMerge);

      // var clsCartDetail = mCurrentCart.CartDetails.where((element) => element.StatusCode == 0)
      //     .where((element) => textIds_Split_trim.contains(element.PrdCode));
      // .firstWhere((element) => textIds_Split_trim.contains(element.PrdCode));

      if (clsCartDetail.length > 0) {
        sumOtherAmount = 0;
        for (var element in clsCartDetail) {
          sumOtherAmount = sumOtherAmount + element.Amount;
          if (element.PrdCode == myProduct.id) {
            currentAmount = element.Amount;
          }
        }
        // currentAmount = clsCartDetail.singleWhere((element) => element.PrdCode == myProduct.id).Amount;
      }

      Globals.TmpCartex.SumAmount = sumOtherAmount;
      Globals.TmpCartex.Amount = currentAmount;
    } else {
      List<ClsCartDetail> mRow = mCurrentCart.CartDetails.where(
          (element) => element.PrdCode == myProduct.id).toList();
      if (mRow.isNotEmpty) {
        currentAmount = mRow.first.Amount;
        Globals.TmpCartex.Amount = currentAmount;
      }
    }

    List<ClsCartDetail> clsCartDetails = mCurrentCart.CartDetails.where(
            (element) =>
                element.StatusCode == 0 && element.PrdCode == myProduct.id)
        .toList();

    if (clsCartDetails != null && clsCartDetails.length > 0) {
      clsCartDetails.forEach((clsCartDetail) {
        if (clsCartDetail.Price == myProduct.price &&
            clsCartDetail.PercentOff == myProduct.percentOff) {
          Globals.TmpCartex.Amount = clsCartDetail.Amount;
          Globals.TmpCartex.CartDetailID = clsCartDetail.CartDetailId;
        } else {
          if (clsCartDetail.Price != myProduct.price) {
            ToastNormal('تغییر قیمت', context, type: 0);
          } else if (clsCartDetail.PercentOff != myProduct.percentOff) {
            ToastNormal('تغییر درصد تخفیف', context, type: 0);
          }
        }
      });
    }
  }

  // spCartButton.setConfig(
  //     TmpCartex.getTotalAmount(),
  //     TmpCartex.getSumAmount(),
  //     TmpCartex.getAmount(),
  //     myProduct.getInvAvailable(),
  //     myProduct.getSelJump(),
  //     myProduct.getSelMinLimit(),
  //     myProduct.getSelMaxLimit(),
  //     myProduct.isInvFirst());
}

Future<http.Response> setCartex(
    BuildContext context, ClsProductInfo itemProduct, bool firstSel) async {
  if ((firstSel && itemProduct.invFirst) || (!firstSel && itemProduct.invAdd)) {
    if (Globals.currentCart.length == 0) {
      Globals.TmpCartex.ValidateCD = Globals.myToken;
    } else {
      Globals.TmpCartex.ValidateCD = Globals.currentCart[0].ValidateCD;
      Globals.TmpCartex.CartexId = Globals.currentCart[0].CartId;
    }
    Globals.TmpCartex.NewAmount =
        (Globals.TmpCartex.Amount! + itemProduct.selJump);

    return postCart(context, Globals.TmpCartex, false);
  } else {
    // ToastNormal("موجود نیست");
    return http.Response('Fail', 500);
  }
}

Future<http.Response> setCartexWithVal(
    BuildContext context,
    ClsProductInfo itemProduct,
    bool firstSel,
    double newValue,
    bool reverse) async {
  if ((firstSel && itemProduct.invFirst) ||
      (!firstSel && itemProduct.invAdd) ||
      reverse) {
    if (Globals.currentCart.length == 0) {
      Globals.TmpCartex.ValidateCD = Globals.myToken;
    } else {
      Globals.TmpCartex.ValidateCD = Globals.currentCart[0].ValidateCD;
      Globals.TmpCartex.CartexId = Globals.currentCart[0].CartId;
    }
    Globals.TmpCartex.NewAmount = newValue;

    return postCart(context, Globals.TmpCartex, false, setMax: true);
  } else {
    ToastNormal("محدودیت انتخاب", context, type: -1);
    return http.Response('Fail', 500);
  }
}

int checkCart(ClsProductInfo myProduct) {
  ClsCart mCurrentCart = Globals.currentCart[0];
  return mCurrentCart.CartDetails.where((element) =>
          element.PrdCode == myProduct.id && element.StatusCode == 0)
      .toList()
      .length;
}
