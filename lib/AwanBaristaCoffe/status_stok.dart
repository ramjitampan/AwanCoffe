import 'package:flutter/material.dart';
import 'package:awan_coffe/data/product_data.dart';

class StatusStokPage extends StatefulWidget {
  const StatusStokPage({Key? key}) : super(key: key);

  @override
  State<StatusStokPage> createState() => _StatusStokPageState();
}

class _StatusStokPageState extends State<StatusStokPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3B241E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E1B15),
        title: const Text(
          'Status Stok Kopi (Barista)',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: productNotifier,
        builder: (context, products, _) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final isSoldOut = product['isSoldOut'] as bool;

              return Card(
                color: const Color(0xFF4E342E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: Icon(
                    product['icon'],
                    color: isSoldOut ? Colors.redAccent : Colors.brown[200],
                    size: 40,
                  ),
                  title: Text(
                    product['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    product['desc'],
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isSoldOut ? 'Sold Out' : 'Available',
                        style: TextStyle(
                          color: isSoldOut
                              ? Colors.redAccent
                              : Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // ✅ Perbaikan Switch yang benar:
                      Switch(
                        value: !isSoldOut,
                        activeColor: Colors.greenAccent,
                        inactiveThumbColor: Colors.redAccent,
                        onChanged: (value) {
                          // panggil fungsi global dari product_data.dart
                          ubahStatusProduk(index, !value);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
