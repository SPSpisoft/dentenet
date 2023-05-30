import 'dart:convert' as convert;
import 'dart:convert';
import 'package:eticon_api/eticon_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:realm/realm.dart';

import '../public/public_variables.dart';
import 'app.dart';


// ClsMember getEmployerAsCode(Realm realm, String employerCode){
//   return realm.query<ClsMember>("UID_Mem == '$employerCode'").first;
// }
//
// ClsPatientInfo getPatientAsCode(Realm realm, String patientCode){
//   return realm.query<ClsPatientInfo>("Id == '$patientCode'").first;
// }

Future<RetMemberModel> fetchMembers(String mID) async {
  Realm realm;
  LocalConfiguration config = Configuration.local(
      [ClsMember.schema, ClsContact.schema, ClsPlace.schema],
      schemaVersion: Globals.mySchemaVersion);
  realm = Realm(config);

  RetMemberModel retMemberModel = RetMemberModel();
  // if(currentModel!.isNotEmpty) {
  //   retMemberModel.retList = currentModel;
  //   retMemberModel.retCode = 100;
  //   return retMemberModel;
  // }
  List<ClsMember> sRet = [];
  var url =
      Uri.parse('${Globals.baseApiAddressDental}SKeyGetEmployers&MemberId=${mID}');

  try {
    final response = await http.get(
      url,
      headers: <String, String>{
        'content-type': 'application/json',
        'accept': 'application/json',
        // 'authorization': Globals.basicAuth
      },
    );

    retMemberModel.retCode = response.statusCode;

    if (response.statusCode == 200) {
      // print(convert.jsonDecode(response.body));
      List jsonList = convert.jsonDecode(response.body);

      if (realm == null) {
        for (var mClsMember in jsonList) {
          sRet.add(clsMemberFromJson(mClsMember));
        }
      } else {
        realm.write(() {
          realm.deleteAll<ClsMember>();
          for (var mClsMember in jsonList) {
            ClsMember? clsMember = realm.find<ClsMember>(0);
            clsMember ?? realm.add<ClsMember>(clsMemberFromJson(mClsMember));
          }
        });
      }
    } else {
      if (response.statusCode == 426) {
        Globals.myToken = response.body.replaceAll("\"", "");
        return fetchMembers(mID);
      } else {
        retMemberModel.retText = response.body;
      }
    }
  } catch (e) {
    retMemberModel.retText = e.toString();
    print(e);
    // return Future.error(e.toString());
  }
  if (realm != null) {
    sRet.addAll(realm.all<ClsMember>().toList());
  }
  retMemberModel.retList = sRet;

  return retMemberModel;
}

List<ClsMember> clsMemberListFromJson(List jsonList) {
  List<ClsMember> ret = [];
  for (var element in jsonList) {
    ret.add(clsMemberFromJson(element));
  }
  return ret;
}

ClsMember clsMemberFromJson(json) {
  // factory _ClsMember.fromJson(Map<String, dynamic> json) =>
  return ClsMember(
    json["UID_Mem"],
    json["Mem_ID"],
    json["UID_Main"],
    json["UID_Plc"],
    json["Address_Title"],
    StatusCode: json["StatusCode"] ?? 0,
    ServiceLimited: json["ServiceLimited"] ?? 0,
    AuthorID: json["AuthorID"] ?? '',
    DateExpiry: json["DateExpiry"] ?? '',
    DateRegistry: json["DateRegistry"] ?? '',
    EditorId: json["EditorId"] ?? '',
    Verified: json["Verified"] ?? false,
    IsLAb: json["IsLAb"] ?? false,
    ImgUrl: json["ImgUrl"] ?? '',
    PerNameLocating: json["PerNameLocating"] ?? 0,
    PerName: json["PerName"] ?? '',
    MidNameLocating: json["MidNameLocating"] ?? 0,
    MidName: json["MidName"] ?? '',
    Name: json["Name"] ?? '',
    TariffID: json["TariffID"] ?? '',
    Place: json["Place"] != null ? clsPlaceFromJson(json["Place"]) : null,
    Contacts: json["Contact"] != null
        ? List<ClsContact>.from(
            json["Contact"].map((x) => clsContactFromJson(x)))
        : [],
  );
}

clsPlaceFromJson(json) {
  return ClsPlace(
    json["UID_Plc"],
    json["UID_Mem"],
    json["Mem_ID"],
    StatusCode: json["StatusCode"] ?? 0,
    LangID: json["LangID"] ?? '',
    Location: json["Location"] ?? '',
    P1: json["P1"] ?? '',
    P2: json["P2"] ?? '',
    P3: json["P3"] ?? '',
    P4: json["P4"] ?? '',
    P5: json["P5"] ?? '',
    P6: json["P6"] ?? '',
    P7: json["P7"] ?? '',
    P8: json["P8"] ?? '',
    P9: json["P9"] ?? '',
  );
}

