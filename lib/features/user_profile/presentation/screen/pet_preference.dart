import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petmatch/core/utils/responsive_helper.dart';
import 'package:petmatch/core/constants/asset_paths.dart';
import 'package:petmatch/features/user_profile/provider/user_profile_provider.dart';
import 'package:petmatch/widgets/back_button.dart';

class PetPreferenceScreen extends ConsumerStatefulWidget {
  const PetPreferenceScreen({super.key});

  @override
  ConsumerState<PetPreferenceScreen> createState() =>
      _PetPreferenceScreenState();
}

class _PetPreferenceScreenState extends ConsumerState<PetPreferenceScreen> {
  double _selectedPetValue = 2.0;

  final List<Map<String, dynamic>> _petOptions = [
    {
      'value': 1,
      'label': 'Cat',
      'emoji': '😺',
      'image': UserProfileAssets.petPreferenceCat,
      'color': const Color.fromARGB(255, 255, 145, 222),
      'description':
          'Cats are independent and love cozy spaces. Perfect for those who prefer a calm, relaxing home environment.'
    },
    {
      'value': 2,
      'label': 'No Preference',
      'emoji': '😌',
      'image': UserProfileAssets.petPreferenceBoth,
      'color': const Color.fromARGB(255, 117, 154, 253),
      'description':
          'Open to any pet! You enjoy a balanced lifestyle and are flexible with your pet choices.'
    },
    {
      'value': 3,
      'label': 'Dog',
      'emoji': '🐶',
      'image': UserProfileAssets.petPreferenceDog,
      'color': const Color.fromARGB(255, 63, 211, 154),
      'description':
          'Dogs are energetic and love outdoor activities. Great for those who enjoy regular walks and playtime.'
    },
  ];

  @override
  void initState() {
    super.initState();
    // Load saved pet preference if it exists
    final savedPreference = ref.read(userProfileProvider).petPreference;
    if (savedPreference != null) {
      // Map preference string to value
      if (savedPreference == 'Cat') {
        _selectedPetValue = 1.0;
      } else if (savedPreference == 'No Preference') {
        _selectedPetValue = 2.0;
      } else if (savedPreference == 'Dog') {
        _selectedPetValue = 3.0;
      }
    }
  }

