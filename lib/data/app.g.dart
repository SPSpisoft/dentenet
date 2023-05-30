// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class ClsContact extends $ClsContact
    with RealmEntity, RealmObjectBase, RealmObject {
  ClsContact(
    int Contact_ID,
    String UID_Mem,
    String Mem_ID, {
    String? UID_Parent,
    String? TypeInCoding,
    String? Description,
    String? Value,
    String? Type,
    String? Title,
    int? ISort,
  }) {
    RealmObjectBase.set(this, 'Contact_ID', Contact_ID);
    RealmObjectBase.set(this, 'UID_Mem', UID_Mem);
    RealmObjectBase.set(this, 'Mem_ID', Mem_ID);
    RealmObjectBase.set(this, 'UID_Parent', UID_Parent);
    RealmObjectBase.set(this, 'TypeInCoding', TypeInCoding);
    RealmObjectBase.set(this, 'Description', Description);
    RealmObjectBase.set(this, 'Value', Value);
    RealmObjectBase.set(this, 'Type', Type);
    RealmObjectBase.set(this, 'Title', Title);
    RealmObjectBase.set(this, 'ISort', ISort);
  }

  ClsContact._();

  @override
  int get Contact_ID => RealmObjectBase.get<int>(this, 'Contact_ID') as int;
  @override
  set Contact_ID(int value) => RealmObjectBase.set(this, 'Contact_ID', value);

  @override
  String get UID_Mem => RealmObjectBase.get<String>(this, 'UID_Mem') as String;
  @override
  set UID_Mem(String value) => RealmObjectBase.set(this, 'UID_Mem', value);

  @override
  String get Mem_ID => RealmObjectBase.get<String>(this, 'Mem_ID') as String;
  @override
  set Mem_ID(String value) => RealmObjectBase.set(this, 'Mem_ID', value);

  @override
  String? get UID_Parent =>
      RealmObjectBase.get<String>(this, 'UID_Parent') as String?;
  @override
  set UID_Parent(String? value) =>
      RealmObjectBase.set(this, 'UID_Parent', value);

  @override
  String? get TypeInCoding =>
      RealmObjectBase.get<String>(this, 'TypeInCoding') as String?;
  @override
  set TypeInCoding(String? value) =>
      RealmObjectBase.set(this, 'TypeInCoding', value);

  @override
  String? get Description =>
      RealmObjectBase.get<String>(this, 'Description') as String?;
  @override
  set Description(String? value) =>
      RealmObjectBase.set(this, 'Description', value);

  @override
  String? get Value => RealmObjectBase.get<String>(this, 'Value') as String?;
  @override
  set Value(String? value) => RealmObjectBase.set(this, 'Value', value);

  @override
  String? get Type => RealmObjectBase.get<String>(this, 'Type') as String?;
  @override
  set Type(String? value) => RealmObjectBase.set(this, 'Type', value);

  @override
  String? get Title => RealmObjectBase.get<String>(this, 'Title') as String?;
  @override
  set Title(String? value) => RealmObjectBase.set(this, 'Title', value);

  @override
  int? get ISort => RealmObjectBase.get<int>(this, 'ISort') as int?;
  @override
  set ISort(int? value) => RealmObjectBase.set(this, 'ISort', value);

  @override
  Stream<RealmObjectChanges<ClsContact>> get changes =>
      RealmObjectBase.getChanges<ClsContact>(this);

  @override
  ClsContact freeze() => RealmObjectBase.freezeObject<ClsContact>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(ClsContact._);
    return const SchemaObject(
        ObjectType.realmObject, ClsContact, 'ClsContact', [
      SchemaProperty('Contact_ID', RealmPropertyType.int),
      SchemaProperty('UID_Mem', RealmPropertyType.string),
      SchemaProperty('Mem_ID', RealmPropertyType.string),
      SchemaProperty('UID_Parent', RealmPropertyType.string, optional: true),
      SchemaProperty('TypeInCoding', RealmPropertyType.string, optional: true),
      SchemaProperty('Description', RealmPropertyType.string, optional: true),
      SchemaProperty('Value', RealmPropertyType.string, optional: true),
      SchemaProperty('Type', RealmPropertyType.string, optional: true),
      SchemaProperty('Title', RealmPropertyType.string, optional: true),
      SchemaProperty('ISort', RealmPropertyType.int, optional: true),
    ]);
  }
}

