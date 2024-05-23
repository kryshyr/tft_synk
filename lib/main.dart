import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app_constants.dart';
import 'comp_view.dart';
import 'database.dart';
import 'home.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TFT SynK',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Synk'),
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

  // Tab Pages
  static final List<Widget> _pages = <Widget>[
    HomeTab(),
    CompViewTab(),
    DatabaseTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: IndexedStack(
            index: _selectedIndex,
            children: _pages,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted),
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
              IconThemeData(color: AppColors.secondary, size: 30),
          selectedItemColor: AppColors.secondary,
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
