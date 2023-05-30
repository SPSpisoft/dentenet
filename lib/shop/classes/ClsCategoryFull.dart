import 'dart:convert';

import 'ClsProductHead.dart';

List<ClsCategoryFull> clsCategoryFullFromJson(String str) => List<ClsCategoryFull>.from(json.decode(str).map((x) => ClsCategoryFull.fromJson(x)));

String clsCategoryFullToJson(List<ClsCategoryFull> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ClsCategoryFull {
  ClsCategoryFull({
    required this.netRec,
    required this.storeCode,
    required this.id,
    required this.title,
    required this.parentCode,
    required this.bannerUrl,
    required this.logo,
    required this.sortLevel,
    required this.description,
    required this.statusCode,
    required this.idRec,
    required this.spCs,
    required this.prDs,
  });

  int netRec;
  String storeCode;
  String id;
  String title;
  String parentCode;
  String bannerUrl;
  int logo;
  int sortLevel;
  String description;
  int statusCode;
  int idRec;
  List<Spc> spCs;
  List<ClsProductHead> prDs;

  factory ClsCategoryFull.fromJson(Map<String, dynamic> json) => ClsCategoryFull(
    netRec: json["NetRec"],
    storeCode: json["StoreCode"],
    id: json["ID"],
    title: json["Title"],
    parentCode: json["ParentCode"],
    bannerUrl: json["BannerUrl"],
    logo: json["Logo"],
    sortLevel: json["SortLevel"],
    description: json["Description"],
    statusCode: json["StatusCode"],
    idRec: json["IdRec"],
    spCs: json["SPCs"] == null ? [] : List<Spc>.from(json["SPCs"].map((x) => Spc.fromJson(x))),
    prDs: json["PRDs"] == null ? [] : List<ClsProductHead>.from(json["PRDs"].map((x) => ClsProductHead.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "NetRec": netRec,
    "StoreCode": storeCode,
    "ID": id,
    "Title": title,
    "ParentCode": parentCode,
    "BannerUrl": bannerUrl,
    "Logo": logo,
    "SortLevel": sortLevel,
    "Description": description,
    "StatusCode": statusCode,
    "IdRec": idRec,
    "SPCs": List<dynamic>.from(spCs.map((x) => x.toJson())),
    "PRDs": List<dynamic>.from(prDs.map((x) => x.toJson())),
  };

  static ClsCategoryFull clone(ClsCategoryFull data) {
    return ClsCategoryFull(netRec: data.netRec,
        storeCode: data.storeCode,
        id: data.id,
        title: data.title,
        parentCode: data.parentCode,
        bannerUrl: data.bannerUrl,
        logo: data.logo,
        sortLevel: data.sortLevel,
        description: data.description,
        statusCode: data.statusCode,
        idRec: data.idRec,
        spCs: List.of(data.spCs),
        prDs: List.of(data.prDs));
  }
}

class Spc {
  Spc({
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
    required this.opTs,
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
  List<Opt> opTs;

  factory Spc.fromJson(Map<String, dynamic> json) => Spc(
    storeCode: json["StoreCode"],
    catId: json["CatId"]?? "",
    catTitle: json["CatTitle"]?? "",
    spcCode: json["SpcCode"]?? "",
    spcCatTitle: json["SpcCatTitle"]?? "",
    catGroup: json["CatGroup"]?? "",
    filter: json["Filter"]?? false,
    optionCustomer: json["OptionCustomer"]?? false,
    toHead: json["toHead"]?? false,
    ordLevel: json["OrdLevel"],
    spcTypeCode: json["SpcTypeCode"],
    optIconCode: json["OptIconCode"],
    opTs: json["OPTs"] == null ? [] : List<Opt>.from(json["OPTs"].map((x) => Opt.fromJson(x))),
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
    "OPTs": List<dynamic>.from(opTs.map((x) => x.toJson())),
  };
}

class Opt {
  Opt({
    required this.spcCode,
    required this.optCode,
    required this.optTitle,
    required this.optIco,
    required this.id,
    required this.idMerge,
    required this.storeCode,
    required this.parentCode,
    required this.img,
    this.doubleValue,
  });

  String spcCode;
  String optCode;
  String optTitle;
  int optIco;
  String? id;
  String? idMerge;
  String storeCode;
  String parentCode;
  double? doubleValue;
  dynamic img;

  factory Opt.fromJson(Map<String, dynamic> json) => Opt(
    spcCode: json["SpcCode"],
    optCode: json["OptCode"],
    optTitle: json["OptTitle"] ?? "",
    optIco: json["OptIco"],
    id: json["ID"]?? "",
    idMerge: json["IDMerge"]?? "",
    storeCode: json["StoreCode"],
    parentCode: json["ParentCode"],
    img: json["Img"],
  );

  Map<String, dynamic> toJson() => {
    "SpcCode": spcCode,
    "OptCode": optCode,
    "OptTitle": optTitle,
    "OptIco": optIco,
    "ID": id,
    "IDMerge": idMerge,
    "StoreCode": storeCode,
    "ParentCode": parentCode,
    "Img": img,
  };
}
