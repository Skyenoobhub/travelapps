import 'package:travelapp/ui/login/daftar.dart';
import 'package:travelapp/ui/login/login.dart';
import 'package:flutter/material.dart';

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({super.key});

  @override
  State<SplashScreen2> createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D47A1), // Latar belakang biru
      body: Center(
        // Memastikan seluruh elemen berada di tengah layar
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Elemen vertikal berada di tengah
          children: <Widget>[
            // Gambar logo di tengah
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
            const SizedBox(height: 40), // Jarak antara teks dan tombol

            // Tombol "Masuk"
            ElevatedButton(
              onPressed: () {
                // Aksi ketika tombol "Masuk" ditekan
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text(
                'Masuk',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20), // Jarak antara tombol Masuk dan Daftar

            // Tombol "Daftar"
            ElevatedButton(
              onPressed: () {
                // Aksi ketika tombol "Daftar" ditekan
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterPage()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text(
                'Daftar',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 40), // Ruang antara tombol dan teks bawah

            // Teks di bagian bawah "Yuk Jalan Dulu Aja"
            const Text(
              'Yuk Jalan Dulu Aja',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
