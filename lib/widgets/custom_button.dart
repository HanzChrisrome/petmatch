import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.gradient,
    this.horizontalPadding = 50,
    this.verticalPadding = 16,
    this.borderRadius = 30,
    this.fontSize = 17,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Gradient? gradient;
  final double horizontalPadding;
  final double verticalPadding;
  final double borderRadius;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final buttonColor =
        backgroundColor ?? Theme.of(context).colorScheme.onPrimary;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: SizedBox(
        width: double.infinity,
        child: gradient != null
            ? _buildGradientButton(context)
            : _buildSolidButton(context, buttonColor),
      ),
    );
  }

  Widget _buildSolidButton(BuildContext context, Color buttonColor) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        elevation: 0,
      ),
      child: _buildButtonContent(context),
    );
  }

  Widget _buildGradientButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Ink(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: verticalPadding),
            alignment: Alignment.center,
            child: _buildButtonContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent(BuildContext context) {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
          ),
        ],
      );
    } else {
      return Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
      );
    }
  }
}
