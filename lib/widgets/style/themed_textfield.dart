import 'package:flutter/material.dart';
import 'package:petmatch/widgets/text_field.dart';

class ThemedTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final bool isPasswordField;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;

  const ThemedTextField({
    super.key,
    required this.label,
    required this.controller,
    this.prefixIcon,
    this.isPasswordField = false,
    this.validator,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldWidget(
      label: label,
      controller: controller,
      prefixIcon: prefixIcon,
      isPasswordField: isPasswordField,
      validator: validator,
      focusNode: focusNode,
      filled: true,
      fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.05),
      borderColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
      focusedBorderColor: Theme.of(context).colorScheme.primary,
      iconColor: Theme.of(context).colorScheme.onPrimary,
    );
  }
}
