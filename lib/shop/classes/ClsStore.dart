// ignore_for_file: file_names

import 'dart:convert';

List<ClsStore> clsStoreFromJson(String str) =>
    List<ClsStore>.from(json.decode(str).map((x) => ClsStore.fromJson(x)));

String clsStoreToJson(List<ClsStore> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ClsStore {
  ClsStore({
    required this.netRec,
    required this.uid,
    required this.faName,
    required this.enName,
    required this.logo,
    required this.sColor,
    required this.banner,
    required this.sGroup,
    required this.category,
    required this.description,
    required this.status,
    required this.config,
    required this.statusCode,
    required this.cSort,
    required this.type,
    required this.url,
    required this.path,
    required this.deviceUid,
    required this.isConnect,
    required this.appVer,
    required this.branches,
    required this.slides,
  });

  int netRec;
  String uid;
  String faName;
  String enName;
  String logo;
  String sColor;
  String banner;
  String sGroup;
  String category;
  String description;
  String status;
  String config;
  int statusCode;
  int cSort;
  String type;
  String url;
  String path;
  String deviceUid;
  String appVer;
  bool isConnect;
  List<Branch> branches;
  List<Slide> slides;

  factory ClsStore.fromJson(Map<String, dynamic> json) =>
      ClsStore(
        netRec: json["NetRec"],
        uid: json["UID"],
        faName: json["FaName"],
        enName: json["EnName"],
        logo: json["Logo"],
        sColor: json["SColor"],
        banner: json["Banner"],
        sGroup: json["sGroup"],
        category: json["Category"],
        description: json["Description"],
        status: json["Status"],
        config: json["Config"],
        statusCode: json["StatusCode"],
        cSort: json["cSort"],
        type: json["Type"],
        url: json["Url"],
        appVer: json["AppVer"],
        path: json["Path"],
        deviceUid: json["DeviceUID"],
        isConnect: json["IsConnect"],
        branches: json["Branches"] != null ? List<Branch>.from(
            json["Branches"].map((x) => Branch.fromJson(x))) : [],
        slides: json["Slides"] != null ? List<Slide>.from(
            json["Slides"].map((x) => Slide.fromJson(x))) : [],
      );

  Map<String, dynamic> toJson() =>
      {
        "NetRec": netRec,
        "UID": uid,
        "FaName": faName,
        "EnName": enName,
        "Logo": logo,
        "SColor": sColor,
        "Banner": banner,
        "sGroup": sGroup,
        "Category": category,
        "Description": description,
        "Status": status,
        "Config": config,
        "StatusCode": statusCode,
        "cSort": cSort,
        "Type": type,
        "Url": url,
        "AppVer": appVer,
        "Path": path,
        "DeviceUID": deviceUid,
        "IsConnect": isConnect,
        "Branches": List<dynamic>.from(branches.map((x) => x.toJson())),
        "Slides": List<dynamic>.from(slides.map((x) => x.toJson())),
      };
}

class Branch {
  Branch({
    required this.id,
    required this.uid,
    required this.hid,
    required this.name,
    required this.manager,
    required this.city,
    required this.address,
    required this.location,
    required this.status,
    required this.cSort,
    required this.comus,
  });

  int id;
  String uid;
  String hid;
  String name;
  String manager;
  String city;
  String address;
  String location;
  String status;
  int cSort;
  List<Comus> comus;

  factory Branch.fromJson(Map<String, dynamic> json) =>
      Branch(
        id: json["Id"],
        uid: json["UID"],
        hid: json["HID"],
        name: json["Name"],
        manager: json["Manager"],
        city: json["City"],
        address: json["Address"],
        location: json["Location"],
        status: json["Status"],
        cSort: json["cSort"],
        comus: List<Comus>.from(json["Comus"].map((x) => Comus.fromJson(x))),
      );

  Map<String, dynamic> toJson() =>
      {
        "Id": id,
        "UID": uid,
        "HID": hid,
        "Name": name,
        "Manager": manager,
        "City": city,
        "Address": address,
        "Location": location,
        "Status": status,
        "cSort": cSort,
        "Comus": List<dynamic>.from(comus.map((x) => x.toJson())),
      };
}

class Comus {
  Comus({
    required this.tmpUid,
    required this.id,
    required this.uid,
    required this.hid,
    required this.title,
    required this.type,
    required this.logo,
    required this.value,
    required this.cSort,
    required this.link,
    required this.crtTime,
    required this.updTime,
  });

  dynamic tmpUid;
  int id;
  String uid;
  String hid;
  String title;
  String type;
  String logo;
  String value;
  int cSort;
  String link;
  DateTime crtTime;
  DateTime updTime;

  factory Comus.fromJson(Map<String, dynamic> json) =>
      Comus(
        tmpUid: json["TmpUID"],
        id: json["Id"],
        uid: json["UID"],
        hid: json["HID"],
        title: json["Title"],
        type: json["Type"],
        logo: json["Logo"],
        value: json["Value"],
        cSort: json["cSort"],
        link: json["Link"],
        crtTime: DateTime.parse(json["CrtTime"]),
        updTime: DateTime.parse(json["UpdTime"]),
      );

  Map<String, dynamic> toJson() =>
      {
        "TmpUID": tmpUid,
        "Id": id,
        "UID": uid,
        "HID": hid,
        "Title": title,
        "Type": type,
        "Logo": logo,
        "Value": value,
        "cSort": cSort,
        "Link": link,
        "CrtTime": crtTime.toIso8601String(),
        "UpdTime": updTime.toIso8601String(),
      };
}

class Slide {
  Slide({
    required this.netRec,
    required this.inactive,
    required this.parentId,
    required this.title,
    required this.subTitle,
    required this.banUrl,
    required this.banDuration,
    required this.banStartTime,
    required this.banExpTime,
    required this.banAnimCode,
    required this.banUserCode,
    required this.banLevel,
    required this.banTaskCode,
    required this.banTaskLink,
    required this.storeCode,
    required this.statusCode,
  });

  int netRec;
  bool inactive;
  String parentId;
  String title;
  String subTitle;
  String banUrl;
  int banDuration;
  dynamic banStartTime;
  dynamic banExpTime;
  int banAnimCode;
  int banUserCode;
  int banLevel;
  int banTaskCode;
  String banTaskLink;
  String storeCode;
  int statusCode;

  factory Slide.fromJson(Map<String, dynamic> json) =>
      Slide(
        netRec: json["NetRec"],
        inactive: json["Inactive"],
        parentId: json["ParentID"],
        title: json["Title"],
        subTitle: json["SubTitle"],
        banUrl: json["BanUrl"],
        banDuration: json["BanDuration"],
        banStartTime: json["BanStartTime"],
        banExpTime: json["BanExpTime"],
        banAnimCode: json["BanAnimCode"],
        banUserCode: json["BanUserCode"],
        banLevel: json["BanLevel"],
        banTaskCode: json["BanTaskCode"],
        banTaskLink: json["BanTaskLink"],
        storeCode: json["StoreCode"],
        statusCode: json["StatusCode"],
      );

  Map<String, dynamic> toJson() =>
      {
        "NetRec": netRec,
        "Inactive": inactive,
        "ParentID": parentId,
        "Title": title,
        "SubTitle": subTitle,
        "BanUrl": banUrl,
        "BanDuration": banDuration,
        "BanStartTime": banStartTime,
        "BanExpTime": banExpTime,
        "BanAnimCode": banAnimCode,
        "BanUserCode": banUserCode,
        "BanLevel": banLevel,
        "BanTaskCode": banTaskCode,
        "BanTaskLink": banTaskLink,
        "StoreCode": storeCode,
        "StatusCode": statusCode,
      };
}
