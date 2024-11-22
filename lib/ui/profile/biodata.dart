// ignore_for_file: library_private_types_in_public_api, avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BiodataPage extends StatefulWidget {
  final String userId; // Mendapatkan userId yang diteruskan dari halaman sebelumnya

  const BiodataPage({super.key, required this.userId}); // Menerima userId melalui konstruktor

  @override
  _BiodataPageState createState() => _BiodataPageState();
}

class _BiodataPageState extends State<BiodataPage> {
  String? name;
  String? email;
  String? phone;
  String? gender;
  bool isLoading = true; // Untuk menunjukkan status loading

  @override
  void initState() {
    super.initState();
    fetchBiodata(widget.userId); // Panggil fetchBiodata dengan userId yang diteruskan
  }

  // Fungsi untuk mengambil biodata berdasarkan userId
  Future<void> fetchBiodata(String userId) async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2/backend/biodata.php?userId=$userId'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          name = data['name']; // Mengambil data nama
          email = data['email']; // Mengambil data email
          phone = data['phone']; // Mengambil data telepon
          gender = data['gender']; // Mengambil data jenis kelamin
          isLoading = false; // Mengubah status loading ke false setelah data diterima
        });
      } else {
        print('Gagal memuat biodata: ${response.statusCode} ${response.body}');
        setState(() {
          isLoading = false; // Mengubah status loading ke false jika gagal
        });
      }
    } catch (e) {
      print('Terjadi error: $e');
      setState(() {
        isLoading = false; // Mengubah status loading ke false jika ada error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Biodata',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? Center(child: CircularProgressIndicator()) // Menampilkan indikator loading
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Nama', name),
                          _buildInfoRow('Email', email),
                          _buildInfoRow('No Telepon', phone),
                          _buildInfoRow('Jenis Kelamin', gender),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // Widget untuk menampilkan informasi dalam bentuk row
  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text('$label:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Text(value ?? 'Tidak tersedia', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
