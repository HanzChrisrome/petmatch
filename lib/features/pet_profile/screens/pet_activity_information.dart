import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petmatch/widgets/custom_button.dart';

class PetActivityInformationScreen extends ConsumerStatefulWidget {
  const PetActivityInformationScreen({super.key});

  @override
  ConsumerState<PetActivityInformationScreen> createState() =>
      _PetActivityInformationScreenState();
}

class _PetActivityInformationScreenState
    extends ConsumerState<PetActivityInformationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Slider values
  double _energyLevel = 5.0;
  double _playfulness = 5.0;

  // Selected value
  String? _dailyExerciseNeeds;

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
          'Pet Activity & Energy',
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
              Color(0xFFFFF3E0),
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
                          colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.directions_run,
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
                            "Activity & Energy Info ⚡",
                            style: TextStyle(
                              fontSize: isSmallScreen ? 20 : 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            "Help us understand this pet's energy",
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

                // Energy Level Slider
                _buildFieldLabel("Energy Level", "⚡", isSmallScreen),
                const SizedBox(height: 8),
                _buildEnergySlider(isSmallScreen),

                SizedBox(height: isSmallScreen ? 28 : 32),

                // Daily Exercise Needs
                _buildFieldLabel("Daily Exercise Needs", "🏃", isSmallScreen),
                const SizedBox(height: 12),
                _buildExerciseCards(isSmallScreen),

                SizedBox(height: isSmallScreen ? 28 : 32),

                // Playfulness Slider
                _buildFieldLabel("Playfulness", "🎾", isSmallScreen),
                const SizedBox(height: 8),
                _buildPlayfulnessSlider(isSmallScreen),

                SizedBox(height: isSmallScreen ? 32 : 40),

                // Info Box
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFF9C4), Color(0xFFFFF59D)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFFBC02D).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "🎯",
                        style: TextStyle(fontSize: isSmallScreen ? 22 : 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Matching activity levels helps ensure pets and adopters have compatible lifestyles for a happy home!",
                          style: TextStyle(
                            fontSize: isSmallScreen ? 13 : 14,
                            color: const Color(0xFFF57F17),
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
                  label: 'Save Activity Information',
                  onPressed: () {
                    _saveActivityInfo();
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

  Widget _buildFieldLabel(String text, String emoji, bool isSmall) {
    return Row(
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
    );
  }

  Widget _buildEnergySlider(bool isSmall) {
    final emojis = ['🛋️', '😌', '🚶', '🏃', '💪', '⚡'];
    final labels = [
      'Very Calm',
      'Calm',
      'Moderate',
      'Active',
      'Energetic',
      'Very Energetic'
    ];

    return Column(
      children: [
        // Emoji indicators
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              final isActive = _energyLevel >= (index * 2) + 1 &&
                  _energyLevel <= (index * 2) + 2;
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
                const Color(0xFF4FC3F7).withOpacity(0.3),
                const Color(0xFFFF9800).withOpacity(0.3),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFFFF9800),
              inactiveTrackColor: Colors.grey[300],
              thumbColor: const Color(0xFFFF9800),
              overlayColor: const Color(0xFFFF9800).withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            ),
            child: Slider(
              value: _energyLevel,
              min: 1,
              max: 10,
              divisions: 9,
              label: _energyLevel.toInt().toString(),
              onChanged: (value) {
                setState(() {
                  _energyLevel = value;
                });
              },
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Current label
        Text(
          labels[_energyLevel ~/ 2 > 5 ? 5 : (_energyLevel - 1) ~/ 2],
          style: TextStyle(
            fontSize: isSmall ? 14 : 15,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFFF9800),
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
                '1 (Very Calm)',
                style: TextStyle(
                  fontSize: isSmall ? 11 : 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '10 (Very Energetic)',
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

  Widget _buildExerciseCards(bool isSmall) {
    final exercises = [
      {
        'label': 'Low',
        'emoji': '🎈',
        'value': 'low',
        'description': 'Occasional play',
        'color': const Color(0xFF81C784),
      },
      {
        'label': 'Moderate',
        'emoji': '🎾',
        'value': 'moderate',
        'description': '1-2 walks/play sessions',
        'color': const Color(0xFFFFB74D),
      },
      {
        'label': 'High',
        'emoji': '🏃‍♂️',
        'value': 'high',
        'description': 'Multiple walks, running',
        'color': const Color(0xFFE57373),
      },
    ];

    return Column(
      children: exercises.map((exercise) {
        final isSelected = _dailyExerciseNeeds == exercise['value'];
        return GestureDetector(
          onTap: () {
            setState(() {
              _dailyExerciseNeeds = exercise['value'] as String;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(isSmall ? 14 : 16),
            decoration: BoxDecoration(
              color: isSelected ? (exercise['color'] as Color) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? (exercise['color'] as Color)
                    : Colors.grey[300]!,
                width: isSelected ? 2 : 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: (exercise['color'] as Color).withOpacity(0.3),
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
                    exercise['emoji'] as String,
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
                        exercise['label'] as String,
                        style: TextStyle(
                          fontSize: isSmall ? 16 : 17,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        exercise['description'] as String,
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
                      color: exercise['color'] as Color,
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

  Widget _buildPlayfulnessSlider(bool isSmall) {
    final emojis = ['😴', '😐', '🙂', '😊', '😄', '🤩'];
    final labels = [
      'Not Playful',
      'Rarely Plays',
      'Sometimes',
      'Playful',
      'Very Playful',
      'Extremely Playful'
    ];

    int currentIndex = (((_playfulness - 1) / 9) * 5).round().clamp(0, 5);

    return Column(
      children: [
        // Emoji indicators
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              final isActive = currentIndex == index;
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
                const Color(0xFFBA68C8).withOpacity(0.5),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFFBA68C8),
              inactiveTrackColor: Colors.grey[300],
              thumbColor: const Color(0xFFBA68C8),
              overlayColor: const Color(0xFFBA68C8).withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            ),
            child: Slider(
              value: _playfulness,
              min: 1,
              max: 10,
              divisions: 9,
              label: _playfulness.toInt().toString(),
              onChanged: (value) {
                setState(() {
                  _playfulness = value;
                });
              },
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Current label
        Text(
          labels[currentIndex],
          style: TextStyle(
            fontSize: isSmall ? 14 : 15,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFBA68C8),
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
                '1 (Not Playful)',
                style: TextStyle(
                  fontSize: isSmall ? 11 : 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '10 (Very Playful)',
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

  void _saveActivityInfo() {
    final activityData = {
      'energy_level': _energyLevel,
      'daily_exercise_needs': _dailyExerciseNeeds,
      'playfulness': _playfulness,
    };

    // TODO: Save to database
    print('Activity Data: $activityData');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('⚡ Activity information saved successfully!'),
        backgroundColor: Color(0xFFFF9800),
      ),
    );

    // Navigate back or to next screen
    Navigator.of(context).pop();
  }
}
