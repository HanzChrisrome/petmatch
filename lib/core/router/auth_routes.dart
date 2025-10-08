import 'package:go_router/go_router.dart';
import 'package:petmatch/core/utils/page_transitions.dart';
import 'package:petmatch/features/auth/presentation/screens/forgot_password.dart';
import 'package:petmatch/features/auth/presentation/screens/login_screen.dart';
import 'package:petmatch/features/auth/presentation/screens/register_screen.dart';
import 'package:petmatch/features/auth/presentation/screens/verify_email_screen.dart';

final authRoutes = [
  GoRoute(
    path: '/login',
    name: 'login',
    builder: (context, state) => const LoginScreen(),
    pageBuilder: (context, state) {
      return slideTransitionBuilder(
        context,
        const LoginScreen(),
      );
    },
  ),
  GoRoute(
    path: '/register',
    name: 'register',
    builder: (context, state) => const RegisterScreen(),
    pageBuilder: (context, state) {
      return slideTransitionBuilder(
        context,
        const RegisterScreen(),
      );
    },
  ),
  GoRoute(
    path: '/forgot-password',
    name: 'forgot-password',
    builder: (context, state) => const ForgotPasswordScreen(),
    pageBuilder: (context, state) {
      return slideTransitionBuilder(
        context,
        const ForgotPasswordScreen(),
      );
    },
  ),
  GoRoute(
    path: '/verify-email',
    name: 'verify-email',
    builder: (context, state) {
      final email = state.uri.queryParameters['email'] ?? '';
      final password = state.uri.queryParameters['password'];
      return VerifyEmailScreen(
        email: email,
        password: password,
      );
    },
    pageBuilder: (context, state) {
      final email = state.uri.queryParameters['email'] ?? '';
      final password = state.uri.queryParameters['password'];
      return slideTransitionBuilder(
        context,
        VerifyEmailScreen(
          email: email,
          password: password,
        ),
      );
    },
  ),
];
