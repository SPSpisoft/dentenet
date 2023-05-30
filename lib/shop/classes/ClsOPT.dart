// ignore_for_file: file_names

class OPTs {
  OPTs({
    int? netRec,
    String? storeCode,
    String? id,
    String? title,
    double? price,
    double? invAvailable,
    bool? invFirst,
    bool? invAdd,
    String? unit,
    String? catTitle,
    int? statusCode,
    String? parentCode,
    double? percentOff,
    String? iDMerge,
    bool? priceTemp,
    bool? inventoryTemp,
    double? selRatio,
    String? setCode,
    int? idRec,
    int? sortCat,
    int? sortPrd,
    String? unitNet,
    double? unitNetScale,
    double? selMinLimit,
    double? selMaxLimit,
    double? selJump,}){
    _netRec = netRec;
    _storeCode = storeCode;
    _id = id;
    _title = title;
    _price = price;
    _invAvailable = invAvailable;
    _invFirst = invFirst;
    _invAdd = invAdd;
    _unit = unit;
    _catTitle = catTitle;
    _statusCode = statusCode;
    _parentCode = parentCode;
    _percentOff = percentOff;
    _iDMerge = iDMerge;
    _priceTemp = priceTemp;
    _inventoryTemp = inventoryTemp;
    _selRatio = selRatio;
    _setCode = setCode;
    _idRec = idRec;
    _sortCat = sortCat;
    _sortPrd = sortPrd;
    _unitNet = unitNet;
    _unitNetScale = unitNetScale;
    _selMinLimit = selMinLimit;
    _selMaxLimit = selMaxLimit;
    _selJump = selJump;
  }

  OPTs.fromJson(dynamic json) {
    _netRec = json['NetRec'];
    _storeCode = json['StoreCode'];
    _id = json['ID'];
    _title = json['Title'];
    _price = json['Price'];
    _invAvailable = json['InvAvailable'];
    _invFirst = json['InvFirst'];
    _invAdd = json['InvAdd'];
    _unit = json['Unit'];
    _catTitle = json['CatTitle'];
    _statusCode = json['StatusCode'];
    _parentCode = json['ParentCode'];
    _percentOff = json['PercentOff'];
    _iDMerge = json['IDMerge'];
    _priceTemp = json['PriceTemp'];
    _inventoryTemp = json['InventoryTemp'];
    _selRatio = json['SelRatio'];
    _setCode = json['SetCode'];
    _idRec = json['IdRec'];
    _sortCat = json['Sort_Cat'];
    _sortPrd = json['Sort_Prd'];
    _unitNet = json['UnitNet'];
    _unitNetScale = json['UnitNetScale'];
    _selMinLimit = json['SelMinLimit'];
    _selMaxLimit = json['SelMaxLimit'];
    _selJump = json['SelJump'];
  }
  int? _netRec;
  String? _storeCode;
  String? _id;
  String? _title;
  double? _price;
  double? _invAvailable;
  bool? _invFirst;
  bool? _invAdd;
  String? _unit;
  String? _catTitle;
  int? _statusCode;
  String? _parentCode;
  double? _percentOff;
  String? _iDMerge;
  bool? _priceTemp;
  bool? _inventoryTemp;
  double? _selRatio;
  String? _setCode;
  int? _idRec;
  int? _sortCat;
  int? _sortPrd;
  String? _unitNet;
  double? _unitNetScale;
  double? _selMinLimit;
  double? _selMaxLimit;
  double? _selJump;

  int? get netRec => _netRec;
  String? get storeCode => _storeCode;
  String? get id => _id;
  String? get title => _title;
  double? get price => _price;
  double? get invAvailable => _invAvailable;
  bool? get invFirst => _invFirst;
  bool? get invAdd => _invAdd;
  String? get unit => _unit;
  String? get catTitle => _catTitle;
  int? get statusCode => _statusCode;
  String? get parentCode => _parentCode;
  double? get percentOff => _percentOff;
  String? get iDMerge => _iDMerge;
  bool? get priceTemp => _priceTemp;
  bool? get inventoryTemp => _inventoryTemp;
  double? get selRatio => _selRatio;
  String? get setCode => _setCode;
  int? get idRec => _idRec;
  int? get sortCat => _sortCat;
  int? get sortPrd => _sortPrd;
  String? get unitNet => _unitNet;
  double? get unitNetScale => _unitNetScale;
  double? get selMinLimit => _selMinLimit;
  double? get selMaxLimit => _selMaxLimit;
  double? get selJump => _selJump;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['NetRec'] = _netRec;
    map['StoreCode'] = _storeCode;
    map['ID'] = _id;
    map['Title'] = _title;
    map['Price'] = _price;
    map['InvAvailable'] = _invAvailable;
    map['InvFirst'] = _invFirst;
    map['InvAdd'] = _invAdd;
    map['Unit'] = _unit;
    map['CatTitle'] = _catTitle;
    map['StatusCode'] = _statusCode;
    map['ParentCode'] = _parentCode;
    map['PercentOff'] = _percentOff;
    map['IDMerge'] = _iDMerge;
    map['PriceTemp'] = _priceTemp;
    map['InventoryTemp'] = _inventoryTemp;
    map['SelRatio'] = _selRatio;
    map['SetCode'] = _setCode;
    map['IdRec'] = _idRec;
    map['Sort_Cat'] = _sortCat;
    map['Sort_Prd'] = _sortPrd;
    map['UnitNet'] = _unitNet;
    map['UnitNetScale'] = _unitNetScale;
    map['SelMinLimit'] = _selMinLimit;
    map['SelMaxLimit'] = _selMaxLimit;
    map['SelJump'] = _selJump;
    return map;
  }

}