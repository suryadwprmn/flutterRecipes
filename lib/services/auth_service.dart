import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:resepmakanan/models/response_model.dart';
import 'package:resepmakanan/ui/home_screen.dart';
import 'package:resepmakanan/ui/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio();

  AuthService() {
    _dio.options.baseUrl =
        "https://recipe.incube.id/api"; // Sesuaikan URL API Anda
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // Fungsi untuk mengambil token
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Fungsi untuk login
  Future<bool> login(context, String email, String password) async {
    try {
      final response = await _dio.post(
        "/login",
        data: {
          "email": email.toString(),
          "password": password.toString(),
        },
      );

      if (response.statusCode == 200) {
        // Menyimpan token dan informasi pengguna di SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token = response.data['data']['token'];
        await prefs.setString('access_token', token);
        await prefs.setString('name', response.data['data']['user']['name']);
        await prefs.setString('email', response.data['data']['user']['email']);
        await prefs.setInt(
            'id',
            response.data['data']['user']
                ['id']); // Pastikan id disimpan sebagai int

        // Redirect ke halaman utama setelah login berhasil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
        return true;
      } else {
        // Tampilkan pesan error jika login gagal
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login gagal: ${response.data['message']}')),
        );
        return false;
      }
    } on DioException catch (e) {
      // Tampilkan error jika ada masalah saat request
      print("Login error: ${e.response?.data['message']}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Terjadi kesalahan, coba lagi.")),
      );
      return false;
    }
  }

  // Fungsi untuk register
  Future<bool> register(
      context, String name, String email, String password) async {
    try {
      final response = await _dio.post(
        "/register",
        data: {
          "name": name,
          "email": email,
          "password": password,
        },
      );

      if (response.statusCode == 201) {
        // Menyimpan token dan informasi pengguna di SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();

        String token = response.data['data']['token'];
        String userName = response.data['data']['user']['name'];
        String userEmail = response.data['data']['user']['email'];

        // Menambahkan pengecekan dan konversi untuk id
        dynamic userId = response.data['data']['user']['id'];

        // Pastikan userId adalah integer
        if (userId is String) {
          userId = int.tryParse(userId) ?? 0; // Mengonversi jika diperlukan
        }

        // Simpan token dan data pengguna ke SharedPreferences
        await prefs.setString('access_token', token);
        await prefs.setString('name', userName);
        await prefs.setString('email', userEmail);
        await prefs.setInt('id', userId); // Simpan id sebagai integer

        // Arahkan ke halaman Login setelah registrasi berhasil
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        return true;
      } else if (response.statusCode == 422) {
        // Tampilkan error jika email sudah ada
        String errorMessage = response.data['errors']['email'][0];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
        return false;
      } else {
        // Tampilkan error umum jika terjadi masalah pada server
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal registrasi, coba lagi.")),
        );
        return false;
      }
    } on DioException catch (e) {
      print("Register error: ${e.response?.data['message']}");
      return false;
    }
  }

  // Fungsi untuk logout
  Future<void> logout(context) async {
    final token = await getToken(); // Mengambil token dari SharedPreferences
    if (token != null) {
      try {
        // Mengirim request logout dengan header Authorization
        final res = await _dio.post(
          "/logout",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token', // Menambahkan token di header
            },
          ),
        );

        // Menangani respons sukses
        if (res.statusCode == 200 && res.data['status'] == 'success') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.remove('access_token'); // Menghapus token setelah logout

          // Arahkan pengguna ke halaman login atau halaman yang sesuai
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const LoginScreen()), // Ganti dengan halaman login kamu
          );
        } else {
          // Menangani jika logout gagal
          print("Logout failed: ${res.data['message']}");
        }
      } on DioException catch (e) {
        // Menangani error jika ada masalah saat melakukan request
        print("Logout error: ${e.response?.data['message']}");
      }
    } else {
      print("No token found. Please login first.");
    }
  }
}