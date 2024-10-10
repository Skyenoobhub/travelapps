// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class DetailTripPage extends StatelessWidget {
  const DetailTripPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Detail Trip', style: TextStyle(color: Colors.blue)),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          'assets/images/ciwangun.jpg',
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.share, color: Colors.white),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(Icons.favorite_border, color: Colors.white),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Fun Trekking Ciwangun Indah Camp',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Implementasi tombol pemesanan
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Mau Coba Costum Trip? Pesan di sini',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const Divider(height: 30),
                  DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        const TabBar(
                          labelColor: Colors.blue,
                          unselectedLabelColor: Colors.black,
                          indicatorColor: Colors.blue,
                          tabs: [
                            Tab(text: 'Deskripsi'),
                            Tab(text: 'Rincian'),
                            Tab(text: 'Fasilitas'),
                          ],
                        ),
                        SizedBox(
                          height: 300,
                          child: TabBarView(
                            children: [
                              _buildDescriptionTab(),
                              _buildItineraryTab(),
                              _buildFacilitiesTab(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Mulai Dari',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              Text(
                'IDR 375.000 /Pax',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              // Implementasi tombol Pesan
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
            ),
            child: const Text(
              'Pesan',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10.2),
      child: const Text(
        'Trekking santai di Bandung! Mau liburan ke alam tapi bosan sama yang itu-itu aja? Tempat ini masih jarang diketahui dan alami. '
        '\n\nKita akan menyusuri sungai, menyebrang dengan jembatan kayu atau bambu, dan naik turun jalan berbatu. Pastikan kamu memakai sepatu yang nyaman ya. Jalan menuju curug berada di lembah dengan tebing di kiri dan kanan. Suasananya sejuk dan alami banget. Hati-hati karena jalannya licin dan berlumut.'
        '\n\nKita akan menginjungi 2 air terjun, Curug Putri, dan Curug Tilu. Sepanjang perjalanan mata akan dimanjakan dengan kebun teh, hutan pinus dan udara segar. Tak hanya itu, kita juga akan mengunjungi Goa Tokek, objek wisata goa yang dulunya memiliki banyak tokek namun saat ini langka karena diburu untuk obat.'
        '\n\nDi Curug Tilu, kalian bisa berendam di aliran sungai. Siapkan pakaian ganti, alas kaki sepatu dan sandal gunung yang nyaman, trekking pole (bila perlu), jaket dan jas hujan. Jangan lupa bawa minum dan snack untuk menjaga stamina selama trekking.',
        textAlign: TextAlign.justify,
        style: TextStyle(height: 1.5),
      ),
    );
  }

  Widget _buildItineraryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '• 06:30 Berangkat dari Meeting Point\n\n'
            '  - Exit Tol Pasteur (Long Day Trip)\n'
            '  - Exit Tol Buah Batu (Long Trip)\n'
            '  - Exit Tol Soraja (Long Trip)\n\n'
            '• 09:30 Ciwangun Indah Camp\n\n'
            'Perkiraan Tiba di Base Camp CIC dan Persiapan untuk Melakukan Trekking\n\n'
            '• 10:00 Start Trekking\n\n'
            'Start Trekking dengan Rute melewati beberapa tempat :\n'
            '      - Curug Putri\n'
            '      - Curug Golosor\n'
            '      - Curug Tilu\n'
            '      - Hutan Pinus\n'
            '      - Goa Tokek\n'
            '      - Perkebunan Teh\n\n'
            '• 15:00 Perjalanan menuju pusat oleh-oleh\n\n'
            'Di tempat oleh-oleh ini banyak menjual makanan ringan yang sangat cocok dijadikan untuk oleh-oleh bagi orang terdekat\n\n'
            '• 16:00 Perjalanan kembali ke Meeting Point\n\n'
            'Perjalanan kembali ke meeting point, perkiraan tiba di meeting point terakhir jam 21:00 dan trip selesai.',
            textAlign: TextAlign.justify,
            style: TextStyle(height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilitiesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: const Text(
        'Paket Tour Termasuk:\n\n'
        '- Transportasi dengan Bus/Hiace White Horse\n'
        '- Driver, BBM, Tol & Parkir\n'
        '- Tiket masuk Ciwangun Indah Camp\n'
        '- Kunjungan Curug Putri\n'
        '- Kunjungan Curug Tilu\n'
        '- Kunjungan Hutan Pinus\n'
        '- Kunjungan Goa Tokek\n'
        '- Kunjungan Perkebunan Teh\n'
        '- Guide Lokal selama Trekking\n'
        '- Tour Leader\n\n'
        'Paket Tour Tidak Termasuk :\n\n'
        '- Penambahan Destinasi diluar Program\n'
        '- Pengeluaran Keperluan Pribadi Selama Perjalanan\n'
        '- Tipping Tour Leader dan Driver\n',
        textAlign: TextAlign.justify,
        style: TextStyle(height: 1.5),
      ),
    );
  }
}