class ClsPlace extends _ClsPlace
    with RealmEntity, RealmObjectBase, RealmObject {
  ClsPlace(
    String UID_Plc,
    String UID_Mem,
    String Mem_ID, {
    String? P9,
    String? P8,
    String? P7,
    String? P6,
    String? P5,
    String? P4,
    String? P3,
    String? P2,
    String? P1,
    String? Location,
    int? StatusCode,
    String? LangID,
  }) {
    RealmObjectBase.set(this, 'UID_Plc', UID_Plc);
    RealmObjectBase.set(this, 'UID_Mem', UID_Mem);
    RealmObjectBase.set(this, 'Mem_ID', Mem_ID);
    RealmObjectBase.set(this, 'P9', P9);
    RealmObjectBase.set(this, 'P8', P8);
    RealmObjectBase.set(this, 'P7', P7);
    RealmObjectBase.set(this, 'P6', P6);
    RealmObjectBase.set(this, 'P5', P5);
    RealmObjectBase.set(this, 'P4', P4);
    RealmObjectBase.set(this, 'P3', P3);
    RealmObjectBase.set(this, 'P2', P2);
    RealmObjectBase.set(this, 'P1', P1);
    RealmObjectBase.set(this, 'Location', Location);
    RealmObjectBase.set(this, 'StatusCode', StatusCode);
    RealmObjectBase.set(this, 'LangID', LangID);
  }

  ClsPlace._();

  @override
  String get UID_Plc => RealmObjectBase.get<String>(this, 'UID_Plc') as String;
  @override
  set UID_Plc(String value) => RealmObjectBase.set(this, 'UID_Plc', value);

  @override
  String get UID_Mem => RealmObjectBase.get<String>(this, 'UID_Mem') as String;
  @override
  set UID_Mem(String value) => RealmObjectBase.set(this, 'UID_Mem', value);

  @override
  String get Mem_ID => RealmObjectBase.get<String>(this, 'Mem_ID') as String;
  @override
  set Mem_ID(String value) => RealmObjectBase.set(this, 'Mem_ID', value);

  @override
  String? get P9 => RealmObjectBase.get<String>(this, 'P9') as String?;
  @override
  set P9(String? value) => RealmObjectBase.set(this, 'P9', value);

  @override
  String? get P8 => RealmObjectBase.get<String>(this, 'P8') as String?;
  @override
  set P8(String? value) => RealmObjectBase.set(this, 'P8', value);

  @override
  String? get P7 => RealmObjectBase.get<String>(this, 'P7') as String?;
  @override
  set P7(String? value) => RealmObjectBase.set(this, 'P7', value);

  @override
  String? get P6 => RealmObjectBase.get<String>(this, 'P6') as String?;
  @override
  set P6(String? value) => RealmObjectBase.set(this, 'P6', value);

  @override
  String? get P5 => RealmObjectBase.get<String>(this, 'P5') as String?;
  @override
  set P5(String? value) => RealmObjectBase.set(this, 'P5', value);

  @override
  String? get P4 => RealmObjectBase.get<String>(this, 'P4') as String?;
  @override
  set P4(String? value) => RealmObjectBase.set(this, 'P4', value);

  @override
  String? get P3 => RealmObjectBase.get<String>(this, 'P3') as String?;
  @override
  set P3(String? value) => RealmObjectBase.set(this, 'P3', value);

  @override
  String? get P2 => RealmObjectBase.get<String>(this, 'P2') as String?;
  @override
  set P2(String? value) => RealmObjectBase.set(this, 'P2', value);

  @override
  String? get P1 => RealmObjectBase.get<String>(this, 'P1') as String?;
  @override
  set P1(String? value) => RealmObjectBase.set(this, 'P1', value);

  @override
  String? get Location =>
      RealmObjectBase.get<String>(this, 'Location') as String?;
  @override
  set Location(String? value) => RealmObjectBase.set(this, 'Location', value);

  @override
  int? get StatusCode => RealmObjectBase.get<int>(this, 'StatusCode') as int?;
  @override
  set StatusCode(int? value) => RealmObjectBase.set(this, 'StatusCode', value);

  @override
  String? get LangID => RealmObjectBase.get<String>(this, 'LangID') as String?;
  @override
  set LangID(String? value) => RealmObjectBase.set(this, 'LangID', value);

  @override
  Stream<RealmObjectChanges<ClsPlace>> get changes =>
      RealmObjectBase.getChanges<ClsPlace>(this);

  @override
  ClsPlace freeze() => RealmObjectBase.freezeObject<ClsPlace>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(ClsPlace._);
    return const SchemaObject(ObjectType.realmObject, ClsPlace, 'ClsPlace', [
      SchemaProperty('UID_Plc', RealmPropertyType.string),
      SchemaProperty('UID_Mem', RealmPropertyType.string),
      SchemaProperty('Mem_ID', RealmPropertyType.string),
      SchemaProperty('P9', RealmPropertyType.string, optional: true),
      SchemaProperty('P8', RealmPropertyType.string, optional: true),
      SchemaProperty('P7', RealmPropertyType.string, optional: true),
      SchemaProperty('P6', RealmPropertyType.string, optional: true),
      SchemaProperty('P5', RealmPropertyType.string, optional: true),
      SchemaProperty('P4', RealmPropertyType.string, optional: true),
      SchemaProperty('P3', RealmPropertyType.string, optional: true),
      SchemaProperty('P2', RealmPropertyType.string, optional: true),
      SchemaProperty('P1', RealmPropertyType.string, optional: true),
      SchemaProperty('Location', RealmPropertyType.string, optional: true),
      SchemaProperty('StatusCode', RealmPropertyType.int, optional: true),
      SchemaProperty('LangID', RealmPropertyType.string, optional: true),
    ]);
  }
}

