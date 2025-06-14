// ignore_for_file: use_super_parameters, prefer_const_constructors, prefer_const_declarations, avoid_print, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:travelapp/ui/profile/profile.dart';
import 'package:travelapp/ui/trips/detail_trip_page.dart';
import 'package:travelapp/ui/trips/trips.dart';

class HomePage extends StatelessWidget {
  final String userName;

  const HomePage({Key? key, required this.userName}) : super(key: key);

  void _navigateToPage(int index, BuildContext context) {
    switch (index) {
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OpenTripPage(userName: userName),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(userName: userName),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String today =
        DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.public, color: Colors.blue),
                SizedBox(width: 8),
                Text(today, style: TextStyle(color: Colors.black)),
              ],
            ),
            Icon(Icons.shopping_cart, color: Colors.blue),
          ],
        ),
      ),
      body: ExploreContent(userName: userName),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (i) => _navigateToPage(i, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore, color: Colors.blue),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map, color: Colors.blue),
            label: 'Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.blue),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class ExploreContent extends StatefulWidget {
  final String userName;
  const ExploreContent({Key? key, required this.userName}) : super(key: key);

  @override
  State<ExploreContent> createState() => _ExploreContentState();
}

class _ExploreContentState extends State<ExploreContent> {
  List<Map<String, dynamic>> _tripPackages = [];
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  // Untuk berita - tetap sama isinya
  final List<Map<String, String>> _newsList = [
    {
      "title": "Keindahan Alam Bandung",
      "desc": "Menjelajahi pesona alam yang memukau di Bandung.",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/9/98/Lake_Tangkuban_Perahu_Bandung_2018.jpg",
      "url": "https://id.wikipedia.org/wiki/Bandung",
    },
    {
      "title": "Kuliner Khas Bandung",
      "desc": "Nikmati makanan tradisional dan modern di kota Bandung.",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/8/8f/Bandung-Kuliner.jpg",
      "url": "https://id.wikipedia.org/wiki/Kuliner_Bandung",
    },
    {
      "title": "Wisata Sejarah Bandung",
      "desc": "Kunjungi tempat bersejarah dan museum menarik di Bandung.",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/e/e6/Museum_Gedung_Sate_Bandung_Indonesia.jpg",
      "url": "https://id.wikipedia.org/wiki/Gedung_Sate",
    },
    {
      "title": "Pusat Belanja di Bandung",
      "desc": "Temukan fashion dan produk lokal terbaik di Bandung.",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/4/44/Bandung_Pasar_Baru_panjang_jalan.jpg",
      "url": "https://id.wikipedia.org/wiki/Pasar_Baru_Bandung",
    },
    {
      "title": "Event dan Festival Bandung",
      "desc": "Ikuti berbagai acara dan festival budaya di Bandung.",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/5/5e/Bandung_festival_2013.jpg",
      "url": "https://id.wikipedia.org/wiki/Bandung_Festival",
    },
  ];

