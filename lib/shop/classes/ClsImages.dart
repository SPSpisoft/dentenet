// ignore_for_file: file_names

class Images {
  Images({
    int? netRec,
    String? typeCode,
    String? linkId,
    dynamic img,
    int? width,
    int? height,
    int? duration,
    String? storeCode,
    String? serverUrl,
    int? statusCode,
    String? description,
    int? idRec,}){
    _netRec = netRec;
    _typeCode = typeCode;
    _linkId = linkId;
    _img = img;
    _width = width;
    _height = height;
    _duration = duration;
    _storeCode = storeCode;
    _serverUrl = serverUrl;
    _statusCode = statusCode;
    _description = description;
    _idRec = idRec;
  }

  Images.fromJson(dynamic json) {
    _netRec = json['NetRec'];
    _typeCode = json['TypeCode'];
    _linkId = json['LinkId'];
    _img = json['Img'];
    _width = json['Width'];
    _height = json['Height'];
    _duration = json['Duration'];
    _storeCode = json['StoreCode'];
    _serverUrl = json['ServerUrl'];
    _statusCode = json['StatusCode'];
    _description = json['Description'];
    _idRec = json['IdRec'];
  }
  int? _netRec;
  String? _typeCode;
  String? _linkId;
  dynamic _img;
  int? _width;
  int? _height;
  int? _duration;
  String? _storeCode;
  String? _serverUrl;
  int? _statusCode;
  String? _description;
  int? _idRec;

  int? get netRec => _netRec;
  String? get typeCode => _typeCode;
  String? get linkId => _linkId;
  dynamic get img => _img;
  int? get width => _width;
  int? get height => _height;
  int? get duration => _duration;
  String? get storeCode => _storeCode;
  String? get serverUrl => _serverUrl;
  int? get statusCode => _statusCode;
  String? get description => _description;
  int? get idRec => _idRec;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['NetRec'] = _netRec;
    map['TypeCode'] = _typeCode;
    map['LinkId'] = _linkId;
    map['Img'] = _img;
    map['Width'] = _width;
    map['Height'] = _height;
    map['Duration'] = _duration;
    map['StoreCode'] = _storeCode;
    map['ServerUrl'] = _serverUrl;
    map['StatusCode'] = _statusCode;
    map['Description'] = _description;
    map['IdRec'] = _idRec;
    return map;
  }

}