// ignore_for_file: avoid_print, prefer_const_constructors, use_super_parameters

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Untuk format harga

class HistoryPage extends StatefulWidget {
  final String userName;

  const HistoryPage({Key? key, required this.userName}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<dynamic> transaksi = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHistori();
  }

  Future<void> fetchHistori() async {
    final url = Uri.parse(
        'http://10.0.2.2/backend/get_transaksi.php?nama_user=${widget.userName}');

    try {
      final response = await http.get(url);
      final result = json.decode(response.body);

      if (result['success']) {
        setState(() {
          transaksi = result['data'];
          isLoading = false;
        });
      } else {
        print("Error: ${result['error']}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Exception: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  String _formatCurrency(String nominal) {
    try {
      final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
      return formatter.format(int.parse(nominal));
    } catch (e) {
      return 'Rp $nominal';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Histori Pemesanan"),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : transaksi.isEmpty
              ? Center(child: Text("Belum ada histori."))
              : ListView.builder(
                  itemCount: transaksi.length,
                  itemBuilder: (context, index) {
                    final item = transaksi[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      elevation: 2,
                      child: ListTile(
                        leading: Icon(Icons.history, color: Colors.blue),
                        title: Text(item['nama_paket'] ?? 'Paket'),
                        subtitle: Text(
                          "${_formatCurrency(item['harga'] ?? '0')}\n${item['deskripsi'] ?? ''}",
                          style: TextStyle(fontSize: 13),
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
    );
  }
}