class ClsMember extends _ClsMember
    with RealmEntity, RealmObjectBase, RealmObject {
  ClsMember(
    String UID_Mem,
    String Mem_ID,
    String UID_Main,
    String UID_Plc,
    String Address_Title, {
    String? TariffID,
    String? Name,
    String? MidName,
    int? MidNameLocating,
    String? PerName,
    int? PerNameLocating,
    String? ImgUrl,
    ClsPlace? Place,
    bool? IsLAb,
    int? StatusCode,
    bool? Verified,
    String? EditorId,
    String? DateRegistry,
    String? DateExpiry,
    String? AuthorID,
    int? ServiceLimited,
    Iterable<ClsContact> Contacts = const [],
  }) {
    RealmObjectBase.set(this, 'UID_Mem', UID_Mem);
    RealmObjectBase.set(this, 'Mem_ID', Mem_ID);
    RealmObjectBase.set(this, 'UID_Main', UID_Main);
    RealmObjectBase.set(this, 'UID_Plc', UID_Plc);
    RealmObjectBase.set(this, 'Address_Title', Address_Title);
    RealmObjectBase.set(this, 'TariffID', TariffID);
    RealmObjectBase.set(this, 'Name', Name);
    RealmObjectBase.set(this, 'MidName', MidName);
    RealmObjectBase.set(this, 'MidNameLocating', MidNameLocating);
    RealmObjectBase.set(this, 'PerName', PerName);
    RealmObjectBase.set(this, 'PerNameLocating', PerNameLocating);
    RealmObjectBase.set(this, 'ImgUrl', ImgUrl);
    RealmObjectBase.set(this, 'Place', Place);
    RealmObjectBase.set(this, 'IsLAb', IsLAb);
    RealmObjectBase.set(this, 'StatusCode', StatusCode);
    RealmObjectBase.set(this, 'Verified', Verified);
    RealmObjectBase.set(this, 'EditorId', EditorId);
    RealmObjectBase.set(this, 'DateRegistry', DateRegistry);
    RealmObjectBase.set(this, 'DateExpiry', DateExpiry);
    RealmObjectBase.set(this, 'AuthorID', AuthorID);
    RealmObjectBase.set(this, 'ServiceLimited', ServiceLimited);
    RealmObjectBase.set<RealmList<ClsContact>>(
        this, 'Contacts', RealmList<ClsContact>(Contacts));
  }

  ClsMember._();

  @override
  String get UID_Mem => RealmObjectBase.get<String>(this, 'UID_Mem') as String;
  @override
  set UID_Mem(String value) => RealmObjectBase.set(this, 'UID_Mem', value);

  @override
  String get Mem_ID => RealmObjectBase.get<String>(this, 'Mem_ID') as String;
  @override
  set Mem_ID(String value) => RealmObjectBase.set(this, 'Mem_ID', value);

  @override
  String get UID_Main =>
      RealmObjectBase.get<String>(this, 'UID_Main') as String;
  @override
  set UID_Main(String value) => RealmObjectBase.set(this, 'UID_Main', value);

  @override
  String get UID_Plc => RealmObjectBase.get<String>(this, 'UID_Plc') as String;
  @override
  set UID_Plc(String value) => RealmObjectBase.set(this, 'UID_Plc', value);

  @override
  String get Address_Title =>
      RealmObjectBase.get<String>(this, 'Address_Title') as String;
  @override
  set Address_Title(String value) =>
      RealmObjectBase.set(this, 'Address_Title', value);

  @override
  String? get TariffID =>
      RealmObjectBase.get<String>(this, 'TariffID') as String?;
  @override
  set TariffID(String? value) => RealmObjectBase.set(this, 'TariffID', value);

  @override
  String? get Name => RealmObjectBase.get<String>(this, 'Name') as String?;
  @override
  set Name(String? value) => RealmObjectBase.set(this, 'Name', value);

  @override
  String? get MidName =>
      RealmObjectBase.get<String>(this, 'MidName') as String?;
  @override
  set MidName(String? value) => RealmObjectBase.set(this, 'MidName', value);

  @override
  int? get MidNameLocating =>
      RealmObjectBase.get<int>(this, 'MidNameLocating') as int?;
  @override
  set MidNameLocating(int? value) =>
      RealmObjectBase.set(this, 'MidNameLocating', value);

  @override
  String? get PerName =>
      RealmObjectBase.get<String>(this, 'PerName') as String?;
  @override
  set PerName(String? value) => RealmObjectBase.set(this, 'PerName', value);

  @override
  int? get PerNameLocating =>
      RealmObjectBase.get<int>(this, 'PerNameLocating') as int?;
  @override
  set PerNameLocating(int? value) =>
      RealmObjectBase.set(this, 'PerNameLocating', value);

  @override
  String? get ImgUrl => RealmObjectBase.get<String>(this, 'ImgUrl') as String?;
  @override
  set ImgUrl(String? value) => RealmObjectBase.set(this, 'ImgUrl', value);

  @override
  ClsPlace? get Place =>
      RealmObjectBase.get<ClsPlace>(this, 'Place') as ClsPlace?;
  @override
  set Place(covariant ClsPlace? value) =>
      RealmObjectBase.set(this, 'Place', value);

  @override
  RealmList<ClsContact> get Contacts =>
      RealmObjectBase.get<ClsContact>(this, 'Contacts')
          as RealmList<ClsContact>;
  @override
  set Contacts(covariant RealmList<ClsContact> value) =>
      throw RealmUnsupportedSetError();

  @override
  bool? get IsLAb => RealmObjectBase.get<bool>(this, 'IsLAb') as bool?;
  @override
  set IsLAb(bool? value) => RealmObjectBase.set(this, 'IsLAb', value);

  @override
  int? get StatusCode => RealmObjectBase.get<int>(this, 'StatusCode') as int?;
  @override
  set StatusCode(int? value) => RealmObjectBase.set(this, 'StatusCode', value);

  @override
  bool? get Verified => RealmObjectBase.get<bool>(this, 'Verified') as bool?;
  @override
  set Verified(bool? value) => RealmObjectBase.set(this, 'Verified', value);

  @override
  String? get EditorId =>
      RealmObjectBase.get<String>(this, 'EditorId') as String?;
  @override
  set EditorId(String? value) => RealmObjectBase.set(this, 'EditorId', value);

  @override
  String? get DateRegistry =>
      RealmObjectBase.get<String>(this, 'DateRegistry') as String?;
  @override
  set DateRegistry(String? value) =>
      RealmObjectBase.set(this, 'DateRegistry', value);

  @override
  String? get DateExpiry =>
      RealmObjectBase.get<String>(this, 'DateExpiry') as String?;
  @override
  set DateExpiry(String? value) =>
      RealmObjectBase.set(this, 'DateExpiry', value);

  @override
  String? get AuthorID =>
      RealmObjectBase.get<String>(this, 'AuthorID') as String?;
  @override
  set AuthorID(String? value) => RealmObjectBase.set(this, 'AuthorID', value);

  @override
  int? get ServiceLimited =>
      RealmObjectBase.get<int>(this, 'ServiceLimited') as int?;
  @override
  set ServiceLimited(int? value) =>
      RealmObjectBase.set(this, 'ServiceLimited', value);

  @override
  Stream<RealmObjectChanges<ClsMember>> get changes =>
      RealmObjectBase.getChanges<ClsMember>(this);

  @override
  ClsMember freeze() => RealmObjectBase.freezeObject<ClsMember>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(ClsMember._);
    return const SchemaObject(ObjectType.realmObject, ClsMember, 'ClsMember', [
      SchemaProperty('UID_Mem', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('Mem_ID', RealmPropertyType.string),
      SchemaProperty('UID_Main', RealmPropertyType.string),
      SchemaProperty('UID_Plc', RealmPropertyType.string),
      SchemaProperty('Address_Title', RealmPropertyType.string),
      SchemaProperty('TariffID', RealmPropertyType.string, optional: true),
      SchemaProperty('Name', RealmPropertyType.string, optional: true),
      SchemaProperty('MidName', RealmPropertyType.string, optional: true),
      SchemaProperty('MidNameLocating', RealmPropertyType.int, optional: true),
      SchemaProperty('PerName', RealmPropertyType.string, optional: true),
      SchemaProperty('PerNameLocating', RealmPropertyType.int, optional: true),
      SchemaProperty('ImgUrl', RealmPropertyType.string, optional: true),
      SchemaProperty('Place', RealmPropertyType.object,
          optional: true, linkTarget: 'ClsPlace'),
      SchemaProperty('Contacts', RealmPropertyType.object,
          linkTarget: 'ClsContact', collectionType: RealmCollectionType.list),
      SchemaProperty('IsLAb', RealmPropertyType.bool, optional: true),
      SchemaProperty('StatusCode', RealmPropertyType.int, optional: true),
      SchemaProperty('Verified', RealmPropertyType.bool, optional: true),
      SchemaProperty('EditorId', RealmPropertyType.string, optional: true),
      SchemaProperty('DateRegistry', RealmPropertyType.string, optional: true),
      SchemaProperty('DateExpiry', RealmPropertyType.string, optional: true),
      SchemaProperty('AuthorID', RealmPropertyType.string, optional: true),
      SchemaProperty('ServiceLimited', RealmPropertyType.int, optional: true),
    ]);
  }
}

