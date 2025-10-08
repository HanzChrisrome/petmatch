// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:petmatch/features/auth/provider/auth_provider.dart';
import 'package:petmatch/core/repository/user_profile_repository.dart';
import 'package:petmatch/features/user_profile/provider/user_profile_state.dart';

/// Notifier to manage user profile state
class UserProfileNotifier extends Notifier<UserProfileState> {
  late final UserProfileRepository _repository;

  @override
  UserProfileState build() {
    _repository = ref.read(userProfileRepositoryProvider);
    return const UserProfileState();
  }

  void setPetPreference(BuildContext context, String preference) {
    state = state.copyWith(petPreference: preference);
    _logState('Pet preference saved: $preference');
    context.push('/onboarding/activity-level');
  }

  void setActivityLevel(BuildContext context, int level, String label) {
    state = state.copyWith(
      activityLevel: level,
      activityLabel: label,
    );
    _logState('Activity level saved: $level - $label');
    context.push('/onboarding/patience-level');
  }

  void setPatienceLevel(BuildContext context, int level, String label) {
    state = state.copyWith(
      patienceLevel: level,
      patienceLabel: label,
    );
    _logState('Patience level saved: $level - $label');
    context.push('/onboarding/affection-level');
  }

  void setAffectionLevel(BuildContext context, int level, String label) {
    state = state.copyWith(
      affectionLevel: level,
      affectionLabel: label,
    );
    _logState('Affection level saved: $level - $label');
    context.push('/onboarding/grooming-level');
  }

  void setGroomingLevel(BuildContext context, int level, String label) {
    state = state.copyWith(
      groomingLevel: level,
      groomingLabel: label,
    );
    _logState('Grooming level saved: $level - $label');
    context.push('/onboarding/size-preference');
  }

  void setSizePreference(BuildContext context, String size) {
    state = state.copyWith(sizePreference: size);
    _logState('Size preference saved: $size');
    context.push('/onboarding/household');
  }

  /// Save whether user has children
  void setHouseholdInfo(
      bool hasChildren,
      bool hasOtherPets,
      String? existingPetsDescription,
      bool comfortableWithShyPet,
      bool financialReady,
      bool hadPetBefore) {
    state = state.copyWith(
      hasChildren: hasChildren,
      hasOtherPets: hasOtherPets,
      existingPetsDescription: existingPetsDescription,
      comfortableWithShyPet: comfortableWithShyPet,
      financialReady: financialReady,
      hadPetBefore: hadPetBefore,
    );
    _logState(
        'Household info saved: $hasChildren, $hasOtherPets, $existingPetsDescription, $comfortableWithShyPet');
  }

  Future<bool> submitProfile() async {
    final authState = ref.watch(authProvider);
    final userId = authState.userId;

    if (!state.isValid) {
      state = state.copyWith(
        errorMessage: 'Please complete all required fields',
      );
      print('❌ Profile incomplete. Cannot submit.');
      print('Missing fields:');
      if (state.petPreference == null) print('  - Pet preference');
      if (state.activityLevel == null) print('  - Activity level');
      if (state.affectionLevel == null) print('  - Affection level');
      if (state.patienceLevel == null) print('  - Patience level');
      return false;
    }

    try {
      state = state.copyWith(isSubmitting: true, errorMessage: null);
      print('📤 Submitting profile to backend...');
      print('Profile data: ${state.toJson()}');

      // Simulate API call
      await Future.delayed(const Duration(seconds: 10));

      _repository.saveUserProfile(
        userId: userId!,
        userLifestyle: {
          'pet_preference': state.petPreference,
          'activity_level': state.activityLevel,
          'grooming_level': state.groomingLevel,
          'size_preference': state.sizePreference,
        },
        personalityTraits: {
          'snuggly_preference': state.affectionLevel,
          'training_patience': state.patienceLevel,
        },
        householdInfo: {
          'has_children': state.hasChildren,
          'has_other_pets': state.hasOtherPets,
          'existing_pets_description': state.existingPetsDescription,
          'comfortable_with_shy_pet': state.comfortableWithShyPet,
          'financial_ready': state.financialReady,
          'had_pet_before': state.hadPetBefore,
        },
      );

      state = state.copyWith(
        isSubmitting: false,
        isComplete: true,
      );

      print('✅ Profile submitted successfully!');
      return true;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Failed to submit profile: $e',
      );
      print('❌ Error submitting profile: $e');
      return false;
    }
  }

  void clearProfile() {
    state = const UserProfileState();
    print('🗑️  Profile cleared');
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void _logState(String message) {
    print('📝 $message');
    print('Current completion: ${state.completionPercentage}%');
    print('Profile state: ${state.toJson()}');
    print('─' * 50);
  }

  String getProfileSummary() {
    final buffer = StringBuffer();
    buffer.writeln('🐾 User Profile Summary:');
    buffer.writeln('Pet Preference: ${state.petPreference ?? "Not set"}');
    buffer.writeln(
        'Activity Level: ${state.activityLevel ?? "Not set"} - ${state.activityLabel ?? ""}');
    buffer.writeln(
        'Affection Level: ${state.affectionLevel ?? "Not set"} - ${state.affectionLabel ?? ""}');
    buffer.writeln(
        'Patience Level: ${state.patienceLevel ?? "Not set"} - ${state.patienceLabel ?? ""}');
    buffer.writeln('Living Space: ${state.livingSpace ?? "Not set"}');
    buffer.writeln('Experience: ${state.experience ?? "Not set"}');
    buffer.writeln('Age Preference: ${state.agePreference ?? "Not set"}');
    buffer.writeln('Size Preference: ${state.sizePreference ?? "Not set"}');
    buffer.writeln('Completion: ${state.completionPercentage}%');
    buffer.writeln('Valid: ${state.isValid ? "✅" : "❌"}');
    return buffer.toString();
  }
}

final userProfileRepositoryProvider =
    Provider((ref) => UserProfileRepository());

final userProfileProvider =
    NotifierProvider<UserProfileNotifier, UserProfileState>(
  UserProfileNotifier.new,
);
