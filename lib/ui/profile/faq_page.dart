// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        "question": "Apa itu Open Trip?",
        "answer":
            "Open Trip adalah layanan perjalanan yang dapat diikuti oleh siapa saja tanpa harus mengumpulkan kelompok sendiri."
      },
      {
        "question": "Di daerah mana PT Jalan Dulu Asia?",
        "answer":
            "PT Jalan Dulu Asia beroperasi di berbagai daerah di Indonesia, terutama di tempat-tempat wisata populer."
      },
      {
        "question": "Siapa saja yang bisa menggunakan jasa Open Trip?",
        "answer":
            "Siapapun bisa menggunakan jasa Open Trip, baik individu, keluarga, maupun kelompok kecil."
      },
      {
        "question":
            "Apa yang membedakan PT Jalan Dulu Asia dari kompetitor lain di industri yang sama?",
        "answer":
            "PT Jalan Dulu Asia menawarkan pengalaman perjalanan yang unik dengan fokus pada kenyamanan dan pengalaman lokal."
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
        child: ListView.separated(
          itemCount: faqs.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final faq = faqs[index];
            return _buildFAQItem(faq["question"]!, faq["answer"]!);
          },
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
