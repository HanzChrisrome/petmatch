import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petmatch/widgets/custom_button.dart';

class PersonalitySetupScreen extends ConsumerStatefulWidget {
  const PersonalitySetupScreen({super.key});

  @override
  ConsumerState<PersonalitySetupScreen> createState() =>
      _PersonalitySetupScreenState();
}

class _PersonalitySetupScreenState
    extends ConsumerState<PersonalitySetupScreen> {
  // Slider values
  double _routineStructure = 5.0;
  double _petAffection = 5.0;
  double _trainingPatience = 5.0;

  // Selected values
  List<String> _selectedTraits = [];
  String? _petRole;

  final List<Map<String, dynamic>> _personalityTraits = [
    {'label': 'Calm', 'emoji': '🧘', 'value': 'calm'},
    {'label': 'Energetic', 'emoji': '⚡', 'value': 'energetic'},
    {'label': 'Introverted', 'emoji': '📚', 'value': 'introverted'},
    {'label': 'Extroverted', 'emoji': '🎉', 'value': 'extroverted'},
    {'label': 'Nurturing', 'emoji': '💖', 'value': 'nurturing'},
    {'label': 'Independent', 'emoji': '🦅', 'value': 'independent'},
    {'label': 'Adventurous', 'emoji': '🏔️', 'value': 'adventurous'},
    {'label': 'Organized', 'emoji': '📋', 'value': 'organized'},
  ];

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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFF5F7),
              Color(0xFFFFFBF5),
              Colors.white,
            ],
            stops: [0.0, 0.4, 1.0],
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
                "Let's talk about YOU! 🌟",
                style: TextStyle(
                  fontSize: isSmallScreen ? 26 : 30,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFE91E63),
                ),
              ),
              SizedBox(height: isSmallScreen ? 6 : 8),
              Text(
                "Your personality helps us find the perfect pet match",
                style: TextStyle(
                  fontSize: isSmallScreen ? 15 : 16,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),

              SizedBox(height: isSmallScreen ? 32 : 40),

              // Personality Traits
              _buildSectionLabel(
                  "Which words describe you best?", "✨", isSmallScreen),
              const SizedBox(height: 8),
              Text(
                "Pick up to 3 that feel right",
                style: TextStyle(
                  fontSize: isSmallScreen ? 13 : 14,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              _buildPersonalityTraits(isSmallScreen),

              SizedBox(height: isSmallScreen ? 32 : 40),

              // Routine Structure
              _buildSectionLabel("Your daily routine", "📅", isSmallScreen),
              const SizedBox(height: 16),
              _buildRoutineSlider(isSmallScreen),

              SizedBox(height: isSmallScreen ? 32 : 40),

              // Pet Affection
              _buildSectionLabel(
                  "How snuggly should your pet be?", "🤗", isSmallScreen),
              const SizedBox(height: 16),
              _buildAffectionSlider(isSmallScreen),

              SizedBox(height: isSmallScreen ? 32 : 40),

              // Training Patience
              _buildSectionLabel(
                  "Your training patience level", "🎓", isSmallScreen),
              const SizedBox(height: 16),
              _buildPatienceSlider(isSmallScreen),

              SizedBox(height: isSmallScreen ? 32 : 40),

              // Pet Role
              _buildSectionLabel("You see your pet as...", "💭", isSmallScreen),
              const SizedBox(height: 16),
              _buildPetRoleCards(isSmallScreen),

              SizedBox(height: isSmallScreen ? 40 : 50),

              // Continue Button
              CustomButton(
                label: 'Continue',
                onPressed: () {
                  _submitPersonality();
                },
                horizontalPadding: 0,
                verticalPadding: isSmallScreen ? 12 : 14,
                icon: Icons.arrow_forward,
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

  Widget _buildPersonalityTraits(bool isSmall) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _personalityTraits.map((trait) {
        final isSelected = _selectedTraits.contains(trait['value']);
        final isDisabled =
            !isSelected && _selectedTraits.length >= 3; // Max 3 selections

        return GestureDetector(
          onTap: isDisabled
              ? null
              : () {
                  setState(() {
                    if (isSelected) {
                      _selectedTraits.remove(trait['value']);
                    } else {
                      if (_selectedTraits.length < 3) {
                        _selectedTraits.add(trait['value'] as String);
                      }
                    }
                  });
                },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: isSmall ? 16 : 18,
              vertical: isSmall ? 12 : 14,
            ),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [
                        Color(0xFFE91E63),
                        Color(0xFFFF6B9D),
                      ],
                    )
                  : null,
              color: isSelected
                  ? null
                  : isDisabled
                      ? Colors.grey[200]
                      : Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFFE91E63)
                    : isDisabled
                        ? Colors.grey[300]!
                        : const Color(0xFFFFB6C1),
                width: isSelected ? 2.5 : 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFFE91E63).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Opacity(
                  opacity: isDisabled ? 0.4 : 1.0,
                  child: Text(
                    trait['emoji'] as String,
                    style: TextStyle(
                      fontSize: isSmall ? 18 : 20,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  trait['label'] as String,
                  style: TextStyle(
                    fontSize: isSmall ? 14 : 15,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : isDisabled
                            ? Colors.grey[400]
                            : Colors.black87,
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRoutineSlider(bool isSmall) {
    final routineEmojis = ['🌊', '🎭', '📊', '⏰', '🤖'];
    final routineLabels = [
      'Very\nFlexible',
      'Somewhat\nFlexible',
      'Balanced',
      'Pretty\nStructured',
      'Very\nStructured'
    ];

    return Container(
      padding: EdgeInsets.all(isSmall ? 16 : 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE3F2FD),
            Color(0xFFF3E5F5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF2196F3).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                routineEmojis[(_routineStructure / 2.5).floor().clamp(0, 4)],
                style: TextStyle(fontSize: isSmall ? 44 : 52),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            routineLabels[(_routineStructure / 2.5).floor().clamp(0, 4)],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmall ? 15 : 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1976D2),
            ),
          ),
          const SizedBox(height: 20),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF2196F3),
              inactiveTrackColor: const Color(0xFF2196F3).withOpacity(0.2),
              thumbColor: const Color(0xFF1976D2),
              overlayColor: const Color(0xFF1976D2).withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
              trackHeight: 6,
            ),
            child: Slider(
              value: _routineStructure,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (value) {
                setState(() {
                  _routineStructure = value;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Very Flexible',
                style: TextStyle(
                  fontSize: isSmall ? 11 : 12,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Very Structured',
                style: TextStyle(
                  fontSize: isSmall ? 11 : 12,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAffectionSlider(bool isSmall) {
    final affectionEmojis = ['🦅', '😊', '🤗', '💕', '🥰'];
    final affectionLabels = [
      'Very\nIndependent',
      'Somewhat\nIndependent',
      'Balanced',
      'Pretty\nAffectionate',
      'Very\nSnuggly'
    ];

    return Container(
      padding: EdgeInsets.all(isSmall ? 16 : 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFF0F5),
            Color(0xFFFFE8F0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFF69B4).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                affectionEmojis[(_petAffection / 2.5).floor().clamp(0, 4)],
                style: TextStyle(fontSize: isSmall ? 44 : 52),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            affectionLabels[(_petAffection / 2.5).floor().clamp(0, 4)],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmall ? 15 : 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFE91E63),
            ),
          ),
          const SizedBox(height: 20),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFFFF69B4),
              inactiveTrackColor: const Color(0xFFFF69B4).withOpacity(0.2),
              thumbColor: const Color(0xFFE91E63),
              overlayColor: const Color(0xFFE91E63).withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
              trackHeight: 6,
            ),
            child: Slider(
              value: _petAffection,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (value) {
                setState(() {
                  _petAffection = value;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Independent',
                style: TextStyle(
                  fontSize: isSmall ? 11 : 12,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Very Snuggly',
                style: TextStyle(
                  fontSize: isSmall ? 11 : 12,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPatienceSlider(bool isSmall) {
    final patienceEmojis = ['😤', '😐', '🙂', '😊', '🧘‍♀️'];
    final patienceLabels = [
      'Very\nLow',
      'Somewhat\nLow',
      'Moderate',
      'Pretty\nHigh',
      'Very\nHigh'
    ];

    return Container(
      padding: EdgeInsets.all(isSmall ? 16 : 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE8F5E9),
            Color(0xFFFFF9E6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF4CAF50).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                patienceEmojis[(_trainingPatience / 2.5).floor().clamp(0, 4)],
                style: TextStyle(fontSize: isSmall ? 44 : 52),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            patienceLabels[(_trainingPatience / 2.5).floor().clamp(0, 4)],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmall ? 15 : 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF388E3C),
            ),
          ),
          const SizedBox(height: 20),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF4CAF50),
              inactiveTrackColor: const Color(0xFF4CAF50).withOpacity(0.2),
              thumbColor: const Color(0xFF388E3C),
              overlayColor: const Color(0xFF388E3C).withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
              trackHeight: 6,
            ),
            child: Slider(
              value: _trainingPatience,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (value) {
                setState(() {
                  _trainingPatience = value;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Very Low',
                style: TextStyle(
                  fontSize: isSmall ? 11 : 12,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Very High',
                style: TextStyle(
                  fontSize: isSmall ? 11 : 12,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPetRoleCards(bool isSmall) {
    final roles = [
      {
        'title': 'A family member',
        'emoji': '👨‍👩‍👧',
        'value': 'family_member',
        'description': 'Part of the family'
      },
      {
        'title': 'A companion',
        'emoji': '🤝',
        'value': 'companion',
        'description': 'My best friend'
      },
      {
        'title': 'An adventure buddy',
        'emoji': '🎒',
        'value': 'adventure_buddy',
        'description': 'Always by my side'
      },
      {
        'title': 'A responsibility',
        'emoji': '📝',
        'value': 'responsibility',
        'description': 'Something to care for'
      },
    ];

    return Column(
      children: roles.map((role) {
        final isSelected = _petRole == role['value'];
        return GestureDetector(
          onTap: () {
            setState(() {
              _petRole = role['value'] as String;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(isSmall ? 16 : 18),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [
                        Color(0xFFFFB74D),
                        Color(0xFFFF9800),
                      ],
                    )
                  : null,
              color: isSelected ? null : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFFFF9800)
                    : const Color(0xFFFFE0B2),
                width: isSelected ? 2.5 : 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFFFF9800).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withOpacity(0.3)
                        : const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    role['emoji'] as String,
                    style: TextStyle(fontSize: isSmall ? 28 : 32),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role['title'] as String,
                        style: TextStyle(
                          fontSize: isSmall ? 16 : 17,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        role['description'] as String,
                        style: TextStyle(
                          fontSize: isSmall ? 12 : 13,
                          color: isSelected
                              ? Colors.white.withOpacity(0.9)
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 28,
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _submitPersonality() {
    // Collect all data
    final personalityData = {
      'traits': _selectedTraits,
      'routineStructure': _routineStructure,
      'petAffection': _petAffection,
      'trainingPatience': _trainingPatience,
      'petRole': _petRole,
    };

    // TODO: Save to database or provider
    print('Personality Data: $personalityData');

    // Navigate to next screen or show success
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Personality preferences saved!')),
    );
  }
}
