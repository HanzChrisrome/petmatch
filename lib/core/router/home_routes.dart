import 'package:go_router/go_router.dart';
import 'package:petmatch/features/home/presentation/landing_dashboard.dart';
import 'package:petmatch/features/home/presentation/profile_dashboard.dart';
import 'package:petmatch/features/pet_profile/screens/pet_activity_information.dart';
import 'package:petmatch/features/pet_profile/screens/pet_behavior_information.dart';
import 'package:petmatch/features/pet_profile/screens/pet_health_information.dart';
import 'package:petmatch/features/pet_profile/screens/pet_information.dart';
import 'package:petmatch/features/pet_profile/screens/pet_temperament_information.dart';
import 'package:petmatch/features/user_profile/presentation/screen/activity_level_setup.dart';
import 'package:petmatch/features/user_profile/presentation/screen/affection_level_setup.dart';
import 'package:petmatch/features/user_profile/presentation/screen/grooming_level_setup.dart';
import 'package:petmatch/features/user_profile/presentation/screen/patience_level_setup.dart';
import 'package:petmatch/features/user_profile/presentation/screen/household_setup.dart';
import 'package:petmatch/features/user_profile/presentation/screen/pet_preference.dart';
import 'package:petmatch/features/user_profile/presentation/screen/profile_setup.dart';
import 'package:petmatch/features/user_profile/presentation/screen/size_preference.dart';

final homeRoutes = [
  GoRoute(
    path: '/home',
    builder: (context, state) => const LandingDashboard(),
    pageBuilder: (context, state) {
      return CustomTransitionPage(
        child: const LandingDashboard(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child;
        },
      );
    },
    routes: [
      GoRoute(
        path: '/profile-screen',
        name: 'profile-screen',
        builder: (context, state) => const ProfileDashboard(),
      ),
      GoRoute(
        path: '/profile-setup',
        name: 'profile-setup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      GoRoute(
        path: '/household-setup',
        name: 'household-setup',
        builder: (context, state) => const HouseholdSetupScreen(),
      ),
      GoRoute(
        path: '/pet-information',
        name: 'pet-information',
        builder: (context, state) => const PetInformationScreen(),
      ),
      GoRoute(
        path: '/pet-health-information',
        name: 'pet-health-information',
        builder: (context, state) => const PetHealthInformationScreen(),
      ),
      GoRoute(
        path: '/pet-activity-information',
        name: 'pet-activity-information',
        builder: (context, state) => const PetActivityInformationScreen(),
      ),
      GoRoute(
        path: '/pet-temperament-information',
        name: 'pet-temperament-information',
        builder: (context, state) => const PetTemperamentInformationScreen(),
      ),
      GoRoute(
        path: '/pet-behavior-information',
        name: 'pet-behavior-information',
        builder: (context, state) => const PetBehaviorInformationScreen(),
      ),
      GoRoute(
        path: '/activity-level-setup',
        name: 'activity-level-setup',
        builder: (context, state) => const ActivityLevelSetupScreen(),
      ),
      GoRoute(
        path: '/patience-level-setup',
        name: 'patience-level-setup',
        builder: (context, state) => const PatienceLevelSetupScreen(),
      ),
      GoRoute(
        path: '/affection-level-setup',
        name: 'affection-level-setup',
        builder: (context, state) => const AffectionLevelSetupScreen(),
      ),
      GoRoute(
        path: '/grooming-level-setup',
        name: 'grooming-level-setup',
        builder: (context, state) => const GroomingLevelSetupScreen(),
      ),
      GoRoute(
        path: '/pet-preference-setup',
        name: 'pet-preference-setup',
        builder: (context, state) => const PetPreferenceScreen(),
      ),
      GoRoute(
        path: '/size-preference-setup',
        name: 'size-preference-setup',
        builder: (context, state) => const SizePreferenceScreen(),
      ),
    ],
  ),
];
