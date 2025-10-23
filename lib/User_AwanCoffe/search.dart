import 'package:flutter/material.dart';
import 'package:awan_coffe/data/product_data.dart';
import 'package:awan_coffe/User_AwanCoffe/pesanan.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF32261A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF32261A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Search',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      // ✅ tetap pakai ValueListenableBuilder agar live update dari Barista
      body: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: productNotifier,
        builder: (context, products, _) {
          // filter hasil pencarian
          final filteredProducts = products
              .where(
                (p) => p['name'].toLowerCase().contains(query.toLowerCase()),
              )
              .toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: TextField(
                    controller: _controller,
                    onChanged: (value) => setState(() => query = value),
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.white70),
                      hintText: 'carilah tentang kopi',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: filteredProducts.isEmpty
                    ? const Center(
                        child: Text(
                          'Kopi yang kamu cari tidak ditemukan ☕',
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          final bool isSoldOut = product['isSoldOut'] ?? false;

                          return GestureDetector(
                            onTap: () {
                              if (isSoldOut) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Maaf, stok kopi ini sedang habis 😔',
                                    ),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PesananPage(
                                      nama: product['name'],
                                      deskripsi: product['desc'],
                                      harga: product['harga'],
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4C3A34),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(12),
                                leading: CircleAvatar(
                                  backgroundColor: isSoldOut
                                      ? Colors.grey.withOpacity(0.3)
                                      : Colors.brown.withOpacity(0.3),
                                  radius: 28,
                                  child: Icon(
                                    product['icon'],
                                    color: isSoldOut
                                        ? Colors.grey
                                        : Colors.amberAccent,
                                    size: 32,
                                  ),
                                ),
                                title: Text(
                                  product['name'],
                                  style: TextStyle(
                                    color: isSoldOut
                                        ? Colors.white54
                                        : Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      product['desc'],
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                        height: 1.3,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      isSoldOut
                                          ? "Stok Habis"
                                          : "Rp ${product['harga']}",
                                      style: TextStyle(
                                        color: isSoldOut
                                            ? Colors.grey
                                            : Colors.amberAccent,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
