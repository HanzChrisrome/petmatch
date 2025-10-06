// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petmatch/core/utils/responsive_helper.dart';
import 'package:petmatch/features/user_profile/provider/user_profile_provider.dart';
import 'package:petmatch/widgets/back_button.dart';

class HasChildrenScreen extends ConsumerStatefulWidget {
  const HasChildrenScreen({super.key});

  @override
  ConsumerState<HasChildrenScreen> createState() => _HasChildrenScreenState();
}

class _HasChildrenScreenState extends ConsumerState<HasChildrenScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedOption; // 'Yes' or 'No'

  final Map<String, dynamic> _yesOption = {
    'value': 'Yes',
    'label': 'Yes',
    'emoji': '👨‍👩‍👧‍👦',
    'color': const Color.fromARGB(255, 63, 211, 154),
    'description': 'I have children at home',
  };

  final Map<String, dynamic> _noOption = {
    'value': 'No',
    'label': 'No',
    'emoji': '🏠',
    'color': const Color.fromARGB(255, 117, 154, 253),
    'description': 'No children at home',
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  onTap: () => context.pop(),
                ),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getResponsiveValue(
                    context,
                    verySmall: 24,
                    small: 28,
                    medium: 32,
                    large: 36,
                  ),
                  vertical: getResponsiveValue(
                    context,
                    verySmall: 0,
                    small: 4,
                    medium: 6,
                    large: 8,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '[ STEP 3 OF 8 ]',
                      style: TextStyle(
                        fontSize: getResponsiveValue(
                          context,
                          verySmall: 11,
                          small: 12,
                          medium: 13,
                          large: 14,
                        ),
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(
                      height: getResponsiveValue(
                        context,
                        verySmall: 12,
                        small: 14,
                        medium: 16,
                        large: 18,
                      ),
                    ),
                    Text(
                      'Do you have\nchildren?',
                      style: GoogleFonts.newsreader(
                        fontSize: getResponsiveValue(
                          context,
                          verySmall: 36,
                          small: 44,
                          medium: 52,
                          large: 58,
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
                        verySmall: 40,
                        small: 50,
                        medium: 60,
                        large: 70,
                      ),
                    ),

                    // Yes/No Options
                    _buildOptionButton(_yesOption),

                    SizedBox(
                      height: getResponsiveValue(
                        context,
                        verySmall: 16,
                        small: 18,
                        medium: 20,
                        large: 24,
                      ),
                    ),

                    _buildOptionButton(_noOption),

                    SizedBox(
                      height: getResponsiveValue(
                        context,
                        verySmall: 40,
                        small: 50,
                        medium: 60,
                        large: 70,
                      ),
                    ),

                    // Continue Button (only shown when option is selected)
                    if (_selectedOption != null)
                      AnimatedOpacity(
                        opacity: _selectedOption != null ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: GestureDetector(
                          onTap: _saveHasChildren,
                          child: Container(
                            width: double.infinity,
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
                                  _selectedOption == 'Yes'
                                      ? _yesOption['color']
                                      : _noOption['color'],
                                  (_selectedOption == 'Yes'
                                          ? _yesOption['color']
                                          : _noOption['color'])
                                      .withOpacity(0.7),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: (_selectedOption == 'Yes'
                                          ? _yesOption['color']
                                          : _noOption['color'])
                                      .withOpacity(0.3),
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

  Widget _buildOptionButton(Map<String, dynamic> option) {
    final isSelected = _selectedOption == option['value'];

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = option['value'];
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: getResponsiveValue(
          context,
          verySmall: 140,
          small: 160,
          medium: 180,
          large: 200,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: isSelected ? option['color'] : Colors.grey[100],
          border: Border.all(
            color: isSelected ? option['color'] : Colors.grey[300]!,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: option['color'].withOpacity(0.3),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              option['emoji'],
              style: TextStyle(
                fontSize: getResponsiveValue(
                  context,
                  verySmall: 48,
                  small: 56,
                  medium: 64,
                  large: 72,
                ),
              ),
            ),
            SizedBox(
              height: getResponsiveValue(
                context,
                verySmall: 8,
                small: 10,
                medium: 12,
                large: 14,
              ),
            ),
            Text(
              option['label'],
              style: GoogleFonts.newsreader(
                fontSize: getResponsiveValue(
                  context,
                  verySmall: 28,
                  small: 32,
                  medium: 36,
                  large: 40,
                ),
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 4),
            Text(
              option['description'],
              style: TextStyle(
                fontSize: getResponsiveValue(
                  context,
                  verySmall: 12,
                  small: 13,
                  medium: 14,
                  large: 15,
                ),
                color: isSelected
                    ? Colors.white.withOpacity(0.9)
                    : Colors.grey[600],
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveHasChildren() {
    if (_selectedOption == null) return;

    // Save to provider
    ref
        .read(userProfileProvider.notifier)
        .setHasChildren(_selectedOption == 'Yes');

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saved: $_selectedOption'),
        backgroundColor:
            _selectedOption == 'Yes' ? _yesOption['color'] : _noOption['color'],
        duration: const Duration(seconds: 2),
      ),
    );

    // Navigate to next screen (update with your actual route)
    // context.push('/next-screen');
  }
}
