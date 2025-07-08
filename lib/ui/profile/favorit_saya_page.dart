// ignore_for_file: use_super_parameters, avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:travelapp/ui/trips/detail_trip_page.dart';

class FavoritSayaPage extends StatefulWidget {
  const FavoritSayaPage({Key? key}) : super(key: key);

  @override
  State<FavoritSayaPage> createState() => _FavoritSayaPageState();
}

class _FavoritSayaPageState extends State<FavoritSayaPage> {
  List<Map<String, dynamic>> favoritTrips = [];
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    fetchFavoritTrips();
  }

  Future<void> fetchFavoritTrips() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2/backend/favorit.php'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['data'] != null && data['data'] is List) {
          setState(() {
            favoritTrips = List<Map<String, dynamic>>.from(data['data']);
            isLoading = false;
          });
        } else {
          setState(() {
            favoritTrips = [];
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
      print("Error fetching favorit trips: $e");
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  Future<void> _hapusFavorit(String tripId) async {
    final url = Uri.parse('http://10.0.2.2/backend/delete_favorit.php');

    try {
      final response = await http.post(url, body: {'trip_id': tripId});
      final result = json.decode(response.body);

      if (result['success']) {
        setState(() {
          favoritTrips.removeWhere((trip) =>
              (trip['trip_id'] ?? trip['id']).toString() == tripId);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Berhasil dihapus dari favorit')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal hapus: ${result['error']}')),
        );
      }
    } catch (e) {
      print("Error hapus favorit: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorit Saya'),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : isError
              ? Center(child: Text("Gagal memuat data."))
              : favoritTrips.isEmpty
                  ? Center(child: Text("Belum ada trip favorit."))
                  : GridView.builder(
                      padding: EdgeInsets.all(12),
                      itemCount: favoritTrips.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.72,
                      ),
                      itemBuilder: (context, index) {
                        final trip = favoritTrips[index];
                        return _buildTripCard(trip, context);
                      },
                    ),
    );
  }

  Widget _buildTripCard(Map<String, dynamic> trip, BuildContext context) {
    final imageUrl = 'http://10.0.2.2/backend/uploads/${trip['foto'] ?? ''}';
    final tripId = (trip['trip_id'] ?? trip['id']).toString();

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailTripPage(packageId: tripId),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: Icon(Icons.image_not_supported, size: 30),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip['nama_paket'] ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6),
                        Divider(height: 10),
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
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 6,
          right: 6,
          child: CircleAvatar(
            radius: 16,
            backgroundColor: Colors.redAccent,
            child: IconButton(
              icon: Icon(Icons.delete, size: 16, color: Colors.white),
              onPressed: () => _hapusFavorit(tripId),
            ),
          ),
        ),
      ],
    );
  }
}
