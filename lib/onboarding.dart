import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'app_constants.dart';
import 'main.dart';

class OnboardingScreen extends StatefulWidget {
  final List<OnboardingPage> pages;

  const OnboardingScreen({super.key, required this.pages});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

// Skip to the next page
  void _skip() {
    _pageController.jumpToPage(widget.pages.length - 1);
  }

// Navigate to the next page
  void _forward() {
    if (_pageController.page! < widget.pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        actions: [
          TextButton(
            onPressed: _skip,
            child: const Text(
              'Skip',
              style: TextStyle(color: AppColors.secondary),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.pages.length,
              itemBuilder: (context, index) {
                return index == widget.pages.length - 1
                    ? OnboardingLastPage(widget.pages[index])
                    : widget.pages[index];
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SmoothPageIndicator(
              controller: _pageController,
              count: widget.pages.length,
              axisDirection: Axis.horizontal,
              effect: const WormEffect(
                spacing: 8.0,
                radius: 4.0,
                dotWidth: 24.0,
                dotHeight: 16.0,
                paintStyle: PaintingStyle.stroke,
                strokeWidth: 1.5,
                dotColor: AppColors.secondary,
                activeDotColor: AppColors.primaryVariant,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox.shrink(), // Placeholder to keep the buttons centered
                IconButton(
                  icon: const Icon(Icons.arrow_forward,
                      color: AppColors.secondary),
                  onPressed: _forward,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
        ],
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
                color: AppColors.secondary,
                width: 2.0,
              ),
            ),
            child: Image.asset(
              imagePath,
              height: 350.0,
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            title,
            style: AppTextStyles.headline1BeaufortforLOL,
          ).animate().slide().fade(),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
            child: Text(
              description,
              textAlign: TextAlign.justify,
              style: AppTextStyles.bodyText6Spiegel,
            ).animate().slide().fade(),
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
          Text(
            page.title,
            style: AppTextStyles.headline1Spiegel,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          Text(page.description,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyText6Spiegel),
          const SizedBox(height: 32.0),
          Image.asset(
            page.imagePath,
            height: 300.0,
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
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryVariant,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero),
                side: const BorderSide(
                  width: 2,
                  color: AppColors.secondary,
                )),
            child: const Text(
              'Build Comp Now!',
              style: AppTextStyles.headline2Spiegel,
            ).animate().fadeIn().shake(),
          ),
        ],
      ),
    );
  }
}
