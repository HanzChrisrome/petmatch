import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildFieldLabel extends StatelessWidget {
  final String text;
  final String emoji;
  final String? subtitle;
  final bool isRequired;

  const BuildFieldLabel({
    super.key,
    required this.text,
    required this.emoji,
    this.subtitle,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 6),
            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              const Text('*',
                  style: TextStyle(color: Colors.red, fontSize: 16)),
            ],
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              subtitle!,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
