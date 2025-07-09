// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:travelapp/ui/payment/checkout.dart';
import 'package:travelapp/ui/payment/history_page.dart';

class DetailTripPage extends StatefulWidget {
  final String packageId;
  const DetailTripPage({super.key, required this.packageId});

  @override
  State<DetailTripPage> createState() => _DetailTripPageState();
}

class _DetailTripPageState extends State<DetailTripPage> {
  int _selectedIndex = 0;
  bool isFavorited = false;

  Future<Map<String, dynamic>> fetchPackageDetails() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2/backend/detail_paket.php?id=${widget.packageId}'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      if (data == null) throw Exception('Data kosong');
      return data;
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  Future<void> toggleFavorite() async {
    final url = Uri.parse('http://10.0.2.2/backend/add_favorit.php');
    final response = await http.post(
      url,
      body: {'trip_id': widget.packageId},
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['success']) {
        setState(() => isFavorited = !isFavorited);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isFavorited ? 'Ditambahkan ke favorit' : 'Dihapus dari favorit')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal memperbarui favorit')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Koneksi gagal')));
    }
  }

  Future<void> addToHistory() async {
    final url = Uri.parse('http://10.0.2.2/backend/add_history.php');
    final response = await http.post(
      url,
      body: {'trip_id': widget.packageId},
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ditambahkan ke riwayat transaksi')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan riwayat')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Koneksi gagal')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF),
      appBar: AppBar(
        title: const Text(
          "Detail Trip",
          style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.blueAccent),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchPackageDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Data tidak ditemukan"));
          }

          final data = snapshot.data!;
          final imageUrl = data['foto'] != null
              ? 'http://10.0.2.2/backend/uploads/${data['foto']}'
              : 'http://via.placeholder.com/250';

          final List<String> sections = [
            data['deskripsi'] ?? 'Tidak ada deskripsi',
            data['rincian'] ?? 'Tidak ada rincian',
            data['fasilitas'] ?? 'Tidak ada fasilitas',
          ];

          return Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              imageUrl,
                              height: 240,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: CircleAvatar(
                              backgroundColor: Colors.white.withOpacity(0.9),
                              child: IconButton(
                                onPressed: toggleFavorite,
                                icon: Icon(
                                  isFavorited ? Icons.favorite : Icons.favorite_border,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              data['nama_paket'] ?? '',
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: IconButton(
                              icon: Icon(Icons.info_outline, color: Colors.blueAccent),
                              onPressed: () async {
                                await addToHistory();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HistoryPage(), 
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.blueAccent, thickness: 2),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(3, (index) {
                          final titles = ["Deskripsi", "Rincian", "Fasilitas"];
                          final icons = [Icons.description, Icons.list_alt, Icons.check_circle_outline];
                          final isSelected = _selectedIndex == index;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  setState(() => _selectedIndex = index);
                                },
                                icon: Icon(icons[index], size: 18),
                                label: Text(titles[index], style: TextStyle(fontSize: 13)),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: isSelected ? Colors.white : Colors.blueAccent,
                                  backgroundColor: isSelected ? Colors.blueAccent : Colors.white,
                                  elevation: isSelected ? 4 : 1,
                                  side: BorderSide(color: Colors.blueAccent),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 20),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: SizeTransition(
                            sizeFactor: animation,
                            axis: Axis.vertical,
                            child: child,
                          ),
                        ),
                        child: Container(
                          key: ValueKey<int>(_selectedIndex),
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            sections[_selectedIndex],
                            style: const TextStyle(fontSize: 15, height: 1.6),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              /// Bottom Button
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -3))],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Mulai dari", style: TextStyle(fontSize: 14, color: Colors.black54)),
                            Text(
                              "IDR ${data['harga']} /Pax",
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        height: 36,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutPage(
                                  packageName: data['nama_paket'] ?? '',
                                  packagePrice: data['harga'] ?? '0',
                                  packageDescription: data['deskripsi'] ?? '',
                                  packageItinerary: data['rincian'] ?? '',
                                  packageFacilities: data['fasilitas'] ?? '',
                                  userName: '',
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.shopping_cart, color: Colors.white, size: 16),
                          label: const Text("Pesan Sekarang", style: TextStyle(fontSize: 13, color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            elevation: 3,
                            minimumSize: Size(120, 36),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
