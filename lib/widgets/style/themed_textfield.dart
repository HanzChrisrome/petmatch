import 'package:flutter/material.dart';
import 'package:petmatch/widgets/text_field.dart';

class ThemedTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final bool isPasswordField;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final int? maxLines;
  final TextInputType? keyboardType;

  const ThemedTextField({
    super.key,
    required this.label,
    required this.controller,
    this.prefixIcon,
    this.isPasswordField = false,
    this.validator,
    this.focusNode,
    this.maxLines,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    // If maxLines is provided, we need to use TextFormField directly
    if (maxLines != null && maxLines! > 1) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFieldWidget(
          label: label,
          controller: controller,
          prefixIcon: prefixIcon,
          iconColor: Theme.of(context).colorScheme.onPrimary,
          fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.05),
          borderColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
          filled: true,
          focusedBorderColor: Theme.of(context).colorScheme.onPrimary,
          validator: validator,
        ),
      );
    }

    return TextFieldWidget(
      label: label,
      controller: controller,
      prefixIcon: prefixIcon,
      iconColor: Theme.of(context).colorScheme.onPrimary,
      fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.05),
      borderColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
      filled: true,
      focusedBorderColor: Theme.of(context).colorScheme.onPrimary,
      validator: validator,
      maxLines: maxLines,
      isPasswordField: isPasswordField,
    );
  }
}
