import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petmatch/widgets/custom_button.dart';

class PetTemperamentInformationScreen extends ConsumerStatefulWidget {
  const PetTemperamentInformationScreen({super.key});

  @override
  ConsumerState<PetTemperamentInformationScreen> createState() =>
      _PetTemperamentInformationScreenState();
}

class _PetTemperamentInformationScreenState
    extends ConsumerState<PetTemperamentInformationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Temperament traits selection (max 3)
  final List<String> _selectedTraits = [];

  // Slider values
  double _affectionLevel = 3.0;
  double _independence = 3.0;
  double _adaptability = 3.0;

  // Training level
  String? _trainingLevel;

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
          'Pet Temperament',
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
              Color(0xFFE1F5FE),
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
                          colors: [Color(0xFF42A5F5), Color(0xFF64B5F6)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.psychology,
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
                            "Temperament & Personality 🧠",
                            style: TextStyle(
                              fontSize: isSmallScreen ? 20 : 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            "Understand this pet's unique nature",
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

                // Temperament Traits
                _buildFieldLabel(
                  "Temperament Traits",
                  "✨",
                  isSmallScreen,
                  subtitle: "Select up to 3 that best describe this pet",
                ),
                const SizedBox(height: 12),
                _buildTraitChips(isSmallScreen),

                SizedBox(height: isSmallScreen ? 28 : 32),

                // Affection Level Slider
                _buildFieldLabel("Affection Level", "💕", isSmallScreen),
                const SizedBox(height: 8),
                _buildAffectionSlider(isSmallScreen),

                SizedBox(height: isSmallScreen ? 28 : 32),

                // Independence Slider
                _buildFieldLabel("Independence", "🦅", isSmallScreen),
                const SizedBox(height: 8),
                _buildIndependenceSlider(isSmallScreen),

                SizedBox(height: isSmallScreen ? 28 : 32),

                // Adaptability Slider
                _buildFieldLabel(
                    "Adaptability to New Environments", "🏠", isSmallScreen),
                const SizedBox(height: 8),
                _buildAdaptabilitySlider(isSmallScreen),

                SizedBox(height: isSmallScreen ? 28 : 32),

                // Training/Obedience Level
                _buildFieldLabel(
                    "Training/Obedience Level", "🎓", isSmallScreen),
                const SizedBox(height: 12),
                _buildTrainingCards(isSmallScreen),

                SizedBox(height: isSmallScreen ? 32 : 40),

                // Info Box
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE1F5FE), Color(0xFFB3E5FC)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF42A5F5).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "💙",
                        style: TextStyle(fontSize: isSmallScreen ? 22 : 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Understanding temperament helps match pets with families who can best support their personality and needs!",
                          style: TextStyle(
                            fontSize: isSmallScreen ? 13 : 14,
                            color: const Color(0xFF0277BD),
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
                  label: 'Save Temperament Information',
                  onPressed: () {
                    _saveTemperamentInfo();
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

  Widget _buildTraitChips(bool isSmall) {
    final traits = [
      {'label': 'Gentle', 'emoji': '🕊️'},
      {'label': 'Protective', 'emoji': '🛡️'},
      {'label': 'Social', 'emoji': '🎉'},
      {'label': 'Independent', 'emoji': '🦅'},
      {'label': 'Affectionate', 'emoji': '💖'},
      {'label': 'Shy', 'emoji': '🙈'},
      {'label': 'Confident', 'emoji': '😎'},
      {'label': 'Loyal', 'emoji': '💙'},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: traits.map((trait) {
        final isSelected = _selectedTraits.contains(trait['label']);
        final isDisabled = !isSelected && _selectedTraits.length >= 3;

        return Opacity(
          opacity: isDisabled ? 0.4 : 1.0,
          child: GestureDetector(
            onTap: isDisabled
                ? null
                : () {
                    setState(() {
                      if (isSelected) {
                        _selectedTraits.remove(trait['label']);
                      } else {
                        if (_selectedTraits.length < 3) {
                          _selectedTraits.add(trait['label'] as String);
                        }
                      }
                    });
                  },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: isSmall ? 14 : 16,
                vertical: isSmall ? 10 : 12,
              ),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
                      )
                    : null,
                color: isSelected ? null : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      isSelected ? const Color(0xFF42A5F5) : Colors.grey[300]!,
                  width: isSelected ? 2 : 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF42A5F5).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    trait['emoji'] as String,
                    style: TextStyle(fontSize: isSmall ? 16 : 18),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    trait['label'] as String,
                    style: TextStyle(
                      fontSize: isSmall ? 13 : 14,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 16,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAffectionSlider(bool isSmall) {
    final emojis = ['🦅', '😐', '🙂', '😊', '💕', '🥰'];
    final labels = [
      'Very Independent',
      'Somewhat Independent',
      'Balanced',
      'Affectionate',
      'Very Affectionate',
      'Extremely Snuggly'
    ];

    return Column(
      children: [
        // Emoji indicators
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              final isActive = _affectionLevel.toInt() == index + 1;
              return Opacity(
                opacity: isActive ? 1.0 : 0.3,
                child: Text(
                  emojis[index],
                  style: TextStyle(fontSize: isSmall ? 22 : 26),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 12),

        // Slider
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFE1BEE7).withOpacity(0.5),
                const Color(0xFFFF80AB).withOpacity(0.5),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFFFF4081),
              inactiveTrackColor: Colors.grey[300],
              thumbColor: const Color(0xFFFF4081),
              overlayColor: const Color(0xFFFF4081).withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            ),
            child: Slider(
              value: _affectionLevel,
              min: 1,
              max: 6,
              divisions: 5,
              label: _affectionLevel.toInt().toString(),
              onChanged: (value) {
                setState(() {
                  _affectionLevel = value;
                });
              },
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Current label
        Text(
          labels[_affectionLevel.toInt() - 1],
          style: TextStyle(
            fontSize: isSmall ? 14 : 15,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFFF4081),
          ),
        ),

        const SizedBox(height: 8),

        // Min-Max labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1 (Independent)',
                style: TextStyle(
                  fontSize: isSmall ? 11 : 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '6 (Very Snuggly)',
                style: TextStyle(
                  fontSize: isSmall ? 11 : 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIndependenceSlider(bool isSmall) {
    final emojis = ['🤝', '👥', '🙋', '🚶', '🦅', '🗻'];
    final labels = [
      'Highly Dependent',
      'Dependent',
      'Moderate',
      'Independent',
      'Very Independent',
      'Extremely Independent'
    ];

    return Column(
      children: [
        // Emoji indicators
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              final isActive = _independence.toInt() == index + 1;
              return Opacity(
                opacity: isActive ? 1.0 : 0.3,
                child: Text(
                  emojis[index],
                  style: TextStyle(fontSize: isSmall ? 22 : 26),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 12),

        // Slider
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFFE082).withOpacity(0.5),
                const Color(0xFFFFB300).withOpacity(0.5),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFFFFB300),
              inactiveTrackColor: Colors.grey[300],
              thumbColor: const Color(0xFFFFB300),
              overlayColor: const Color(0xFFFFB300).withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            ),
            child: Slider(
              value: _independence,
              min: 1,
              max: 6,
              divisions: 5,
              label: _independence.toInt().toString(),
              onChanged: (value) {
                setState(() {
                  _independence = value;
                });
              },
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Current label
        Text(
          labels[_independence.toInt() - 1],
          style: TextStyle(
            fontSize: isSmall ? 14 : 15,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFFFB300),
          ),
        ),

        const SizedBox(height: 8),

        // Min-Max labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1 (Highly Dependent)',
                style: TextStyle(
                  fontSize: isSmall ? 11 : 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '6 (Very Independent)',
                style: TextStyle(
                  fontSize: isSmall ? 11 : 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdaptabilitySlider(bool isSmall) {
    final emojis = ['😰', '😟', '😐', '🙂', '😊', '🌟'];
    final labels = [
      'Struggles with Change',
      'Difficult',
      'Moderate',
      'Adaptable',
      'Very Adaptable',
      'Highly Adaptable'
    ];

    return Column(
      children: [
        // Emoji indicators
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              final isActive = _adaptability.toInt() == index + 1;
              return Opacity(
                opacity: isActive ? 1.0 : 0.3,
                child: Text(
                  emojis[index],
                  style: TextStyle(fontSize: isSmall ? 22 : 26),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 12),

        // Slider
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFB2DFDB).withOpacity(0.5),
                const Color(0xFF26A69A).withOpacity(0.5),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF26A69A),
              inactiveTrackColor: Colors.grey[300],
              thumbColor: const Color(0xFF26A69A),
              overlayColor: const Color(0xFF26A69A).withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            ),
            child: Slider(
              value: _adaptability,
              min: 1,
              max: 6,
              divisions: 5,
              label: _adaptability.toInt().toString(),
              onChanged: (value) {
                setState(() {
                  _adaptability = value;
                });
              },
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Current label
        Text(
          labels[_adaptability.toInt() - 1],
          style: TextStyle(
            fontSize: isSmall ? 14 : 15,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF26A69A),
          ),
        ),

        const SizedBox(height: 8),

        // Min-Max labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1 (Struggles)',
                style: TextStyle(
                  fontSize: isSmall ? 11 : 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '6 (Highly Adaptable)',
                style: TextStyle(
                  fontSize: isSmall ? 11 : 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrainingCards(bool isSmall) {
    final levels = [
      {
        'label': 'Beginner',
        'emoji': '🌱',
        'value': 'beginner',
        'description': 'Little to no training',
        'color': const Color(0xFF81C784),
      },
      {
        'label': 'Intermediate',
        'emoji': '🎯',
        'value': 'intermediate',
        'description': 'Basic commands learned',
        'color': const Color(0xFF64B5F6),
      },
      {
        'label': 'Advanced',
        'emoji': '🏆',
        'value': 'advanced',
        'description': 'Well-trained & obedient',
        'color': const Color(0xFFFFB74D),
      },
    ];

    return Column(
      children: levels.map((level) {
        final isSelected = _trainingLevel == level['value'];
        return GestureDetector(
          onTap: () {
            setState(() {
              _trainingLevel = level['value'] as String;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(isSmall ? 14 : 16),
            decoration: BoxDecoration(
              color: isSelected ? (level['color'] as Color) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    isSelected ? (level['color'] as Color) : Colors.grey[300]!,
                width: isSelected ? 2 : 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: (level['color'] as Color).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              children: [
                // Emoji
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withOpacity(0.3)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    level['emoji'] as String,
                    style: TextStyle(fontSize: isSmall ? 26 : 30),
                  ),
                ),
                const SizedBox(width: 14),

                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        level['label'] as String,
                        style: TextStyle(
                          fontSize: isSmall ? 16 : 17,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        level['description'] as String,
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

                // Checkmark
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.check,
                      color: level['color'] as Color,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _saveTemperamentInfo() {
    final temperamentData = {
      'temperament_traits': _selectedTraits,
      'affection_level': _affectionLevel,
      'independence': _independence,
      'adaptability': _adaptability,
      'training_level': _trainingLevel,
    };

    // TODO: Save to database
    print('Temperament Data: $temperamentData');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🧠 Temperament information saved successfully!'),
        backgroundColor: Color(0xFF42A5F5),
      ),
    );

    // Navigate back or to next screen
    Navigator.of(context).pop();
  }
}
