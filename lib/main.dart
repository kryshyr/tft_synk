import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tft_synk/custom_icons/my_flutter_app_icons.dart';

import 'app_constants.dart';
import 'comp_view.dart';
import 'firebase_options.dart';
import 'home.dart';
import 'onboarding.dart';
import 'widgets/tabbed_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();
  final bool seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

  runApp(MyApp(seenOnboarding: seenOnboarding));
}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;

  const MyApp({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TFT SynK',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.background),
      home: seenOnboarding
          ? const MyHomePage(title: 'Synk')
          : const OnboardingScreen(
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
                  title: 'Costumize Comp Names',
                  description:
                      'As tacticians, we are fond of building powerful synergies by trying out different builds, synergies, and compositions. With TFT Synk, you can save and review your costumized comps in a few clicks.',
                  imagePath: 'assets/onboarding/onboarding_3.gif',
                ),
                OnboardingPage(
                  title: 'Champions Information Database',
                  description:
                      'With our database feature, we are now able to view and study different champions according to their classes, and view different traits and items at the same time.',
                  imagePath: 'assets/onboarding/onboarding_4.gif',
                ),
                OnboardingPage(
                  title: 'Buil Your Own Compositions Now!',
                  description:
                      'Now, are you ready to scale up your team composition and try out different synergies?',
                  imagePath: 'assets/images/logo.png',
                ),
              ],
            ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final GlobalKey<HomeTabState> homeTabKey = GlobalKey<HomeTabState>();

  // // Tab Pages
  // static final List<Widget> _pages = <Widget>[
  //   HomeTab(key: HomeTab.homeTabKey),
  //   CompViewTab(),
  //   // DatabaseTab(),
  //   TabbedScreen()
  // ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              // _pages
              HomeTab(key: homeTabKey),
              CompViewTab(),
              // DatabaseTab(),
              TabbedScreen()
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CustomIcon.hexagons),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.layers),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_stories),
              label: '',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          iconSize: 25,
          backgroundColor: AppColors.primaryVariant,
          selectedIconTheme:
              const IconThemeData(color: AppColors.secondary, size: 30),
          selectedItemColor: AppColors.secondary,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 6,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      homeTabKey.currentState?.resetPage();
    });
  }
}
