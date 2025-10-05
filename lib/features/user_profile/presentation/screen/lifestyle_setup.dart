import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petmatch/widgets/custom_button.dart';

class LifestyleSetupScreen extends ConsumerStatefulWidget {
  const LifestyleSetupScreen({super.key});

  @override
  ConsumerState<LifestyleSetupScreen> createState() =>
      _LifestyleSetupScreenState();
}

class _LifestyleSetupScreenState extends ConsumerState<LifestyleSetupScreen> {
  // Slider values
  double _activityLevel = 5.0;
  double _petCareTime = 5.0;

  // Selected values
  String? _timeAtHome;
  bool? _hasOutdoorSpace;

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
            Text(
              "Your lifestyle matters! 🏃‍♀️",
              style: TextStyle(
                fontSize: isSmallScreen ? 26 : 30,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1B7A75),
              ),
            ),
            SizedBox(height: isSmallScreen ? 6 : 8),
            Text(
              "Let's match you with a pet that fits your daily rhythm",
              style: TextStyle(
                fontSize: isSmallScreen ? 15 : 16,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),

            SizedBox(height: isSmallScreen ? 32 : 40),

            // Activity Level Slider
            _buildSectionLabel("How active are you?", "💪", isSmallScreen),
            const SizedBox(height: 16),
            _buildActivitySlider(isSmallScreen),

            SizedBox(height: isSmallScreen ? 32 : 40),

            // Time at Home
            _buildSectionLabel(
                "How much time do you spend at home?", "🏠", isSmallScreen),
            const SizedBox(height: 16),
            _buildTimeAtHomeCards(isSmallScreen),

            SizedBox(height: isSmallScreen ? 32 : 40),

            // Outdoor Space
            _buildSectionLabel(
                "Do you have outdoor space?", "🌳", isSmallScreen),
            const SizedBox(height: 16),
            _buildOutdoorSpaceToggle(isSmallScreen),

            SizedBox(height: isSmallScreen ? 32 : 40),

            // Pet Care Time Slider
            _buildSectionLabel(
                "Time you can dedicate daily", "⏰", isSmallScreen),
            const SizedBox(height: 16),
            _buildPetCareTimeSlider(isSmallScreen),

            SizedBox(height: isSmallScreen ? 40 : 50),

            // Continue Button
            CustomButton(
              label: 'Continue',
              onPressed: () {
                _submitLifestyle();
              },
              horizontalPadding: 0,
              verticalPadding: isSmallScreen ? 12 : 14,
              icon: Icons.arrow_forward,
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
        Text(
          text,
          style: TextStyle(
            fontSize: isSmall ? 16 : 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildActivitySlider(bool isSmall) {
    final activityEmojis = ['🛋️', '🚶', '🏃', '💪', '🏋️'];
    final activityLabels = [
      'Couch\nPotato',
      'Light\nActivity',
      'Moderate',
      'Active',
      'Very\nActive'
    ];

    return Container(
      padding: EdgeInsets.all(isSmall ? 16 : 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F9F9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
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
                activityEmojis[(_activityLevel / 2.5).floor().clamp(0, 4)],
                style: TextStyle(fontSize: isSmall ? 40 : 48),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            activityLabels[(_activityLevel / 2.5).floor().clamp(0, 4)],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmall ? 15 : 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 20),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Theme.of(context).colorScheme.onPrimary,
              inactiveTrackColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.2),
              thumbColor: Theme.of(context).colorScheme.onPrimary,
              overlayColor:
                  Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
              trackHeight: 6,
            ),
            child: Slider(
              value: _activityLevel,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (value) {
                setState(() {
                  _activityLevel = value;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1',
                style: TextStyle(
                  fontSize: isSmall ? 12 : 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '10',
                style: TextStyle(
                  fontSize: isSmall ? 12 : 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeAtHomeCards(bool isSmall) {
    final options = [
      {
        'title': 'Mostly home',
        'icon': Icons.home,
        'emoji': '🏠',
        'value': 'mostly_home'
      },
      {
        'title': 'Work 9–5',
        'icon': Icons.work_outline,
        'emoji': '💼',
        'value': 'work_9_5'
      },
      {
        'title': 'Travel often',
        'icon': Icons.flight_takeoff,
        'emoji': '✈️',
        'value': 'travel_often'
      },
    ];

    return Column(
      children: options.map((option) {
        final isSelected = _timeAtHome == option['value'];
        return GestureDetector(
          onTap: () {
            setState(() {
              _timeAtHome = option['value'] as String;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(isSmall ? 16 : 18),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.1)
                  : Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Colors.grey[300]!,
                width: isSelected ? 2.5 : 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    option['emoji'] as String,
                    style: TextStyle(fontSize: isSmall ? 24 : 28),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    option['title'] as String,
                    style: TextStyle(
                      fontSize: isSmall ? 15 : 16,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Colors.black87,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: isSmall ? 24 : 28,
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOutdoorSpaceToggle(bool isSmall) {
    return Row(
      children: [
        Expanded(
          child: _buildToggleOption(
            'Yes! 🌿',
            true,
            _hasOutdoorSpace == true,
            isSmall,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildToggleOption(
            'No 🏢',
            false,
            _hasOutdoorSpace == false,
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
          _hasOutdoorSpace = value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: isSmall ? 18 : 22,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.onPrimary
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Colors.grey[300]!,
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.3),
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
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPetCareTimeSlider(bool isSmall) {
    final timeEmojis = ['⏱️', '🕐', '🕒', '🕔', '🕗'];
    final timeLabels = [
      'Quick\n<30 min',
      '30 min-\n1 hour',
      '1-2\nhours',
      '2-3\nhours',
      '4+\nhours'
    ];

    return Container(
      padding: EdgeInsets.all(isSmall ? 16 : 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFFB84D).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // Time indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                timeEmojis[(_petCareTime / 2.5).floor().clamp(0, 4)],
                style: TextStyle(fontSize: isSmall ? 40 : 48),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            timeLabels[(_petCareTime / 2.5).floor().clamp(0, 4)],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmall ? 15 : 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFFF8C00),
            ),
          ),
          const SizedBox(height: 20),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFFFFB84D),
              inactiveTrackColor: const Color(0xFFFFB84D).withOpacity(0.2),
              thumbColor: const Color(0xFFFF8C00),
              overlayColor: const Color(0xFFFF8C00).withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
              trackHeight: 6,
            ),
            child: Slider(
              value: _petCareTime,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (value) {
                setState(() {
                  _petCareTime = value;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1',
                style: TextStyle(
                  fontSize: isSmall ? 12 : 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '10',
                style: TextStyle(
                  fontSize: isSmall ? 12 : 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _submitLifestyle() {
    // Collect all data
    final lifestyleData = {
      'activityLevel': _activityLevel,
      'timeAtHome': _timeAtHome,
      'hasOutdoorSpace': _hasOutdoorSpace,
      'petCareTime': _petCareTime,
    };

    // TODO: Save to database or provider
    print('Lifestyle Data: $lifestyleData');

    // Navigate to next screen or show success
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lifestyle preferences saved!')),
    );
  }
}
