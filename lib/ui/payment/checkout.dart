// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:travelapp/ui/payment/history_page.dart';

class CheckoutPage extends StatefulWidget {
  final String packageName;
  final String packagePrice;
  final String packageDescription;
  final String packageItinerary;
  final String packageFacilities;
  final String userName;

  const CheckoutPage({
    super.key,
    required this.packageName,
    required this.packagePrice,
    required this.packageDescription,
    required this.packageItinerary,
    required this.packageFacilities,
    required this.userName,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late final WebViewController _controller;
  String? snapToken;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) async {
            print('🌐 Navigasi WebView: $url');

            if (url.contains("finish") || url.contains("transaction_status=succeed")) {
              print("✅ Transaksi sukses terdeteksi");
              await simpanDetailTransaksi();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistoryPage(),
                ),
              );
            } else if (url.contains("error") || url.contains("transaction_status=deny")) {
              print("❌ Transaksi gagal terdeteksi");
              Navigator.pop(context);
            }
          },
        ),
      );
    getSnapToken();
  }

  Future<void> getSnapToken() async {
    final url = Uri.parse('http://10.0.2.2/backend/midtrans_token.php');

    final response = await http.post(url, body: {
      'nama_paket': widget.packageName,
      'harga': widget.packagePrice,
      'deskripsi': widget.packageDescription,
      'rincian': widget.packageItinerary,
      'fasilitas': widget.packageFacilities,
      'nama_user': widget.userName,
    });

    final result = json.decode(response.body);
    print('📥 RESPONSE TOKEN: $result');

    if (response.statusCode == 200 && result['token'] != null) {
      setState(() {
        snapToken = result['token'];
        isLoading = false;
      });

      final snapUrl =
          'https://app.sandbox.midtrans.com/snap/v2/vtweb/${result['token']}';
      _controller.loadRequest(Uri.parse(snapUrl));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mendapatkan token: ${result['error']}')),
      );
    }
  }

  Future<void> simpanDetailTransaksi() async {
    final url = Uri.parse('http://10.0.2.2/backend/simpan_transaksi.php');

    final body = {
      'nama_paket': widget.packageName,
      'harga': widget.packagePrice,
      'deskripsi': widget.packageDescription,
      'rincian': widget.packageItinerary,
      'fasilitas': widget.packageFacilities,
      'nama_user': widget.userName,
    };

    print("📤 Mengirim data ke database: $body");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      print("📦 Response: ${response.statusCode} - ${response.body}");

      final result = json.decode(response.body);
      if (result['success'] == true) {
        print('✅ Detail transaksi berhasil disimpan');
      } else {
        print('❌ Gagal simpan: ${result['error']}');
      }
    } catch (e) {
      print('❌ Exception simpan transaksi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pembayaran"),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          : WebViewWidget(controller: _controller),
    );
  }
}
