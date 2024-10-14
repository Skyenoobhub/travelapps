import 'package:flutter/material.dart';
import 'package:travelapp/home.dart';
import 'package:travelapp/ui/trips/trips.dart';
import 'biodata.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _navigateToPage(int index, BuildContext context) {
    if (index == 0) {
      // Navigasi ke halaman Explore
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else if (index == 1) {
      // Navigasi ke halaman Trips
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OpenTripPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1), // Warna latar belakang AppBar
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout), // Ikon logout
            onPressed: () {
              // Aksi logout
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pengaturan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),

              _buildSectionTitle('Umum', Icons.settings),
              _buildListTile('Biodata', Icons.person, context),
              _buildListTile('Histori', Icons.history, context),
              _buildListTile('Favorit', Icons.favorite, context),
              _buildNotificationTile(),

              const SizedBox(height: 20),

              _buildSectionTitle('Bantuan', Icons.help_outline),
              _buildListTile('Pertanyaan Umum', Icons.question_answer, context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Ini menandai halaman "Profil"
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

  // Widget untuk menampilkan judul setiap kategori
  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan ListTile untuk setiap item pengaturan
  Widget _buildListTile(String title, IconData icon, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Menavigasi ke halaman Biodata jika memilih opsi Biodata
        if (title == 'Biodata') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BiodataPage()),
          );
        }
        // Tambahkan navigasi lain jika perlu
      },
    );
  }

  // Widget untuk tile pemberitahuan dengan Switch
  Widget _buildNotificationTile() {
    return ListTile(
      leading: const Icon(Icons.notifications, color: Colors.black87),
      title: const Text('Pemberitahuan'),
      trailing: Switch(
        value: true, // Atur nilai switch
        onChanged: (value) {
          // Aksi ketika switch diubah
        },
      ),
    );
  }
}
