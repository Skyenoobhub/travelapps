// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:travelapp/home.dart';
import 'package:travelapp/ui/profile/profile.dart';
import 'package:travelapp/ui/trips/detail_trip_page.dart';

class OpenTripPage extends StatefulWidget {
  final String userName;

  const OpenTripPage({super.key, required this.userName});

  @override
  State<OpenTripPage> createState() => _OpenTripPageState();
}

class _OpenTripPageState extends State<OpenTripPage> {
  final Set<String> favoriteTrips = {};

  void _navigateToPage(int index, BuildContext context) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(userName: widget.userName)),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage(userName: widget.userName)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Open Trip Bandung',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.notifications_none, color: Colors.blue),
                          onPressed: () {},
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          radius: 16,
                          child: Icon(Icons.person, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(color: Colors.grey[300]),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchTrips(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada paket trip tersedia.'));
          }

          final trips = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Liburan Sehari, Tanpa Ribet & Hemat Waktu!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Bersama PT Jalan Dulu Asia – Teman Liburan Terbaikmu!',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                TextField(
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
                SizedBox(height: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: GridView.builder(
                      itemCount: trips.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.72, // Lebih tinggi
                      ),
                      itemBuilder: (context, index) {
                        final trip = trips[index];
                        final tripId = trip["id"].toString();
                        return _buildTripCard(
                          id: tripId,
                          name: trip["nama_paket"],
                          price: trip["harga"],
                          imageUrl: 'http://10.0.2.2/backend/uploads/${trip["foto"]}',
                          context: context,
                          isFavorite: favoriteTrips.contains(tripId),
                          onToggleFavorite: () {
                            setState(() {
                              if (favoriteTrips.contains(tripId)) {
                                favoriteTrips.remove(tripId);
                              } else {
                                favoriteTrips.add(tripId);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) => _navigateToPage(index, context),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Trips'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchTrips() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/backend/detail.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['data']);
    } else {
      throw Exception('Gagal memuat data trips');
    }
  }

  Widget _buildTripCard({
    required String id,
    required String name,
    required dynamic price,
    required String imageUrl,
    required BuildContext context,
    required bool isFavorite,
    required VoidCallback onToggleFavorite,
  }) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailTripPage(packageId: id)),
      ),
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
              child: Stack(
                children: [
                  ClipRRect(
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
                  Positioned(
                    right: 8,
                    top: 8,
                    child: GestureDetector(
                      onTap: onToggleFavorite,
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Divider(color: Colors.grey[300], height: 16),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                        SizedBox(width: 4),
                        Text("1 Hari", style: TextStyle(fontSize: 11)),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 12, color: Colors.redAccent),
                        SizedBox(width: 4),
                        Text("Bandung", style: TextStyle(fontSize: 11)),
                      ],
                    ),
                    Spacer(),
                    Text(
                      "IDR $price",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
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
