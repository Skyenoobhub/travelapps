// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        "question": "Apa itu Open Trip?",
        "answer": "Open Trip adalah layanan perjalanan yang dapat diikuti oleh siapa saja tanpa harus mengumpulkan kelompok sendiri."
      },
      {
        "question": "Di daerah mana PT Jalan Dulu Asia?",
        "answer": "PT Jalan Dulu Asia beroperasi di berbagai daerah di Indonesia, terutama di tempat-tempat wisata populer."
      },
      {
        "question": "Siapa saja yang bisa menggunakan jasa Open Trip?",
        "answer": "Siapapun bisa menggunakan jasa Open Trip, baik individu, keluarga, maupun kelompok kecil."
      },
      {
        "question": "Apa yang membedakan PT Jalan Dulu Asia dari kompetitor lain di industri yang sama?",
        "answer": "PT Jalan Dulu Asia menawarkan pengalaman perjalanan yang unik dengan fokus pada kenyamanan dan pengalaman lokal."
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Pertanyaan Umum',
          style: TextStyle(color: Colors.blue),
        ),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: faqs.length,
          itemBuilder: (context, index) {
            final faq = faqs[index];
            return _buildExpansionTile(faq["question"]!, faq["answer"]!);
          },
        ),
      ),
    );
  }

  Widget _buildExpansionTile(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              answer,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ],
        trailing: const Icon(
          Icons.arrow_drop_down,
          color: Colors.blue,
        ),
      ),
    );
  }
}
