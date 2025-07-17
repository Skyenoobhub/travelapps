// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        "question": "Apa itu paket wisata open trip?",
        "answer":
            "Open trip adalah paket wisata gabungan di mana peserta dari berbagai kalangan bisa ikut dalam satu perjalanan wisata tanpa harus membentuk kelompok sendiri."
      },
      {
        "question": "Apa keuntungan ikut open trip dibanding wisata pribadi?",
        "answer":
            "Biaya lebih murah karena ditanggung bersama, bertemu teman baru, dan itinerary sudah disiapkan oleh penyelenggara."
      },
      {
        "question": "Bagaimana cara mengetahui detail lengkap dari open trip?",
        "answer": "Detail lengkap tersedia di menu trips pada aplikasi."
      },
      {
        "question": "Bagaimana jika ingin membatalkan perjalanan atau proses refund?",
        "answer":
            "Proses pembatalan perjalanan atau refund bisa dilakukan sesuai dengan ketentuan yang berlaku, cukup hubungi layanan pelanggan kami"
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Pertanyaan Umum',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: faqs.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final faq = faqs[index];
                  return _buildFAQItem(faq["question"]!, faq["answer"]!);
                },
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                const Text(
                  'Butuh Bantuan?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    // Ganti ini dengan fungsi navigasi atau chat CS
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Menghubungi customer service...'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.support_agent),
                  label: const Text('Hubungi CS'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        iconColor: Colors.blue,
        collapsedIconColor: Colors.blue,
        title: Row(
          children: [
            const Icon(Icons.help_outline, color: Colors.blue),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                question,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
        children: [
          const Divider(color: Color(0xFFE0E0E0), height: 1, thickness: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.question_answer_outlined, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    answer,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
