import 'package:get/get.dart';

abstract class AppTranslation {
  static Map<String, Map<String, String>> translationsKeys = {
    "en_US": enUS,
    "fa": fa,
    // "te": te,
    // "ur": ur,
    // "hi": hi,
    // "ta": ta,
    // "es": es,
    // "mr": mr,
    // "ru": ru,
    // "fr": fr
  };
}

final Map<String, String> enUS = {
  'unknown': '--',
  'settings': 'Settings',
  'doctor': 'Doctor / Client',
  'patient': 'Patient Info',
  'attachments': 'Attachments',
  'location': 'Location',
  'task': 'Task',
  'media': 'Media',
  'events': 'Events',
  'store': 'Store',
  'ServerNotFound': "Server Not Found!",

  'publicSetting': 'Public Setting',
  'WakeUp': 'Wake Up',
  'LoginPageSetting': 'Login Page Settings',
  'TaskPageSetting': 'Task Page Settings',
  'EmployerPageSetting': 'Employer Page Settings',
  'PatientPageSetting': 'Patient Page Settings',
  'Language': 'Language',
  'Date': 'Date/Calender',
  'TimeZone': 'Time Zone',
  'TimeZoneIsNotDevice': 'The specified time zone is not synchronized with the device!',
  'DateGregorian': 'Gregorian Calendar',
  'DatePersian': 'Persian Jalali Calendar',
  'Theme': 'Theme',
  'DarkTheme': 'Dark Theme',
  'UserName': 'User Name',
  'Password': 'Password',

  'ScrollPage': 'Scroll page with touch to Left/Right',
  'ExpandList': 'Expanded List',

  'Removable': 'Removable',
  'Fixed': 'Fixed',

  'Male': 'Mr.',
  'Female': 'Mrs.',

  'PatientName': 'Patient Name',
  'EnterPatientNameHere': 'Enter Patient Name Here',
  'PatientAge': 'Age of the patient',
  'BirthdayFull': 'Birthday',
  'BirthdayYear': 'Year of Birth',
  'AgeRange': 'The age range',
  'OnlyAge': 'Age',

  'Description': 'Description',
  'RepeatPatient' : 'Another patient with the same name has already been registered!',
  'PatientUpdate' : "Confirm to update patient information.",
  'PatientReset' : "Or distinguish the patient's name with another character and resend.",
  'SetDate': 'Date of insertion',

  'Cancel': 'Cancel',
  'Loading': 'Loading',
  'Failed': 'Failed',
  'Success': 'Success',
  'Repeat': 'Duplicate!',
  'Back': 'Bach',
  'Save': 'Save',
  'Update': 'Update',
  'Select': 'Select',

  'RecordInserted': 'This record has been inserted!',
  'enterPatientName': 'Enter Patient Name!',
  'enterPatientGender': 'Specify the gender of the patient!',
  'enterPatientAge': "Specify the patient's age!",

  'OrderPlaced': 'Order Placed',
  'Registered': 'Registered',
  'Reception': 'Reception',
  'Process': 'Process',
  'Delivered': 'Delivered',
  'Cashed': 'Cashed',
};

