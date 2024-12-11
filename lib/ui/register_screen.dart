import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resepmakanan/provider/register_notifier.dart';
import 'package:resepmakanan/services/auth_service.dart';
import 'package:resepmakanan/ui/login_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterNotifier(context: context),
      child: Consumer<RegisterNotifier>(
        builder: (context, value, child) => Scaffold(
          body: Stack(
            children: [
              Form(
                key: value.keyfrom,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 32, right: 16, left: 16, bottom: 16),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Column(
                              children: const [
                                Text(
                                  'Daftar Akun Untuk Mengakses Aplikasi',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Section: Name Field
                          _buildTextFormField(
                            controller: value.nameController,
                            label: 'Nama',
                            validator: (e) {
                              if (e!.isEmpty) return "Nama Tidak boleh kosong";
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Section: Email Field
                          _buildTextFormField(
                            controller: value.emailController,
                            label: 'Email',
                            validator: (e) {
                              if (e!.isEmpty) return "Email Tidak boleh kosong";
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // Section: Password Field
                          _buildTextFormField(
                            controller: value.passwordController,
                            label: 'Password',
                            obscureText: true,
                            validator: (e) {
                              if (e!.isEmpty)
                                return "Password Tidak boleh kosong";
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Section: Confirm Password Field
                          _buildTextFormField(
                            controller: value.retypePasswordController,
                            label: 'Konfirmasi Password',
                            obscureText: true,
                            validator: (e) {
                              if (e!.isEmpty)
                                return "Konfirmasi Password Tidak boleh kosong";
                              if (e != value.passwordController.text) {
                                return "Password dan Konfirmasi Password tidak cocok";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Display Error Message if Exists
                          if (value.errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Text(
                                value.errorMessage!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                          // Section: Sign Up Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (value.keyfrom.currentState!.validate()) {
                                  value.setLoading(true);

                                  // Call the AuthService register method
                                  print('Calling AuthService.register');

                                  final response = await AuthService().register(
                                    context,
                                    value.nameController.text,
                                    value.emailController.text,
                                    value.passwordController.text,
                                  );

                                  print(
                                      'AuthService.register response: $response');

                                  if (response) {
                                    print('Registration successful');
                                    value.setLoading(false);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginScreen(),
                                      ),
                                    );
                                  } else {
                                    value.setLoading(false);
                                    // Handle registration failure (optional)
                                    print('Registration failed');
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: value.isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      'Daftar',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Section: Register Option
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Sudah Punya Akun ?',
                                  style: TextStyle(color: Colors.white),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()),
                                    );
                                  },
                                  child: const Text(
                                    'Masuk',
                                    style: TextStyle(
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function for text fields
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    String? prefix,
    bool obscureText = false,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefix: prefix != null ? Text(prefix) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      validator: validator,
    );
  }
}