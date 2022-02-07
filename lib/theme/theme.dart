import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData _currentTheme = ThemeData.dark();

const Color blackbellsColor = Color(0xff121212);
const _defaultTextStyle = TextStyle(color: Colors.white);

final _colorScheme = const ColorScheme.dark().copyWith(
  background: blackbellsColor,
  primary: Colors.white,
);

const _appBarTheme = AppBarTheme(elevation: 0);

ThemeData blackbellsTheme = _currentTheme.copyWith(
  appBarTheme: _appBarTheme,
  scaffoldBackgroundColor: blackbellsColor,
  colorScheme: _colorScheme,
  textTheme: GoogleFonts.robotoSlabTextTheme(
    const TextTheme(
      headline6: _defaultTextStyle,
    ),
  ),
);
