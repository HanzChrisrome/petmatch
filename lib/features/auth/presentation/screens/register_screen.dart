// ignore_for_file: library_private_types_in_public_api, library_prefixes

import 'package:flutter/services.dart';
// location imports removed — location/region fields are not needed here
import 'package:petmatch/core/utils/notifier_helpers.dart';
import 'package:petmatch/core/utils/validators.dart';
import 'package:petmatch/features/auth/provider/auth_provider.dart';
import 'package:petmatch/widgets/custom_button.dart';
import 'package:petmatch/widgets/outline_button.dart';
import 'package:petmatch/widgets/text_gradient.dart';
import 'package:petmatch/widgets/style/themed_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController username = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    username.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authStateNotifier = ref.read(authProvider.notifier);

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
                        firstChild: const Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image(
                                image: AssetImage('assets/petmatch_logo.png'),
                                height: 84,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Your journey starts here\nTake the first step',
                                style: TextStyle(
                                  fontSize: 24,
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

                      const SizedBox(height: 70),
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 420),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ThemedTextField(
                                  label: 'E-mail',
                                  controller: emailController,
                                  prefixIcon: Icons.email,
                                  validator: Validators.validateEmail,
                                ),
                                ThemedTextField(
                                  label: 'Username',
                                  controller: username,
                                  prefixIcon: Icons.person,
                                ),
                                ThemedTextField(
                                  label: 'Password',
                                  controller: passwordController,
                                  isPasswordField: true,
                                  prefixIcon: Icons.lock,
                                  validator: Validators.validatePassword,
                                ),
                                ThemedTextField(
                                  label: 'Confirm password',
                                  controller: confirmPasswordController,
                                  isPasswordField: true,
                                  prefixIcon: Icons.lock,
                                ),
                                const SizedBox(height: 20),
                                CustomButton(
                                  label: 'Sign up',
                                  onPressed: () {
                                    authStateNotifier.signUp(
                                        context,
                                        emailController.text,
                                        passwordController.text,
                                        username.text,
                                        confirmPasswordController.text);
                                  },
                                  horizontalPadding: 0,
                                  verticalPadding: 12,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "By creating an account, you agree to our \nterms and conditions",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
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
