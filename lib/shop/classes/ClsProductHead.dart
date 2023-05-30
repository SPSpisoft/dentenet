// To parse this JSON data, do
//
//     final clsProductHead = clsProductHeadFromJson(jsonString);

// ignore_for_file: file_names

import 'package:meta/meta.dart';
import 'dart:convert';

List<ClsProductHead> clsProductHeadFromJson(String str) => List<ClsProductHead>.from(json.decode(str).map((x) => ClsProductHead.fromJson(x)));

String clsProductHeadToJson(List<ClsProductHead> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ClsProductHead {
  ClsProductHead({
    required this.storeCode,
    required this.id,
    required this.idMerge,
    required this.parentCode,
    required this.parent,
    required this.title,
    required this.price,
    required this.invFirst,
    required this.percentOff,
    required this.imgUrl,
    required this.sortCat,
    required this.sortPrd,
    required this.priceMax,
    required this.priceMin,
    required this.invIs,
    required this.inventoryTemp,
    required this.priceTemp,
    required this.percentMin,
    required this.percentMax,
    required this.inCartHead,
    required this.prdIDs,
    required this.images,
    required this.spcRep,
    required this.spCs,
    required this.opTs,
    this.inProgress,
  });

  String storeCode;
  String id;
  String idMerge;
  String parentCode;
  String parent;
  String title;
  double price;
  bool invFirst;
  double percentOff;
  String imgUrl;
  int sortCat;
  int sortPrd;
  double? priceMax;
  double? priceMin;
  bool invIs ;
  bool inventoryTemp ;
  bool priceTemp ;
  double? percentMin;
  double? percentMax;
  double inCartHead;
  String prdIDs;
  bool? inProgress = false;
  List<ImagesItem> images;
  List<SpcRep> spcRep;
  List<ClsSpcCatFull> spCs;
  List<ClsProductInfo> opTs;

  factory ClsProductHead.fromJson(Map<String, dynamic> json) => ClsProductHead(
    storeCode: json["StoreCode"],
    id: json["ID"],
    idMerge: json["IDMerge"] ?? '',
    parentCode: json["ParentCode"] ?? '',
    parent: json["Parent"] ?? '',
    title: json["Title"] ?? '',
    price: json["Price"],
    invFirst: json["InvFirst"] ?? false,
    percentOff: json["PercentOff"],
    imgUrl: json["ImgUrl"] ?? '',
    sortCat: json["Sort_Cat"],
    sortPrd: json["Sort_Prd"],
    priceMax: json["PriceMax"],
    priceMin: json["PriceMin"],
    invIs: json["InvIs"] ?? false,
    inventoryTemp: json["InventoryTemp"] ?? false,
    priceTemp: json["PriceTemp"] ?? false,
    percentMin: json["PercentMin"],
    percentMax: json["PercentMax"],
    inCartHead: json["InCartHead"] ?? 0,
    prdIDs: json["PrdIDs"] ?? '',
    images: json["Images"] == null ? [] : List<ImagesItem>.from(json["Images"].map((x) => ImagesItem.fromJson(x))),
    spcRep: json["SpcRep"] == null ? [] : List<SpcRep>.from(json["SpcRep"].map((x) => SpcRep.fromJson(x))),
    spCs: json["SPCs"] == null ? [] : List<ClsSpcCatFull>.from(json["SPCs"].map((x) => ClsSpcCatFull.fromJson(x))),
    opTs: json["OPTs"] == null ? [] : List<ClsProductInfo>.from(json["OPTs"].map((x) => ClsProductInfo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "StoreCode": storeCode,
    "ID": id,
    "IDMerge": idMerge,
    "ParentCode": parentCode,
    "Parent": parent,
    "Title": title,
    "Price": price,
    "InvFirst": invFirst,
    "PercentOff": percentOff,
    "ImgUrl": imgUrl,
    "Sort_Cat": sortCat,
    "Sort_Prd": sortPrd,
    "PriceMax": priceMax,
    "PriceMin": priceMin,
    "InvIs": invIs,
    "InventoryTemp": inventoryTemp,
    "PriceTemp": priceTemp,
    "PercentMin": percentMin,
    "PercentMax": percentMax,
    "PrdIDs": prdIDs,
    "Images": List<dynamic>.from(images.map((x) => x)),
    "SpcRep": List<dynamic>.from(spcRep.map((x) => x)),
    "SPCs": List<dynamic>.from(spCs.map((x) => x.toJson())),
    "OPTs": List<dynamic>.from(opTs.map((x) => x.toJson())),
  };
}

class ImagesItem {
  ImagesItem({
    required this.netRec,
    required this.typeCode ,
    required this.linkId ,
    required this.width ,
    required this.height,
    required this.duration ,
    required this.storeCode ,
    required this.serverUrl,
    required this.statusCode,
    required this.description ,
    required this.idRec,
  });

  int netRec;
  String typeCode;
  String linkId;
  int width;
  int height;
  int duration;
  String storeCode;
  String serverUrl;
  int statusCode;
  String description;
  int idRec;

  factory ImagesItem.fromJson(Map<String, dynamic> json) => ImagesItem(
    netRec: json["NetRec"],
    typeCode: json["TypeCode"] ?? '',
    linkId: json["LinkId"] ?? '',
    width: json["Width"],
    height: json["Height"],
    duration: json["Duration"],
    storeCode: json["StoreCode"],
    serverUrl: json["ServerUrl"] ?? '',
    statusCode: json["StatusCode"],
    description: json["Description"] ?? '',
    idRec: json["IdRec"],
  );

  Map<String, dynamic> toJson() => {
    'NetRec': netRec,
    'TypeCode': typeCode,
    'LinkId': linkId,
    'Width': width,
    'Height': height,
    'Duration': duration,
    'StoreCode': storeCode,
    'ServerUrl': serverUrl,
    'StatusCode': statusCode,
    'Description': description,
    'IdRec': idRec,
  };
}

class SpcRep {
  SpcRep({
    required this.iID,
    required this.spcTitle,
    required this.spcCode,
    required this.optCount,
    required this.valueList,
  });

    String iID;
    String spcTitle;
    String spcCode;
    int optCount;
    String valueList;

  factory SpcRep.fromJson(Map<String, dynamic> json) => SpcRep(
    iID: json["IID"] ?? '',
    spcTitle: json["SpcTitle"] ?? '',
    spcCode: json["SpcCode"] ?? '',
    optCount: json["OptCount"],
    valueList: json["ValueList"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "IID": iID,
    "SpcTitle": spcTitle,
    "SpcCode": spcCode,
    "OptCount": optCount,
    "ValueList": valueList,
  };
}

class ClsProductInfo {
  ClsProductInfo({
    this.netRec = -1,
    this.storeCode = '',
    this.id = '',
    this.title = '',
    this.price = -1,
    this.invAvailable = -1,
    this.invFirst = false,
    this.invAdd = false,
    this.unit = '',
    this.catTitle = '',
    this.statusCode = -1,
    this.parentCode = '',
    this.percentOff = 0,
    this.idMerge = '',
    this.priceTemp = false,
    this.inventoryTemp = false,
    this.selRatio = 0,
    this.setCode = '',
    this.idRec = -1,
    this.sortCat = 0,
    this.sortPrd = 0,
    this.unitNet = '',
    this.unitNetScale = 0,
    this.selMinLimit = -1,
    this.selMaxLimit = -1,
    this.selJump = -1,
    this.inCart,
  });

  int netRec;
  String storeCode;
  String id;
  String title;
  double price;
  double invAvailable;
  bool invFirst;
  bool invAdd;
  String unit;
  String catTitle;
  int statusCode;
  String parentCode;
  double percentOff;
  String idMerge;
  bool priceTemp;
  bool inventoryTemp;
  double selRatio;
  String setCode;
  int idRec;
  int sortCat;
  int sortPrd;
  String unitNet;
  double unitNetScale;
  double selMinLimit;
  double selMaxLimit;
  double selJump;
  double? inCart;

  factory ClsProductInfo.fromJson(Map<String, dynamic> json) => ClsProductInfo(
    netRec: json["NetRec"],
    storeCode: json["StoreCode"],
    id: json["ID"],
    title: json["Title"] ?? '',
    price: json["Price"],
    invAvailable: json["InvAvailable"],
    invFirst: json["InvFirst"],
    invAdd: json["InvAdd"],
    unit: json["Unit"] ?? '',
    catTitle: json["CatTitle"] ?? '',
    statusCode: json["StatusCode"],
    parentCode: json["ParentCode"] ?? '',
    percentOff: json["PercentOff"],
    idMerge: json["IDMerge"] ?? '',
    priceTemp: json["PriceTemp"],
    inventoryTemp: json["InventoryTemp"],
    selRatio: json["SelRatio"],
    setCode: json["SetCode"] ?? '',
    idRec: json["IdRec"],
    sortCat: json["Sort_Cat"],
    sortPrd: json["Sort_Prd"],
    unitNet: json["UnitNet"] ?? '',
    unitNetScale: json["UnitNetScale"],
    selMinLimit: json["SelMinLimit"],
    selMaxLimit: json["SelMaxLimit"],
    selJump: json["SelJump"],
    inCart: json["InCart"]?? 0,
  );

  Map<String, dynamic> toJson() => {
    "NetRec": netRec,
    "StoreCode": storeCode,
    "ID": id,
    "Title": title,
    "Price": price,
    "InvAvailable": invAvailable,
    "InvFirst": invFirst,
    "InvAdd": invAdd,
    "Unit": unit,
    "CatTitle": catTitle,
    "StatusCode": statusCode,
    "ParentCode": parentCode,
    "PercentOff": percentOff,
    "IDMerge": idMerge,
    "PriceTemp": priceTemp,
    "InventoryTemp": inventoryTemp,
    "SelRatio": selRatio,
    "SetCode": setCode,
    "IdRec": idRec,
    "Sort_Cat": sortCat,
    "Sort_Prd": sortPrd,
    "UnitNet": unitNet,
    "UnitNetScale": unitNetScale,
    "SelMinLimit": selMinLimit,
    "SelMaxLimit": selMaxLimit,
    "SelJump": selJump,
    "InCart": inCart,
  };
}

class ClsSpcCatFull {
  ClsSpcCatFull({
    required this.storeCode,
    required this.catId,
    required this.catTitle,
    required this.spcCode,
    required this.spcCatTitle,
    required this.catGroup,
    required this.filter,
    required this.optionCustomer,
    required this.toHead,
    required this.ordLevel,
    required this.spcTypeCode,
    required this.optIconCode,
    required this.spcStrValue,
    required this.lstOpt,
    this.selOpt = -1,
  });

  String storeCode;
  String catId;
  String catTitle;
  String spcCode;
  String spcCatTitle;
  String catGroup;
  bool filter;
  bool optionCustomer;
  bool toHead;
  int? ordLevel;
  int spcTypeCode;
  int optIconCode;
  String spcStrValue;
  List<ClsPrdSpcOpt> lstOpt;

  late int selOpt = -1;

  factory ClsSpcCatFull.fromJson(Map<String, dynamic> json) => ClsSpcCatFull(
    storeCode: json["StoreCode"],
    catId: json["CatId"],
    catTitle: json["CatTitle"],
    spcCode: json["SpcCode"],
    spcCatTitle: json["SpcCatTitle"],
    catGroup: json["CatGroup"],
    filter: json["Filter"],
    optionCustomer: json["OptionCustomer"],
    toHead: json["toHead"],
    ordLevel: json["OrdLevel"] ?? -1,
    spcTypeCode: json["SpcTypeCode"],
    optIconCode: json["OptIconCode"],
    spcStrValue: json["SpcStrValue"] ?? '',
    lstOpt: json["LstOpt"] == null ? [] : List<ClsPrdSpcOpt>.from(json["LstOpt"].map((x) => ClsPrdSpcOpt.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "StoreCode": storeCode,
    "CatId": catId,
    "CatTitle": catTitle,
    "SpcCode": spcCode,
    "SpcCatTitle": spcCatTitle,
    "CatGroup": catGroup,
    "Filter": filter,
    "OptionCustomer": optionCustomer,
    "toHead": toHead,
    "OrdLevel": ordLevel,
    "SpcTypeCode": spcTypeCode,
    "OptIconCode": optIconCode,
    "SpcStrValue": spcStrValue,
    "LstOpt": lstOpt ,
  };
}

class ClsPrdSpcOpt {
  ClsPrdSpcOpt({
    required this.optCode,
    required this.optTitle,
    required this.lstPrd,
    this.disable = false,
  });

  String optCode;
  String optTitle;
  bool disable;
  List<String> lstPrd;

  factory ClsPrdSpcOpt.fromJson(Map<String, dynamic> json) => ClsPrdSpcOpt(
    optCode: json["OptCode"],
    optTitle: json["OptTitle"],
    lstPrd: List<String>.from(json["LstPrd"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "OptCode": optCode,
    "OptTitle": optTitle,
    "LstPrd": List<dynamic>.from(lstPrd.map((x) => x)),
  };
}

class ArrayModel {
  int code;
  int selOpt;
  List<String> list;

  ArrayModel(this.code, this.selOpt, this.list);
}