import 'package:flutter/material.dart';
import 'package:travelapp/home.dart';
import 'package:travelapp/ui/trips/trips.dart';
import 'biodata.dart';
import 'favorite_page.dart'; // Import FavoritePage
import 'history_page.dart'; // Import HistoryPage
import 'faq_page.dart'; // Import FAQPage

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
              _showLogoutDialog(context); // Show the logout dialog
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
              _buildListTile('Histori', Icons.history, context), // Now navigates to HistoryPage
              _buildListTile('Favorit', Icons.favorite, context), // List item for Favorit
              _buildNotificationTile(),

              const SizedBox(height: 20),

              _buildSectionTitle('Bantuan', Icons.help_outline),
              _buildListTile('Pertanyaan Umum', Icons.question_answer, context), // List item for FAQ
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Keluar',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Apakah Anda yakin ingin keluar?',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();  // Close the dialog without logging out
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Text(
                          'Tidak',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();  // Close the dialog and perform logout
                        // Add logout functionality here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Text(
                          'Keluar',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
        // Navigasi ke halaman Histori jika memilih opsi Histori
        else if (title == 'Histori') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HistoryPage()), // Navigate to HistoryPage
          );
        } 
        // Navigasi ke halaman Favorit jika memilih opsi Favorit
        else if (title == 'Favorit') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FavoritePage()), // Navigate to FavoritePage
          );
        }
        // Navigasi ke halaman Pertanyaan Umum jika memilih opsi Pertanyaan Umum
        else if (title == 'Pertanyaan Umum') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FAQPage()), // Navigate to FAQPage
          );
        }
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
