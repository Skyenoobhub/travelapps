// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

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
  List<Map<String, dynamic>> allTrips = [];
  List<Map<String, dynamic>> filteredTrips = [];
  final TextEditingController _searchController = TextEditingController();

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 4,
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.directions_bus, color: Colors.blueAccent, size: 26),
                        SizedBox(width: 8),
                        Text(
                          'Open Trip Bandung',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(userName: widget.userName),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.blueAccent.withOpacity(0.2),
                        radius: 18,
                        child: Icon(Icons.person, color: Colors.blueAccent),
                      ),
                    ),
                  ],
                ),
                Divider(color: Colors.grey[300], thickness: 1.1),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
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
                  SizedBox(height: 12),
                  TextField(
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
                  SizedBox(height: 12),
                ],
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -3)),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: 1,
          onTap: (index) => _navigateToPage(index, context),
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined, size: 28),
              activeIcon: Icon(Icons.explore, size: 30, color: Colors.blueAccent),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined, size: 28),
              activeIcon: Icon(Icons.map, size: 30, color: Colors.blueAccent),
              label: 'Trips',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 28),
              activeIcon: Icon(Icons.person, size: 30, color: Colors.blueAccent),
              label: 'Profil',
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
                      "IDR $price",
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
