// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        "question": "Bagaimana cara mendaftar di Tripshare?",
        "answer":
            "Cukup buka aplikasi, lalu pilih menu Daftar. Isi data diri Anda dengan lengkap dan aplikasi dapat digunakan."
      },
      {
        "question": "Bagaimana cara memesan trip?",
        "answer":
            "Pilih paket trip yang tersedia, klik Pesan Sekarang, lalu ikuti langkah pemesanan hingga proses pembayaran selesai."
      },
      {
        "question": "Bagaimana alur pembayaran di Tripshare?",
        "answer": "Setelah memilih trip, Anda akan diarahkan ke halaman pembayaran melalui Midtrans. Pilih metode pembayaran (transfer bank, e-wallet, dll), lalu selesaikan pembayaran sesuai instruksi."
      },
      {
        "question": "Apakah saya bisa mendapatkan refund jika membatalkan trip atau terjadi pembatalan karena cuaca ekstrem atau bencana alam ?",
        "answer":
            "Ya, jika terjadi kondisi darurat seperti cuaca buruk, banjir, atau longsor yang membuat trip tidak dapat dilaksanakan, pengguna berhak mengajukan refund atau penjadwalan ulang sesuai kebijakan PT. Denar Pesona."
      },
      {
        "question": "Syarat proses refund?",
        "answer": "Pengajuan maksimal 3×24 jam setelah pengumuman pembatalan, Sertakan bukti pemesanan dan alasan pembatalan, Proses refund maksimal 7 hari kerja dan Refund berupa dana kembali atau penjadwalan ulang, sesuai kebijakan PT. Denar Pesona."
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
