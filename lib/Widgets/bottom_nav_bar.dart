import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex; // Indeks tab yang saat ini dipilih
  final Function(int) onTap; // Callback ketika tab ditekan

  const BottomNavBar({
    super.key,
    required this.selectedIndex, // Parameter untuk menentukan tab yang aktif
    required this.onTap, // Parameter untuk menangani event klik tab
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // Daftar item dalam navigasi bar
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.table_chart),
          label: 'Standings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sports_soccer),
          label: 'Next Fixtures',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          label: 'Top Scorer',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: 'About',
        ),
      ],
      currentIndex: selectedIndex, // Menentukan tab yang sedang aktif
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey, // Warna untuk tab yang tidak aktif
      onTap: onTap, // Memanggil callback ketika tab ditekan
    );
  }
}
