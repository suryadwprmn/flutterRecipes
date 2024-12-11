import 'package:flutter/material.dart';

class RegisterNotifier extends ChangeNotifier {
  final BuildContext context;

  RegisterNotifier({required this.context});

  final keyfrom = GlobalKey<FormState>();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController retypePasswordController =
      TextEditingController();

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void setErrorMessage(String? value) {
    _errorMessage = value;
    notifyListeners();
  }
}