final Map<String, String> fa = {
  'unknown': '--',
  'settings': 'تنظیمات',
  'doctor': 'پزشک / کارفرما',
  'patient': 'اطلاعات بیمار',
  'attachments': 'پیوست',
  'location': 'مکان',
  'task': 'دستور کار',
  'media': 'رسانه',
  'events': 'وقایع',
  'store': 'فروشگاه',

  'ServerNotFound': "ارتباط با سرور برقرار نشد!",

  'publicSetting': 'تنظیمات عمومی',
  'WakeUp': 'بیدار ماندن دستگاه',
  'LoginPageSetting': 'تنظیمات صفحه ورود',
  'TaskPageSetting': 'تنظیمات صفحه دستور کار',
  'EmployerPageSetting': 'تنظیمات لیست پزشک/کارفرما',
  'PatientPageSetting': 'تنظیمات اطلاعات بیمار',
  'Language': '(Language)زبان',
  'Date': 'تاریخ/تقویم',
  'TimeZone': 'منطقه زمانی',
  'TimeZoneIsNotDevice': '!منطقه زمانی تعیین شده با دستگاه همگام نیست',
  'DateGregorian': 'تقویم میلادی',
  'DatePersian': 'تقویم فارسی جلالی',
  'Theme': 'طرح',
  'DarkTheme': 'طرح تاریک',
  'UserName': 'نام کاربری',
  'Password': 'کلمه عبور',

  'ScrollPage': 'مرور صفحات با کشیدن انگشت به چپ و راست',
  'ExpandList': 'لیست کرکره ای',

  'Removable': 'متحرک',
  'Fixed': 'ثابت',

  'Male': 'آقای',
  'Female': 'خانم',

  'PatientName': 'نام بیمار',
  'EnterPatientNameHere': 'نام بیمار را وارد کنید',
  'PatientAge': 'سن بیمار',
  'BirthdayFull': 'تاریخ تولد',
  'BirthdayYear': 'سال تولد',
  'AgeRange': 'محدوده سنی',
  'OnlyAge': 'سن',

  'Description': 'ملاحظات',
  'RepeatPatient' : 'بیمار دیگری با همین نام قبلا ثبت شده است!',
  'PatientUpdate' : "برای بروزرسانی اطلاعات بیمار تأیید نمایید.",
  'PatientReset' : 'و یا انصراف داده و نام بیمار را با کاراکتری متمایز و مجدد ارسال کنید.',
  'SetDate': 'تاریخ ثبت',

  'Cancel': 'انصراف',
  'Loading': 'درحال بارگذاری',
  'Failed': 'ناموفق',
  'Success': 'انجام شد',
  'Repeat': 'تکراری!',
  'Back': 'بازگشت',
  'Save': 'ثبت',
  'Update': 'بروزرسانی',
  'Select': 'انتخاب',

  'RecordInserted': 'این رکورد درج شده است!',
  'enterPatientName': 'نام بیمار را وارد کنید!',
  'enterPatientGender': 'جنسیت بیمار را مشخص کنید!',
  'enterPatientAge': 'سن بیمار را مشخص کنید!',

  'OrderPlaced': 'درج اطلاعات',
  'Registered': 'ثبت',
  'Reception': 'پذیرش',
  'Process': 'روند طراحی',
  'Delivered': 'تحویل',
  'Cashed': 'تسویه',

//نوجوان
//< 20
//
//جوان
//۲۰ تا ۳۰ سالگی
//
//میانسال
//۳۰ تا ۵۰ سالگی
//
//۵۰ تا ۷۵ سالگی
//بزرگسال
//
//سالمند
//> 75

};

// class WordsTranslations extends Translations {
//   @override
//   Map<String, Map<String, String>> get keys => {
//     'en_US': {
//       'settings': 'Settings',
//       'doctor': 'Doctor / Client',
//       'task': 'Task',
//       'media': 'Media',
//       'events': 'Events',
//       'store': 'Store',
//
//       'publicSetting': 'Public Setting',
//       'WakeUp': 'Wake Up',
//       'LoginPageSetting': 'Login Page Settings',
//       'TaskPageSetting': 'Task Page Settings',
//       'EmployerPageSetting': 'Employer Page Settings',
//       'Language': 'Language',
//       'Theme': 'Theme',
//       'DarkTheme': 'Dark Theme',
//       'UserName': 'User Name',
//       'Password': 'Password',
//
//       'ScrollPage': 'Scroll page with touch to Left/Right',
//       'ExpandList': 'Expanded List',
//
//     },
//     'fa_IR': {
//       'settings': 'تنظیمات',
//       'doctor': 'پزشک / کارفرما',
//       'task': 'دستور کار',
//       'media': 'رسانه',
//       'events': 'وقایع',
//       'store': 'فروشگاه',
//
//       'publicSetting': 'تنظیمات عمومی',
//       'WakeUp': 'بیدار ماندن دستگاه',
//       'LoginPageSetting': 'تنظیمات صفحه ورود',
//       'TaskPageSetting': 'تنظیمات صفحه دستور کار',
//       'EmployerPageSetting': 'تنظیمات لیست پزشک/کارفرما',
//       'Language': '(Language)زبان',
//       'Theme': 'طرح',
//       'DarkTheme': 'طرح تاریک',
//       'UserName': 'نام کاربری',
//       'Password': 'کلمه عبور',
//
//       'ScrollPage': 'مرور صفحات با کشیدن انگشت به چپ و راست',
//       'ExpandList': 'لیست کرکره ای',
//     }
//   };
// }