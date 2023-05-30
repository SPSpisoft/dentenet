// To parse this JSON data, do
//
//     final clsTags = clsTagsFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'dart:convert';

List<ClsCartDetail> clsTagsFromJson(String str) => List<ClsCartDetail>.from(json.decode(str).map((x) => ClsCartDetail.fromJson(x)));

String clsTagsToJson(List<ClsCartDetail> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ClsCartDetail {
  ClsCartDetail({
    required this.StoreCode,
    required this.StatusCode,
    required this.CartId,
    required this.Amount,
    required this.CartDetailId,
    required this.CrtTime_Detail,
    required this.Description,
    // required this.Detail,
    required this.IDMerge,
    // required this.IdRec,
    required this.Inquiry,
    required this.InvAdd,
    required this.InvAvailable,
    required this.Parent,
    required this.ParentCode,
    required this.PercentOff,
    required this.PrdCode,
    required this.Price,
    required this.Price4C,
    required this.PricePlus,
    required this.PricePlusDesc,
    required this.PriceTotal,
    required this.SelJump,
    required this.SelMaxLimit,
    required this.SelMinLimit,
    required this.SumAmount,
    required this.Title,
    required this.UnitNet,
    required this.UpdTime_Detail,
  });

  // int IdRec;
  // int Detail;
  String CartId;
  String CartDetailId;
  String ParentCode;
  String Parent;
  String PrdCode;
  String IDMerge;
  String Title;
  double Price;
  double Price4C;
  double PricePlus;
  double PriceTotal;
  String PricePlusDesc;
  double PercentOff;
  bool Inquiry;
  double Amount;
  double SumAmount;
  double SelMinLimit;
  double SelMaxLimit;
  double SelJump;
  double InvAvailable;
  bool InvAdd;
  String? UnitNet;
  String Description;
  String StoreCode;
  DateTime? CrtTime_Detail;
  DateTime? UpdTime_Detail;
  int StatusCode;

  factory ClsCartDetail.fromJson(Map<String, dynamic> json) => ClsCartDetail(
        // IdRec: json["IdRec"],
        // Detail: json["Detail"],
        CartId: json["CartId"],
        CartDetailId: json["CartDetailId"],
        ParentCode: json["ParentCode"],
        Parent: json["Parent"],
        PrdCode: json["PrdCode"],
        IDMerge: json["IDMerge"],
        Title: json["Title"],
        Price: json["Price"],
        Price4C: json["Price4C"],
        PricePlus: json["PricePlus"],
        PriceTotal: json["PriceTotal"],
        PricePlusDesc: json["PricePlusDesc"],
        PercentOff: json["PercentOff"],
        Inquiry: json["Inquiry"],
        Amount: json["Amount"],
        SumAmount: json["SumAmount"],
        SelMinLimit: json["SelMinLimit"],
        SelMaxLimit: json["SelMaxLimit"],
        SelJump: json["SelJump"],
        InvAvailable: json["InvAvailable"],
        InvAdd: json["InvAdd"],
        UnitNet: json["UnitNet"],
        Description: json["Description"],
        StoreCode: json["StoreCode"],
        CrtTime_Detail: DateTime.parse(json["CrtTime_Detail"]),
        // json["CrtTime_Detail"],
        UpdTime_Detail: DateTime.parse(json["UpdTime_Detail"]),
    // json["UpdTime_Detail"],
        StatusCode: json["StatusCode"],
      );

  Map<String, dynamic> toJson() => {
        // "IdRec": IdRec,
        // "Detail": Detail,
        "CartId": CartId,
        "CartDetailId": CartDetailId,
        "ParentCode": ParentCode,
        "Parent": Parent,
        "PrdCode": PrdCode,
        "IDMerge": IDMerge,
        "Title": Title,
        "Price": Price,
        "Price4C": Price4C,
        "PricePlus": PricePlus,
        "PriceTotal": PriceTotal,
        "PricePlusDesc": PricePlusDesc,
        "PercentOff": PercentOff,
        "Inquiry": Inquiry,
        "Amount": Amount,
        "SumAmount": SumAmount,
        "SelMinLimit": SelMinLimit,
        "SelMaxLimit": SelMaxLimit,
        "SelJump": SelJump,
        "InvAvailable": InvAvailable,
        "InvAdd": InvAdd,
        "UnitNet": UnitNet,
        "Description": Description,
        "StoreCode": StoreCode,
        "CrtTime_Detail": CrtTime_Detail,
        "UpdTime_Detail": UpdTime_Detail,
        "StatusCode": StatusCode,
      };
}
