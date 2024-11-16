import 'package:flutter/material.dart';
import '../Widgets/bottom_nav_bar.dart';
import 'LeagueStandings.dart';
import 'LeagueNextFixture.dart';
import 'LeagueTopScorers.dart';
import 'Profile.dart';
import 'About.dart';

// HomeScreen adalah halaman utama dengan navigasi tab
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Daftar halaman yang akan ditampilkan sesuai dengan tab yang dipilih
  static final List<Widget> _pages = <Widget>[
    LeagueStandings(),
    LeagueNextFixture(),
    LeagueTopScorers(),
    Profile(),
    About(),
  ];

  // Fungsi untuk mengganti halaman saat tab pada Bottom Navigation Bar ditekan
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      // Bottom Navigation Bar untuk navigasi antar halaman
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
