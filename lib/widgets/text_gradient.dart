import 'package:flutter/material.dart';

class TextHeader extends StatelessWidget {
  const TextHeader({
    super.key,
    required this.text,
    required this.fontSize,
    this.textAlign,
    this.letterSpacing = -1.5,
    this.heightSpacing = 1.2,
    this.color,
  });

  final String text;
  final double fontSize;
  final TextAlign? textAlign;
  final double letterSpacing;
  final double heightSpacing;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.left,
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: fontSize,
            letterSpacing: letterSpacing,
            color: color ?? Theme.of(context).colorScheme.onPrimary,
            height: heightSpacing,
          ),
    );
  }
}
