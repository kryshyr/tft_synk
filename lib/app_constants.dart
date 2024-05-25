import 'package:flutter/material.dart';

// Color palette
class AppColors {
  static const Color primary = Color(0xFF0A1428);
  static const Color primaryVariant = Color(0xFF0A323C);
  static const Color secondary = Color(0xFFC89B3C);
  static const Color secondaryVariant = Color(0xFF785A28);
  static const Color background = Color(0xFF0A1428);
  static const Color primaryAccent = Color(0xFF165A6B);
  static const Color secondaryAccent = Color(0xFF092231);
  static const Color tertiaryAccent = Color(0xFF0AC8B9);
  static const Color primaryText = Color(0xFFFFFFFF);
  static const Color secondaryText = Color(0xFFC89B3C);
  static const Color hintText = Color(0xFFA09B8C);
  static const Color error = Color(0xFFB00020);
}

// Font sizes
class FontSizes {
  static const double extraSmall = 10.0;
  static const double small = 12.0;
  static const double medium = 14.0;
  static const double large = 18.0;
  static const double extraLarge = 24.0;
}

// Text styles
class AppTextStyles {
  // BeaufortforLOL
  static const TextStyle headline1BeaufortforLOL = TextStyle(
    fontFamily: 'BeaufortforLOL',
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.secondaryText,
  );
  static const TextStyle headline2BeaufortforLOL = TextStyle(
    fontFamily: 'BeaufortforLOL',
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
  );
  static const TextStyle headline3BeaufortforLOL = TextStyle(
    fontFamily: 'BeaufortforLOL',
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: AppColors.secondaryText,
  );
  static const TextStyle headline4BeaufortforLOL = TextStyle(
    fontFamily: 'BeaufortforLOL',
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 255, 255, 255),
  );
  static const TextStyle headline5BeaufortforLOL = TextStyle(
    fontFamily: 'BeaufortforLOL',
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: AppColors.secondaryText,
  );
  static const TextStyle bodyText1BeaufortforLOL = TextStyle(
    fontFamily: 'BeaufortforLOL',
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: AppColors.primaryText,
  );
  static const TextStyle bodyText2BeaufortforLOL = TextStyle(
    fontFamily: 'BeaufortforLOL',
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.primaryText,
  );

  // Spiegel
  static const TextStyle headline1Spiegel = TextStyle(
    fontFamily: 'Spiegel',
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.secondaryText,
  );
  static const TextStyle headline2Spiegel = TextStyle(
    fontFamily: 'Spiegel',
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: AppColors.secondaryText,
  );
  static const TextStyle bodyText1Spiegel = TextStyle(
    fontFamily: 'Spiegel',
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: AppColors.primaryText,
  );
  static const TextStyle bodyText2Spiegel = TextStyle(
    fontFamily: 'Spiegel',
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
  );
  static const TextStyle bodyText3Spiegel = TextStyle(
    fontFamily: 'Spiegel',
    fontSize: 12.0,
    color: AppColors.hintText,
  );
  static const TextStyle bodyText4Spiegel = TextStyle(
    fontFamily: 'Spiegel',
    fontSize: 10.0,
    color: AppColors.tertiaryAccent,
  );
  static const TextStyle bodyText5Spiegel = TextStyle(
    fontFamily: 'Spiegel',
    fontSize: 14.0,
    color: AppColors.hintText,
  );
  static const TextStyle bodyText6Spiegel = TextStyle(
    fontFamily: 'Spiegel',
    fontSize: 16.0,
    color: AppColors.hintText,
  );
}

// Other constants
class AppConstants {
  static const double padding = 16.0;
  static const double margin = 16.0;
  static const double borderRadius = 8.0;
}
