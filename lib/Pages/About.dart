import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan Scaffold sebagai struktur dasar untuk halaman About
      appBar: AppBar(
        title: Text('About'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Tentang Footy Standings",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Paragraf pertama tentang aplikasi
              Text(
                "Selamat datang di Footy Standings – aplikasi yang membawa seluruh dunia sepak bola ke genggaman Anda! Dengan Footy Standings, Anda bisa merasakan pengalaman menjadi bagian dari kompetisi liga-liga terbaik dunia. Dari Premier League hingga La Liga, Serie A, dan banyak lagi, semua informasi sepak bola yang Anda butuhkan ada di sini.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),

              // Paragraf kedua tentang tujuan aplikasi
              Text(
                "Di Footy Standings, kami mengerti bahwa menjadi penggemar sepak bola berarti selalu ingin tahu posisi tim favorit Anda di klasemen, kapan pertandingan selanjutnya, siapa pencetak gol terbanyak, dan detail menarik tentang setiap klub. Dengan antarmuka yang sederhana dan elegan, aplikasi ini dibuat untuk memberikan pengalaman terbaik bagi pecinta sepak bola di mana pun Anda berada.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),

              // Judul untuk daftar fitur aplikasi
              Text(
                "Fitur unggulan Footy Standings:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),

              // Menampilkan daftar fitur aplikasi dengan `_buildFeatureItem`
              _buildFeatureItem(
                "Klasemen Liga",
                "Pantau peringkat terbaru tim-tim favorit Anda dengan cepat dan mudah.",
              ),
              _buildFeatureItem(
                "Jadwal Pertandingan",
                "Jangan lewatkan satu pertandingan pun! Dapatkan informasi lengkap tentang pertandingan mendatang.",
              ),
              _buildFeatureItem(
                "Top Skor",
                "Lihat siapa yang memimpin daftar pencetak gol di liga, dan pantau bintang-bintang sepak bola beraksi.",
              ),
              _buildFeatureItem(
                "Profil Klub",
                "Temukan informasi lengkap klub – dari sejarah, warna tim, hingga stadion kebanggaan mereka.",
              ),
              SizedBox(height: 16),

              // Paragraf penutup tentang pengalaman menggunakan aplikasi
              Text(
                "Nikmati pengalaman menyaksikan dan mengikuti perkembangan dunia sepak bola dengan Footy Standings. Mari kita rayakan setiap gol, setiap kemenangan, dan setiap momen bersejarah dalam permainan yang kita cintai ini!",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk menampilkan setiap fitur aplikasi
  Widget _buildFeatureItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Colors.blueAccent, size: 20), // Icon untuk setiap fitur
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
