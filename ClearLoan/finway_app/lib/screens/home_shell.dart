import 'package:flutter/material.dart';
import '../services/i18n.dart';
import 'aggregator_screen.dart';
import 'loans_screen.dart';
import 'request_screen.dart';
import 'profile_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  final _pages = const [
    AggregatorScreen(),
    LoansScreen(),
    RequestScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: _pages[_index],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.grid_view_rounded),
            label: I18n.t('aggregator'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_bag_outlined),
            label: I18n.t('loans'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.edit_note_rounded),
            label: I18n.t('request'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline_rounded),
            label: I18n.t('profile'),
          ),
        ],
      ),
    );
  }
}
