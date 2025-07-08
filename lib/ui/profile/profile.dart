// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:travelapp/home.dart';
import 'package:travelapp/ui/login/login.dart';
import 'package:travelapp/ui/trips/trips.dart';
import 'package:travelapp/ui/profile/biodata.dart';
import 'package:travelapp/ui/profile/faq_page.dart';
import 'package:travelapp/ui/profile/about_page.dart';
import 'package:travelapp/ui/profile/favorit_saya_page.dart';
import 'package:travelapp/ui/payment/history_page.dart';

class ProfilePage extends StatelessWidget {
  final String userName;

  const ProfilePage({super.key, required this.userName});

  void _navigateToPage(int index, BuildContext context) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(userName: userName)),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OpenTripPage(userName: userName)),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F7FF),
      appBar: AppBar(
        backgroundColor: Color(0xFF1565C0),
        elevation: 2,
        title: Text(
          'Profil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            _divider(),
            _buildSectionTitle('Umum', Icons.settings),
            _buildSettingItem(context, 'Biodata', Icons.account_box_rounded, BiodataPage(userId: userName)),
            _buildSettingItem(context, 'Favorit Saya', Icons.favorite, FavoritSayaPage()),
            _buildSettingItem(context, 'Riwayat Pemesanan', Icons.history, const HistoryPage()), // ✅ tanpa userName
            _divider(),
            _buildSectionTitle('Bantuan', Icons.help_outline),
            _buildSettingItem(context, 'Pertanyaan Umum', Icons.live_help_rounded, FAQPage()),
            _divider(),
            _buildSettingItem(context, 'Tentang', Icons.info_outline, AboutPage()),
            SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: Color(0xFF1565C0),
        unselectedItemColor: Colors.grey,
        onTap: (index) => _navigateToPage(index, context),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Trips'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Row(
        children: [
          CircleAvatar(
            radius: 38,
            backgroundColor: Colors.blue.shade100,
            child: Icon(Icons.person, size: 40, color: Colors.blue.shade800),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
                ),
                SizedBox(height: 4),
                Text(
                  "Selamat Datang Kembali!",
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(color: Colors.grey.shade300, thickness: 1),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade800),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, String title, IconData icon, Widget page) {
    return ListTile(
      tileColor: Colors.white,
      leading: Icon(icon, color: Colors.blue.shade700),
      title: Text(
        title,
        style: TextStyle(fontSize: 16),
      ),
      trailing: Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 18),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.logout, size: 48, color: Colors.redAccent),
              SizedBox(height: 16),
              Text(
                'Keluar',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text(
                'Apakah Anda yakin ingin keluar?',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Text('Tidak', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Text('Keluar', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
