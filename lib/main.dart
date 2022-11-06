import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo/resources/lang/localization_service.dart';
import 'package:todo/services/theme_services.dart';

import 'package:todo/ui/screens/home_screen.dart';
import 'package:get/get.dart';

import 'config/theme.dart';
import 'constants/local_string.dart';
import 'db/db_helper.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await DBHelper().database;
  runApp(MyApp());

}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeServices _ts = ThemeServices();


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: LocalString.appName,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: _ts.theme,
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

