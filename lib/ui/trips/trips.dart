import 'package:flutter/material.dart';
import 'package:travelapp/home.dart';
import 'package:travelapp/ui/profile/profile.dart';
import 'package:travelapp/ui/trips/detail_trip_page.dart'; // Import halaman detail

class OpenTripPage extends StatelessWidget {
  const OpenTripPage({super.key});

  void _navigateToPage(int index, BuildContext context) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final trips = [
      {"name": "Fun Trekking Ciwangun", "price": "IDR 350.000", "image": "assets/images/ciwangun.jpg"},
      {"name": "Tangkuban Perahu", "price": "IDR 275.000", "image": "assets/images/tangkuban_perahu.jpg"},
      {"name": "Sunrise Ranca Upas", "price": "IDR 325.000", "image": "assets/images/sunrise_ranca_upas.jpg"},
      {"name": "Kota Lama Bandung", "price": "IDR 350.000", "image": "assets/images/kota_lama_bandung.jpg"},
      {"name": "Pangalengan Adventure", "price": "IDR 350.000", "image": "assets/images/pangalengan.jpg"},
      {"name": "Sunrise Gunung Putri", "price": "IDR 475.000", "image": "assets/images/gunung_putri.jpg"},
      {"name": "Stone Garden", "price": "IDR 250.000", "image": "assets/images/stone_garden.jpg"},
      {"name": "Kawah Ratu", "price": "IDR 400.000", "image": "assets/images/kawah_ratu.jpg"},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Open Trip Bandung',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none, color: Colors.blue),
                  onPressed: () {},
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
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Open Trip Bandung',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'OPEN TRIP SEHARIAN SEKALI BAYAR TANPA TAMBAHAN APAPUN!!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 5),
            const Center(
              child: Text(
                'Liburan Ga Pake Ribet Cukup Sekali Bayar Tinggal Duduk Manis Tanpa Pusing Atur Perjalanan, Karena Kita Yang Handle !!',
                style: TextStyle(fontSize: 14, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari Open Trips...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: trips.length,
                itemBuilder: (context, index) {
                  final trip = trips[index];
                  return _buildTripCard(
                    trip["name"]!,
                    trip["price"]!,
                    trip["image"]!,
                    context,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) => _navigateToPage(index, context),
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

  Widget _buildTripCard(String name, String price, String imagePath, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (name == "Fun Trekking Ciwangun") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DetailTripPage()),
          );
        }
      },
      child: Container(
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
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.asset(
                imagePath,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(price, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