clsContactFromJson(json) {
  return ClsContact(
    json["Contact_ID"],
    json["UID_Mem"],
    json["Mem_ID"],
    Value: json["Value"] ?? '',
    UID_Parent: json["UID_Parent"] ?? '',
    TypeInCoding: json["TypeInCoding"] ?? '',
    Type: json["Type"] ?? '',
    Title: json["Title"] ?? '',
    Description: json["Description"] ?? '',
    ISort: json["ISort"] ?? 0,
  );
}

class RetMemberModel {
  int retCode = -1;
  late String retText;
  late List<ClsMember> retList;
}

Future<RetPatientModelMap> putPatient(ClsPatientInfo clsPatientInfo) async {

  Map<String, dynamic> clsPatientJson = clsPatientToJson(
      clsPatientInfo);
  RetPatientModelMap retPatientModelMap = RetPatientModelMap();
  try{
    Response response = await Api.put('PutPatient',
        body: clsPatientJson
        , responseType: ResponseType.jsonResponse
    );

    // if(response.statusCode == 201){
    //   // List<dynamic> nn = json.decode(error.body);
    //   // retPatientModel.retList = json.decode(error.body);
    //   retPatientModel.retList.add(ClsPatientInfoJ.fromJson(response.data.first));
    // }else {
    retPatientModelMap.retList.add(Map<String, dynamic>.from(
          response.data.first));
    retPatientModelMap.retCode = response.statusCode!;

    // }
  } on APIException catch(error){
    retPatientModelMap.retCode = error.code;
    // if(error.code == 302){
    //   // List<dynamic> nn = json.decode(error.body);
    //   // retPatientModel.retList = json.decode(error.body);
    //   retPatientModel.retList.add(ClsPatientInfoJ.fromJson(json.decode(error.body)[0]));
    // }else {
    if(error.body != null){
      retPatientModelMap.retText = error.body;
    }

    print('ERROR CODE: ${error.code}');
  }
  // print('ret 0******************** : ${retPatientModelMap.retList.first["Age"]}');

  return retPatientModelMap;
}

Future<RetPatientModelMap> putPatient1(Map<String, dynamic> clsPatientToJson) async {
  RetPatientModelMap retPatientModelMap = RetPatientModelMap();
  try{
    Response response = await Api.put('PutPatient',
        body: clsPatientToJson
        , responseType: ResponseType.jsonResponse
    );

    // if(response.statusCode == 201){
    //   // List<dynamic> nn = json.decode(error.body);
    //   // retPatientModel.retList = json.decode(error.body);
    //   retPatientModel.retList.add(ClsPatientInfoJ.fromJson(response.data.first));
    // }else {
    retPatientModelMap.retList.add(Map<String, dynamic>.from(
        response.data.first));
    retPatientModelMap.retCode = response.statusCode!;

    // }
  } on APIException catch(error){
    retPatientModelMap.retCode = error.code;
    // if(error.code == 302){
    //   // List<dynamic> nn = json.decode(error.body);
    //   // retPatientModel.retList = json.decode(error.body);
    //   retPatientModel.retList.add(ClsPatientInfoJ.fromJson(json.decode(error.body)[0]));
    // }else {
    retPatientModelMap.retText = error.body;
    // }

    print('ERROR CODE: ${error.code}');
  }
  print('ret 0******************** : ${retPatientModelMap.retList.first["Age"]}');

  return retPatientModelMap;
}

Future<Map<String, dynamic>> putPatient0(Map<String, dynamic> clsPatientToJson) async {
  Map<String, dynamic> response = Map();
  try{
    response = await Api.put('PutPatient', body: clsPatientToJson
    );
  } on APIException catch(error){
    print('ERROR CODE: ${error.code}');
  }
  return response;
}

Future<RetPatientModel> fetchPatients(String mID, String mName, {bool onLike = false}) async {
  late Realm realm;
  LocalConfiguration config = Configuration.local([ClsPatientInfo.schema],
      schemaVersion: Globals.mySchemaVersion);
  realm = Realm(config);

  RetPatientModel retPatientModel = RetPatientModel();
  // if(currentModel!.isNotEmpty) {
  //   retMemberModel.retList = currentModel;
  //   retMemberModel.retCode = 100;
  //   return retMemberModel;
  // }
  List<ClsPatientInfo> sRet = [];
  var url =
  Uri.parse("${Globals.baseApiAddressDental}GetPatients?MemberId=$mID&Name=$mName&onLike=$onLike");
  print(url);

  try {
    final response = await http.get(
      url,
      headers: <String, String>{
        'content-type': 'application/json',
        'accept': 'application/json',
        // 'authorization': Globals.basicAuth
      },
    );

    retPatientModel.retCode = response.statusCode;

    if (response.statusCode == 200) {

      var jsonList = convert.jsonDecode(response.body);


      // print(jsonList[0].description);
      for (var mClsPatient in jsonList) {
        sRet.add(ClsPatientInfoJ.fromJson(mClsPatient));
      }
      print(sRet[0]);

      if (realm != null) {
        realm.write(() {
          realm.addAll(sRet, update: true);
        });
      }
    } else {
      if (response.statusCode == 426) {
        Globals.myToken = response.body.replaceAll("\"", "");
        return fetchPatients(mID, mName);
      } else {
        retPatientModel.retText = response.body;
      }
    }
  } catch (e) {
    retPatientModel.retText = e.toString();
    print(e);
    // return Future.error(e.toString());
  }
  // if (realm != null) {
  //   sRet.addAll(realm.all<ClsPatientInfo>().toList());
  // }
  retPatientModel.retList = sRet;

  return retPatientModel;
}

