import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'riwayat.dart';
import 'package:flutter/material.dart';

Future<void> buatPesanan(
  BuildContext context,
  String namaProduk,
  int harga,
) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kamu harus login dulu untuk memesan!')),
    );
    return;
  }

  try {
    await FirebaseFirestore.instance.collection('Orders').add({
      'namaProduk': namaProduk,
      'harga': harga,
      'tanggal': Timestamp.now(),
      'status': 'Menunggu konfirmasi',
      'userId': user.uid,
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Pesanan berhasil dibuat!')));

    await Future.delayed(const Duration(milliseconds: 500));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RiwayatPage()),
    );
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Gagal membuat pesanan: $e')));
  }
}

class PesananPage extends StatefulWidget {
  final String nama;
  final String deskripsi;
  final IconData? icon; // ganti dari gambar ke icon
  final int harga;

  const PesananPage({
    required this.nama,
    required this.deskripsi,
    required this.harga,
    this.icon,
    super.key,
  });

  @override
  State<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage> {
  int rating = 0;
  final TextEditingController reviewController = TextEditingController();
  final List<Map<String, dynamic>> reviews = [];

  @override
  Widget build(BuildContext context) {
    double averageRating = reviews.isEmpty
        ? 0
        : reviews.map((r) => r['rating'] as int).reduce((a, b) => a + b) /
              reviews.length;

    return Scaffold(
      backgroundColor: const Color(0xFF3B241E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E1B15),
        title: Text(
          widget.nama,
          style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ====== Ikon Produk (vektor, bukan gambar) ======
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF4E342E),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(40),
                child: Icon(
                  widget.icon ?? Icons.coffee_rounded,
                  color: Colors.brown[100],
                  size: 90,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ===== Nama & Deskripsi =====
            Text(
              widget.nama,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.deskripsi,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            // ===== Detail Produk =====
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF6D4C41),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Detail Produk",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Asal: Indonesia",
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      Text(
                        "Berat: 250g",
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      Text(
                        "Rasa: Rich & Sweet",
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ===== Rating =====
            const Text(
              "Beri Rating:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () => setState(() => rating = index + 1),
                  icon: Icon(
                    Icons.star_rounded,
                    color: index < rating ? Colors.amber : Colors.white24,
                    size: 32,
                  ),
                );
              }),
            ),

            if (reviews.isNotEmpty) ...[
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    averageRating.toStringAsFixed(1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "(${reviews.length} ulasan)",
                    style: const TextStyle(color: Colors.white60, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // ===== Ulasan =====
            const Text(
              "Tulis Ulasanmu:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: reviewController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Ketik ulasan kamu di sini...",
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF5D4037),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8D6E63),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (reviewController.text.isNotEmpty && rating > 0) {
                    setState(() {
                      reviews.add({
                        'text': reviewController.text,
                        'rating': rating,
                      });
                      reviewController.clear();
                      rating = 0;
                    });
                  }
                },
                child: const Text(
                  "Kirim Ulasan",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ===== Tombol Pesan =====
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD2691E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () async {
                  await buatPesanan(context, widget.nama, widget.harga);
                },
                child: const Text(
                  "Pesan Sekarang",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontFamily: 'Poppins',
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
