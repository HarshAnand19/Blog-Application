import 'package:flutter/material.dart';

class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    textTheme: TextTheme(bodyText1: TextStyle(color: Colors.white)),
    colorScheme: ColorScheme.dark(),
    primaryColor: Colors.grey.shade800,
   iconTheme: IconThemeData(color: Colors.amber),
      appBarTheme: AppBarTheme(backgroundColor: Colors.transparent),
      floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.amber),


  );

  static final lightTheme = ThemeData(
scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.white,
    colorScheme: ColorScheme.light(),
      textTheme: TextTheme(bodyText1: TextStyle(color: Colors.black)),
      iconTheme: IconThemeData(color: Colors.white),
      appBarTheme: AppBarTheme(backgroundColor: Colors.green),
      floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.green)

  );
}

class ThemeProvider extends ChangeNotifier{
  //which theme to show by default
  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode =>themeMode ==ThemeMode.dark;

void toggleTheme(bool isOn){
  themeMode=isOn? ThemeMode.dark:ThemeMode.light;
  notifyListeners();
}
}
