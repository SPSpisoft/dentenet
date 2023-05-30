// ignore_for_file: file_names

import 'package:meta/meta.dart';
import 'dart:convert';

List<ClsCategoryGroup> clsCategoryGroupFromJson(String str) => List<ClsCategoryGroup>.from(json.decode(str).map((x) => ClsCategoryGroup.fromJson(x)));

String clsCategoryGroupToJson(List<ClsCategoryGroup> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ClsCategoryGroup {
  ClsCategoryGroup({
    required this.parentCode,
    required this.parentUrl,
    required this.storeCode,
    required this.subGroup,
  });

  String parentCode;
  String parentUrl;
  String storeCode;
  List<SubGroup> subGroup;

  factory ClsCategoryGroup.fromJson(Map<String, dynamic> json) => ClsCategoryGroup(
    parentCode: json["ParentCode"],
    parentUrl: json["ParentUrl"],
    storeCode: json["StoreCode"],
    subGroup: List<SubGroup>.from(json["SubGroup"].map((x) => SubGroup.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ParentCode": parentCode,
    "ParentUrl": parentUrl,
    "StoreCode": storeCode,
    "SubGroup": List<dynamic>.from(subGroup.map((x) => x.toJson())),
  };
}

class SubGroup {
  SubGroup({
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

  factory SubGroup.fromJson(Map<String, dynamic> json) => SubGroup(
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
    spCs: List<Spc>.from(json["SPCs"].map((x) => Spc.fromJson(x))),
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
  };
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
  dynamic ordLevel;
  int spcTypeCode;
  int optIconCode;
  dynamic opTs;

  factory Spc.fromJson(Map<String, dynamic> json) => Spc(
    storeCode: json["StoreCode"],
    catId: json["CatId"],
    catTitle: json["CatTitle"],
    spcCode: json["SpcCode"],
    spcCatTitle: json["SpcCatTitle"],
    catGroup: json["CatGroup"],
    filter: json["Filter"],
    optionCustomer: json["OptionCustomer"],
    toHead: json["toHead"],
    ordLevel: json["OrdLevel"],
    spcTypeCode: json["SpcTypeCode"],
    optIconCode: json["OptIconCode"],
    opTs: json["OPTs"],
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
    "OPTs": opTs,
  };
}
