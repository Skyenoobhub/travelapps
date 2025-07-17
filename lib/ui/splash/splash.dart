// ignore_for_file: use_build_context_synchronously

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

    // Jalankan navigasi setelah frame pertama selesai di-render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 5), () {
        Navigator.pushReplacementNamed(context, '/main_guest');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, // Full width
        height: double.infinity, // Full height
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1976D2), Color(0xFF0D47A1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Spacer(flex: 2),

              // Gambar logo di tengah
              Image.asset(
                'assets/images/logo.png',
                width: 150,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),

              // Teks "TripShare"
              const Text(
                'TripShare',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),

              const Spacer(flex: 3),

              // Teks bawah
              const Padding(
                padding: EdgeInsets.only(bottom: 30.0),
                child: Text(
                  'Membuat Perjalanan Lebih Mempesona',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
