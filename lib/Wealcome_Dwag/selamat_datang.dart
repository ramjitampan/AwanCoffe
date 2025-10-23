import 'package:flutter/material.dart';
import 'package:awan_coffe/Login_Register/Login_page.dart';
import 'package:awan_coffe/Login_Register/register_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFC47A39), // warna utama figma
      body: SafeArea(
        child: Stack(
          children: [
            // Bagian atas (judul + logo)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 80),

                // Judul di atas logo
                Text(
                  "Awan coffe",
                  style: TextStyle(
                    fontFamily: 'RockerStory',
                    fontSize: 34,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "The art of coffee drink or grind.",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 30),

                // Logo di bawah teks
                Center(
                  child: Container(
                    width: 230, // ubah ukuran sesuai kebutuhan figma
                    height: 230,
                    decoration: const BoxDecoration(color: Colors.transparent),
                    child: Image.asset(
                      'assets/images/awan_coffe.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),

            // Panel bawah (selamat datang)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: screenHeight * 0.35,
                decoration: const BoxDecoration(
                  color: Color(0xFF4B2E28),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 30.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Selamat Datang",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Selamat datang silahkan menikmati, dan juga kalian bisa menikmati seduhan coffee gaya serta membeli biji dan bubuk kopi pilihan khas Gayo berkualitas tinggi.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Tombol Selanjutnya
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC47A39),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 13,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Selanjutnya",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Icon(Icons.arrow_right_alt, color: Colors.white),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
