// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Kami'),
        backgroundColor: Color(0xFF1565C0),
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(Icons.info_outline, size: 60, color: Colors.blue.shade700),
            const SizedBox(height: 16),
            const Text(
              'Tentang Kami',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1565C0),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'PT Denar Pesona adalah biro perjalanan wisata yang menghadirkan pengalaman liburan hemat dan menyenangkan melalui layanan open trip. Kami menghubungkan para pelancong dari berbagai latar belakang untuk menikmati perjalanan bersama, tanpa repot mengatur semuanya sendiri.\n\n'
              'Kami hadir di aplikasi ini untuk memudahkan Anda berwisata. cukup klik, pesan, dan berangkat!',
              style: TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
