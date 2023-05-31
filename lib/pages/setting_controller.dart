import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  // static RxString selectedLanguage = Get.locale!.languageCode.obs;
  // static LanguageModel currentLanguage = languages.firstWhere((element) => element.symbol == Get.locale!.languageCode);

  set changeLanguage(String lang) {
    Locale locale = Locale(lang);
    Get.updateLocale(locale);
    // SettingValues.myLanguage.value = lang;
    // selectedLanguage.value = lang;
    // currentLanguage = languages.firstWhere((element) => element.symbol == lang);
  }
}
