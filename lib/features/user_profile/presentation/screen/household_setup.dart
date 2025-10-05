import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petmatch/widgets/custom_button.dart';
import 'package:petmatch/widgets/style/themed_textfield.dart';

class HouseholdSetupScreen extends ConsumerStatefulWidget {
  const HouseholdSetupScreen({super.key});

  @override
  ConsumerState<HouseholdSetupScreen> createState() =>
      _HouseholdSetupScreenState();
}

class _HouseholdSetupScreenState extends ConsumerState<HouseholdSetupScreen> {
  // Controllers
  final TextEditingController _existingPetsController = TextEditingController();

  // Selected values
  bool? _hasOtherPets;
  bool? _hasChildren;
  bool? _hasAllergies;
  bool? _comfortableWithShyPet;

  @override
  void dispose() {
    _existingPetsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF0F9FF),
              Color(0xFFFFFBF0),
              Colors.white,
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 20 : 24,
            vertical: isSmallScreen ? 16 : 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                "About your household 🏡",
                style: TextStyle(
                  fontSize: isSmallScreen ? 26 : 30,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0284C7),
                ),
              ),
              SizedBox(height: isSmallScreen ? 6 : 8),
              Text(
                "These details help us ensure a safe and happy match",
                style: TextStyle(
                  fontSize: isSmallScreen ? 15 : 16,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),

              SizedBox(height: isSmallScreen ? 32 : 40),

              // Other Pets
              _buildSectionLabel(
                  "Do you have other pets?", "🐾", isSmallScreen),
              const SizedBox(height: 16),
              _buildYesNoToggle(
                _hasOtherPets,
                (value) {
                  setState(() {
                    _hasOtherPets = value;
                    if (value == false) {
                      _existingPetsController.clear();
                    }
                  });
                },
                isSmallScreen,
              ),

              // Conditional pet type input
              if (_hasOtherPets == true) ...[
                const SizedBox(height: 16),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tell us about them! 🐕🐈",
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 10),
                      ThemedTextField(
                        controller: _existingPetsController,
                        label: 'e.g., 1 dog, 2 cats',
                        prefixIcon: Icons.pets,
                      ),
                    ],
                  ),
                ),
              ],

              SizedBox(height: isSmallScreen ? 32 : 40),

              // Children
              _buildSectionLabel("Do you have children?", "👶", isSmallScreen),
              const SizedBox(height: 16),
              _buildYesNoToggle(
                _hasChildren,
                (value) {
                  setState(() {
                    _hasChildren = value;
                  });
                },
                isSmallScreen,
              ),

              SizedBox(height: isSmallScreen ? 32 : 40),

              // Allergies
              _buildSectionLabel(
                  "Any household allergies?", "🤧", isSmallScreen),
              const SizedBox(height: 16),
              _buildYesNoToggle(
                _hasAllergies,
                (value) {
                  setState(() {
                    _hasAllergies = value;
                  });
                },
                isSmallScreen,
              ),

              SizedBox(height: isSmallScreen ? 32 : 40),

              // Shy Pet Comfort
              _buildSectionLabel(
                  "Comfortable with a shy pet?", "🥺", isSmallScreen),
              const SizedBox(height: 12),
              Text(
                "Some pets need extra patience and gentle care",
                style: TextStyle(
                  fontSize: isSmallScreen ? 13 : 14,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              _buildYesNoToggle(
                _comfortableWithShyPet,
                (value) {
                  setState(() {
                    _comfortableWithShyPet = value;
                  });
                },
                isSmallScreen,
              ),

              SizedBox(height: isSmallScreen ? 40 : 50),

              // Continue Button
              CustomButton(
                label: 'All Done!',
                onPressed: () {
                  _submitHousehold();
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
    );
  }

  Widget _buildSectionLabel(String text, String emoji, bool isSmall) {
    return Row(
      children: [
        Text(
          emoji,
          style: TextStyle(fontSize: isSmall ? 20 : 24),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isSmall ? 16 : 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildYesNoToggle(
    bool? currentValue,
    Function(bool) onChanged,
    bool isSmall,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildToggleButton(
            'Yes! 👍',
            true,
            currentValue == true,
            () => onChanged(true),
            isSmall,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildToggleButton(
            'No',
            false,
            currentValue == false,
            () => onChanged(false),
            isSmall,
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton(
    String label,
    bool value,
    bool isSelected,
    VoidCallback onTap,
    bool isSmall,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          vertical: isSmall ? 18 : 22,
        ),
        decoration: BoxDecoration(
          gradient: isSelected && value
              ? const LinearGradient(
                  colors: [
                    Color(0xFF0EA5E9),
                    Color(0xFF0284C7),
                  ],
                )
              : null,
          color: isSelected && !value
              ? Colors.grey[300]
              : isSelected
                  ? null
                  : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? (value ? const Color(0xFF0284C7) : Colors.grey[400]!)
                : const Color(0xFFBAE6FD),
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: isSelected && value
              ? [
                  BoxShadow(
                    color: const Color(0xFF0284C7).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : isSelected && !value
                  ? [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isSmall ? 16 : 18,
              fontWeight: FontWeight.w700,
              color: isSelected && value
                  ? Colors.white
                  : isSelected
                      ? Colors.grey[700]
                      : const Color(0xFF0284C7),
            ),
          ),
        ),
      ),
    );
  }

  void _submitHousehold() {
    // Collect all data
    final householdData = {
      'hasOtherPets': _hasOtherPets,
      'existingPets':
          _hasOtherPets == true ? _existingPetsController.text : null,
      'hasChildren': _hasChildren,
      'hasAllergies': _hasAllergies,
      'comfortableWithShyPet': _comfortableWithShyPet,
    };

    // TODO: Save to database or provider
    print('Household Data: $householdData');

    // Navigate to next screen or show success
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Setup complete! 🎉')),
    );
  }
}
