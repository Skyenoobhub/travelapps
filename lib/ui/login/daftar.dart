// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for input formatters
import 'package:http/http.dart' as http; // Import for HTTP requests
import 'dart:convert';

import 'package:travelapp/ui/login/login.dart'; // Import for JSON encoding/decoding

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? gender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D47A1), // Background color
      body: Column(
        children: [
          // Top section with image and back icon
          _buildTopSection(),
          // Registration form
          _buildRegistrationForm(),
        ],
      ),
    );
  }

  Widget _buildTopSection() {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.32,
          decoration: const BoxDecoration(
            color: Color(0xFF0D47A1),
          ),
          child: Center(
            child: Image.asset(
              'assets/images/logo.png', // Replace with your image path
              width: 100,
              height: 100,
            ),
          ),
        ),
        Positioned(
          top: 40,
          left: 16,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop(); // Back action
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationForm() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Daftarkan\nAkun Anda!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D47A1),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(namaController, 'Nama', 'Masukkan Nama Anda'),
              _buildTextField(emailController, 'Email', 'Masukkan Email Anda'),
              _buildTextField(phoneController, 'Nomor Telepon',
                  'Masukkan Nomor Telepon Anda',
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
              _buildGenderDropdown(),
              _buildTextField(
                  passwordController, 'Kata Sandi', 'Masukkan Kata Sandi Anda',
                  obscureText: true),
              _buildRegisterButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String hintText,
      {bool obscureText = false, List<TextInputFormatter>? inputFormatters}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _inputLabelStyle),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          keyboardType: inputFormatters != null
              ? TextInputType.number
              : TextInputType.text,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Jenis Kelamin', style: _inputLabelStyle),
        const SizedBox(height: 10),
        DropdownButton<String>(
          value: gender,
          hint: const Text('Pilih Jenis Kelamin'),
          isExpanded: true,
          items: <String>['Laki-laki', 'Perempuan'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              gender = newValue;
            });
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _registerUser(); // Call the registration method
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0D47A1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: const Text(
          'Daftar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _registerUser() async {
    // Validasi input
    if (namaController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        phoneController.text.isEmpty ||
        gender == null) {
      _showDialog('Error', 'All fields are required.');
      return;
    }

    const String apiUrl =
        'http://10.0.2.2/backend/regis.php'; // Ganti dengan URL API yang benar

    final Map<String, dynamic> data = {
      'name': namaController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'phone': phoneController.text,
      'gender': gender,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      // Log response body for debugging
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Cek jika kode status adalah 200 atau 201
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        _showDialog('Success', responseBody['message'], success: true);
      } else {
        // Jika ada status error lain
        final responseBody = json.decode(response.body);
        _showDialog('Error', responseBody['message']);
      }
    } catch (error) {
      _showDialog('Error', 'Failed to register. Please try again later.');
    }
  }

  void _showDialog(String title, String message, {bool success = false}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (success) {
                  // Navigate to login page if registration was successful
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static const TextStyle _inputLabelStyle = TextStyle(
    fontSize: 16,
    color: Colors.blueAccent,
    fontWeight: FontWeight.bold,
  );
}