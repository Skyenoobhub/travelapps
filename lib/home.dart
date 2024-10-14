import 'package:flutter/material.dart';
import 'package:travelapp/ui/profile/profile.dart';
import 'package:travelapp/ui/trips/trips.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Menyimpan indeks halaman aktif

  // Fungsi untuk navigasi ke halaman berdasarkan index
  void _navigateToPage(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OpenTripPage()),
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
                  icon: const Icon(Icons.notifications_none, color: Colors.blue),
                  onPressed: () {
                    // Aksi notifikasi
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
      backgroundColor: const Color(0xFFF5F5F5), // Latar belakang abu-abu muda
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian Header
              const Text(
                'Halo!',
                style: TextStyle(fontSize: 16, color: Colors.black87),
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
                  // Aksi tombol pemesanan kostum trip
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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

              // Bagian Informasi Pesanan
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(20),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edward Pieters',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.shopping_cart_outlined, color: Colors.white),
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

              // Bagian Open Trip Baru
              const Text(
                'Open Trip Baru !',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              
              SizedBox(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildTripCard("Sunrise Ranca Upas", "IDR 325.000", "assets/images/sunrise_ranca_upas.jpg"),
                    _buildTripCard("Tangkuban Perahu", "IDR 275.000", "assets/images/tangkuban_perahu.jpg"),
                    _buildTripCard("Stone Garden", "IDR 225.000", "assets/images/stone_garden.jpg"),
                    _buildTripCard("Gunung Putri", "IDR 475.000", "assets/images/gunung_putri.jpg"),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Bagian Rekomendasi
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
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildTripCard("Trekking Kawah Ratu", "IDR 350.000", "assets/images/kawah_ratu.jpg"),
                    _buildTripCard("Pangalengan", "IDR 350.000", "assets/images/pangalengan.jpg"),
                    _buildTripCard("Kota Lama Bandung", "IDR 350.000", "assets/images/kota_lama_bandung.jpg"),
                    _buildTripCard("Trekking Ciwangun", "IDR 350.000", "assets/images/ciwangun.jpg"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _navigateToPage, // Menandai halaman Explore aktif
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

  // Widget untuk informasi pesanan dan transaksi
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
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // Widget untuk kartu perjalanan (trip card) tanpa subtitle
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
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(price, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
