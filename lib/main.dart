import 'package:flutter/material.dart';
import 'Pages/HomeScreen.dart';

void main() {
  runApp(FootyStandingsApp());
}

class FootyStandingsApp extends StatelessWidget {
  const FootyStandingsApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Fungsi build untuk mendefinisikan UI aplikasi menggunakan widget MaterialApp.

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      
      home: HomeScreen(),  // Mengatur halaman utama aplikasi untuk menampilkan HomeScreen().
    );
  }
}
