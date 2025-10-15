import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petmatch/widgets/custom_button.dart';
import 'package:petmatch/widgets/style/themed_textfield.dart';

class PetBehaviorInformationScreen extends ConsumerStatefulWidget {
  const PetBehaviorInformationScreen({super.key});

  @override
  ConsumerState<PetBehaviorInformationScreen> createState() =>
      _PetBehaviorInformationScreenState();
}

class _PetBehaviorInformationScreenState
    extends ConsumerState<PetBehaviorInformationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _behavioralNotesController =
      TextEditingController();

  // Selected values
  bool? _goodWithChildren;
  bool? _goodWithDogs;
  bool? _goodWithCats;
  bool? _houseTrained;

  @override
  void dispose() {
    _behavioralNotesController.dispose();
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
          'Pet Behavior & Compatibility',
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
              Color(0xFFF3E5F5),
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
                          colors: [Color(0xFFAB47BC), Color(0xFFBA68C8)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.group,
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
                            "Behavior & Compatibility 🐾",
                            style: TextStyle(
                              fontSize: isSmallScreen ? 20 : 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            "How does this pet interact with others?",
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

                // Good with Children
                _buildFieldLabel("Good with children?", "👶", isSmallScreen),
                const SizedBox(height: 12),
                _buildYesNoToggle(
                  selected: _goodWithChildren,
                  onChanged: (value) {
                    setState(() {
                      _goodWithChildren = value;
                    });
                  },
                  isSmall: isSmallScreen,
                ),

                SizedBox(height: isSmallScreen ? 24 : 28),

                // Good with Other Dogs
                _buildFieldLabel("Good with other dogs?", "🐕", isSmallScreen),
                const SizedBox(height: 12),
                _buildYesNoToggle(
                  selected: _goodWithDogs,
                  onChanged: (value) {
                    setState(() {
                      _goodWithDogs = value;
                    });
                  },
                  isSmall: isSmallScreen,
                ),

                SizedBox(height: isSmallScreen ? 24 : 28),

                // Good with Cats
                _buildFieldLabel("Good with cats?", "🐈", isSmallScreen),
                const SizedBox(height: 12),
                _buildYesNoToggle(
                  selected: _goodWithCats,
                  onChanged: (value) {
                    setState(() {
                      _goodWithCats = value;
                    });
                  },
                  isSmall: isSmallScreen,
                ),

                SizedBox(height: isSmallScreen ? 24 : 28),

                // House-trained
                _buildFieldLabel("House-trained?", "🏠", isSmallScreen),
                const SizedBox(height: 12),
                _buildYesNoToggle(
                  selected: _houseTrained,
                  onChanged: (value) {
                    setState(() {
                      _houseTrained = value;
                    });
                  },
                  isSmall: isSmallScreen,
                ),

                SizedBox(height: isSmallScreen ? 24 : 28),

                // Behavioral Notes
                _buildFieldLabel(
                  "Behavioral Notes",
                  "📝",
                  isSmallScreen,
                  subtitle:
                      "Any specific behaviors, quirks, or important details",
                ),
                const SizedBox(height: 12),
                ThemedTextField(
                  controller: _behavioralNotesController,
                  label:
                      'e.g., Loves car rides, scared of loud noises, needs slow introductions',
                  prefixIcon: Icons.edit_note,
                ),

                SizedBox(height: isSmallScreen ? 32 : 40),

                // Info Box
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFCE4EC), Color(0xFFF8BBD0)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFEC407A).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "🌟",
                        style: TextStyle(fontSize: isSmallScreen ? 22 : 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Compatibility information helps us match pets with the right families and ensures everyone's safety and happiness!",
                          style: TextStyle(
                            fontSize: isSmallScreen ? 13 : 14,
                            color: const Color(0xFFC2185B),
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
                  label: 'Save Behavior Information',
                  onPressed: () {
                    _saveBehaviorInfo();
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
    required bool? selected,
    required Function(bool) onChanged,
    required bool isSmall,
  }) {
    final options = [
      {
        'label': 'Yes',
        'emoji': '✅',
        'value': true,
        'color': const Color(0xFF66BB6A)
      },
      {
        'label': 'No',
        'emoji': '❌',
        'value': false,
        'color': const Color(0xFFEF5350)
      },
    ];

    return Row(
      children: options.map((option) {
        final isSelected = selected == option['value'];
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(option['value'] as bool),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(
                vertical: isSmall ? 12 : 14,
              ),
              decoration: BoxDecoration(
                color: isSelected ? (option['color'] as Color) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? (option['color'] as Color)
                      : Colors.grey[300]!,
                  width: isSelected ? 2 : 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: (option['color'] as Color).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                children: [
                  Text(
                    option['emoji'] as String,
                    style: TextStyle(fontSize: isSmall ? 20 : 22),
                  ),
                  SizedBox(height: isSmall ? 4 : 6),
                  Text(
                    option['label'] as String,
                    style: TextStyle(
                      fontSize: isSmall ? 12 : 13,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w600,
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

  void _saveBehaviorInfo() {
    final behaviorData = {
      'good_with_children': _goodWithChildren,
      'good_with_dogs': _goodWithDogs,
      'good_with_cats': _goodWithCats,
      'house_trained': _houseTrained,
      'behavioral_notes': _behavioralNotesController.text,
    };

    print('Behavior Data: $behaviorData');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🐾 Behavior information saved successfully!'),
        backgroundColor: Color(0xFFAB47BC),
      ),
    );

    // Navigate back or to next screen
    Navigator.of(context).pop();
  }
}