class ClsPatientInfo extends _ClsPatientInfo
    with RealmEntity, RealmObjectBase, RealmObject {
  ClsPatientInfo(
    String uidMem,
    String id,
    String name,
    int gender,
    int age,
    bool isInfectious,
    DateTime setDate, {
    int? idRec,
    String? description,
    DateTime? birthday,
    String? userId,
  }) {
    RealmObjectBase.set(this, 'idRec', idRec);
    RealmObjectBase.set(this, 'uidMem', uidMem);
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'gender', gender);
    RealmObjectBase.set(this, 'age', age);
    RealmObjectBase.set(this, 'isInfectious', isInfectious);
    RealmObjectBase.set(this, 'setDate', setDate);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'birthday', birthday);
    RealmObjectBase.set(this, 'userId', userId);
  }

  ClsPatientInfo._();

  @override
  int? get idRec => RealmObjectBase.get<int>(this, 'idRec') as int?;
  @override
  set idRec(int? value) => RealmObjectBase.set(this, 'idRec', value);

  @override
  String get uidMem => RealmObjectBase.get<String>(this, 'uidMem') as String;
  @override
  set uidMem(String value) => RealmObjectBase.set(this, 'uidMem', value);

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  int get gender => RealmObjectBase.get<int>(this, 'gender') as int;
  @override
  set gender(int value) => RealmObjectBase.set(this, 'gender', value);

  @override
  int get age => RealmObjectBase.get<int>(this, 'age') as int;
  @override
  set age(int value) => RealmObjectBase.set(this, 'age', value);

  @override
  bool get isInfectious =>
      RealmObjectBase.get<bool>(this, 'isInfectious') as bool;
  @override
  set isInfectious(bool value) =>
      RealmObjectBase.set(this, 'isInfectious', value);

  @override
  DateTime get setDate =>
      RealmObjectBase.get<DateTime>(this, 'setDate') as DateTime;
  @override
  set setDate(DateTime value) => RealmObjectBase.set(this, 'setDate', value);

  @override
  String? get description =>
      RealmObjectBase.get<String>(this, 'description') as String?;
  @override
  set description(String? value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  DateTime? get birthday =>
      RealmObjectBase.get<DateTime>(this, 'birthday') as DateTime?;
  @override
  set birthday(DateTime? value) => RealmObjectBase.set(this, 'birthday', value);

  @override
  String? get userId => RealmObjectBase.get<String>(this, 'userId') as String?;
  @override
  set userId(String? value) => RealmObjectBase.set(this, 'userId', value);

  @override
  Stream<RealmObjectChanges<ClsPatientInfo>> get changes =>
      RealmObjectBase.getChanges<ClsPatientInfo>(this);

  @override
  ClsPatientInfo freeze() => RealmObjectBase.freezeObject<ClsPatientInfo>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(ClsPatientInfo._);
    return const SchemaObject(
        ObjectType.realmObject, ClsPatientInfo, 'ClsPatientInfo', [
      SchemaProperty('idRec', RealmPropertyType.int, optional: true),
      SchemaProperty('uidMem', RealmPropertyType.string),
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('gender', RealmPropertyType.int),
      SchemaProperty('age', RealmPropertyType.int),
      SchemaProperty('isInfectious', RealmPropertyType.bool),
      SchemaProperty('setDate', RealmPropertyType.timestamp),
      SchemaProperty('description', RealmPropertyType.string, optional: true),
      SchemaProperty('birthday', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('userId', RealmPropertyType.string, optional: true),
    ]);
  }
}