// ClsPatientInfo clsPatientFromJson(json) {
//   DateFormat format = DateFormat("yyyy-MM-dd");
//   // factory _ClsMember.fromJson(Map<String, dynamic> json) =>
//   return ClsPatientInfo(
//     json["UidMem"],
//     json["Id"],
//     json["Name"],
//     json["Gender"],
//     json["Age"],
//     json["Infectious"],
//     format.parse(json["SetDate"] ),
//     idRec: json["IdRec"]?? 0,
//     description: json["Description"] ?? '',
//     birthday: format.parse(json["Birthday"] ),
//     userId: json["UserID"] ?? ''
//   );
// }

List clsListPatientToJson(List<ClsPatientInfo> data) => List<dynamic>.from(data.map((x) => x.toJson()));

String clsListPatientToJsonStr(List<ClsPatientInfo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Map<String, dynamic> clsPatientToJson(ClsPatientInfo data) {
  return data.toJson();
}

// List<ClsPatientInfo> listPatientFromJson(json) {
//
//   return ClsPatientInfoJ.fromJson(json);
// }

// ClsPatientInfo clsPatientMapJson(json) {
//   return ClsPatientInfoJ.fromMapJson(json);
// }

String clsPatientToJsonStr(ClsPatientInfo data) => json.encode(data.toJson());

class RetPatientModel {
  int retCode = -1;
  late String retText;
  List<ClsPatientInfo> retList = [];
}

class RetPatientModelMap {
  int retCode = -1;
  late String retText;
  List<Map<String, dynamic>> retList = [];
}

Future<ClsTime> fetchDateTime(String myZoomTime) async {
  ClsTime sRet = ClsTime(
    datetime: DateTime.now().toString(),
    isMachineSet: true,
  );
  var url = Uri.parse('http://worldtimeapi.org/api/timezone/$myZoomTime');

  try {
    final response = await http.get(
      url,
      headers: <String, String>{
        'content-type': 'application/json',
        'accept': 'application/json',
        // 'authorization': Globals.basicAuth
      },
    );

    if (response.statusCode == 200) {
      print(convert.jsonDecode(response.body));
      sRet = ClsTime.fromJson(convert.jsonDecode(response.body));
    } else {
      print(response.statusCode);
      print(response.body);
    }
  } catch (e) {
    print(e);
    return sRet;
  }

  return sRet;
}

class ClsTime {
  ClsTime(
      {this.isMachineSet,
      this.abbreviation,
      this.client_ip,
      this.datetime,
      this.day_of_week,
      this.day_of_year,
      this.dst,
      this.dst_from,
      this.dst_offset,
      this.dst_until,
      this.raw_offset,
      this.timezone,
      this.unixtime,
      this.utc_datetime,
      this.utc_offset,
      this.week_number});

  bool? isMachineSet = false;
  String? abbreviation;
  String? client_ip;
  String? datetime;
  int? day_of_week;
  int? day_of_year;
  bool? dst;
  String? dst_from;
  int? dst_offset;
  String? dst_until;
  int? raw_offset;
  String? timezone;
  int? unixtime;
  String? utc_datetime;
  String? utc_offset;
  int? week_number;

  factory ClsTime.fromJson(Map<String, dynamic> json) => ClsTime(
        abbreviation: json["abbreviation"],
        week_number: json["week_number"],
        utc_offset: json["utc_offset"],
        utc_datetime: json["utc_datetime"],
        unixtime: json["unixtime"],
        timezone: json["timezone"],
        raw_offset: json["raw_offset"],
        dst_until: json["dst_until"],
        dst_offset: json["dst_offset"],
        dst_from: json["dst_from"],
        dst: json["dst"],
        day_of_year: json["day_of_year"],
        day_of_week: json["day_of_week"],
        datetime: json["datetime"],
        client_ip: json["client_ip"],
      );

// Map<String, dynamic> toJson() =>
//     {
//       "NetRec": netRec,
//
//     };
}
