// ignore_for_file: library_private_types_in_public_api, avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';

class BiodataPage extends StatefulWidget {
  final String userId; // Mendapatkan userId yang diteruskan dari halaman sebelumnya

  const BiodataPage({super.key, required this.userId}); // Menerima userId melalui konstruktor

  @override
  _BiodataPageState createState() => _BiodataPageState();
}

class _BiodataPageState extends State<BiodataPage> {
  // Data statis yang ditampilkan pada halaman
  final String name = 'putra';
  final String email = 'putra@gmail.com';
  final String phone = '0829754274197';
  final String gender = 'Laki-laki';
  bool isLoading = false; // Status loading diatur menjadi false untuk menampilkan data langsung

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
            ? Center(child: CircularProgressIndicator()) // Menampilkan indikator loading jika diperlukan
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
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text('$label:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
