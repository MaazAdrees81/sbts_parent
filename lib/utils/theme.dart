import 'package:flutter/material.dart';

import '../globals/constants.dart';

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: kPrimaryColor,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: kPoppins,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: kPrimaryColor,
    primarySwatch: Colors.deepPurple,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    checkboxTheme: CheckboxThemeData(
      side: const BorderSide(width: 1.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: kPrimaryColor,
      contentTextStyle: TextStyle(color: Colors.white),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: kBorderRadius24),
    ),
    datePickerTheme: DatePickerThemeData(rangeSelectionBackgroundColor: kOrange.withValues(alpha: 0.2)),
    colorScheme: const ColorScheme.light().copyWith(primary: kPrimaryColor, surfaceTint: kPrimaryColor),
    switchTheme: SwitchThemeData(thumbColor: WidgetStateColor.resolveWith((Set<WidgetState> states) => states.contains(WidgetState.selected) ? Colors.white : Colors.black), trackColor: WidgetStateColor.resolveWith((Set<WidgetState> states) => states.contains(WidgetState.selected) ? Colors.teal : Colors.white)),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: kPrimaryColor,
        textStyle: const TextStyle(fontFamily: kPoppins, fontWeight: FontWeight.w500, color: kPrimaryColor),
        side: const BorderSide(color: kGrey, width: 0.5),
        shape: RoundedRectangleBorder(borderRadius: kBorderRadius16),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: kBorderRadius12),
        foregroundColor: Colors.white,
        backgroundColor: kPrimaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        textStyle: const TextStyle(fontFamily: kPoppins, fontWeight: FontWeight.w500, color: Colors.white),
        disabledForegroundColor: Colors.white,
        disabledBackgroundColor: Colors.grey,
      ),
    ),
  );
}
