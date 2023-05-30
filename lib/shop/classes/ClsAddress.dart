// To parse this JSON data, do
//
//     final clsTags = clsTagsFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'dart:convert';

import '../../../public/public_variables.dart';
import 'ClsCartDetail.dart';

// List<ClsCart> clsCartFromJson(String str) => List<ClsCart>.from(json.decode(str).map((x) => ClsCart.fromJson(x)));

String clsListCartexToJson(List<ClsAddress> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

String clsCartexToJson(ClsAddress data) => json.encode(data.toJson());

class ClsAddress {
  ClsAddress({
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

//   public string TmpUID { get; set; }
// public int Id { get; set; }
// public string UID { get; set; }
// public string HID { get; set; }
// public string Title { get; set; }
// public string sLocation { get; set; }
// public string CountryId { get; set; }
// public string sCountry { get; set; }
// public string sState { get; set; }
// public string sCity { get; set; }
// public string sQuarter { get; set; }
// public string sAddress { get; set; }
// public string sPlaque { get; set; }
// public string sUnit { get; set; }
// public string sPostCD { get; set; }
// public DateTime CrtTime { get; set; }
// public DateTime UpdTime { get; set; }
// public List<ClsCommunication> AddComus { get; set; }

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
