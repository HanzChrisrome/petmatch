import 'package:go_router/go_router.dart';
import 'package:petmatch/features/home/presentation/landing_dashboard.dart';

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
  ),
];
