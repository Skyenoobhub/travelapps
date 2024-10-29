// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BiodataPage extends StatefulWidget {
  const BiodataPage({super.key});

  @override
  _BiodataPageState createState() => _BiodataPageState();
}

class _BiodataPageState extends State<BiodataPage> {
  String? name;
  String? email;
  String? phone;
  String? gender;
  bool isLoading = true; // To show loading state

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchBiodata();
  }

  Future<void> fetchBiodata() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2/backend/biodata.php')); // Update with your server URL

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          name = data['name'];
          email = data['email'];
          phone = data['phone'];
          gender = data['gender'];
          isLoading = false; // Stop loading when data is received

          // Set initial values for the controllers
          nameController.text = name ?? '';
          emailController.text = email ?? '';
          phoneController.text = phone ?? '';
          genderController.text = gender ?? '';
        });
      } else {
        // Print error response
        print('Failed to load biodata: ${response.statusCode} ${response.body}');
        setState(() {
          isLoading = false; // Stop loading on error
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false; // Stop loading on error
      });
    }
  }

  Future<void> updateBiodata() async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2/backend/update_biodata.php'), // Update to your update script URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'gender': genderController.text,
          // Include user ID if necessary
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data['message']); // Display success message
        // Optionally show a snackbar or a dialog to confirm success
      } else {
        print('Failed to update biodata: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Biodata',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? Center(child: CircularProgressIndicator()) // Show loading indicator
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(label: 'Nama', controller: nameController),
                  _buildTextField(label: 'Email', controller: emailController),
                  _buildTextField(label: 'No Telepon', controller: phoneController),
                  _buildTextField(label: 'Jenis Kelamin', controller: genderController),
                  const SizedBox(height: 30),
                  _buildUpdateButton(),
                ],
              ),
      ),
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.blue)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Masukkan $label',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildUpdateButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          updateBiodata(); // Call the update function
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'Update',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}