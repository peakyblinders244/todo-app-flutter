import 'dart:ui';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/internacionalization.dart';
import 'package:todo/resources/lang/vi_vn.dart';

import '../../config/app_storage.dart';
import 'en_us.dart';



class LocalizationService extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {"vi": viVN, "en": enUS};

  final appStorage = Get.find<AppStorage>();

  static const VI_VN = "vi";
  static const EN_US = "en";

  static const supportLocale = [
    Locale(VI_VN),
    Locale(EN_US),
  ];

  String _language = VI_VN;

  String get currentLanguage => _language;

  init() {
    loadLanguage();
  }

  Future<void> loadLanguage() async {
    _language = await appStorage.getLanguage();
  }

  Locale get getLocale {
    return Locale(_language);
  }

  Future<void> updateLanguage(String value) async {
    _language = value;
    await appStorage.setLanguage(value);
    if (getLocale != null) {
      Get.updateLocale(getLocale);

    }
  }
}

