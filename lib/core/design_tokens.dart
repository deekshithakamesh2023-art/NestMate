import 'package:flutter/cupertino.dart';

abstract final class PortalTokens {
  static const double space1 = 4;
  static const double space2 = 8;
  static const double space3 = 12;
  static const double space4 = 16;
  static const double space5 = 20;
  static const double space6 = 24;
  static const double space8 = 32;

  static const double radiusSmall = 12;
  static const double radiusCard = 20;
  static const double radiusLarge = 28;
  static const double tapTarget = 48;

  static const Color lightBackground = Color(0xFFF4F7F6);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightPrimaryText = Color(0xFF17252C);
  static const Color lightSecondaryText = Color(0xFF43545B);
  static const Color lightTertiaryText = Color(0xFF53656C);
  static const Color lightAccent = Color(0xFF145C4B);
  static const Color lightAccentText = Color(0xFFFFFFFF);
  static const Color lightLink = Color(0xFF174FA3);
  static const Color lightError = Color(0xFFAA261E);
  static const Color lightSuccess = Color(0xFF17623B);
  static const Color lightWarning = Color(0xFF704400);
  static const Color lightBorder = Color(0xFF78858A);

  static const Color darkBackground = Color(0xFF10191D);
  static const Color darkSurface = Color(0xFF1B292E);
  static const Color darkPrimaryText = Color(0xFFF0F5F4);
  static const Color darkSecondaryText = Color(0xFFC5D2D0);
  static const Color darkTertiaryText = Color(0xFFB5C6C3);
  static const Color darkAccent = Color(0xFF91DEC3);
  static const Color darkAccentText = Color(0xFF10231D);
  static const Color darkLink = Color(0xFFA6C8FF);
  static const Color darkError = Color(0xFFFFB4A9);
  static const Color darkSuccess = Color(0xFF9BE0B0);
  static const Color darkWarning = Color(0xFFFFD18A);
  static const Color darkBorder = Color(0xFF849693);

  static CupertinoThemeData theme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final text = isDark ? darkPrimaryText : lightPrimaryText;
    return CupertinoThemeData(
      brightness: brightness,
      primaryColor: isDark ? darkAccent : lightAccent,
      scaffoldBackgroundColor: isDark ? darkBackground : lightBackground,
      barBackgroundColor: isDark ? darkSurface : lightSurface,
      textTheme: CupertinoTextThemeData(
        textStyle: TextStyle(color: text, fontSize: 16, height: 1.45),
        navTitleTextStyle: TextStyle(
          color: text,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
        tabLabelTextStyle: TextStyle(
          color: isDark ? darkSecondaryText : lightSecondaryText,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

extension PortalColors on BuildContext {
  bool get isDark => CupertinoTheme.brightnessOf(this) == Brightness.dark;
  Color get canvas =>
      isDark ? PortalTokens.darkBackground : PortalTokens.lightBackground;
  Color get surface =>
      isDark ? PortalTokens.darkSurface : PortalTokens.lightSurface;
  Color get primaryText =>
      isDark ? PortalTokens.darkPrimaryText : PortalTokens.lightPrimaryText;
  Color get secondaryText =>
      isDark ? PortalTokens.darkSecondaryText : PortalTokens.lightSecondaryText;
  Color get tertiaryText =>
      isDark ? PortalTokens.darkTertiaryText : PortalTokens.lightTertiaryText;
  Color get accent =>
      isDark ? PortalTokens.darkAccent : PortalTokens.lightAccent;
  Color get accentText =>
      isDark ? PortalTokens.darkAccentText : PortalTokens.lightAccentText;
  Color get link => isDark ? PortalTokens.darkLink : PortalTokens.lightLink;
  Color get error => isDark ? PortalTokens.darkError : PortalTokens.lightError;
  Color get success =>
      isDark ? PortalTokens.darkSuccess : PortalTokens.lightSuccess;
  Color get warning =>
      isDark ? PortalTokens.darkWarning : PortalTokens.lightWarning;
  Color get border =>
      isDark ? PortalTokens.darkBorder : PortalTokens.lightBorder;
}
