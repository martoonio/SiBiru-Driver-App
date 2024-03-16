import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

Color whiteColor = Color(0xffffffff);
Color textColor = Color(0xffffffff);
Color secondaryTextColor = Color(0xffffffff);
Color primaryButtonColor = Color(0x054C67);
Color buttonColor = Color.fromARGB(0, 255, 255, 255);
const kPrimaryColor = Color(0xFF054C67);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF82A5B3), Color(0xFF054C67)],
);
const kSecondaryColor = Color(0xFF82A5B3);
const kTextColor = Color(0xFF757575);

TextStyle whiteTextStyle = GoogleFonts.dmSans(
  color: whiteColor,
);
TextStyle textTextStyle = GoogleFonts.dmSans(
  color: textColor,
);
TextStyle secondaryTextStyle = GoogleFonts.poppins(
  color: secondaryTextColor,
);

FontWeight bold = FontWeight.bold;