  @override
  void dispose() {
    // Restore system UI when leaving screen
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  Map<String, dynamic> get _currentPetOption {
    final roundedLevel = _selectedPetValue.round();
    return _petOptions.firstWhere(
      (level) => level['value'] == roundedLevel,
      orElse: () => _petOptions[1],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Back button at top left
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: BackButtonCircle(
                  iconSize: getResponsiveValue(
                    context,
                    verySmall: 14,
                    small: 16,
                    medium: 18,
                    large: 20,
                  ),
                  borderColor: Colors.grey.shade300,
                  iconColor: Colors.black87,
                  onTap: () =>
                      context.pop(), // optional, defaults to Navigator.pop
                ),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: getResponsiveValue(
                    context,
                    verySmall: 0,
                    small: 4,
                    medium: 6,
                    large: 8,
                  ),
                ),
                child: Column(
                  children: [
                    // Text(
                    //   '[ STEP 1 OF 8 ]',
                    //   style: TextStyle(
                    //     fontSize: getResponsiveValue(
                    //       context,
                    //       verySmall: 11,
                    //       small: 12,
                    //       medium: 13,
                    //       large: 14,
                    //     ),
                    //     color: Colors.grey[600],
                    //     fontWeight: FontWeight.w500,
                    //     letterSpacing: 1.2,
                    //   ),
                    // ),
                    SizedBox(
                      height: getResponsiveValue(
                        context,
                        verySmall: 8,
                        small: 9,
                        medium: 10,
                        large: 12,
                      ),
                    ),
                    Text(
                      'What\'s your preferred pet?',
                      style: GoogleFonts.newsreader(
                        fontSize: getResponsiveValue(
                          context,
                          verySmall: 32,
                          small: 40,
                          medium: 48,
                          large: 54,
                        ),
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        letterSpacing: -1.1,
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(
                      height: getResponsiveValue(
                        context,
                        verySmall: 14,
                        small: 16,
                        medium: 18,
                        large: 20,
                      ),
                    ),

                    // Swipeable cards stack
                    _buildSwipeableCards(screenHeight),

                    SizedBox(
                      height: getResponsiveValue(
                        context,
                        verySmall: 8,
                        small: 9,
                        medium: 10,
                        large: 12,
                      ),
                    ),

                    // Swipe indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back,
                            size: 16, color: Colors.grey[400]),
                        SizedBox(width: 8),
                        Text(
                          'SWIPE TO CHANGE PET',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward,
                            size: 16, color: Colors.grey[400]),
                      ],
                    ),

                    SizedBox(
                      height: getResponsiveValue(
                        context,
                        verySmall: 12,
                        small: 15,
                        medium: 18,
                        large: 22,
                      ),
                    ),

                    GestureDetector(
                      onTap: _savePetPreference,
                      child: Container(
                        width: getResponsiveValue(
                          context,
                          verySmall: 260,
                          small: 280,
                          medium: 300,
                          large: 320,
                        ),
                        height: getResponsiveValue(
                          context,
                          verySmall: 48,
                          small: 50,
                          medium: 53,
                          large: 56,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              _currentPetOption['color'],
                              _currentPetOption['color'].withOpacity(0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: _currentPetOption['color'],
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  _currentPetOption['color'].withOpacity(0.25),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Continue',
                            style: GoogleFonts.newsreader(
                              fontSize: getResponsiveValue(
                                context,
                                verySmall: 18,
                                small: 19,
                                medium: 21,
                                large: 22,
                              ),
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeableCards(double screenHeight) {
    return SizedBox(
      height: getResponsiveValue(
        context,
        verySmall: screenHeight * 0.5,
        small: screenHeight * 0.52,
        medium: screenHeight * 0.54,
        large: screenHeight * 0.55,
      ),
      child: PageView.builder(
        controller: PageController(
          viewportFraction: 0.85,
          initialPage: _selectedPetValue.round() - 1,
        ),
        onPageChanged: (index) {
          setState(() {
            _selectedPetValue = (index + 1).toDouble();
          });
        },
        itemCount: _petOptions.length,
        itemBuilder: (context, index) {
          final level = _petOptions[index];
          final isActive = _selectedPetValue.round() == level['value'];

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: isActive ? 0 : 16,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: level['color'],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  Align(
                    alignment: level['value'] == 2
                        ? Alignment.topLeft
                        : Alignment.topCenter,
                    child: Padding(
                      padding: level['value'] == 2
                          ? const EdgeInsets.only(top: 24, left: 32)
                          : const EdgeInsets.only(top: 20),
                      child: SizedBox(
                        height: getResponsiveValue(
                          context,
                          verySmall: 180,
                          small: 240,
                          medium: 300,
                          large: 330,
                        ),
                        child: Image.asset(
                          level['image'],
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: level['color'].withOpacity(0.1),
                              child: Center(
                                child: Text(
                                  level['emoji'],
                                  style: TextStyle(
                                    fontSize: getResponsiveValue(
                                      context,
                                      verySmall: 36,
                                      small: 44,
                                      medium: 54,
                                      large: 64,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  // Label and description at the bottom
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 32, left: 24, right: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.8),
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              level['label'],
                              style: GoogleFonts.newsreader(
                                fontSize: isActive
                                    ? getResponsiveValue(
                                        context,
                                        verySmall: 16,
                                        small: 18,
                                        medium: 20,
                                        large: 22,
                                      )
                                    : getResponsiveValue(
                                        context,
                                        verySmall: 12,
                                        small: 13,
                                        medium: 14,
                                        large: 16,
                                      ),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 300,
                            child: Text(
                              level['description'],
                              style: TextStyle(
                                fontSize: isActive
                                    ? getResponsiveValue(
                                        context,
                                        verySmall: 13,
                                        small: 14,
                                        medium: 15,
                                        large: 16,
                                      )
                                    : getResponsiveValue(
                                        context,
                                        verySmall: 11,
                                        small: 12,
                                        medium: 13,
                                        large: 14,
                                      ),
                                color: Colors.white.withOpacity(0.85),
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _savePetPreference() {
    final selectedPet = _currentPetOption['label'] as String;
    final isEditMode = ModalRoute.of(context)?.canPop ?? false;

    if (isEditMode) {
      ref.read(userProfileProvider.notifier).updatePetPreference(selectedPet);
      Navigator.of(context).pop();
    } else {
      ref
          .read(userProfileProvider.notifier)
          .setPetPreference(context, selectedPet);
    }
  }
}
