import 'package:flutter/material.dart';
import 'package:awan_coffe/User_AwanCoffe/search.dart';
import 'package:awan_coffe/User_AwanCoffe/user.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF32261A),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Nama dan tagline
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Awan Coffee',
                      style: TextStyle(
                        fontFamily: 'RockerStory',
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Rasakan hangatnya seduhan dari\nDanau Lut Tawar',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),

                // Foto profil kanan atas
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                ),
              ],
            ),
          ),
        ),
      ),

      // ISI KONTEN
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        children: [
          // Header image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/header_coffee.jpg',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),

          // PROMO SECTION
          const Text(
            'PROMO HARI INI',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),

          // List Promo
          SizedBox(
            height: 220,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                promoCard(
                  'assets/images/kopi (1).png',
                  'SI HITAM LEGAM',
                  'Promo buat premium coffee',
                ),
                promoCard(
                  'assets/images/kopi (2).png',
                  'SEDAP NYOO',
                  'Beli 1 Gratis 1 All Varian',
                ),
                promoCard(
                  'assets/images/kopi (3).png',
                  'ICED BLEND',
                  'Diskon hingga 20%',
                ),
                promoCard(
                  'assets/images/kopi (4).png',
                  'COKLAT PANAS',
                  'Promo spesial minggu ini',
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // EVENT SECTION
          const Text(
            'EVENT',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),

          // List Event
          SizedBox(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                eventCard('assets/images/1.png'),
                eventCard('assets/images/2.png'),
                eventCard('assets/images/3.png'),
                eventCard('assets/images/4.png'),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),

      // NAVBAR BAWAH (✅ sudah fix)
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF211912),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.brown,
          unselectedItemColor: Colors.white70,
          currentIndex: 0, // halaman ini adalah Home
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: ''),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_rounded),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: '',
            ),
          ],

          // 🔹 navigasi tanpa ubah struktur kode
          onTap: (index) {
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            } else if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfilePage()),
              );
            }
          },
        ),
      ),
    );
  }

  // --- Widget Kartu Promo ---
  static Widget promoCard(String image, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(right: 14),
      width: 160,
      decoration: BoxDecoration(
        color: const Color(0xFF4C3A34),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.asset(
              image,
              height: 110,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget Kartu Event ---
  static Widget eventCard(String image) {
    return Container(
      margin: const EdgeInsets.only(right: 14),
      width: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 5,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.asset(image, fit: BoxFit.cover),
      ),
    );
  }
}
