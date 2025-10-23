import 'package:flutter/material.dart';
import 'Login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isObscure1 = true;
  bool _isObscure2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4E2C1E), // coklat tua elegan
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Judul Register ---
              const Center(
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontFamily: 'RockerStory',
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // --- Username ---
              const Text(
                "Username",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: _usernameController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Masukkan username kamu"),
              ),
              const SizedBox(height: 20),

              // --- Email ---
              const Text(
                "Email",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Masukkan email kamu"),
              ),
              const SizedBox(height: 20),

              // --- Password ---
              const Text(
                "Password",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: _passwordController,
                obscureText: _isObscure1,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Masukkan password kamu").copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure1 ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() => _isObscure1 = !_isObscure1);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // --- Konfirmasi Password ---
              const Text(
                "Ulangi Password",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: _confirmPasswordController,
                obscureText: _isObscure2,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Masukkan ulang password kamu")
                    .copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure2 ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          setState(() => _isObscure2 = !_isObscure2);
                        },
                      ),
                    ),
              ),
              const SizedBox(height: 35),

              // --- Tombol Daftar ---
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD39D55),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 55,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                    shadowColor: Colors.black45,
                  ),
                  child: const Text(
                    'Daftar',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // --- Teks Login di bawah ---
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                  child: const Text(
                    "Sudah punya akun?\nLogin di sini",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xD9D39D55), // coklat muda lembut
                      fontSize: 13,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 45),

              // --- Nama brand di bawah ---
              const Center(
                child: Text(
                  "Awan Coffe",
                  style: TextStyle(
                    fontFamily: 'RockerStory',
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable input decoration biar rapih
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      filled: true,
      fillColor: const Color(0xFF6F3C1C),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
    );
  }
}
