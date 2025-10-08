// ═══════════════════════════════════════════════════════════════════════════
// USER PROFILE PROVIDER - USAGE EXAMPLES
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petmatch/features/user_profile/provider/user_profile_provider.dart';

// ═══════════════════════════════════════════════════════════════════════════
// EXAMPLE 1: Save Pet Preference (in pet_preference.dart)
// ═══════════════════════════════════════════════════════════════════════════

class PetPreferenceExample extends ConsumerWidget {
  const PetPreferenceExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        // ✅ Save selected pet preference
        ref.read(userProfileProvider.notifier).setPetPreference(context, 'Dog');

        // Navigate to next screen
        // context.push('/activity-level');
      },
      child: const Text('Continue'),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EXAMPLE 2: Save Activity Level (in activity_level_setup.dart)
// ═══════════════════════════════════════════════════════════════════════════

class ActivityLevelExample extends ConsumerStatefulWidget {
  const ActivityLevelExample({super.key});

  @override
  ConsumerState<ActivityLevelExample> createState() =>
      _ActivityLevelExampleState();
}

class _ActivityLevelExampleState extends ConsumerState<ActivityLevelExample> {
  double _activityLevel = 3.0;

  void _saveActivityLevel() {
    // ✅ Save activity level with label
    ref.read(userProfileProvider.notifier).setActivityLevel(
          context,
          _activityLevel.round(),
          'Moderately Active', // Label corresponding to the level
        );

    // Navigate to next screen
    // context.push('/affection-level');
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _saveActivityLevel,
      child: const Text('Continue'),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EXAMPLE 3: Save Affection Level (in affection_level_setup.dart)
// ═══════════════════════════════════════════════════════════════════════════

class AffectionLevelExample extends ConsumerStatefulWidget {
  const AffectionLevelExample({super.key});

  @override
  ConsumerState<AffectionLevelExample> createState() =>
      _AffectionLevelExampleState();
}

class _AffectionLevelExampleState extends ConsumerState<AffectionLevelExample> {
  double _affectionLevel = 3.0;

  void _saveAffectionLevel() {
    // ✅ Save affection level with label
    ref.read(userProfileProvider.notifier).setAffectionLevel(
          context,
          _affectionLevel.round(),
          'Balanced', // Label corresponding to the level
        );

    // Navigate to next screen
    // context.push('/patience-level');
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _saveAffectionLevel,
      child: const Text('Continue'),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EXAMPLE 4: Save Patience Level (in patience_level_setup.dart)
// ═══════════════════════════════════════════════════════════════════════════

class PatienceLevelExample extends ConsumerStatefulWidget {
  const PatienceLevelExample({super.key});

  @override
  ConsumerState<PatienceLevelExample> createState() =>
      _PatienceLevelExampleState();
}

class _PatienceLevelExampleState extends ConsumerState<PatienceLevelExample> {
  double _patienceLevel = 3.0;

  void _savePatienceLevel() {
    // ✅ Save patience level with label
    ref.read(userProfileProvider.notifier).setPatienceLevel(
          context,
          _patienceLevel.round(),
          'Moderate Patience', // Label corresponding to the level
        );

    // Navigate to next screen or submit profile
    // context.push('/review-profile');
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _savePatienceLevel,
      child: const Text('Continue'),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EXAMPLE 5: Watch Current State (Display profile data)
// ═══════════════════════════════════════════════════════════════════════════

class ProfileSummaryExample extends ConsumerWidget {
  const ProfileSummaryExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Watch the profile state (rebuilds when state changes)
    final profile = ref.watch(userProfileProvider);

    return Column(
      children: [
        Text('Pet Preference: ${profile.petPreference ?? "Not selected"}'),
        Text('Activity Level: ${profile.activityLevel ?? "Not selected"}'),
        Text('Affection Level: ${profile.affectionLevel ?? "Not selected"}'),
        Text('Patience Level: ${profile.patienceLevel ?? "Not selected"}'),
        Text('Completion: ${profile.completionPercentage}%'),
        LinearProgressIndicator(
          value: profile.completionPercentage / 100,
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EXAMPLE 6: Submit Profile to Backend
// ═══════════════════════════════════════════════════════════════════════════

class SubmitProfileExample extends ConsumerWidget {
  const SubmitProfileExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);

    return ElevatedButton(
      onPressed: profile.isSubmitting
          ? null
          : () async {
              // ✅ Submit profile to backend
              final success =
                  await ref.read(userProfileProvider.notifier).submitProfile();

              if (success && context.mounted) {
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile saved successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );

                // Navigate to home or dashboard
                // context.go('/home');
              } else if (context.mounted) {
                // Show error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      profile.errorMessage ?? 'Failed to save profile',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
      child: profile.isSubmitting
          ? const CircularProgressIndicator()
          : const Text('Submit Profile'),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EXAMPLE 7: Read State Once (without watching)
// ═══════════════════════════════════════════════════════════════════════════

class ReadOnceExample extends ConsumerWidget {
  const ReadOnceExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        // ✅ Read state once (doesn't rebuild on changes)
        final profile = ref.read(userProfileProvider);

        // Get profile summary
        final notifier = ref.read(userProfileProvider.notifier);
        final summary = notifier.getProfileSummary();

        print(summary);
      },
      child: const Text('Print Profile Summary'),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EXAMPLE 8: Clear Profile Data
// ═══════════════════════════════════════════════════════════════════════════

class ClearProfileExample extends ConsumerWidget {
  const ClearProfileExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        // ✅ Clear all profile data
        ref.read(userProfileProvider.notifier).clearProfile();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile cleared')),
        );
      },
      child: const Text('Clear Profile'),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EXAMPLE 9: Check if Profile is Valid
// ═══════════════════════════════════════════════════════════════════════════

class ValidateProfileExample extends ConsumerWidget {
  const ValidateProfileExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);

    return Column(
      children: [
        Text(
          profile.isValid ? 'Profile Complete ✅' : 'Profile Incomplete ❌',
          style: TextStyle(
            color: profile.isValid ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (!profile.isValid)
          Text(
            'Please complete all required fields',
            style: TextStyle(color: Colors.grey[600]),
          ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CONSOLE OUTPUT EXAMPLES
// ═══════════════════════════════════════════════════════════════════════════

/*
When you call setPetPreference('Dog'):
  📝 Pet preference saved: Dog
  Current completion: 25%
  Profile state: {pet_preference: Dog, activity_level: null, ...}
  ──────────────────────────────────────────────────────

When you call setActivityLevel(3, 'Moderately Active'):
  📝 Activity level saved: 3 - Moderately Active
  Current completion: 50%
  Profile state: {pet_preference: Dog, activity_level: 3, activity_label: Moderately Active, ...}
  ──────────────────────────────────────────────────────

When you call submitProfile():
  📤 Submitting profile to backend...
  Profile data: {pet_preference: Dog, activity_level: 3, affection_level: 4, patience_level: 5, ...}
  ✅ Profile submitted successfully!

When you call getProfileSummary():
  🐾 User Profile Summary:
  Pet Preference: Dog
  Activity Level: 3 - Moderately Active
  Affection Level: 4 - Pretty Affectionate
  Patience Level: 5 - Very High Patience
  Living Space: Not set
  Experience: Not set
  Age Preference: Not set
  Size Preference: Not set
  Completion: 100%
  Valid: ✅
*/
