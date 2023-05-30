// ignore_for_file: file_names

import 'ClsLstOpt.dart';

class SPCs {
  SPCs({
    String? storeCode,
    String? catId,
    String? catTitle,
    String? spcCode,
    String? spcCatTitle,
    String? catGroup,
    bool? filter,
    bool? optionCustomer,
    bool? toHead,
    dynamic ordLevel,
    int? spcTypeCode,
    int? optIconCode,
    dynamic spcStrValue,
    List<LstOpt>? lstOpt,}){
    _storeCode = storeCode;
    _catId = catId;
    _catTitle = catTitle;
    _spcCode = spcCode;
    _spcCatTitle = spcCatTitle;
    _catGroup = catGroup;
    _filter = filter;
    _optionCustomer = optionCustomer;
    _toHead = toHead;
    _ordLevel = ordLevel;
    _spcTypeCode = spcTypeCode;
    _optIconCode = optIconCode;
    _spcStrValue = spcStrValue;
    _lstOpt = lstOpt;
  }

  SPCs.fromJson(dynamic json) {
    _storeCode = json['StoreCode'];
    _catId = json['CatId'];
    _catTitle = json['CatTitle'];
    _spcCode = json['SpcCode'];
    _spcCatTitle = json['SpcCatTitle'];
    _catGroup = json['CatGroup'];
    _filter = json['Filter'];
    _optionCustomer = json['OptionCustomer'];
    _toHead = json['toHead'];
    _ordLevel = json['OrdLevel'];
    _spcTypeCode = json['SpcTypeCode'];
    _optIconCode = json['OptIconCode'];
    _spcStrValue = json['SpcStrValue'];
    if (json['LstOpt'] != null) {
      _lstOpt = [];
      json['LstOpt'].forEach((v) {
        _lstOpt?.add(LstOpt.fromJson(v));
      });
    }
  }
  String? _storeCode;
  String? _catId;
  String? _catTitle;
  String? _spcCode;
  String? _spcCatTitle;
  String? _catGroup;
  bool? _filter;
  bool? _optionCustomer;
  bool? _toHead;
  dynamic _ordLevel;
  int? _spcTypeCode;
  int? _optIconCode;
  dynamic _spcStrValue;
  List<LstOpt>? _lstOpt;

  String? get storeCode => _storeCode;
  String? get catId => _catId;
  String? get catTitle => _catTitle;
  String? get spcCode => _spcCode;
  String? get spcCatTitle => _spcCatTitle;
  String? get catGroup => _catGroup;
  bool? get filter => _filter;
  bool? get optionCustomer => _optionCustomer;
  bool? get toHead => _toHead;
  dynamic get ordLevel => _ordLevel;
  int? get spcTypeCode => _spcTypeCode;
  int? get optIconCode => _optIconCode;
  dynamic get spcStrValue => _spcStrValue;
  List<LstOpt>? get lstOpt => _lstOpt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['StoreCode'] = _storeCode;
    map['CatId'] = _catId;
    map['CatTitle'] = _catTitle;
    map['SpcCode'] = _spcCode;
    map['SpcCatTitle'] = _spcCatTitle;
    map['CatGroup'] = _catGroup;
    map['Filter'] = _filter;
    map['OptionCustomer'] = _optionCustomer;
    map['toHead'] = _toHead;
    map['OrdLevel'] = _ordLevel;
    map['SpcTypeCode'] = _spcTypeCode;
    map['OptIconCode'] = _optIconCode;
    map['SpcStrValue'] = _spcStrValue;
    if (_lstOpt != null) {
      map['LstOpt'] = _lstOpt?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}