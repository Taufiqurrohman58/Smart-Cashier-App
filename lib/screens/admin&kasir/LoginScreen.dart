import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _isPasswordHidden = true;
  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final response = await http.post(
          Uri.parse('https://flutter001.pythonanywhere.com/api/auth/login/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'username': _usernameController.text,
            'password': _passwordController.text,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          if (data['status'] == true) {
            final token = data['token'];
            final role = data['user']['role'];
            final name = data['user']['name'];

            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('auth_token', token);
            await prefs.setString('user_role', role);
            await prefs.setString('user_name', name);

            if (role == 'kasir') {
              Navigator.pushReplacementNamed(context, '/kasir');
            } else {
              Navigator.pushReplacementNamed(context, '/admin');
            }
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Login gagal')));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: Stack(
        children: [
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 62, 62, 63).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D1D1F),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(
                        12,
                      ), // ⬅️ jarak dari semua sisi
                      child: Image.asset(
                        "assets/images/cashier.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "Smart Cashier App",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 32),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // EMAIL
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            hintText: 'Username',
                            prefixIcon: const Icon(Icons.person_outline),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? "Username wajib diisi" : null,
                        ),

                        const SizedBox(height: 16),

                        // PASSWORD
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _isPasswordHidden,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordHidden
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordHidden = !_isPasswordHidden;
                                });
                              },
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) =>
                              value!.length < 6 ? "Minimal 6 karakter" : null,
                        ),

                        const SizedBox(height: 14),

                        // REMEMBER & FORGOT
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              activeColor: const Color(0xFF1D1D1F),
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value!;
                                });
                              },
                            ),
                            const Text("Remember me"),
                            const Spacer(),
                            const Text(
                              "Forget Password",
                              style: TextStyle(color: Color(0xFF1d1D1F)),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // LOGIN BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1D1D1F),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // SIGN UP
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don’t have an account? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/register');
                              },
                              child: const Text(
                                "Sign up",
                                style: TextStyle(
                                  color: Color(0xFF4CAF7A),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
