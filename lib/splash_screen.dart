// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:petmatch/features/auth/provider/auth_provider.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.read(authProvider.notifier);

    Future.microtask(() async {
      await authNotifier.initializeAuth();

      if (context.mounted) {
        final authState = ref.read(authProvider);
        final isAuth = authState.isAuthenticated;

        if (!isAuth) {
          context.go('/get-started');
        } else {
          context.go('/home');
        }
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Add Lottie dependency in pubspec.yaml: lottie: ^2.7.0
                // Place your Lottie file in assets/lottie/logo.json (update path as needed)
                // Add asset to pubspec.yaml: assets/lottie/logo.json

                SizedBox(
                  height: 300,
                  child: Lottie.asset(
                    'assets/lottie/Rotation Cats.json',
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
