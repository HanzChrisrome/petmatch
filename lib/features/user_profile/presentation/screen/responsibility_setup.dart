import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petmatch/widgets/custom_button.dart';

class ResponsibilitySetupScreen extends ConsumerStatefulWidget {
  const ResponsibilitySetupScreen({super.key});

  @override
  ConsumerState<ResponsibilitySetupScreen> createState() =>
      _ResponsibilitySetupScreenState();
}

class _ResponsibilitySetupScreenState
    extends ConsumerState<ResponsibilitySetupScreen> {
  // Selected values
  String? _commitmentLength;
  bool? _financiallyPrepared;
  bool? _hasPetExperience;

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
              Color(0xFFFFF4E6),
              Color(0xFFFFF9F0),
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
                "Let's talk commitment 💛",
                style: TextStyle(
                  fontSize: isSmallScreen ? 26 : 30,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFF9800),
                ),
              ),
              SizedBox(height: isSmallScreen ? 6 : 8),
              Text(
                "Being honest helps us find the right match for everyone",
                style: TextStyle(
                  fontSize: isSmallScreen ? 15 : 16,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),

              SizedBox(height: isSmallScreen ? 32 : 40),

              // Commitment Length
              _buildSectionLabel(
                  "How long can you commit?", "⏳", isSmallScreen),
              const SizedBox(height: 12),
              Text(
                "Pets need long-term love and care",
                style: TextStyle(
                  fontSize: isSmallScreen ? 13 : 14,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              _buildCommitmentCards(isSmallScreen),

              SizedBox(height: isSmallScreen ? 32 : 40),

              // Financial Preparedness
              _buildSectionLabel(
                  "Are you financially ready?", "💰", isSmallScreen),
              const SizedBox(height: 12),
              Text(
                "For food, vet visits, and unexpected emergencies",
                style: TextStyle(
                  fontSize: isSmallScreen ? 13 : 14,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              _buildYesNoToggle(
                _financiallyPrepared,
                (value) {
                  setState(() {
                    _financiallyPrepared = value;
                  });
                },
                isSmallScreen,
              ),

              SizedBox(height: isSmallScreen ? 32 : 40),

              // Pet Experience
              _buildSectionLabel(
                  "Have you had pets before?", "🎓", isSmallScreen),
              const SizedBox(height: 12),
              Text(
                "First-time owners are welcome too!",
                style: TextStyle(
                  fontSize: isSmallScreen ? 13 : 14,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              _buildYesNoToggle(
                _hasPetExperience,
                (value) {
                  setState(() {
                    _hasPetExperience = value;
                  });
                },
                isSmallScreen,
              ),

              SizedBox(height: isSmallScreen ? 40 : 50),

              // Info Box
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFFF3E0),
                      Color(0xFFFFE0B2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFFFB74D).withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    const Text(
                      '💡',
                      style: TextStyle(fontSize: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Remember: Pet ownership is a rewarding journey that requires time, money, and dedication. We\'re here to help you find your perfect companion!',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 13 : 14,
                          color: const Color(0xFFE65100),
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: isSmallScreen ? 32 : 40),

              // Continue Button
              CustomButton(
                label: 'Complete Setup',
                onPressed: () {
                  _submitResponsibility();
                },
                horizontalPadding: 0,
                verticalPadding: isSmallScreen ? 12 : 14,
                icon: Icons.celebration,
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

  Widget _buildCommitmentCards(bool isSmall) {
    final commitments = [
      {
        'label': '1-3 years',
        'emoji': '🌱',
        'value': '1-3',
        'subtitle': 'Short term'
      },
      {
        'label': '4-7 years',
        'emoji': '🌿',
        'value': '4-7',
        'subtitle': 'Medium term'
      },
      {
        'label': '8-12 years',
        'emoji': '🌳',
        'value': '8-12',
        'subtitle': 'Long term'
      },
      {
        'label': 'Lifetime',
        'emoji': '💝',
        'value': 'lifetime',
        'subtitle': 'Forever home'
      },
    ];

    return Column(
      children: commitments.map((commitment) {
        final isSelected = _commitmentLength == commitment['value'];
        return GestureDetector(
          onTap: () {
            setState(() {
              _commitmentLength = commitment['value'] as String;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(isSmall ? 14 : 16),
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
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withOpacity(0.3)
                        : const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    commitment['emoji'] as String,
                    style: TextStyle(fontSize: isSmall ? 24 : 28),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        commitment['label'] as String,
                        style: TextStyle(
                          fontSize: isSmall ? 16 : 17,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        commitment['subtitle'] as String,
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

  Widget _buildYesNoToggle(
    bool? currentValue,
    Function(bool) onChanged,
    bool isSmall,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildToggleButton(
            'Yes! ✓',
            true,
            currentValue == true,
            () => onChanged(true),
            isSmall,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildToggleButton(
            'Not yet',
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
                    Color(0xFF4CAF50),
                    Color(0xFF388E3C),
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
                ? (value ? const Color(0xFF388E3C) : Colors.grey[400]!)
                : const Color(0xFFC8E6C9),
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: isSelected && value
              ? [
                  BoxShadow(
                    color: const Color(0xFF388E3C).withOpacity(0.3),
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
                      : const Color(0xFF388E3C),
            ),
          ),
        ),
      ),
    );
  }

  void _submitResponsibility() {
    // Collect all data
    final responsibilityData = {
      'commitmentLength': _commitmentLength,
      'financiallyPrepared': _financiallyPrepared,
      'hasPetExperience': _hasPetExperience,
    };

    // TODO: Save to database or provider
    print('Responsibility Data: $responsibilityData');

    // Navigate to next screen or show success
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🎉 Profile complete! Let\'s find your perfect match!'),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
