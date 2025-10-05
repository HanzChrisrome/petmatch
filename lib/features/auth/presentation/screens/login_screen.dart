// ignore_for_file: library_private_types_in_public_api, library_prefixes

import 'dart:async';

import 'package:flutter/services.dart';
// location imports removed — location/region fields are not needed here
import 'package:petmatch/core/utils/notifier_helpers.dart';
import 'package:petmatch/core/utils/validators.dart';
import 'package:petmatch/features/auth/provider/auth_provider.dart';
import 'package:petmatch/widgets/custom_button.dart';
import 'package:petmatch/widgets/outline_button.dart';
import 'package:petmatch/widgets/text_field.dart';
import 'package:petmatch/widgets/text_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  int _calculateRemainingSeconds(DateTime? lockoutTime) {
    if (lockoutTime == null) return 0;
    final secondsLeft = lockoutTime.difference(DateTime.now()).inSeconds;
    return secondsLeft > 0 ? secondsLeft : 0;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final authStateNotifier = ref.read(authProvider.notifier);
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    final lockoutTime = authState.lockoutTime;
    final remainingSeconds = _calculateRemainingSeconds(lockoutTime);
    final bool isLockedOut = remainingSeconds > 0;

    double lockoutProgress = 0;
    if (isLockedOut) {
      const totalLockoutDuration = 60;
      lockoutProgress =
          (totalLockoutDuration - remainingSeconds) / totalLockoutDuration;
      if (lockoutProgress < 0) lockoutProgress = 0;
      if (lockoutProgress > 1) lockoutProgress = 1;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final kb = MediaQuery.of(context).viewInsets.bottom;
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: kb), // keyboard-aware padding
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      AnimatedCrossFade(
                        firstChild: Padding(
                          padding:
                              EdgeInsets.only(top: isSmallScreen ? 30 : 50),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image(
                                image: const AssetImage(
                                    'assets/petmatch_logo.png'),
                                height: isSmallScreen ? 64 : 84,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(height: isSmallScreen ? 12 : 20),
                              Text(
                                'Your journey starts here\nTake the first step',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 20 : 24,
                                  height: 1.1,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        secondChild: const SizedBox.shrink(),
                        crossFadeState: kb > 0
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 220),
                        sizeCurve: Curves.easeInOut,
                      ),

                      SizedBox(height: isSmallScreen ? 40 : 70),
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 420),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 20.0 : 24.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFieldWidget(
                                  label: 'Email',
                                  controller: emailController,
                                  prefixIcon: Icons.person,
                                  iconColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fillColor: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.05),
                                  borderColor: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.5),
                                  filled: true,
                                  focusedBorderColor:
                                      Theme.of(context).colorScheme.primary,
                                ),
                                TextFieldWidget(
                                  label: 'Password',
                                  controller: passwordController,
                                  isPasswordField: true,
                                  prefixIcon: Icons.lock,
                                  fillColor: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.05),
                                  borderColor: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.5),
                                  filled: true,
                                  iconColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  focusedBorderColor:
                                      Theme.of(context).colorScheme.primary,
                                  validator: Validators.validatePassword,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      context.push('/forgot-password');
                                    },
                                    child: Text(
                                      'Forgot password?',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontWeight: FontWeight.w600,
                                        fontSize: isSmallScreen ? 13 : 14,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: isSmallScreen ? 16 : 20),
                                CustomButton(
                                  label: authState.isLoggingIn
                                      ? 'Signing in...'
                                      : isLockedOut
                                          ? 'Locked (${remainingSeconds}s)'
                                          : 'Sign in',
                                  backgroundColor: isLockedOut
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onPrimary,
                                  onPressed:
                                      authState.isLoggingIn || isLockedOut
                                          ? null
                                          : () {
                                              authStateNotifier.signIn(
                                                context,
                                                emailController.text,
                                                passwordController.text,
                                              );
                                            },
                                  horizontalPadding: 0,
                                  verticalPadding: isSmallScreen ? 10 : 12,
                                ),
                                SizedBox(height: isSmallScreen ? 16 : 20),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Bottom spacer keeps middle vertically centered
                      const Spacer(),

                      // Optional small footer text (still inside SafeArea)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Text(
                          "Already have an account? Sign in",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
