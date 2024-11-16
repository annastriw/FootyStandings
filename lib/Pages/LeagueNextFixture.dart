import 'package:flutter/material.dart';
import '../Screens/NextFixtureScreen.dart';

class LeagueNextFixture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'League Next Fixtures',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: GridView.builder(
          // GridView untuk menampilkan daftar liga dalam bentuk grid
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.0,
          ),
          itemCount: leagueData.length, // Jumlah item sesuai dengan jumlah data liga
          itemBuilder: (context, index) {
            final Map<String, String> league = leagueData[index];

            return GestureDetector(
              onTap: () {
                // Navigasi ke halaman NextFixture saat item ditekan
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NextFixture(
                      leagueCode: league['code']!,
                      leagueColor: Colors.blueAccent,
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
                  // Tampilan konten dalam kartu
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      league['image']!, //logo liga
                      height: 50,
                      width: 50,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 10),
                    Text(
                      league['name']!, // Nama liga
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

// Data liga untuk ditampilkan di kartu
final List<Map<String, String>> leagueData = [
  {'image': 'assets/pl.png', 'name': 'Premier League', 'code': 'PL'},
  {'image': 'assets/laliga.png', 'name': 'La Liga', 'code': 'PD'},
  {'image': 'assets/bundesliga.png', 'name': 'Bundesliga', 'code': 'BL1'},
  {'image': 'assets/seria.png', 'name': 'Serie A', 'code': 'SA'},
  {'image': 'assets/ligue1.png', 'name': 'Ligue 1', 'code': 'FL1'},
  {'image': 'assets/nos.png', 'name': 'Primeira Liga', 'code': 'PPL'},
];
