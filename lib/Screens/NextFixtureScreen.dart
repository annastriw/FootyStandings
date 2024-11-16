import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NextFixture extends StatefulWidget {
  final String leagueCode; // Kode liga untuk mendapatkan data pertandingan
  final Color leagueColor; // Warna latar yang diatur sesuai liga

  NextFixture({required this.leagueCode, required this.leagueColor});

  @override
  _NextFixtureState createState() => _NextFixtureState();
}

class _NextFixtureState extends State<NextFixture> {
  late Future<List<Match>> _matchesFuture; // widget FutureBuilder untuk menyimpan daftar pertandingan

  @override
  void initState() {
    super.initState();
    _matchesFuture = getUpcomingMatches(widget.leagueCode); // Inisialisasi Future ketika widget dibuat
  }

  Future<List<Match>> getUpcomingMatches(String code) async {
    final response = await http.get(
      Uri.parse('https://api.football-data.org/v4/competitions/$code/matches?status=SCHEDULED'),
      headers: {
        "X-Auth-Token": 'f651cd2498624bb7b9fa3ff3199fcd2b',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> matches = data['matches']; // Ambil daftar pertandingan dari JSON
      
      return matches.map((matchData) {
        // Map data JSON ke dalam objek `Match`
        return Match(
          matchData['homeTeam']['name'],
          matchData['awayTeam']['name'],
          matchData['utcDate'],
        );
      }).toList();
    } else {
      throw Exception("Failed to load matches");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Next Fixtures",
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
        child: FutureBuilder<List<Match>>(
          future: _matchesFuture, // Future untuk mendapatkan data pertandingan
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error loading fixtures"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No upcoming matches available"));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                padding: EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final match = snapshot.data![index]; // Ambil data pertandingan
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12),
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            formatDate(match.utcDate), // Tampilkan tanggal
                            style: TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                          SizedBox(height: 4),
                          Text(
                            formatTime(match.utcDate), // Tampilkan waktu
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      title: Text(
                        match.homeTeam, // Nama tim tuan rumah
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "vs ${match.awayTeam}", // Teks "vs" dan nama tim tamu
                        style: TextStyle(fontSize: 16),
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

  /// Fungsi untuk memformat tanggal dari UTC ke format DD/MM/YYYY
  String formatDate(String utcDate) {
    final dateTime = DateTime.parse(utcDate).toLocal();
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }

  /// Fungsi untuk memformat waktu dari UTC ke format HH:mm WIB
  String formatTime(String utcDate) {
    final dateTime = DateTime.parse(utcDate).toLocal();
    return "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} WIB";
  }
}

class Match {
  final String homeTeam;
  final String awayTeam;
  final String utcDate;

  Match(this.homeTeam, this.awayTeam, this.utcDate); // Konstruktor
}
