// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:travelapp/ui/splash/splash2.dart';
import 'package:intl/intl.dart';

class MainGuestScreen extends StatefulWidget {
  const MainGuestScreen({super.key});

  @override
  State<MainGuestScreen> createState() => _MainGuestScreenState();
}

class _MainGuestScreenState extends State<MainGuestScreen> {
  List<Map<String, dynamic>> allTrips = [];
  List<Map<String, dynamic>> filteredTrips = [];
  final TextEditingController _searchController = TextEditingController();
  final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _fetchTrips();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredTrips = allTrips.where((trip) {
        final name = trip['nama_paket'].toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  Future<void> _fetchTrips() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2/backend/detail.php'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final trips = List<Map<String, dynamic>>.from(data['data']);
        setState(() {
          allTrips = trips;
          filteredTrips = trips;
        });
      } else {
        throw Exception('Gagal memuat data trips');
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1976D2),
        title: Row(
          children: [
            Icon(Icons.explore, color: Colors.white),
            SizedBox(width: 8),
            Text('TripShare - Guest Mode', style: TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline, color: Colors.white),
            tooltip: 'Masuk',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SplashScreen2()),
              );
            },
          ),
        ],
        elevation: 2,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari Open Trips...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: filteredTrips.isEmpty
                    ? Center(child: Text("Paket tidak ditemukan."))
                    : GridView.builder(
                        padding: EdgeInsets.only(bottom: 16),
                        itemCount: filteredTrips.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.72,
                        ),
                        itemBuilder: (context, index) {
                          final trip = filteredTrips[index];
                          return _buildTripCard(
                            id: trip["id"].toString(),
                            name: trip["nama_paket"],
                            price: trip["harga"],
                            imageUrl: 'http://10.0.2.2/backend/uploads/${trip["foto"]}',
                            context: context,
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripCard({
    required String id,
    required String name,
    required dynamic price,
    required String imageUrl,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        // Arahkan ke SplashScreen2 (pilihan Masuk / Daftar)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Silakan login untuk melihat detail trip')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SplashScreen2()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: Icon(Icons.image_not_supported, size: 30),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Divider(color: Colors.grey[300], height: 18),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                        SizedBox(width: 5),
                        Text("1 Hari", style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.redAccent),
                        SizedBox(width: 5),
                        Text("Bandung", style: TextStyle(fontSize: 12, color: Colors.redAccent)),
                      ],
                    ),
                    Spacer(),
                    Text(
                      formatter.format(double.tryParse(price.toString()) ?? 0),
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
