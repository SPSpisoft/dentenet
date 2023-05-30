// To parse this JSON data, do
//
//     final clsTags = clsTagsFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'dart:convert';

import '../../../public/public_variables.dart';

// List<ClsCart> clsCartFromJson(String str) => List<ClsCart>.from(json.decode(str).map((x) => ClsCart.fromJson(x)));

String clsListCartexToJson(List<ClsCartex> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

String clsCartexToJson(ClsCartex data) => json.encode(data.toJson());

class ClsCartex {
  ClsCartex({
    this.Status,
    this.CartexId,
    this.FromDeviceId,
    this.CustomerId ,
    this.StoreCode,
    this.ValidateCD,
    this.CartDetailID,
    this.IDMerge,
    this.PrdCode,
    this.Amount,
    this.NewAmount,
    this.Price,
    this.PercentOff,
    this.SumAmount,
    this.TotalAmount,
    this.InvAvailable,
    this.InvAdd,
  });

  int? Status;
  String? ValidateCD;
  String? CartexId;
  String? FromDeviceId = Globals.myDeviceId;
  String? CustomerId = Globals.myMemberId;
  String? StoreCode = Globals.myStoreId;
  String? CartDetailID;
  String? IDMerge;
  String? PrdCode;
  double? Amount;
  double? NewAmount;
  double? Price;
  double? PercentOff;
  double? SumAmount;
  double? TotalAmount;
  double? InvAvailable;
  bool? InvAdd;

  Map<String, dynamic> toJson() => {
        "Status": Status,
        "ValidateCD": ValidateCD,
        "CartexId": CartexId,
        "FromDeviceId": FromDeviceId,
        "CustomerId": CustomerId,
        "CartDetailID": CartDetailID,
        "StoreCode": StoreCode,
        "IDMerge": IDMerge,
        "PrdCode": PrdCode,
        "Amount": Amount,
        "TotalAmount": TotalAmount,
        "NewAmount": NewAmount,
        "Price": Price,
        "PercentOff": PercentOff,
        "SumAmount": SumAmount,
        "InvAdd": InvAdd,
        "InvAvailable": InvAvailable,
      };
}
