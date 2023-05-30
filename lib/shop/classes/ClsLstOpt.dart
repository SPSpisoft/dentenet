// ignore_for_file: file_names

class LstOpt {
  LstOpt({
    String? optCode,
    String? optTitle,
    List<String>? lstPrd,}){
    _optCode = optCode;
    _optTitle = optTitle;
    _lstPrd = lstPrd;
  }

  LstOpt.fromJson(dynamic json) {
    _optCode = json['OptCode'];
    _optTitle = json['OptTitle'];
    _lstPrd = json['LstPrd'] != null ? json['LstPrd'].cast<String>() : [];
  }
  String? _optCode;
  String? _optTitle;
  List<String>? _lstPrd;

  String? get optCode => _optCode;
  String? get optTitle => _optTitle;
  List<String>? get lstPrd => _lstPrd;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['OptCode'] = _optCode;
    map['OptTitle'] = _optTitle;
    map['LstPrd'] = _lstPrd;
    return map;
  }

}