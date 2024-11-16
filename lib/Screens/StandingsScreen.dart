import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ClubDetailScreen.dart';

class StandingsScreen extends StatefulWidget {
  final String code; // Kode liga untuk mendapatkan data klasemen

  const StandingsScreen({Key? key, required this.code}) : super(key: key);

  @override
  _StandingsScreenState createState() => _StandingsScreenState();
}

class _StandingsScreenState extends State<StandingsScreen> {
  late Future<List<TeamStanding>> _standingsFuture; // wicget Future untuk menyimpan data klasemen

  @override
  void initState() {
    super.initState();
    _standingsFuture = getLeagueStandings(widget.code); // Inisialisasi data klasemen saat widget dibuat
  }

  Future<List<TeamStanding>> getLeagueStandings(String leagueCode) async {
    final response = await http.get(
      Uri.parse('https://api.football-data.org/v4/competitions/$leagueCode/standings'),
      headers: {
        "X-Auth-Token": 'f651cd2498624bb7b9fa3ff3199fcd2b',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> standings = data['standings'][0]['table']; // Ambil data tabel klasemen
      
      return standings.map((entry) {
        return TeamStanding(
          entry['team']['id'],
          entry['position'],
          entry['team']['name'],
          entry['team']['crest'] ?? '',
          entry['playedGames'],
          entry['won'],
          entry['draw'],
          entry['lost'],
          entry['goalDifference'],
          entry['points'],
          entry['goalsFor'],
          entry['goalsAgainst'],
        );
      }).toList();
    } else {
      throw Exception("Failed to load standings");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "League Standings",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Container(
        color: Colors.blueAccent.withOpacity(0.1),
        child: FutureBuilder<List<TeamStanding>>(
          future: _standingsFuture, // widget Future data klasemen
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error loading standings"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No standings data available"));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                padding: EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final team = snapshot.data![index];
                  return Card(
                    color: Colors.white,
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () {
                        // Navigasi ke halaman detail tim saat kartu diklik
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClubDetailScreen(teamId: team.id), // Halaman detail dengan ID tim
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Text(
                              "${team.position}", // Tampilkan posisi
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            SizedBox(width: 10),
                            
                            // Logo tim
                            team.crestUrl.isNotEmpty
                                ? Image.network(
                                    team.crestUrl,
                                    height: 40,
                                    width: 40,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Icon(Icons.sports_soccer, color: Colors.grey), // Ikon pengganti jika gagal memuat logo
                                  )
                                : Icon(Icons.sports_soccer, color: Colors.grey),
                            
                            SizedBox(width: 10),
                            
                            // Nama tim
                            Expanded(
                              child: Text(
                                team.teamName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            
                            Spacer(),
                            
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end, // Posisi statistik di kanan
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildStat("P", team.playedGames),
                                    _buildStat("W", team.won),
                                    _buildStat("D", team.draw),
                                    _buildStat("L", team.lost),
                                    _buildStat("GF", team.goalsFor),
                                    _buildStat("GA", team.goalsAgainst),
                                    _buildStat("Pts", team.points),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      backgroundColor: Colors.grey[100],
    );
  }

  /// Fungsi untuk menampilkan statistik tim (label + nilai)
  Widget _buildStat(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Text(
            "$value", // Nilai statistik
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          Text(
            label, // Label statistik
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

/// Model data untuk menyimpan informasi tim dalam klasemen
class TeamStanding {
  final int id;
  final int position;
  final String teamName;
  final String crestUrl;
  final int playedGames;
  final int won;
  final int draw;
  final int lost;
  final int goalDifference;
  final int points;
  final int goalsFor;
  final int goalsAgainst;

  TeamStanding(
    this.id,
    this.position,
    this.teamName,
    this.crestUrl,
    this.playedGames,
    this.won,
    this.draw,
    this.lost,
    this.goalDifference,
    this.points,
    this.goalsFor,
    this.goalsAgainst,
  );
}
