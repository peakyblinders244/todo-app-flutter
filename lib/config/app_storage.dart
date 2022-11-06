import 'package:get_storage/get_storage.dart';

import '../resources/lang/localization_service.dart';

class AppStorage {
  late GetStorage box;
  static const STORAGE_NAME = "todo_storage";
  static const APP_LANGUAGE = "app_language";

  // static const APP_THEME = "app_theme";

  init() async {
    await GetStorage.init(STORAGE_NAME);
    box = GetStorage(STORAGE_NAME);
  }

  Future<void> setLanguage(String language) async {
    box.write(APP_LANGUAGE, language);
  }

  Future<String> getLanguage() async {
    final language = await box.read(APP_LANGUAGE) ?? LocalizationService.VI_VN;
    return language;
  }

// Future<void> setTheme(int theme) async {
//   box.write(APP_THEME, theme);
// }

// Future<int> getTheme() async {
//   final theme = await box.read(APP_THEME) ?? ThemeService.LIGHT_THEME;
//   return theme;
// }
}
