// ignore_for_file: use_super_parameters, prefer_const_declarations, avoid_print, unused_element, prefer_final_fields, unused_import

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:travelapp/ui/payment/checkout.dart';
import 'dart:math'; // Import untuk shuffle()
import 'package:travelapp/ui/profile/profile.dart';
import 'package:travelapp/ui/trips/trips.dart';
import 'package:intl/intl.dart';
import 'package:travelapp/ui/trips/detail_trip_page.dart';  // Import DetailTripPage

class HomePage extends StatefulWidget {
  final String userName;

  const HomePage({Key? key, required this.userName}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Store the active page index
  List<Map<String, dynamic>> _tripPackages = []; // Store trip packages from API
  List<Map<String, dynamic>> _cart = [];

  // Function to fetch trip packages from API
  Future<void> _fetchTripPackages() async {
    final url = 'http://10.0.2.2/backend/detail.php'; // Update to your API URL

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _tripPackages = List<Map<String, dynamic>>.from(data['data']);
          _tripPackages.shuffle(); // Mengacak urutan trip setelah diterima
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

  void _addToCart(Map<String, dynamic> package) {
    setState(() {
      _cart.add(package);
    });
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
    // Mendapatkan tanggal hari ini
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(now);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formattedDate, // Menampilkan tanggal yang sudah diformat
              style: const TextStyle(color: Colors.black, fontSize: 18), // Increased font size
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.black),
              onPressed: () {
                // Navigate to Checkout Page and pass selected cart items
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutPage(
                      packageName: _cart.isNotEmpty ? _cart[0]['nama_paket'] : '',
                      packagePrice: _cart.isNotEmpty ? _cart[0]['harga'] : '',
                      packageDescription: '', // Assuming placeholder for now
                      packageItinerary: '', // Assuming placeholder for now
                      packageFacilities: '', // Assuming placeholder for now
                    ),
                  ),
                );
              },
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
                style: const TextStyle(fontSize: 20, color: Colors.black87), // Increased font size
              ),
              const Text(
                'Ayo Jalan-Jalan',
                style: TextStyle(
                  fontSize: 30, // Increased font size
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
              // New Open Trip Section
              const Text(
                'Open Trip Baru !',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Increased font size
              ),
              const SizedBox(height: 10),

              SizedBox(
                height: 240, // Increased card height
                child: _tripPackages.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _tripPackages.length,
                        itemBuilder: (context, index) {
                          final package = _tripPackages[index];
                          return _buildTripCard(
                            package['id'], // Pass the package ID
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Increased font size
                  ),
                  Text(
                    'Lihat Semua',
                    style: TextStyle(color: Colors.blue, fontSize: 16), // Increased font size
                  ),
                ],
              ),
              const SizedBox(height: 10),

              SizedBox(
                height: 240, // Increased card height
                child: _tripPackages.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _tripPackages.length,
                        itemBuilder: (context, index) {
                          final package = _tripPackages[index];
                          return _buildTripCard(
                            package['id'], // Pass the package ID
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
                  fontSize: 20, // Increased font size
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // Widget for trip card
  Widget _buildTripCard(String packageId, String title, String price, String imagePath) {
    return GestureDetector(
      onTap: () {
        // Navigate to DetailTripPage with the package ID
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailTripPage(packageId: packageId), // Pass package ID
          ),
        );
      },
      child: Container(
        width: 200, // Increased card width
        margin: const EdgeInsets.only(right: 15), // Increased margin
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
              height: 120, // Increased image height
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
              padding: const EdgeInsets.all(12), // Increased padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)), // Increased font size
                  const SizedBox(height: 5),
                  Text(price,
                      style: const TextStyle(fontSize: 16, color: Colors.blue)), // Increased font size
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
