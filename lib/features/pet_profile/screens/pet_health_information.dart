import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petmatch/widgets/custom_button.dart';
import 'package:petmatch/widgets/style/themed_textfield.dart';

class PetHealthInformationScreen extends ConsumerStatefulWidget {
  const PetHealthInformationScreen({super.key});

  @override
  ConsumerState<PetHealthInformationScreen> createState() =>
      _PetHealthInformationScreenState();
}

class _PetHealthInformationScreenState
    extends ConsumerState<PetHealthInformationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _healthNotesController = TextEditingController();
  final TextEditingController _specialNeedsDescController =
      TextEditingController();

  // Selected values
  bool? _isVaccinationUpToDate;
  bool? _isSpayedNeutered;
  bool? _hasSpecialNeeds;

  @override
  void dispose() {
    _healthNotesController.dispose();
    _specialNeedsDescController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Pet Health Information',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8F5E9),
              Colors.white,
            ],
            stops: [0.0, 0.4],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 20 : 24,
            vertical: isSmallScreen ? 16 : 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF66BB6A), Color(0xFF81C784)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.medical_services,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Health & Medical Records 🏥",
                            style: TextStyle(
                              fontSize: isSmallScreen ? 20 : 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            "Keep track of important health details",
                            style: TextStyle(
                              fontSize: isSmallScreen ? 13 : 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: isSmallScreen ? 28 : 32),

                // Vaccinations up to date
                _buildFieldLabel(
                    "Vaccinations up to date?", "💉", isSmallScreen),
                const SizedBox(height: 12),
                _buildYesNoToggle(
                  isSelected: _isVaccinationUpToDate,
                  onChanged: (value) {
                    setState(() {
                      _isVaccinationUpToDate = value;
                    });
                  },
                  isSmall: isSmallScreen,
                ),

                SizedBox(height: isSmallScreen ? 24 : 28),

                // Spayed/Neutered
                _buildFieldLabel("Spayed/Neutered?", "🏥", isSmallScreen),
                const SizedBox(height: 12),
                _buildYesNoToggle(
                  isSelected: _isSpayedNeutered,
                  onChanged: (value) {
                    setState(() {
                      _isSpayedNeutered = value;
                    });
                  },
                  isSmall: isSmallScreen,
                ),

                SizedBox(height: isSmallScreen ? 24 : 28),

                // Health Notes
                _buildFieldLabel(
                  "Health Notes",
                  "📋",
                  isSmallScreen,
                  subtitle: "Allergies, chronic conditions, medications, etc.",
                ),
                const SizedBox(height: 12),
                ThemedTextField(
                  controller: _healthNotesController,
                  label:
                      'e.g., Allergic to chicken, takes arthritis medication',
                  prefixIcon: Icons.notes,
                ),

                SizedBox(height: isSmallScreen ? 24 : 28),

                // Special Needs
                _buildFieldLabel(
                    "Does this pet have special needs?", "♿", isSmallScreen),
                const SizedBox(height: 12),
                _buildYesNoToggle(
                  isSelected: _hasSpecialNeeds,
                  onChanged: (value) {
                    setState(() {
                      _hasSpecialNeeds = value;
                    });
                  },
                  isSmall: isSmallScreen,
                ),

                // Conditional Special Needs Description
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _hasSpecialNeeds == true
                      ? (isSmallScreen ? 140 : 160)
                      : 0,
                  child: _hasSpecialNeeds == true
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: isSmallScreen ? 16 : 20),
                            _buildFieldLabel(
                              "Describe special needs",
                              "✍️",
                              isSmallScreen,
                              subtitle:
                                  "What accommodations does this pet require?",
                            ),
                            const SizedBox(height: 12),
                            ThemedTextField(
                              controller: _specialNeedsDescController,
                              label:
                                  'e.g., Blind in one eye, requires ramp access, needs calm environment',
                              prefixIcon: Icons.accessible,
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),

                SizedBox(height: isSmallScreen ? 32 : 40),

                // Info Box
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF2196F3).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "💡",
                        style: TextStyle(fontSize: isSmallScreen ? 22 : 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Accurate health information helps us find the perfect match and ensures pets receive proper care in their new homes!",
                          style: TextStyle(
                            fontSize: isSmallScreen ? 13 : 14,
                            color: const Color(0xFF1565C0),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: isSmallScreen ? 24 : 28),

                // Save Button
                CustomButton(
                  label: 'Save Health Information',
                  onPressed: () {
                    _saveHealthInfo();
                  },
                  horizontalPadding: 0,
                  verticalPadding: isSmallScreen ? 12 : 14,
                  icon: Icons.check_circle,
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(
    String text,
    String emoji,
    bool isSmall, {
    String? subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              emoji,
              style: TextStyle(fontSize: isSmall ? 16 : 18),
            ),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                fontSize: isSmall ? 14 : 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: isSmall ? 12 : 13,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildYesNoToggle({
    required bool? isSelected,
    required Function(bool) onChanged,
    required bool isSmall,
  }) {
    return Row(
      children: [
        // Yes Button
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(true),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: isSmall ? 14 : 16,
              ),
              decoration: BoxDecoration(
                gradient: isSelected == true
                    ? const LinearGradient(
                        colors: [Color(0xFF66BB6A), Color(0xFF81C784)],
                      )
                    : null,
                color: isSelected == true ? null : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected == true
                      ? const Color(0xFF66BB6A)
                      : Colors.grey[300]!,
                  width: isSelected == true ? 2 : 1.5,
                ),
                boxShadow: isSelected == true
                    ? [
                        BoxShadow(
                          color: const Color(0xFF66BB6A).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: Text(
                  "Yes! ✓",
                  style: TextStyle(
                    fontSize: isSmall ? 15 : 16,
                    fontWeight: FontWeight.w700,
                    color: isSelected == true ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // No Button
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(false),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: isSmall ? 14 : 16,
              ),
              decoration: BoxDecoration(
                color: isSelected == false ? Colors.grey[400] : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected == false
                      ? Colors.grey[500]!
                      : Colors.grey[300]!,
                  width: isSelected == false ? 2 : 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  "No",
                  style: TextStyle(
                    fontSize: isSmall ? 15 : 16,
                    fontWeight: FontWeight.w700,
                    color: isSelected == false ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _saveHealthInfo() {
    final healthData = {
      'vaccinations_up_to_date': _isVaccinationUpToDate,
      'spayed_neutered': _isSpayedNeutered,
      'health_notes': _healthNotesController.text,
      'has_special_needs': _hasSpecialNeeds,
      'special_needs_description':
          _hasSpecialNeeds == true ? _specialNeedsDescController.text : null,
    };

    // TODO: Save to database
    print('Health Data: $healthData');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Health information saved successfully!'),
        backgroundColor: Color(0xFF66BB6A),
      ),
    );

    // Navigate back or to next screen
    Navigator.of(context).pop();
  }
}
