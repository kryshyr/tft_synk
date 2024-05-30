import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';
import 'onboarding.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  _navigateToNextScreen() async {
    await Future.delayed(
        const Duration(seconds: 5), () {}); // Show splash for 3 seconds

    // Get the seenOnboarding flag
    final prefs = await SharedPreferences.getInstance();
    final bool seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

    // Navigate to the appropriate screen
    if (seenOnboarding) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(title: 'Synk')),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const OnboardingScreen(
                  pages: [
                    OnboardingPage(
                      title: 'Hello Tactician!',
                      description:
                          'Welcome to TFT Synk. Your ultimate tool for creating winning team compositions in Teamfight Tactics.',
                      imagePath: 'assets/images/logo.png',
                    ),
                    OnboardingPage(
                      title: 'Build Compositions',
                      description:
                          'With drag and drop feature, TFT Synk provides composition building which allows you to visualize your build just like in the game.',
                      imagePath: 'assets/onboarding/onboarding_1.gif',
                    ),
                    OnboardingPage(
                      title: 'Easy Synergy Formation',
                      description:
                          'TFT Synk also allows easier synergy formation by searching champions based on their corresponding classes. With every drop on the arena, champion traits are displayed below to help tacticians strategize.',
                      imagePath: 'assets/onboarding/onboarding_2.gif',
                    ),
                    OnboardingPage(
                      title: 'Customize Comp Names',
                      description:
                          'As tacticians, we are fond of building powerful synergies by trying out different builds, synergies, and compositions. With TFT Synk, you can save and review your customized comps in a few clicks.',
                      imagePath: 'assets/onboarding/onboarding_3.gif',
                    ),
                    OnboardingPage(
                      title: 'Information Database',
                      description:
                          'With our database feature, we are now able to view and study different champions according to their classes, and view different traits and items at the same time.',
                      imagePath: 'assets/onboarding/onboarding_4.gif',
                    ),
                    OnboardingPage(
                      title: 'Build Your Own Compositions Now!',
                      description:
                          'Now, are you ready to scale up your team composition and try out different synergies?',
                      imagePath: 'assets/images/logo.png',
                    ),
                  ],
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(
          'assets/images/splash_1.gif',
          fit: BoxFit.cover,
        ),
      )),
    );
  }
}
