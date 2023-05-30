import 'dart:collection';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:realm/realm.dart';  // import realm package
import 'package:json_annotation/json_annotation.dart';

part 'app.g.dart'; // declare a part file.

// @RealmModel()
// class _Car {
//   @PrimaryKey()
//   late int id;
//   late String make;
//   String? model;
//   int? kilometers = 500;
//   _Person? owner;
// }
//
// @RealmModel()
// class _Person {
//   @PrimaryKey()
//   late int id;
//   late String name;
//   int age = 1;
// }

// @RealmModel()
// abstract class RealmList<_ClsContact> implements List<_ClsContact> {
//   late List<_ClsContact> Contacts;
// }

@RealmModel()
class $ClsContact {
  // @PrimaryKey()
  late int Contact_ID;
  late String UID_Mem;
  late String Mem_ID;
  String? UID_Parent;
  String? TypeInCoding;
  String? Description;
  String? Value;
  String? Type;
  String? Title;
  int? ISort;
}

@RealmModel()
class _ClsPlace {
  // @PrimaryKey()
  late String UID_Plc;
  late String UID_Mem;
  late String Mem_ID;
  String? P9;
  String? P8;
  String? P7;
  String? P6;
  String? P5;
  String? P4;
  String? P3;
  String? P2;
  String? P1;
  String? Location;
  int? StatusCode;
  String? LangID;
}

@RealmModel()
@JsonSerializable()
class _ClsMember {
  @PrimaryKey()
  late String UID_Mem; //TODO: Member Flower ID (with specific place)
  late String Mem_ID; //TODO: Member ID
  late String UID_Main; //TODO: Member Flower ID (Personal ID)
  late String UID_Plc; //TODO: Member Flower Place ID
  late String Address_Title; //TODO: Member Flower Place Title
  String? TariffID; //TODO: Tariff ID
  String? Name; //TODO: Member Flower Name
  String? MidName; //TODO: Member Flower MiddleName (Adjective/Characteristic)
  int? MidNameLocating; //TODO: Member Flower Locating (0: Before 1: After)
  String? PerName; //TODO: Member Flower PerName (Mr. Sr..)
  int? PerNameLocating; //TODO: Member Flower Locating (0: Before 1: Middle 2: After)
  String? ImgUrl; //TODO: Member Flower Image URL
  _ClsPlace? Place; //TODO: Member Flower Place Info
  late List<$ClsContact> Contacts ; //TODO: Member Flower Contacts Info
  bool? IsLAb; //TODO: Member Flower Is Laboratory?
  int? StatusCode; //TODO: Status: 0=Normal  -1=Inactive
  bool? Verified; //TODO: Member Flower Verified
  String? EditorId; //TODO: Record Creator/Last Editor
  String? DateRegistry; //TODO: User Register Date
  String? DateExpiry; //TODO: User Expire Date
  String? AuthorID; //TODO: Author ID
  int? ServiceLimited; //TODO: 0:Unlimited 1:OnlyFix 2:OnlyRemovable & UnderZero disable user
}

@RealmModel()
@JsonSerializable(explicitToJson: true)
class _ClsPatientInfo {
  int? idRec;
  late String uidMem;
  @PrimaryKey()
  late String id;
  late String name;
  late int gender;
  late int age;
  late bool isInfectious;
  late DateTime setDate;
  String? description;
  DateTime? birthday;
  String? userId;
}
  extension ClsPatientInfoJ on ClsPatientInfo {
  static ClsPatientInfo toRealmObject(_ClsPatientInfo clsPatientInfo) {
    return ClsPatientInfo(clsPatientInfo.uidMem, clsPatientInfo.id, clsPatientInfo.name,
        clsPatientInfo.gender, clsPatientInfo.age, clsPatientInfo.isInfectious, clsPatientInfo.setDate);
  }

  static ClsPatientInfo fromMapJson(MapEntry<String, dynamic> jsonMap) => toRealmObject(_$ClsPatientInfoFromJsonMap(jsonMap));

  static ClsPatientInfo fromJson(json) => _$ClsPatientInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ClsPatientInfoToJson(this);

  static ClsPatientInfo _$ClsPatientInfoFromJson(json) {
    DateFormat format = DateFormat("yyyy-MM-dd");
    DateTime birthday = format.parse(json["Birthday"]);

    return ClsPatientInfo(
        json["UidMem"],
        json["Id"],
        json["Name"],
        json["Gender"],
        json["Age"],
        json["Infectious"],
        format.parse(json["SetDate"] ),
        idRec: json["IdRec"]?? -1,
        description: json["Description"] ?? '',
        birthday: birthday.year > 1 ? birthday : null,
        userId: json["UserID"] ?? ''
    );
  }

  static ClsPatientInfo _$ClsPatientInfoFromJsonMap(MapEntry<String, dynamic> jMap) {
    var json = jMap.value[0];
    DateFormat format = DateFormat("yyyy-MM-dd");
    return ClsPatientInfo(
        json["UidMem"],
        json["Id"],
        json["Name"],
        json["Gender"],
        json["Age"],
        json["Infectious"],
        format.parse(json["SetDate"] ),
        idRec: json["IdRec"]?? -1,
        description: json["Description"] ?? '',
        birthday: format.parse(json["Birthday"] ),
        userId: json["UserID"] ?? ''
    );
  }

  _$ClsPatientInfoToJson(ClsPatientInfo clsPatientInfo) {
    return {
      "IdRec": clsPatientInfo.idRec,
      "UidMem": clsPatientInfo.uidMem,
      "Id": clsPatientInfo.id,
      "Name": clsPatientInfo.name,
      "Gender": clsPatientInfo.gender,
      "Age": clsPatientInfo.age,
      "Infectious": clsPatientInfo.isInfectious,
      "SetDate": clsPatientInfo.setDate.toString(),
      "Description": clsPatientInfo.description,
      "Birthday": clsPatientInfo.birthday.toString(),
      "UserId": clsPatientInfo.userId,
    };
  }
}

  // Map<String, dynamic> toJson() => {
  //   "IdRec": idRec,
  //   "UidMem": uidMem,
  //   "Id": id,
  //   "Name": name,
  //   "Gender": gender,
  //   "Age": age,
  //   "IsInfectious": isInfectious,
  //   "SetDate": setDate,
  //   "Description": description,
  //   "Birthday": birthday,
  //   "UserId": userId,
  // };
// }
