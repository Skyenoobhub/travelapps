// ignore_for_file: use_super_parameters, prefer_const_declarations, avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:travelapp/ui/profile/profile.dart';
import 'package:travelapp/ui/trips/trips.dart';

class HomePage extends StatefulWidget {
  final String userName;

  const HomePage({Key? key, required this.userName}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Store the active page index
  List<Map<String, dynamic>> _tripPackages = []; // Store trip packages from API

  // Function to fetch trip packages from API
  Future<void> _fetchTripPackages() async {
    final url = 'http://10.0.2.2/backend/detail.php'; // Update to your API URL

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _tripPackages = List<Map<String, dynamic>>.from(data['data']);
        });
      } else {
        print('Failed to load trip packages');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTripPackages(); // Fetch trip packages when the page loads
  }

  // Function to navigate to the page based on the index
  void _navigateToPage(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              OpenTripPage(userName: widget.userName), // Pass username
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ProfilePage(userName: widget.userName), // Pass username
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Senin, 22 Oktober 2024',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            Row(
              children: [
                IconButton(
                  icon:
                      const Icon(Icons.notifications_none, color: Colors.blue),
                  onPressed: () {
                    // Notification action
                  },
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  radius: 16,
                  child: const Icon(Icons.person, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF5F5F5), // Light gray background
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Text(
                'Halo, ${widget.userName}!', // Personalized greeting
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const Text(
                'Ayo Jalan-Jalan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {
                  // Action for ordering custom trip
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Mau Coba Costum Trip? Pesan di sini",
                      style: TextStyle(color: Colors.black),
                    ),
                    Icon(Icons.arrow_forward, color: Colors.black),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Order Information Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.userName, // Display the logged-in user's name
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.shopping_cart_outlined,
                        color: Colors.white),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoBox("Pesanan Aktif", "0"),
                  _buildInfoBox("Total Transaksi", "0"),
                ],
              ),
              const SizedBox(height: 20),

              // New Open Trip Section
              const Text(
                'Open Trip Baru !',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              SizedBox(
                height: 200,
                child: _tripPackages.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _tripPackages.length,
                        itemBuilder: (context, index) {
                          final package = _tripPackages[index];
                          return _buildTripCard(
                            package['nama_paket'],
                            'IDR ${package['harga']}',
                            'http://10.0.2.2/backend/uploads/${package['foto']}', // Update image URL
                          );
                        },
                      )
                    : const Center(
                        child: Text('Loading packages...'),
                      ),
              ),
              const SizedBox(height: 20),

              // Recommendations Section
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rekomendasi',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Lihat Semua',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              SizedBox(
                height: 200,
                child: _tripPackages.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _tripPackages.length,
                        itemBuilder: (context, index) {
                          final package = _tripPackages[index];
                          return _buildTripCard(
                            package['nama_paket'],
                            'IDR ${package['harga']}',
                            'http://10.0.2.2/backend/uploads/${package['foto']}', // Update image URL
                          );
                        },
                      )
                    : const Center(
                        child: Text('Loading recommendations...'),
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _navigateToPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  // Widget for order and transaction information
  Widget _buildInfoBox(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 5),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // Widget for trip card
  Widget _buildTripCard(String title, String price, String imagePath) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              image: DecorationImage(
                image: NetworkImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(price,
                    style: const TextStyle(fontSize: 14, color: Colors.blue)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}