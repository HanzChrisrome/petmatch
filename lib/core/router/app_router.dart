import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:petmatch/core/router/auth_routes.dart';
import 'package:petmatch/core/router/home_routes.dart';
import 'package:petmatch/get_started_screen.dart';
import 'package:petmatch/splash_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/get-started',
        name: 'get-started',
        builder: (context, state) => const GetStartedScreen(),
      ),
      ...homeRoutes,
      ...authRoutes
    ],
  );
});
