import 'package:flutter/material.dart';

double getResponsiveValue(
  BuildContext context, {
  required double verySmall,
  required double small,
  required double medium,
  required double large,
}) {
  final screenHeight = MediaQuery.of(context).size.height;

  if (screenHeight < 700) return verySmall;
  if (screenHeight < 800) return small;
  if (screenHeight < 900) return medium;
  return large;
}
