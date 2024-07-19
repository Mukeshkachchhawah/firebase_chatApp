import 'package:flutter/material.dart';

Widget hSpace({double mHeight = 20.0}) {
  return SizedBox(
    height: mHeight,
  );
}

Widget wSpace({double mWidth = 15.0}) {
  return SizedBox(
    width: mWidth,
  );
}

TextStyle smallTextStyle(BuildContext context, {Color color = Colors.black}) {
  return Theme.of(context).textTheme.bodySmall!.copyWith(
        color: color,
        fontSize: 14,
      );
}

TextStyle mediumTextStyle(BuildContext context, {Color color = Colors.black}) {
  return Theme.of(context).textTheme.bodyMedium!.copyWith(
        color: color,
        fontSize: 16,
      );
}

TextStyle largeTextStyle(BuildContext context, {Color color = Colors.black}) {
  return Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: color,
        fontSize: 24,
      );
}

/// Custom fonts custom button fonts size forget password
TextStyle textStyleFonts14(BuildContext context, {colors = Colors.black}) {
  return Theme.of(context).textTheme.displaySmall!.copyWith(
        color: colors,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      );
}
