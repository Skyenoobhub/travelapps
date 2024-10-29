// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailTripPage extends StatelessWidget {
  DetailTripPage({super.key, required this.packageId});

  final String packageId; // Parameter to fetch specific data

  Future<Map<String, dynamic>> fetchPackageDetails() async {
    final response = await http.get(
        Uri.parse('http://10.0.2.2/backend/detail_paket.php?id=$packageId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      if (data == null) {
        throw Exception('No data found for the provided package ID');
      }
      return data; // Get the data from the response
    } else {
      throw Exception('Failed to load package details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Detail Trip', style: TextStyle(color: Colors.blue)),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchPackageDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data available'));
          }

          final package = snapshot.data!;

          // Safely accessing fields with default values
          String packageName = package['nama_paket'] ?? 'No Name Available';
          String packageDescription =
              package['deskripsi'] ?? 'No Description Available';
          String packageItinerary =
              package['rincian'] ?? 'No Itinerary Available';
          String packageFacilities =
              package['fasilitas'] ?? 'No Facilities Available';
          String packageImage = package['foto'] != null
              ? 'http://10.0.2.2/backend/uploads/${package['foto']}'
              : 'https://via.placeholder.com/250'; // Default placeholder
          String packagePrice =
              package['harga'] ?? '0'; // Default price if null

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              packageImage, // Use the URL or a placeholder
                              width: double.infinity,
                              height: 250,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.share, color: Colors.white),
                                  onPressed: () {
                                    // Implement share functionality
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.favorite_border,
                                      color: Colors.white),
                                  onPressed: () {
                                    // Implement favorite functionality
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        packageName, // Display the package name
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Implement booking functionality
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Mau Coba Costum Trip? Pesan di sini',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const Divider(height: 30),
                      DefaultTabController(
                        length: 3,
                        child: Column(
                          children: [
                            const TabBar(
                              labelColor: Colors.blue,
                              unselectedLabelColor: Colors.black,
                              indicatorColor: Colors.blue,
                              tabs: [
                                Tab(text: 'Deskripsi'),
                                Tab(text: 'Rincian'),
                                Tab(text: 'Fasilitas'),
                              ],
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 300,
                              child: TabBarView(
                                children: [
                                  _buildDescriptionTab(packageDescription),
                                  _buildItineraryTab(packageItinerary),
                                  _buildFacilitiesTab(packageFacilities),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildBottomBar(context, packagePrice),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, String harga) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Mulai Dari',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              Text(
                'IDR $harga /Pax',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              // Implement booking button functionality
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
            ),
            child: const Text(
              'Pesan',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionTab(String deskripsi) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        deskripsi,
        textAlign: TextAlign.justify,
        style: const TextStyle(height: 1.5),
      ),
    );
  }

  Widget _buildItineraryTab(String rincian) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        rincian,
        textAlign: TextAlign.justify,
        style: const TextStyle(height: 1.5),
      ),
    );
  }

  Widget _buildFacilitiesTab(String fasilitas) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        fasilitas,
        textAlign: TextAlign.justify,
        style: const TextStyle(height: 1.5),
      ),
    );
  }
}