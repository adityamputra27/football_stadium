import 'package:flutter/widgets.dart';

const String fontFamily = 'WorkSans';
const Color primaryColor = Color(0xff2260CE);
const Color secondaryColor = Color(0xff13232C);
const Color thirdColor = Color(0xff172A32);
const Color backgroundColor = Color(0xff0E1C26);
const Color whiteColor = Color(0xffFFFFFF);
const Color grayColor = Color.fromARGB(255, 144, 144, 144);
const Color borderColor = Color(0xff3C3C3C);
const Color dotIndicatorDefaultColor = Color(0xff929292);
const Color dotIndicatorActiveColor = Color(0xff454545);
const Color initialGradientColor = Color(0xff232425);
const Color subtitleColor = Color.fromARGB(255, 205, 205, 205);

var thinTextStyle = TextStyle(
  fontFamily: fontFamily,
  fontWeight: FontWeight.w100,
);

var lightTextStyle = TextStyle(
  fontFamily: fontFamily,
  fontWeight: FontWeight.w300,
);

var regularTextStyle = TextStyle(
  fontFamily: fontFamily,
  fontWeight: FontWeight.normal,
);

var mediumTextStyle = TextStyle(
  fontFamily: fontFamily,
  fontWeight: FontWeight.w500,
);

var semiBoldTextStyle = TextStyle(
  fontFamily: fontFamily,
  fontWeight: FontWeight.w600,
);

var boldTextStyle = TextStyle(
  fontFamily: fontFamily,
  fontWeight: FontWeight.bold,
);

var blackTextStyle = TextStyle(
  fontFamily: fontFamily,
  fontWeight: FontWeight.w900,
);

Color adjustColor(Color color) {
  final hsl = HSLColor.fromColor(color);
  return hsl.withLightness(hsl.lightness * 0.75).toColor();
}
