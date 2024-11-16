import 'package:flutter/material.dart';
import '../Screens/TopScorersScreen.dart';

class LeagueTopScorers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold sebagai kerangka utama halaman
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'League Top Scorers',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: GridView.builder(
          // GridView untuk menampilkan daftar liga dalam tata letak grid
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.0,
          ),
          itemCount: leagueData.length,
          itemBuilder: (context, index) {
            // Mengambil data liga berdasarkan indeks
            final Map<String, String> league = leagueData[index];

            return GestureDetector(
              onTap: () {
                // Navigasi ke halaman TopScorersScreen saat kartu ditekan
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TopScorersScreen(
                      leagueCode: league['code']!, // Mengirimkan kode liga ke halaman tujuan
                      leagueColor: Colors.blue,
                    ),
                  ),
                );
              },
              child: Container(
                // Desain kartu liga
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      league['image']!, // Menampilkan logo liga
                      height: 50,
                      width: 50,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 10),
                    Text(
                      league['name']!, // Menampilkan nama liga
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Data liga untuk digunakan dalam grid view
final List<Map<String, String>> leagueData = [
  {'image': 'assets/pl.png', 'name': 'Premier League', 'code': 'PL'},
  {'image': 'assets/laliga.png', 'name': 'La Liga', 'code': 'PD'},
  {'image': 'assets/bundesliga.png', 'name': 'Bundesliga', 'code': 'BL1'},
  {'image': 'assets/seria.png', 'name': 'Serie A', 'code': 'SA'},
  {'image': 'assets/ligue1.png', 'name': 'Ligue 1', 'code': 'FL1'},
  {'image': 'assets/nos.png', 'name': 'Primeira Liga', 'code': 'PPL'},
];
