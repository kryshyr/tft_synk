import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_constants.dart';
import 'main.dart';

class OnboardingScreen extends StatelessWidget {
  final List<OnboardingPage> pages;

  const OnboardingScreen({super.key, required this.pages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: pages.length,
        itemBuilder: (context, index) {
          return index == pages.length - 1
              ? OnboardingLastPage(pages[index])
              : pages[index];
        },
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.secondary, // Change the color as needed
                width: 2.0, // Border width
              ),
            ),
            child: Image.asset(
              imagePath,
              height: 500.0,
            ),
          ),
          const SizedBox(height: 30.0),
          Text(
            title,
            style: AppTextStyles.headline1BeaufortforLOL,
          ),
          const SizedBox(height: 16.0),
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyText1Spiegel,
          ),
          const SizedBox(height: 32.0),
        ],
      ),
    );
  }
}

class OnboardingLastPage extends StatelessWidget {
  final OnboardingPage page;

  const OnboardingLastPage(this.page, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(page.title, style: AppTextStyles.headline1Spiegel),
          const SizedBox(height: 16.0),
          Text(page.description,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyText1Spiegel),
          const SizedBox(height: 32.0),
          Image.asset(
            page.imagePath,
            height: 400.0,
          ),
          const SizedBox(height: 32.0),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('seenOnboarding', true);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => const MyHomePage(title: 'Synk')),
              );
            },
            child: const Text('Build Comp Now!'),
          ),
        ],
      ),
    );
  }
}
