import 'package:flutter/material.dart';
import 'package:resepmakanan/ui/home_screen.dart';
import 'package:resepmakanan/ui/login_screen.dart';
import 'package:resepmakanan/ui/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginScreen(),
    );
  }
}