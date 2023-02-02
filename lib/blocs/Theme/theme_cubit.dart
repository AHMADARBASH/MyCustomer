// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_customer/blocs/Theme/theme_state.dart';
import 'package:my_customer/data/local/sharedPreferences_helper.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeChangedState());

  static ThemeCubit get(BuildContext context) =>
      BlocProvider.of<ThemeCubit>(context);

  ThemeData? appTheme;

  void setTheme() {
    CachedData.containsTheme()
        ? appTheme = themes[CachedData.getTheme()]!
        : appTheme = ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: const Color.fromARGB(255, 96, 150, 204),
                secondary: Colors.blue,
                background: const Color(0xffDDDDDD),
                error: Colors.redAccent),
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            primaryIconTheme: IconThemeData(
              color: Colors.white,
            ),
            listTileTheme: const ListTileThemeData(
              iconColor: Color(0xff30475E),
              contentPadding: EdgeInsets.all(10),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color.fromARGB(255, 47, 90, 132),
              iconTheme: IconThemeData(color: Color(0xFFFFFFFE)),
              actionsIconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(color: Colors.white)),
            ),
            textTheme: TextTheme(
                bodyMedium: TextStyle(color: Colors.white),
                bodySmall: TextStyle(color: Colors.white)),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.blue,
            ),
            canvasColor: const Color(0xff1D2328),
          );
  }

  Map<String, ThemeData> themes = {
    'blueTheme': ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromARGB(255, 96, 150, 204),
          secondary: Colors.blue,
          background: const Color(0xffDDDDDD),
          error: Colors.redAccent),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      primaryIconTheme: const IconThemeData(
        color: Colors.white,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: Color(0xff30475E),
        contentPadding: EdgeInsets.all(10),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 47, 90, 132),
        iconTheme: IconThemeData(color: Color(0xFFFFFFFE)),
        actionsIconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(color: Colors.white)),
      ),
      textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white)),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.blue,
      ),
      canvasColor: const Color(0xff1D2328),
    ),
    'darkTheme': ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromARGB(255, 96, 150, 204),
          secondary: Colors.blue,
          background: const Color(0xffDDDDDD),
          error: Colors.redAccent),
      listTileTheme: const ListTileThemeData(
        iconColor: Color(0xff30475E),
        contentPadding: EdgeInsets.all(10),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 47, 90, 132),
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(color: Colors.white)),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.white),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.blue,
      ),
      canvasColor: Colors.black,
    ),
    'whiteTheme': ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromARGB(255, 96, 150, 204),
          secondary: Colors.blue,
          background: Colors.white,
          error: Colors.redAccent),
      listTileTheme: const ListTileThemeData(
        iconColor: Colors.black,
        contentPadding: EdgeInsets.all(10),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(color: Colors.black)),
      ),
      textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
          bodySmall: TextStyle(color: Colors.white)),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.blue,
      ),
      canvasColor: Colors.white,
    ),
  };

  String getThemeName() {
    bool hasTheme = CachedData.containsTheme();
    if (hasTheme) {
      return CachedData.getTheme()!;
    } else {}
    return 'blueTheme';
  }

  void changeTheme({required String themeName}) {
    CachedData.saveTheme(themeName: themeName);
    appTheme = themes[themeName];
    emit(ThemeChangedState());
  }
}
