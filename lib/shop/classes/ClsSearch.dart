// ignore_for_file: file_names
import 'package:meta/meta.dart';
import 'dart:convert';

List<ClsSearch> clsSearchFromJson(String str) => List<ClsSearch>.from(json.decode(str).map((x) => ClsSearch.fromJson(x)));

String clsSearchToJson(List<ClsSearch> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ClsSearch {
  ClsSearch({
    required this.id,
    required this.text,
    required this.typeCode,
    required this.iin,
    required this.iinCat,
    required this.searchText,
  });

  String id;
  String text;
  int typeCode;
  dynamic iin;
  String iinCat;
  String searchText;

  factory ClsSearch.fromJson(Map<String, dynamic> json) => ClsSearch(
    id: json["Id"],
    text: json["Text"],
    typeCode: json["TypeCode"],
    iin: json["iin"],
    iinCat: json["iin_cat"],
    searchText: json["SearchText"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Text": text,
    "TypeCode": typeCode,
    "iin": iin,
    "iin_cat": iinCat,
    "SearchText": searchText,
  };
}
