import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:petmatch/widgets/custom_button.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _floatA;
  late final Animation<double> _floatB;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _floatA = Tween<double>(begin: 0, end: 18).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );

    _floatB = Tween<double>(begin: 0, end: -16).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _ctrl,
            builder: (context, child) {
              return Positioned(
                bottom: 250 + _floatB.value,
                right: -20 + (_floatA.value / 4),
                child: Transform.rotate(
                  angle: 6 + (_floatA.value * 0.004),
                  child: child,
                ),
              );
            },
            child: Image.asset(
              'assets/get_started_screen/paws.png',
              width: isSmallScreen ? 60 : 80,
              height: isSmallScreen ? 60 : 80,
            ),
          ),

          AnimatedBuilder(
            animation: _ctrl,
            builder: (context, child) {
              return Positioned(
                bottom: 120 + _floatB.value,
                left: -35 + (_floatB.value / 6),
                child: Transform.rotate(
                  angle: -6 + (_floatB.value * 0.003),
                  child: child,
                ),
              );
            },
            child: Image.asset(
              'assets/get_started_screen/paws.png',
              width: isSmallScreen ? 75 : 100,
              height: isSmallScreen ? 75 : 100,
            ),
          ),

          // Main content with dog (on top)
          Positioned.fill(
            child: Column(
              children: [
                SizedBox(height: isSmallScreen ? 40 : 80),

                Image.asset(
                  "assets/petmatch_logo.png",
                  height: isSmallScreen ? 100 : 140,
                ),

                SizedBox(height: isSmallScreen ? 16 : 24),

                // Tagline
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontSize: isSmallScreen ? 28 : 34,
                                color: Theme.of(context).colorScheme.secondary,
                                height: 1.2,
                                fontWeight: FontWeight.bold,
                              ),
                          children: [
                            const TextSpan(text: "Where "),
                            TextSpan(
                              text: "companions",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    fontSize: isSmallScreen ? 28 : 34,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    height: 1.2,
                                    fontWeight: FontWeight.w900,
                                    fontStyle: FontStyle.italic,
                                  ),
                            ),
                            const TextSpan(text: "\nfind each other."),
                          ],
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 12 : 16),
                      Text(
                        "PetMatch connects people and pets through smart, caring technology—helping adopters discover the perfect furry friend while giving every animal the chance to find a loving home.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: isSmallScreen ? 13 : 14,
                              color: const Color(0xFF666666),
                              height: 1.6,
                            ),
                        // style: TextStyle(
                        //   fontSize: 14,
                        //   color: Color(0xFF666666),
                        //   height: 1.6,
                        // ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: isSmallScreen ? 20 : 30),

                CustomButton(
                  label: 'Create Account',
                  onPressed: () {
                    context.push('/register');
                  },
                  icon: Icons.pets,
                  backgroundColor: const Color.fromARGB(255, 24, 24, 24),
                  verticalPadding: isSmallScreen ? 12 : 14,
                ),

                SizedBox(height: isSmallScreen ? 12 : 16),

                GestureDetector(
                  onTap: () {
                    context.push('/login');
                  },
                  child: Text.rich(
                    TextSpan(
                      text: "I already have an account, ",
                      style: TextStyle(
                          color: const Color(0xFF666666),
                          fontSize: isSmallScreen ? 13 : 14),
                      children: [
                        TextSpan(
                          text: "Sign in",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                Image.asset(
                  "assets/get_started_screen/dog.png",
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
                  height: isSmallScreen ? 210 : 350,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
