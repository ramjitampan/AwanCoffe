import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;

final ValueNotifier<List<Map<String, dynamic>>> productNotifier =
    ValueNotifier<List<Map<String, dynamic>>>([]);

/// 🟤 Inisialisasi listener Firestore
Future<void> initProductListener() async {
  _db.collection('products').snapshots().listen((snapshot) {
    final List<Map<String, dynamic>> products = snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'name': data['name'] ?? '',
        'desc': data['desc'] ?? '',
        'harga': data['harga'] ?? 0,
        'isSoldOut': data['isSoldOut'] ?? false,
        'icon': Icons.coffee,
      };
    }).toList();

    productNotifier.value = products;
  });
}

/// 🟤 Pastikan Firestore punya data awal (kalau kosong)
Future<void> ensureProductsExist() async {
  final snapshot = await _db.collection('products').get();
  if (snapshot.docs.isEmpty) {
    final defaultProducts = [
      {
        'name': 'Arabica',
        'desc': 'Strong, aromatic, rich flavor.',
        'harga': 25000,
        'isSoldOut': false,
      },
      {
        'name': 'Torabica',
        'desc': 'Bold and dark with smooth finish.',
        'harga': 22000,
        'isSoldOut': false,
      },
      {
        'name': 'Bener Meriah',
        'desc': 'Delicate sweetness and caramel hints.',
        'harga': 28000,
        'isSoldOut': false,
      },
      {
        'name': 'Silih Nara',
        'desc': 'Smooth and floral aftertaste.',
        'harga': 30000,
        'isSoldOut': false,
      },
      {
        'name': 'Aceh Gayo',
        'desc': 'Full-bodied coffee with earthy notes.',
        'harga': 27000,
        'isSoldOut': false,
      },
      {
        'name': 'Luwak Gold',
        'desc': 'Exotic, smooth, and low-acid coffee.',
        'harga': 60000,
        'isSoldOut': false,
      },
      {
        'name': 'Robusta Blend',
        'desc': 'Strong body with bold bitterness.',
        'harga': 20000,
        'isSoldOut': false,
      },
      {
        'name': 'Mocha Classic',
        'desc': 'Sweet, chocolatey, and aromatic.',
        'harga': 25000,
        'isSoldOut': false,
      },
      {
        'name': 'Gayo Beans',
        'desc': 'Aromatic and balanced, from Sumatra.',
        'harga': 35000,
        'isSoldOut': false,
      },
      {
        'name': 'Toraja Beans',
        'desc': 'Spicy aroma with deep earthy tones.',
        'harga': 40000,
        'isSoldOut': false,
      },
      {
        'name': 'Bali Beans',
        'desc': 'Citrus brightness with a mild finish.',
        'harga': 32000,
        'isSoldOut': false,
      },
      {
        'name': 'Java Beans',
        'desc': 'Classic taste with smooth character.',
        'harga': 30000,
        'isSoldOut': false,
      },
    ];

    // Simpan defaultProducts ke Firestore (tanpa IconData yang tidak serializable)
    for (final prod in defaultProducts) {
      await _db.collection('products').add(prod);
    }
  }
}

/// 🟤 Fungsi ubah status stok
Future<void> ubahStatusProduk(int index, bool isSoldOut) async {
  if (index >= productNotifier.value.length) return;

  final product = productNotifier.value[index];
  final productId = product['id'];

  if (productId == null) {
    debugPrint('❌ Produk belum punya ID Firestore');
    return;
  }

  try {
    await _db.collection('products').doc(productId).update({
      'isSoldOut': isSoldOut,
    });

    // Update lokal agar langsung terlihat (buat salinan sehingga ValueNotifier memberi tahu pendengar)
    final updated = productNotifier.value
        .map((p) => Map<String, dynamic>.from(p))
        .toList();
    updated[index]['isSoldOut'] = isSoldOut;
    productNotifier.value = updated;
  } catch (e) {
    debugPrint('🔥 Error update stok: $e');
  }
}
