import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

  Stream<QuerySnapshot> getUserOrders() {
    final user = FirebaseAuth.instance.currentUser;
    // Tanpa orderBy supaya gak perlu index
    return FirebaseFirestore.instance
        .collection('Orders')
        .where('userId', isEqualTo: user?.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
        backgroundColor: Colors.brown[700],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getUserOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada pesanan...',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          // Data dari Firebase
          final orders = snapshot.data!.docs;

          // Urutkan secara manual berdasarkan field 'tanggal'
          orders.sort((a, b) {
            final tglA = a['tanggal'] is Timestamp
                ? (a['tanggal'] as Timestamp).toDate()
                : DateTime(0);
            final tglB = b['tanggal'] is Timestamp
                ? (b['tanggal'] as Timestamp).toDate()
                : DateTime(0);
            return tglB.compareTo(tglA); // terbaru duluan
          });

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final data = orders[index].data() as Map<String, dynamic>? ?? {};

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  title: Text(
                    data['namaProduk'] ?? 'Produk tidak diketahui',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    data['status'] ?? 'Status tidak diketahui',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: Text(
                    data['harga'] != null ? 'Rp ${data["harga"]}' : '-',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                      fontSize: 15,
                    ),
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
