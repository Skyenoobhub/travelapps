// ignore_for_file: use_super_parameters, avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:travelapp/ui/trips/detail_trip_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> history = [];
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2/backend/history.php'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['data'] != null && data['data'] is List) {
          setState(() {
            history = List<Map<String, dynamic>>.from(data['data']);
            isLoading = false;
          });
        } else {
          setState(() {
            history = [];
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching history: $e");
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Transaksi'),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : isError
              ? Center(child: Text("Gagal memuat data."))
              : history.isEmpty
                  ? Center(child: Text("Belum ada riwayat transaksi."))
                  : ListView.builder(
                      padding: EdgeInsets.all(12),
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final trip = history[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildTripListItem(trip, context),
                        );
                      },
                    ),
    );
  }

  Widget _buildTripListItem(Map<String, dynamic> trip, BuildContext context) {
    final imageUrl = 'http://10.0.2.2/backend/uploads/${trip['foto'] ?? ''}';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                DetailTripPage(packageId: (trip['trip_id'] ?? trip['id']).toString()),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
              child: Image.network(
                imageUrl,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[300],
                  child: Icon(Icons.image_not_supported, size: 30),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip['nama_paket'] ?? '',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6),
                    Text(
                      "IDR ${trip['harga'] ?? '0'}",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
