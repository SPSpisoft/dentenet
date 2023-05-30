// To parse this JSON data, do
//
//     final clsTags = clsTagsFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'dart:convert';

import 'ClsCartDetail.dart';

List<ClsCart> clsCartFromJson(String str) => List<ClsCart>.from(json.decode(str).map((x) => ClsCart.fromJson(x)));

String clsCartToJson(List<ClsCart> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ClsCart {
  ClsCart({
    required this.CartDetails,
    required this.CartId,
    required this.CartIdValid,
    required this.CountRow,
    required this.CustomerDeviceId,
    required this.CustomerId,
    required this.LevelId,
    required this.NetRec,
    required this.StatusCode,
    required this.StoreCode,
    required this.TotalAmount,
    required this.TotalPrice,
    required this.ValidateCD,
  });

  String CartId;
  int NetRec;
  String ValidateCD;
  int StatusCode;
  String CustomerId;
  String CustomerDeviceId;
  String StoreCode;
  int LevelId;
  String CartIdValid;
  int CountRow;
  double TotalAmount;
  double TotalPrice;
  List<ClsCartDetail> CartDetails;

  factory ClsCart.fromJson(Map<String, dynamic> json) => ClsCart(
    CartId: json["CartId"] ,
    NetRec: json["NetRec"],
    ValidateCD: json["ValidateCD"],
    StatusCode: json["StatusCode"],
    CustomerId: json["CustomerId"],
    CustomerDeviceId: json["CustomerDeviceId"],
    StoreCode: json["StoreCode"],
    LevelId: json["LevelId"],
    CartIdValid: json["CartIdValid"],
    CountRow: json["CountRow"],
    TotalAmount: json["TotalAmount"],
    TotalPrice: json["TotalPrice"],
    CartDetails: List<ClsCartDetail>.from(json["CartDetails"].map((x) => ClsCartDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "CartId": CartId,
    "NetRec": NetRec,
    "ValidateCD": ValidateCD,
    "StatusCode": StatusCode,
    "CustomerId": CustomerId,
    "CustomerDeviceId": CustomerDeviceId,
    "StoreCode": StoreCode,
    "LevelId": LevelId,
    "CartIdValid": CartIdValid,
    "CountRow": CountRow,
    "TotalAmount": TotalAmount,
    "TotalPrice": TotalPrice,
    "CartDetails": CartDetails == null || CartDetails.length == 0 ? [] : List<dynamic>.from(CartDetails.map((x) => x.toJson())),
  };

}
