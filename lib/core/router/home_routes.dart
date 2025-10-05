import 'package:go_router/go_router.dart';
import 'package:petmatch/features/home/presentation/landing_dashboard.dart';
import 'package:petmatch/features/home/presentation/profile_dashboard.dart';
import 'package:petmatch/features/pet_profile/screens/pet_activity_information.dart';
import 'package:petmatch/features/pet_profile/screens/pet_behavior_information.dart';
import 'package:petmatch/features/pet_profile/screens/pet_health_information.dart';
import 'package:petmatch/features/pet_profile/screens/pet_information.dart';
import 'package:petmatch/features/pet_profile/screens/pet_temperament_information.dart';
import 'package:petmatch/features/user_profile/presentation/screen/household_setup.dart';
import 'package:petmatch/features/user_profile/presentation/screen/lifestyle_setup.dart';
import 'package:petmatch/features/user_profile/presentation/screen/personality_setup.dart';
import 'package:petmatch/features/user_profile/presentation/screen/pet_preferences_setup.dart';
import 'package:petmatch/features/user_profile/presentation/screen/profile_setup.dart';
import 'package:petmatch/features/user_profile/presentation/screen/responsibility_setup.dart';

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
        path: '/lifestyle-setup',
        name: 'lifestyle-setup',
        builder: (context, state) => const LifestyleSetupScreen(),
      ),
      GoRoute(
        path: '/pet-preferences-setup',
        name: 'pet-preferences-setup',
        builder: (context, state) => const PetPreferencesSetupScreen(),
      ),
      GoRoute(
        path: '/personality-setup',
        name: 'personality-setup',
        builder: (context, state) => const PersonalitySetupScreen(),
      ),
      GoRoute(
        path: '/household-setup',
        name: 'household-setup',
        builder: (context, state) => const HouseholdSetupScreen(),
      ),
      GoRoute(
        path: '/responsibility-setup',
        name: 'responsibility-setup',
        builder: (context, state) => const ResponsibilitySetupScreen(),
      ),

      //PET PROFILE
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
    ],
  ),
];
