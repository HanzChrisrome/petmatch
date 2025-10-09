import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petmatch/features/pet_profile/widgets/build_field_label.dart';
import 'package:petmatch/widgets/style/themed_textfield.dart';

class HealthInfoStep extends ConsumerStatefulWidget {
  final TextEditingController healthNotesController;
  final TextEditingController specialNeedsDescController;
  final int? groomingNeeds;
  final String? hasSpecialNeeds;
  final String? isVaccinationUpToDate;
  final String? isSpayedNeutered;
  final Function(int?) onGroomingNeedsChanged;
  final Function(bool?) onHasSpecialNeedsChanged;
  final Function(bool?) onVaccinationChanged;
  final Function(bool?) onSpayedNeuteredChanged;

  const HealthInfoStep({
    super.key,
    required this.healthNotesController,
    required this.specialNeedsDescController,
    required this.groomingNeeds,
    required this.hasSpecialNeeds,
    required this.isVaccinationUpToDate,
    required this.isSpayedNeutered,
    required this.onGroomingNeedsChanged,
    required this.onHasSpecialNeedsChanged,
    required this.onVaccinationChanged,
    required this.onSpayedNeuteredChanged,
  });

  @override
  ConsumerState<HealthInfoStep> createState() => _HealthInfoStepState();
}

class _HealthInfoStepState extends ConsumerState<HealthInfoStep> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BuildFieldLabel(text: 'Vaccinations up to date?', emoji: '💉'),
          const SizedBox(height: 12),
          _buildYesNoToggle(
            isSelected: widget.isVaccinationUpToDate,
            onChanged: (value) => widget.onVaccinationChanged(value),
          ),
          const SizedBox(height: 24),

          // Spayed/Neutered
          const BuildFieldLabel(text: 'Spayed/Neutered?', emoji: '🏥'),
          const SizedBox(height: 12),
          _buildYesNoToggle(
            isSelected: widget.isSpayedNeutered,
            onChanged: (value) => widget.onSpayedNeuteredChanged(value),
          ),
          const SizedBox(height: 24),

          // Health Notes
          const BuildFieldLabel(
            text: 'Health Notes',
            emoji: '📋',
            subtitle: 'Allergies, conditions, medications',
          ),
          const SizedBox(height: 8),
          ThemedTextField(
            controller: widget.healthNotesController,
            label: 'e.g., Allergic to chicken, takes arthritis medication',
            prefixIcon: Icons.notes,
            maxLines: 3,
          ),
          const SizedBox(height: 24),

          // Special Needs
          const BuildFieldLabel(text: 'Special Needs?', emoji: '♿'),
          const SizedBox(height: 12),
          _buildYesNoToggle(
            isSelected: widget.hasSpecialNeeds,
            onChanged: (value) => widget.onHasSpecialNeedsChanged(value),
          ),

          if (widget.hasSpecialNeeds == "Yes") ...[
            const SizedBox(height: 16),
            ThemedTextField(
              controller: widget.specialNeedsDescController,
              label: 'Describe special needs...',
              prefixIcon: Icons.accessibility,
              maxLines: 3,
            ),
          ],

          const SizedBox(height: 24),

          // Grooming Needs
          const BuildFieldLabel(text: 'Grooming Needs', emoji: '✂️'),
          const SizedBox(height: 12),
          _buildGroomingSlider(),
        ],
      ),
    );
  }

  // --------------------------------
  // Widget Builders for various sections
  // --------------------------------
  Widget _buildGroomingSlider() {
    final labels = ['Very Low', 'Low', 'Moderate', 'High', 'Very High'];
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(0xFF9C27B0),
            inactiveTrackColor: Colors.grey[300],
            thumbColor: const Color(0xFF9C27B0),
            overlayColor: const Color(0xFF9C27B0).withOpacity(0.2),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
          ),
          child: Slider(
            value: (widget.groomingNeeds ?? 3).toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            label: labels[(widget.groomingNeeds ?? 3) - 1],
            onChanged: (value) => widget.onGroomingNeedsChanged(value.toInt()),
          ),
        ),
        Text(
          labels[(widget.groomingNeeds ?? 3) - 1],
          style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF9C27B0)),
        ),
      ],
    );
  }

  Widget _buildYesNoToggle(
      {required String? isSelected, required Function(bool) onChanged}) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(true),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: isSelected == "Yes"
                    ? const LinearGradient(
                        colors: [Color(0xFF66BB6A), Color(0xFF81C784)])
                    : null,
                color: isSelected == "Yes" ? null : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected == "Yes"
                      ? const Color(0xFF66BB6A)
                      : Colors.grey[300]!,
                  width: isSelected == "Yes" ? 2 : 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  'Yes! ✓',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isSelected == "Yes" ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(false),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: isSelected == "No" ? Colors.grey[400] : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected == "No"
                      ? Colors.grey[500]!
                      : Colors.grey[300]!,
                  width: isSelected == "No" ? 2 : 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  'No',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isSelected == "No" ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
