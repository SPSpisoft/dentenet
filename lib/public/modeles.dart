import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';
import 'package:timezone/timezone.dart';

import '../data/app.dart';


final List<LanguageModel> languages = [
  LanguageModel("English", "en_US"),
  LanguageModel("فارسی", "fa"),
  // LanguageModel("Telugu", "te"),
  // LanguageModel("Urdu", "ur"),
  // LanguageModel("Tamil", "ta"),
  // LanguageModel("Spanish", "es"),
  // LanguageModel("Marathi", "mr"),
  // LanguageModel("Russian", "ru"),
  // LanguageModel("Hindi", "hi"),
  // LanguageModel("French", "fr"),
];

class LanguageModel {
  LanguageModel(
    this.language,
    this.symbol,
  );

  String language;
  String symbol;
}

final List<dateModel> dateTypes = [
  // return [
    dateModel("Gregorian", "M" , null, 'DateGregorian'.tr),
    dateModel("شمسی/Jalali", "J", "fa", 'DatePersian'.tr),
  ];
// }

final List<AgeModel> ageTypes = [
  // return [
  AgeModel(0, "AgeRange".tr, ""),
  AgeModel(1, "BirthdayFull".tr, ""),
    AgeModel(2, "BirthdayYear".tr, ""),
    // AgeModel(4, "OnlyAge".tr, ""),
  ];
// }

// <20 - 20~35 - 35~

// final List<dateModel> dateTypes = [
//   dateModel("Gregorian", "M" , null, 'DateGregorian'.tr),
//   dateModel("شمسی/Jalali", "J", "fa", 'DatePersian'.tr),
// ];

// final List<dateModel> dateTypesPublic = [
//   dateModel("Gregorian", "M" , "en", 'DateGregorian'),
//   dateModel("شمسی/Jalali", "J", "fa", 'DatePersian'),
// ];

class AgeModel {
  AgeModel(
      this.code,
      this.title,
      this.description,
      );

  int code;
  String title;
  String? description;
}

class dateModel {
  dateModel(
      this.dateType,
      this.symbol,
      this.lang,
      this.description,
      );

  String dateType;
  String symbol;
  String? lang;
  String description;
}

class LocationModel {
  String txt;
  Location location;
  LocationModel(this.txt, this.location);
  // @override
  // String toString() {
  //   return '{ ${this.txt}, ${this.location} }';
  // }
}

// class zoneModel {
//   String txt;
//   Location location;
//   LocationModel(this.txt, this.location);
// // @override
// // String toString() {
// //   return '{ ${this.txt}, ${this.location} }';
// // }
// }

class MemberSection implements ExpandableListSection<String> {
  late bool expanded;
  List<String> items = [];
  late String header;
  late String headerName;
  String? imgUrl;
  late String uidMain;
  List<ClsMember> clsMembers = List<ClsMember>.empty(growable: true);

  @override
  List<String> getItems() {
    return items;
  }

  @override
  bool isSectionExpanded() {
    return expanded;
  }

  @override
  void setSectionExpanded(bool expanded) {
    this.expanded = expanded;
  }
}

class TaskModel {

  TaskModel({
    this.netRec,
    this.idRec,
    this.date,
    this.isRemovable,
    this.clsMember,
    this.clsPatientInfo,
    this.mDescription,
    this.attachFiles,
    // required this.tagId,
  });

  int? netRec;
  int? idRec;
  DateTime? date;
  bool? isRemovable;
  ClsMember? clsMember;
  ClsPatientInfo? clsPatientInfo;
  String? mDescription;
  List<PlatformFile>? attachFiles;


// factory ClsTags.fromJson(Map<String, dynamic> json) => ClsTags(
//   netRec: json["NetRec"],
//   idRec: json["IdRec"],
//   storeCode: json["StoreCode"],
//   author: json["Author"],
//   tagType: json["TagType"],
//   tagId: json["TagID"],
//   tagTitle: json["TagTitle"],
//   description: json["Description"],
//   linkShowType: json["LinkShowType"],
//   backColor: json["BackColor"]?? '',
//   statusCode: json["StatusCode"],
//   sort: json["Sort"],
//   logo: json["Logo"]?? -1,
//   logoW: json["Logo_W"]?? -1,
//   logoH: json["Logo_H"]?? -1,
//   logoD: json["Logo_D"]?? -1,
//   logoA: json["Logo_A"]?? '',
//   border: json["Border"]?? -1,
//   borderW: json["Border_W"]?? -1,
//   borderH: json["Border_H"]?? -1,
//   borderD: json["Border_D"]?? -1,
//   borderA: json["Border_A"]?? '',
//   startTime: json["StartTime"]?? '',
//   expTime: json["ExpTime"]?? '',
//   strokeColor: json["StrokeColor"]?? '',
//   bannerUrl: json["BannerUrl"]?? '',
//   backgroundUrl: json["BackgroundUrl"]?? '',
//   lstType: json["LstType"],
//   scriptId: json["ScriptID"],
//   modelShowType: json["ModelShowType"],
//   subset: json["Subset"] == null ? [] : List<ClsTags>.from(json["Subset"].map((x) => ClsTags.fromJson(x))),
//   links: json["Links"] == null ? [] : List<tagLink>.from(json["Links"].map((x) => tagLink.fromJson(x))),
//   prdList: json["PrdList"] == null ? [] : List<ClsProductHead>.from(json["PrdList"].map((x) => ClsProductHead.fromJson(x))),
// );
//
// Map<String, dynamic> toJson() => {
//   "NetRec": netRec,
//   "IdRec": idRec,
//   "StoreCode": storeCode,
//   "Author": author,
//   "TagType": tagType,
//   "TagID": tagId,
//   "TagTitle": tagTitle,
//   "Description": description,
//   "LinkShowType": linkShowType,
//   "BackColor": backColor,
//   "StatusCode": statusCode,
//   "Sort": sort,
//   "Logo": logo,
//   "Logo_W": logoW,
//   "Logo_H": logoH,
//   "Logo_D": logoD,
//   "Logo_A": logoA,
//   "Border": border,
//   "Border_W": borderW,
//   "Border_H": borderH,
//   "Border_D": borderD,
//   "Border_A": borderA,
//   "StartTime": startTime,
//   "ExpTime": expTime,
//   "StrokeColor": strokeColor,
//   "BannerUrl": bannerUrl,
//   "BackgroundUrl": backgroundUrl,
//   "LstType": lstType,
//   "ScriptID": scriptId,
//   "ModelShowType": modelShowType,
//   "Subset": subset == null ? [] : List<dynamic>.from(subset.map((x) => x.toJson())),
//   "Links": links == null ? [] : List<dynamic>.from(links.map((x) => x.toJson())),
//   "PrdList": prdList == null ? [] : List<dynamic>.from(prdList.map((x) => x.toJson())),
// };
}
