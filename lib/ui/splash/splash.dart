// ignore_for_file: use_build_context_synchronously

import 'package:travelapp/ui/splash/splash2.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5)).then((value) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SplashScreen2()),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D47A1), // Warna latar belakang biru
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2, // Menambahkan ruang ekstra di bagian atas
            child: Container(),
          ),
          // Logo di tengah
          Image.asset(
            'assets/images/logo.png', // Ganti dengan path gambar Anda
            width: 150, // Ukuran gambar
          ),
          const SizedBox(height: 20),
          // Teks "TripShare"
          const Text(
            'TripShare',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Expanded(
            flex: 3, // Menambahkan ruang ekstra di bagian bawah
            child: Container(),
          ),
          // Teks di bagian bawah
          const Padding(
            padding: EdgeInsets.only(bottom: 30.0),
            child: Text(
              'Yuk Jalan Dulu Aja',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
