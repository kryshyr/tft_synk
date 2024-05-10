import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

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
    _PageOne(),
    _PageTwo(),
    _PageThree(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        backgroundColor: Colors.grey,
        selectedIconTheme: IconThemeData(color: Colors.amberAccent, size: 30),
        selectedItemColor: Colors.amberAccent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class _PageOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Tab 1'),
    );
  }
}

class _PageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Tab 2'),
    );
  }
}

class _PageThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Tab 3'),
    );
  }
}
