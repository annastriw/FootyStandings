import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TopScorer {
  String name;
  String teamName;
  String goalNum;
  String teamCrest;

  TopScorer(this.name, this.teamName, this.goalNum, this.teamCrest);
}

Future<List<TopScorer>> getScorers(String code) async {
  final response = await http.get(
    Uri.parse('https://api.football-data.org/v4/competitions/$code/scorers'),
    headers: {
      "X-Auth-Token": 'f651cd2498624bb7b9fa3ff3199fcd2b',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    if (data.containsKey('scorers') && data['scorers'] != null) {
      // Jika ada data pencetak gol, map data tersebut ke dalam daftar objek `TopScorer`
      List<dynamic> scorers = data['scorers'];
      return scorers.map((scorer) {
        return TopScorer(
          scorer['player']['name'],
          scorer['team']['name'],
          scorer['goals']?.toString() ?? '0',
          scorer['team']['crest'] ?? '',
        );
      }).toList();
    } else {
      print("No scorers data available for league code $code");
      return [];
    }
  } else {
    print("Failed to load top scorers. Status code: ${response.statusCode}");
    throw Exception("Failed to load top scorers");
  }
}

// Widget layar untuk menampilkan pencetak gol terbanyak
class TopScorersScreen extends StatefulWidget {
  final String leagueCode; // Kode liga yang dipilih
  final Color leagueColor; // Warna tema untuk liga tertentu

  TopScorersScreen({required this.leagueCode, required this.leagueColor});

  @override
  _TopScorersScreenState createState() => _TopScorersScreenState();
}

class _TopScorersScreenState extends State<TopScorersScreen> {
  late Future<List<TopScorer>> _scorersFuture; // widget Future untuk menyimpan data pencetak gol

  @override
  void initState() {
    super.initState();
    // Memuat data pencetak gol dari API saat layar pertama kali dibuat
    _scorersFuture = getScorers(widget.leagueCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Top Scorers',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: widget.leagueColor.withOpacity(0.1),
        child: FutureBuilder<List<TopScorer>>(
          future: _scorersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              print("Error loading top scorers: ${snapshot.error}");
              return Center(
                child: Text("Failed to load top scorers"),
              );
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "No top scorers data available for this league.",
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
              );
            } else {
              final scorers = snapshot.data!;
              return ListView.builder(
                itemCount: scorers.length,
                itemBuilder: (context, i) {
                  final scorer = scorers[i]; // Ambil data pencetak gol
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: scorer.teamCrest.isNotEmpty
                          ? Image.network(
                              scorer.teamCrest, // Logo tim
                              height: 40,
                              width: 40,
                              fit: BoxFit.contain,
                            )
                          : Icon(Icons.sports_soccer, size: 40), // Ikon default jika logo tidak tersedia
                      title: Text(
                        scorer.name, // Nama pemain
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(scorer.teamName), // Nama tim
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            scorer.goalNum, // Jumlah gol
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Goals', // Label untuk jumlah gol
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