  late ScrollController _newsScrollController;
  Timer? _newsTimer;
  int _newsCurrentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
    _newsScrollController = ScrollController();
    _fetchTripPackages();
    _startAutoScroll();
    _startAutoScrollNews();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_pageController.hasClients && _tripPackages.isNotEmpty) {
        _currentPage++;
        if (_currentPage >= _tripPackages.length) _currentPage = 0;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _startAutoScrollNews() {
    _newsTimer = Timer.periodic(Duration(seconds: 4), (_) {
      if (_newsScrollController.hasClients) {
        _newsCurrentIndex++;
        if (_newsCurrentIndex >= _newsList.length) _newsCurrentIndex = 0;
        final offset = _newsCurrentIndex * 292.0; // width + margin kira2 280 + 12
        _newsScrollController.animateTo(offset,
            duration: Duration(milliseconds: 600), curve: Curves.easeInOut);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _newsTimer?.cancel();
    _pageController.dispose();
    _newsScrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchTripPackages() async {
    final url = 'http://10.0.2.2/backend/detail.php';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _tripPackages = List<Map<String, dynamic>>.from(data['data']);
          _tripPackages.shuffle();
        });
      } else {
        print('Gagal memuat data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error ambil data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.waving_hand_rounded, color: Colors.orange),
              SizedBox(width: 8),
              Text('Halo, ${widget.userName}!',
                  style: TextStyle(fontSize: 20)),
            ],
          ),
          Row(
            children: [
              Icon(Icons.directions_bus, color: Colors.blue), // tetap directions_bus
              SizedBox(width: 8),
              Text('Ayo Jalan-Jalan',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue)),
            ],
          ),
          SizedBox(height: 20),
          Divider(),
          Row(
            children: [
              Icon(Icons.new_releases, color: Colors.deepOrange),
              SizedBox(width: 8),
              Text('Open Trip Baru!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 10),
          _buildAutoScrollTripList(),
          SizedBox(height: 20),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  SizedBox(width: 8),
                  Text('Rekomendasi',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
              GestureDetector(
                onTap: () {
                  // Navigasi ke halaman Trips
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OpenTripPage(userName: widget.userName),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.arrow_forward_ios,
                        color: Colors.blue, size: 16),
                    SizedBox(width: 4),
                    Text('Lihat Semua',
                        style: TextStyle(fontSize: 16, color: Colors.blue)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          _buildStaticTripList(),
          SizedBox(height: 20),
          Divider(),
          Row(
            children: [
              Icon(Icons.update, color: Colors.green), // icon update untuk Terkini
              SizedBox(width: 8),
              Text('Terkini di Bandung',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 10),
          _buildNewsListIconStyle(), // ganti ke list icon style
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAutoScrollTripList() {
    return SizedBox(
      height: 230,
      child: _tripPackages.isNotEmpty
          ? PageView.builder(
              controller: _pageController,
              itemCount: _tripPackages.length,
              itemBuilder: (context, index) {
                final trip = _tripPackages[index];
                return _buildTripCard(
                  title: trip['nama_paket'],
                  price: 'IDR ${trip['harga']}',
                  imageUrl:
                      'http://10.0.2.2/backend/uploads/${trip['foto']}',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailTripPage(
                          packageId: trip['id'].toString(),
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildStaticTripList() {
    return SizedBox(
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _tripPackages.length,
        itemBuilder: (context, index) {
          final trip = _tripPackages[index];
          return _buildTripCard(
            title: trip['nama_paket'],
            price: 'IDR ${trip['harga']}',
            imageUrl: 'http://10.0.2.2/backend/uploads/${trip['foto']}',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailTripPage(
                    packageId: trip['id'].toString(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTripCard({
    required String title,
    required String price,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        margin: EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(imageUrl,
                  height: 120, width: double.infinity, fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 120,
                  color: Colors.grey[200],
                  child: Center(child: CircularProgressIndicator()),
                );
              }, errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  color: Colors.grey[300],
                  child: Icon(Icons.broken_image, size: 40),
                );
              }),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Divider(),
                  Row(
                    children: [
                      Icon(Icons.wallet, size: 16, color: Colors.blue),
                      SizedBox(width: 4),
                      Text(price,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Berita dengan icon list style (tanpa gambar besar)
  Widget _buildNewsListIconStyle() {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _newsList.length,
      separatorBuilder: (_, __) => Divider(),
      itemBuilder: (context, index) {
        final news = _newsList[index];
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsDetailPage(
                  title: news['title']!,
                  description: news['desc']!,
                  url: news['url']!,
                  imageUrl: news['image']!,
                ),
              ),
            );
          },
          leading: Icon(Icons.article_outlined, color: Colors.green, size: 36),
          title: Text(
            news['title']!,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Text(
            news['desc']!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey[700]),
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        );
      },
    );
  }
}

class NewsDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final String url;
  final String imageUrl;

  const NewsDetailPage({
    Key? key,
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Berita Detail'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: Icon(Icons.broken_image, size: 40),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800]),
              ),
              SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () async {
                  // buka URL dengan url_launcher jika mau (tidak termasuk dalam request)
                },
                icon: Icon(Icons.open_in_new),
                label: Text('Buka Sumber'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
