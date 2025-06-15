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
              'PT. Jalan Dulu Asia berdiri pada tahun 2018. Perusahaan kami menyediakan kebutuhan yang berhubungan dengan jasa pariwisata yaitu wisata Kota Bandung.\n\n'
              'Kami memberikan layanan berkualitas dengan didukung oleh tenaga muda handal serta profesional yang menjadikan perjalanan anda lebih menyenangkan dan mendapatkan pengalaman berlibur yang berkesan.',
              style: TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
