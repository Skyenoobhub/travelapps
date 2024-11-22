// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';

class CheckoutPage extends StatelessWidget {
  final String packageName;
  final String packagePrice;
  final String packageDescription;
  final String packageItinerary;
  final String packageFacilities;

  // Constructor to receive data from DetailTripPage
  CheckoutPage({
    required this.packageName,
    required this.packagePrice,
    required this.packageDescription,
    required this.packageItinerary,
    required this.packageFacilities,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Checkout', style: TextStyle(color: Colors.blue)),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              packageName,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 20),
            Text(
              'Price: IDR $packagePrice / Pax',
              style: const TextStyle(
                  fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 20),
            Text(
              'Description:',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(packageDescription),
            const Divider(height: 20),
            Text(
              'Itinerary:',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(packageItinerary),
            const Divider(height: 20),
            Text(
              'Facilities:',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(packageFacilities),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: () {
            // Handle the checkout process, maybe navigate to payment page
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Proceeding to Payment')));
          },
          child: const Text('Proceed to Payment'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }
}
