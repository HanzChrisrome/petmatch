import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petmatch/features/pet_profile/widgets/build_field_label.dart';
import 'package:petmatch/widgets/style/themed_textfield.dart';

class BehaviorInfoStep extends ConsumerStatefulWidget {
  final TextEditingController behavioralNotesController;
  final String? goodWithChildren;
  final String? goodWithDogs;
  final String? goodWithCats;
  final String? houseTrained;
  final Function(String?) onGoodWithChildrenChanged;
  final Function(String?) onGoodWithDogsChanged;
  final Function(String?) onGoodWithCatsChanged;
  final Function(String?) onHouseTrainedChanged;

  const BehaviorInfoStep({
    super.key,
    required this.behavioralNotesController,
    required this.goodWithChildren,
    required this.goodWithDogs,
    required this.goodWithCats,
    required this.houseTrained,
    required this.onGoodWithChildrenChanged,
    required this.onGoodWithDogsChanged,
    required this.onGoodWithCatsChanged,
    required this.onHouseTrainedChanged,
  });

  @override
  ConsumerState<BehaviorInfoStep> createState() => _BehaviorInfoStepState();
}

class _BehaviorInfoStepState extends ConsumerState<BehaviorInfoStep> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Good with Children
          const BuildFieldLabel(text: 'Good with children?', emoji: '👶'),
          const SizedBox(height: 12),
          _buildThreeOptionToggle(
            selected: widget.goodWithChildren,
            onChanged: (value) => widget.onGoodWithChildrenChanged(value),
          ),
          const SizedBox(height: 24),

          // Good with Dogs
          const BuildFieldLabel(text: 'Good with other dogs?', emoji: '🐕'),
          const SizedBox(height: 12),
          _buildThreeOptionToggle(
            selected: widget.goodWithDogs,
            onChanged: (value) => widget.onGoodWithDogsChanged(value),
          ),
          const SizedBox(height: 24),

          // Good with Cats
          const BuildFieldLabel(text: 'Good with cats?', emoji: '🐈'),
          const SizedBox(height: 12),
          _buildThreeOptionToggle(
            selected: widget.goodWithCats,
            onChanged: (value) => widget.onGoodWithCatsChanged(value),
          ),
          const SizedBox(height: 24),

          // House Trained
          const BuildFieldLabel(text: 'House-trained?', emoji: '🏠'),
          const SizedBox(height: 12),
          _buildHouseTrainedToggle(),
          const SizedBox(height: 24),

          // Behavioral Notes
          const BuildFieldLabel(
              text: 'Behavioral Notes',
              emoji: '📝',
              subtitle: 'Behaviors, quirks, important details'),
          const SizedBox(height: 8),
          ThemedTextField(
            controller: widget.behavioralNotesController,
            label: 'e.g., Loves car rides, scared of loud noises',
            prefixIcon: Icons.edit_note,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  // -------------------------------
  // Helper to build field labels
  // -------------------------------
  Widget _buildThreeOptionToggle(
      {required String? selected, required Function(String) onChanged}) {
    final options = [
      {
        'label': 'Yes',
        'emoji': '✅',
        'value': 'Yes',
        'color': const Color(0xFF66BB6A)
      },
      {
        'label': 'No',
        'emoji': '❌',
        'value': 'No',
        'color': const Color(0xFFEF5350)
      },
      {
        'label': 'Unknown',
        'emoji': '❓',
        'value': 'Unknown',
        'color': const Color(0xFFBDBDBD)
      },
    ];

    return Row(
      children: options.map((option) {
        final isSelected = selected == option['value'];
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(option['value'] as String),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: isSelected ? (option['color'] as Color) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? (option['color'] as Color)
                      : Colors.grey[300]!,
                  width: isSelected ? 2 : 1.5,
                ),
              ),
              child: Column(
                children: [
                  Text(option['emoji'] as String,
                      style: const TextStyle(fontSize: 22)),
                  const SizedBox(height: 6),
                  Text(
                    option['label'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHouseTrainedToggle() {
    final options = [
      {
        'label': 'Yes',
        'emoji': '✅',
        'value': 'Yes',
        'color': const Color(0xFF66BB6A)
      },
      {
        'label': 'No',
        'emoji': '❌',
        'value': 'No',
        'color': const Color(0xFFEF5350)
      },
      {
        'label': 'In Progress',
        'emoji': '🔄',
        'value': 'In Progress',
        'color': const Color(0xFF42A5F5)
      },
    ];

    return Row(
      children: options.map((option) {
        final isSelected = widget.houseTrained == option['value'];
        return Expanded(
          child: GestureDetector(
            onTap: () =>
                widget.onHouseTrainedChanged(option['value'] as String),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: isSelected ? (option['color'] as Color) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? (option['color'] as Color)
                      : Colors.grey[300]!,
                  width: isSelected ? 2 : 1.5,
                ),
              ),
              child: Column(
                children: [
                  Text(option['emoji'] as String,
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 6),
                  Text(
                    option['label'] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
