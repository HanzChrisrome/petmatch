import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petmatch/widgets/custom_button.dart';

class PetPreferencesSetupScreen extends ConsumerStatefulWidget {
  const PetPreferencesSetupScreen({super.key});

  @override
  ConsumerState<PetPreferencesSetupScreen> createState() =>
      _PetPreferencesSetupScreenState();
}

class _PetPreferencesSetupScreenState
    extends ConsumerState<PetPreferencesSetupScreen> {
  // Slider values
  double _energyLevel = 5.0;
  double _groomingTolerance = 5.0;

  // Selected values
  String? _preferredPetType;
  String? _preferredSize;
  String? _preferredAge;
  bool? _openToSpecialNeeds;

  // Get theme colors based on selected pet type
  Color get _primaryColor {
    if (_preferredPetType == 'dog') return const Color(0xFFFF8C00);
    if (_preferredPetType == 'cat') return const Color(0xFF6B5BE2);
    return const Color(0xFF1B7A75); // Default teal
  }

  Color get _lightColor {
    if (_preferredPetType == 'dog') return const Color(0xFFFFE8D6);
    if (_preferredPetType == 'cat') return const Color(0xFFE8E8FF);
    return const Color(0xFFE8F5F3); // Default light teal
  }

  Color get _accentColor {
    if (_preferredPetType == 'dog') return const Color(0xFFFFA500);
    if (_preferredPetType == 'cat') return const Color(0xFF9B8CE8);
    return const Color(0xFF1B7A75); // Default teal
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 20 : 24,
          vertical: isSmallScreen ? 16 : 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              style: TextStyle(
                fontSize: isSmallScreen ? 26 : 30,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
              child: const Text("Find your perfect match! 🐾"),
            ),
            SizedBox(height: isSmallScreen ? 6 : 8),
            Text(
              "Tell us about your dream companion",
              style: TextStyle(
                fontSize: isSmallScreen ? 15 : 16,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),

            SizedBox(height: isSmallScreen ? 32 : 40),

            // Pet Type
            _buildSectionLabel("Who's your type?", "❤️", isSmallScreen),
            const SizedBox(height: 16),
            _buildPetTypeCards(isSmallScreen),

            SizedBox(height: isSmallScreen ? 32 : 40),

            // Pet Size
            _buildSectionLabel(
                "What size fits your life?", "📏", isSmallScreen),
            const SizedBox(height: 16),
            _buildSizeChips(isSmallScreen),

            SizedBox(height: isSmallScreen ? 32 : 40),

            // Age Preference
            _buildSectionLabel("Age preference?", "🎂", isSmallScreen),
            const SizedBox(height: 16),
            _buildAgeCards(isSmallScreen),

            SizedBox(height: isSmallScreen ? 32 : 40),

            // Energy Level
            _buildSectionLabel(
                "Energy level you're looking for", "⚡", isSmallScreen),
            const SizedBox(height: 16),
            _buildEnergySlider(isSmallScreen),

            SizedBox(height: isSmallScreen ? 32 : 40),

            // Grooming Tolerance
            _buildSectionLabel("Grooming comfort level", "✂️", isSmallScreen),
            const SizedBox(height: 16),
            _buildGroomingSlider(isSmallScreen),

            SizedBox(height: isSmallScreen ? 32 : 40),

            // Special Needs
            _buildSectionLabel(
                "Open to special needs pets?", "💝", isSmallScreen),
            const SizedBox(height: 16),
            _buildSpecialNeedsToggle(isSmallScreen),

            SizedBox(height: isSmallScreen ? 40 : 50),

            // Continue Button
            CustomButton(
              label: 'Find My Match',
              onPressed: () {
                _submitPreferences();
              },
              horizontalPadding: 0,
              verticalPadding: isSmallScreen ? 12 : 14,
              icon: Icons.favorite,
            ),

            const SizedBox(height: 20),
          ],
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

  Widget _buildPetTypeCards(bool isSmall) {
    return Row(
      children: [
        Expanded(
          child: _buildPetTypeCard(
            '🐶',
            'Dog',
            'dog',
            _preferredPetType == 'dog',
            const Color(0xFFFFE8D6),
            const Color(0xFFFF8C00),
            isSmall,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildPetTypeCard(
            '🐱',
            'Cat',
            'cat',
            _preferredPetType == 'cat',
            const Color(0xFFE8E8FF),
            const Color(0xFF6B5BE2),
            isSmall,
          ),
        ),
      ],
    );
  }

  Widget _buildPetTypeCard(String emoji, String label, String value,
      bool isSelected, Color bgColor, Color accentColor, bool isSmall) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _preferredPetType = value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: isSmall ? 24 : 30,
        ),
        decoration: BoxDecoration(
          color: isSelected ? accentColor : bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? accentColor : Colors.transparent,
            width: 3,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accentColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            Text(
              emoji,
              style: TextStyle(fontSize: isSmall ? 48 : 60),
            ),
            SizedBox(height: isSmall ? 8 : 12),
            Text(
              label,
              style: TextStyle(
                fontSize: isSmall ? 17 : 19,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeChips(bool isSmall) {
    final sizes = [
      {'label': 'Small', 'emoji': '🐕', 'value': 'small'},
      {'label': 'Medium', 'emoji': '🦮', 'value': 'medium'},
      {'label': 'Large', 'emoji': '🐕‍🦺', 'value': 'large'},
      {'label': 'No preference', 'emoji': '🤷', 'value': 'no_preference'},
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: sizes.map((size) {
        final isSelected = _preferredSize == size['value'];
        return GestureDetector(
          onTap: () {
            setState(() {
              _preferredSize = size['value'] as String;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmall ? 16 : 18,
              vertical: isSmall ? 12 : 14,
            ),
            decoration: BoxDecoration(
              color: isSelected ? _primaryColor : _lightColor,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: isSelected ? _primaryColor : Colors.grey[300]!,
                width: isSelected ? 2.5 : 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  size['emoji'] as String,
                  style: TextStyle(fontSize: isSmall ? 20 : 22),
                ),
                const SizedBox(width: 8),
                Text(
                  size['label'] as String,
                  style: TextStyle(
                    fontSize: isSmall ? 14 : 15,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAgeCards(bool isSmall) {
    final ages = [
      {'label': 'Puppy/Kitten', 'emoji': '🍼', 'value': 'baby'},
      {'label': 'Young Adult', 'emoji': '🎾', 'value': 'young_adult'},
      {'label': 'Adult', 'emoji': '🦴', 'value': 'adult'},
      {'label': 'Senior', 'emoji': '🧓', 'value': 'senior'},
      {'label': 'No preference', 'emoji': '💕', 'value': 'no_preference'},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ages.map((age) {
        final isSelected = _preferredAge == age['value'];
        return GestureDetector(
          onTap: () {
            setState(() {
              _preferredAge = age['value'] as String;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmall ? 14 : 16,
              vertical: isSmall ? 10 : 12,
            ),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        _primaryColor,
                        _accentColor,
                      ],
                    )
                  : null,
              color: isSelected ? null : Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? _primaryColor : Colors.grey[300]!,
                width: isSelected ? 2 : 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  age['emoji'] as String,
                  style: TextStyle(fontSize: isSmall ? 18 : 20),
                ),
                const SizedBox(width: 6),
                Text(
                  age['label'] as String,
                  style: TextStyle(
                    fontSize: isSmall ? 13 : 14,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEnergySlider(bool isSmall) {
    final energyEmojis = ['😴', '🛋️', '🚶', '🏃', '⚡'];
    final energyLabels = [
      'Very\nCalm',
      'Relaxed',
      'Moderate\nEnergy',
      'Active',
      'Very\nEnergetic'
    ];

    return Container(
      padding: EdgeInsets.all(isSmall ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _lightColor,
            _lightColor.withOpacity(0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _primaryColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // Emoji indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                energyEmojis[(_energyLevel / 2.5).floor().clamp(0, 4)],
                style: TextStyle(fontSize: isSmall ? 44 : 52),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            energyLabels[(_energyLevel / 2.5).floor().clamp(0, 4)],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmall ? 15 : 16,
              fontWeight: FontWeight.w700,
              color: _primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _primaryColor,
              inactiveTrackColor: _primaryColor.withOpacity(0.2),
              thumbColor: _primaryColor,
              overlayColor: _primaryColor.withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
              trackHeight: 6,
            ),
            child: Slider(
              value: _energyLevel,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (value) {
                setState(() {
                  _energyLevel = value;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Very Calm',
                style: TextStyle(
                  fontSize: isSmall ? 11 : 12,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Very Energetic',
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

  Widget _buildGroomingSlider(bool isSmall) {
    final groomingEmojis = ['✌️', '🧼', '🪮', '✂️', '💅'];
    final groomingLabels = [
      'Low\nMaintenance',
      'Basic\nCare',
      'Regular\nGrooming',
      'Frequent\nCare',
      'High\nMaintenance'
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
          // Emoji indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                groomingEmojis[(_groomingTolerance / 2.5).floor().clamp(0, 4)],
                style: TextStyle(fontSize: isSmall ? 44 : 52),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            groomingLabels[(_groomingTolerance / 2.5).floor().clamp(0, 4)],
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
              value: _groomingTolerance,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (value) {
                setState(() {
                  _groomingTolerance = value;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Low Only',
                style: TextStyle(
                  fontSize: isSmall ? 11 : 12,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'High Needs OK',
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

  Widget _buildSpecialNeedsToggle(bool isSmall) {
    return Row(
      children: [
        Expanded(
          child: _buildToggleOption(
            'Yes, I\'m open! 💖',
            true,
            _openToSpecialNeeds == true,
            isSmall,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildToggleOption(
            'Not right now',
            false,
            _openToSpecialNeeds == false,
            isSmall,
          ),
        ),
      ],
    );
  }

  Widget _buildToggleOption(
      String label, bool value, bool isSelected, bool isSmall) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _openToSpecialNeeds = value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: isSmall ? 16 : 20,
        ),
        decoration: BoxDecoration(
          gradient: isSelected && value
              ? const LinearGradient(
                  colors: [
                    Color(0xFFFF6B9D),
                    Color(0xFFFFC371),
                  ],
                )
              : null,
          color: isSelected && !value
              ? Colors.grey[300]
              : isSelected
                  ? null
                  : Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? (value ? const Color(0xFFFF6B9D) : Colors.grey[400]!)
                : Colors.grey[300]!,
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: isSelected && value
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF6B9D).withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmall ? 14 : 15,
              fontWeight: FontWeight.w700,
              color: isSelected && value
                  ? Colors.white
                  : isSelected
                      ? Colors.grey[700]
                      : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  void _submitPreferences() {
    // Collect all data
    final preferencesData = {
      'petType': _preferredPetType,
      'size': _preferredSize,
      'age': _preferredAge,
      'energyLevel': _energyLevel,
      'groomingTolerance': _groomingTolerance,
      'openToSpecialNeeds': _openToSpecialNeeds,
    };

    // TODO: Save to database or provider
    print('Pet Preferences: $preferencesData');

    // Navigate to next screen or show success
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preferences saved! Finding your match...')),
    );
  }
}
