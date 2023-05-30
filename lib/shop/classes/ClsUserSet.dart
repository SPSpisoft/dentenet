// To parse this JSON data, do
//
//     final clsTags = clsTagsFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:typed_data';

import 'dart:convert';
import 'ClsAddress.dart';
import 'ClsCommunication.dart';

String clsListUserSetToJson(List<ClsUserSet> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

String clsUserSetToJson(ClsUserSet data) => json.encode(data.toJson());

class ClsUserSet {
  ClsUserSet({
    required this.UserID,
    this.Password,
    this.newPassword,
    this.NikName ,
    this.UserName,
    this.ProfileImgUrl,
    this.Config,
    this.GenderCode,
    this.Birthday,
    this.ListAddress,
    this.Comus,
  });

  String UserID ;
  String? Password ;
  String? newPassword ;
  String? NikName ;
  String? UserName ;
  String? ProfileImgUrl ;
  String? Config ;
  int? GenderCode = 0 ;
  String? Birthday ;
  List<ClsAddress>? ListAddress ;
  List<ClsCommunication>? Comus ;

  Map<String, dynamic> toJson() => {
        "UserID": UserID,
        "Password": Password,
        "newPassword": newPassword,
        "NikName": NikName,
        "ProfileImgUrl": ProfileImgUrl,
        "Config": Config,
        "GenderCode": GenderCode,
        "Birthday": Birthday,
        "ListAddress": ListAddress == null? [] : List<dynamic>.from(ListAddress!.map((x) => x.toJson())),
        "Comus": Comus == null? [] : List<dynamic>.from(Comus!.map((x) => x.toJson())),
      };
}
