import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tft_synk/custom_icons/my_flutter_app_icons.dart';

import 'app_constants.dart';
import 'comp_view.dart';
import 'firebase_options.dart';
import 'home.dart';
import 'splash_screen.dart';
import 'widgets/tabbed_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TFT SynK',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.background),
      home: SplashScreen(), // Always show splash screen first
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              HomeTab(key: homeTabKey),
              CompViewTab(),
              TabbedScreen(),
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
