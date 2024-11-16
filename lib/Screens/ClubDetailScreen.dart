import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ClubDetailScreen extends StatefulWidget {
  final int teamId; // ID tim yang dipilih

  const ClubDetailScreen({Key? key, required this.teamId}) : super(key: key);

  @override
  _ClubDetailScreenState createState() => _ClubDetailScreenState();
}

class _ClubDetailScreenState extends State<ClubDetailScreen> {
  late Future<ClubDetail> _clubDetailFuture; // Widget FutureBuilder untuk memuat data detail klub

  @override
  void initState() {
    super.initState();
    _clubDetailFuture = getClubDetail(widget.teamId); // Inisialisasi Future ketika halaman diakses
  }

  Future<ClubDetail> getClubDetail(int teamId) async {
    final response = await http.get(
      Uri.parse('https://api.football-data.org/v4/teams/$teamId'),
      headers: {
        "X-Auth-Token": 'f651cd2498624bb7b9fa3ff3199fcd2b',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ClubDetail(
        crest: data['crest'] ?? '',
        name: data['name'] ?? '',
        address: data['address'] ?? '',
        website: data['website'] ?? '',
        founded: data['founded'] ?? 0,
        clubColors: data['clubColors'] ?? '',
        venue: data['venue'] ?? '',
      );
    } else {
      throw Exception("Failed to load club details");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Club Details",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<ClubDetail>(
        future: _clubDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading club details"));
          } else if (!snapshot.hasData) {
            return Center(child: Text("No club details available"));
          } else {
            final club = snapshot.data!;
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    club.crest.isNotEmpty
                        ? Image.network(
                            club.crest,
                            height: 100,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.sports_soccer, size: 100), // Ikon jika gambar gagal dimuat
                          )
                        : Icon(Icons.sports_soccer, size: 100),
                    SizedBox(height: 20),
                    Text(
                      club.name, //nama klub
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    _buildDetailText("Address", club.address),
                    _buildDetailText("Founded", club.founded.toString()),
                    _buildDetailText("Club Colors", club.clubColors),
                    _buildDetailText("Venue", club.venue),
                    SizedBox(height: 20),
                    InkWell(
                      // Tombol untuk membuka website klub
                      onTap: () => _launchURL(club.website),
                      child: Text(
                        "Visit Website", // Teks link
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  /// Fungsi untuk membangun teks detail
  Widget _buildDetailText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        "$label: $value",
        style: TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Fungsi untuk membuka URL menggunakan package url_launcher
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not launch $url: $e")),
      );
    }
  }
}

/// Model data untuk detail klub
class ClubDetail {
  final String crest;
  final String name;
  final String address;
  final String website;
  final int founded;
  final String clubColors;
  final String venue;

  ClubDetail({
    required this.crest,
    required this.name,
    required this.address,
    required this.website,
    required this.founded,
    required this.clubColors,
    required this.venue,
  });
}
