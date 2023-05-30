// To parse this JSON data, do
//
//     final clsTags = clsTagsFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'dart:convert';

import 'ClsProductHead.dart';

List<ClsTags> clsTagsFromJson(String str) => List<ClsTags>.from(json.decode(str).map((x) => ClsTags.fromJson(x)));

String clsTagsToJson(List<ClsTags> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ClsTags {
  ClsTags({
    required this.netRec,
    required this.idRec,
    required this.storeCode,
    required this.author,
    required this.tagType,
    required this.tagId,
    required this.tagTitle,
    required this.description,
    required this.linkShowType,
    required this.backColor,
    required this.statusCode,
    required this.sort,
    required this.logo,
    required this.logoW,
    required this.logoH,
    required this.logoD,
    required this.logoA,
    required this.border,
    required this.borderW,
    required this.borderH,
    required this.borderD,
    required this.borderA,
    required this.startTime,
    required this.expTime,
    required this.strokeColor,
    required this.bannerUrl,
    required this.backgroundUrl,
    required this.lstType,
    required this.scriptId,
    required this.modelShowType,
    required this.subset,
    required this.links,
    required this.prdList,
  });

  int netRec;
  int idRec;
  String storeCode;
  String author;
  String tagType;
  String tagId;
  String tagTitle;
  String description;
  int linkShowType;
  String backColor;
  int statusCode;
  int sort;
  int logo;
  int logoW;
  int logoH;
  int logoD;
  String logoA;
  int border;
  int borderW;
  int borderH;
  int borderD;
  String borderA;
  dynamic startTime;
  dynamic expTime;
  String strokeColor;
  String bannerUrl;
  String backgroundUrl;
  int lstType;
  String scriptId;
  int modelShowType;
  List<ClsTags> subset;
  List<tagLink> links;
  List<ClsProductHead> prdList;

  factory ClsTags.fromJson(Map<String, dynamic> json) => ClsTags(
    netRec: json["NetRec"],
    idRec: json["IdRec"],
    storeCode: json["StoreCode"],
    author: json["Author"],
    tagType: json["TagType"],
    tagId: json["TagID"],
    tagTitle: json["TagTitle"],
    description: json["Description"],
    linkShowType: json["LinkShowType"],
    backColor: json["BackColor"]?? '',
    statusCode: json["StatusCode"],
    sort: json["Sort"],
    logo: json["Logo"]?? -1,
    logoW: json["Logo_W"]?? -1,
    logoH: json["Logo_H"]?? -1,
    logoD: json["Logo_D"]?? -1,
    logoA: json["Logo_A"]?? '',
    border: json["Border"]?? -1,
    borderW: json["Border_W"]?? -1,
    borderH: json["Border_H"]?? -1,
    borderD: json["Border_D"]?? -1,
    borderA: json["Border_A"]?? '',
    startTime: json["StartTime"]?? '',
    expTime: json["ExpTime"]?? '',
    strokeColor: json["StrokeColor"]?? '',
    bannerUrl: json["BannerUrl"]?? '',
    backgroundUrl: json["BackgroundUrl"]?? '',
    lstType: json["LstType"],
    scriptId: json["ScriptID"],
    modelShowType: json["ModelShowType"],
    subset: json["Subset"] == null ? [] : List<ClsTags>.from(json["Subset"].map((x) => ClsTags.fromJson(x))),
    links: json["Links"] == null ? [] : List<tagLink>.from(json["Links"].map((x) => tagLink.fromJson(x))),
    prdList: json["PrdList"] == null ? [] : List<ClsProductHead>.from(json["PrdList"].map((x) => ClsProductHead.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "NetRec": netRec,
    "IdRec": idRec,
    "StoreCode": storeCode,
    "Author": author,
    "TagType": tagType,
    "TagID": tagId,
    "TagTitle": tagTitle,
    "Description": description,
    "LinkShowType": linkShowType,
    "BackColor": backColor,
    "StatusCode": statusCode,
    "Sort": sort,
    "Logo": logo,
    "Logo_W": logoW,
    "Logo_H": logoH,
    "Logo_D": logoD,
    "Logo_A": logoA,
    "Border": border,
    "Border_W": borderW,
    "Border_H": borderH,
    "Border_D": borderD,
    "Border_A": borderA,
    "StartTime": startTime,
    "ExpTime": expTime,
    "StrokeColor": strokeColor,
    "BannerUrl": bannerUrl,
    "BackgroundUrl": backgroundUrl,
    "LstType": lstType,
    "ScriptID": scriptId,
    "ModelShowType": modelShowType,
    "Subset": subset == null ? [] : List<dynamic>.from(subset.map((x) => x.toJson())),
    "Links": links == null ? [] : List<dynamic>.from(links.map((x) => x.toJson())),
    "PrdList": prdList == null ? [] : List<dynamic>.from(prdList.map((x) => x.toJson())),
  };
}

class tagLink {
  tagLink({
    required this.id,
    required this.typeCode,
    required this.childType,
    required this.title,
    required this.img,
    required this.imgLink,
    required this.imgUrl,
    required this.parentUrl,
    required this.tagId,
    required this.childId,
    required this.sortLevel,
    required this.description,
    required this.prdList,
  });

  String id;
  dynamic typeCode;
  int childType;
  String title;
  dynamic img;
  int imgLink;
  String imgUrl;
  String parentUrl;
  String tagId;
  dynamic childId;
  int sortLevel;
  String? description;
  List<ClsProductHead> prdList;

  factory tagLink.fromJson(Map<String, dynamic> json) => tagLink(
    id: json["ID"],
    typeCode: json["TypeCode"],
    childType: json["ChildType"],
    title: json["Title"],
    img: json["Img"],
    imgLink: json["ImgLink"],
    imgUrl: json["ImgUrl"],
    parentUrl: json["ParentUrl"] ?? '',
    tagId: json["TagId"],
    childId: json["ChildId"],
    sortLevel: json["SortLevel"],
    description: json["Description"],
    prdList: json["PrdList"] == null ? [] : List<ClsProductHead>.from(json["PrdList"].map((x) => ClsProductHead.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "TypeCode": typeCode,
    "ChildType": childType,
    "Title": title,
    "Img": img,
    "ImgLink": imgLink,
    "ImgUrl": imgUrl,
    "ParentUrl": parentUrl,
    "TagId": tagId,
    "ChildId": childId,
    "SortLevel": sortLevel,
    "Description": description,
    "PrdList": prdList,
  };
}

//   factory ClsTags.fromJson(Map<String, dynamic> json) => ClsTags(
//     netRec: json["NetRec"],
//     idRec: json["IdRec"],
//     storeCode: json["StoreCode"],
//     author: json["Author"],
//     tagType: json["TagType"],
//     tagId: json["TagID"],
//     tagTitle: json["TagTitle"],
//     description: json["Description"],
//     linkShowType: json["LinkShowType"],
//     backColor: json["BackColor"],
//     statusCode: json["StatusCode"],
//     sort: json["Sort"],
//     logo: json["Logo"],
//     logoW: json["Logo_W"],
//     logoH: json["Logo_H"],
//     logoD: json["Logo_D"],
//     logoA: json["Logo_A"],
//     border: json["Border"],
//     borderW: json["Border_W"],
//     borderH: json["Border_H"],
//     borderD: json["Border_D"],
//     borderA: json["Border_A"],
//     startTime: json["StartTime"],
//     expTime: json["ExpTime"],
//     strokeColor: json["StrokeColor"],
//     bannerUrl: json["BannerUrl"],
//     backgroundUrl: json["BackgroundUrl"],
//     lstType: json["LstType"],
//     scriptId: json["ScriptID"],
//     modelShowType: json["ModelShowType"],
//     subset: json["Subset"] ?? [],
//     links: json["Links"] ?? [],
//     prdList: json["PrdList"] ?? [],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "NetRec": netRec,
//     "IdRec": idRec,
//     "StoreCode": storeCode,
//     "Author": author,
//     "TagType": tagType,
//     "TagID": tagId,
//     "TagTitle": tagTitle,
//     "Description": description,
//     "LinkShowType": linkShowType,
//     "BackColor": backColor,
//     "StatusCode": statusCode,
//     "Sort": sort,
//     "Logo": logo,
//     "Logo_W": logoW,
//     "Logo_H": logoH,
//     "Logo_D": logoD,
//     "Logo_A": logoA,
//     "Border": border,
//     "Border_W": borderW,
//     "Border_H": borderH,
//     "Border_D": borderD,
//     "Border_A": borderA,
//     "StartTime": startTime,
//     "ExpTime": expTime,
//     "StrokeColor": strokeColor,
//     "BannerUrl": bannerUrl,
//     "BackgroundUrl": backgroundUrl,
//     "LstType": lstType,
//     "ScriptID": scriptId,
//     "ModelShowType": modelShowType,
//     "Subset": subset,
//     "Links": links,
//     "PrdList": prdList,
//   };
// }
//
//
// class ClsTagLink {
//   ClsTagLink({
//     required this.id,
//     required this.typeCode,
//     required this.childType,
//     required this.title,
//     required this.img,
//     required this.imgLink,
//     required this.imgUrl,
//     required this.tagId,
//     required this.childId,
//     required this.sortLevel,
//     required this.description,
//     required this.prdList,
//   });
//
//   String id;
//   String typeCode;
//   int childType;
//   String title;
//   ByteData img;
//   int imgLink;
//   String imgUrl;
//   String tagId;
//   String childId;
//   int sortLevel;
//   String description;
//   List<ClsProductHead> prdList;
//
//   factory ClsTagLink.fromJson(Map<String, dynamic> json) => ClsTagLink(
//     id: json["Id"],
//     typeCode: json["TypeCode"],
//     childType: json["ChildType"],
//     title: json["Title"],
//     img: json["Img"] ?? [],
//     imgLink: json["ImgLink"],
//     imgUrl: json["ImgUrl"],
//     tagId: json["TagId"],
//     childId: json["ChildId"],
//     sortLevel: json["SortLevel"],
//     description: json["Description"],
//     prdList: json["PrdList"] ?? [],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "Id": id,
//     "TypeCode": typeCode,
//     "ChildType": childType,
//     "Title": title,
//     "Img": img,
//     "ImgLink": imgLink,
//     "ImgUrl": imgUrl,
//     "TagId": tagId,
//     "ChildId": childId,
//     "SortLevel": sortLevel,
//     "Description": description,
//     "PrdList": prdList,
//   };
// }
