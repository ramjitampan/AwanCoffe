import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'orders.dart';
import 'status_stok.dart';

class CompletedPage extends StatefulWidget {
  const CompletedPage({Key? key}) : super(key: key);

  @override
  _CompletedPageState createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OrdersPage()),
      );
    } else if (index == 1)
      return;
    else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StatusStokPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3B241E),
      appBar: AppBar(
        title: const Text(
          'Pesanan Selesai',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2E1B15),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Orders')
            .where('status', isEqualTo: 'Selesai')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.brown),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Terjadi kesalahan: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada pesanan yang selesai.',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final orders = snapshot.data!.docs.map((doc) {
            return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
          }).toList();

          // Urutkan berdasarkan waktu terbaru
          orders.sort((a, b) {
            final tA = (a['updatedAt'] as Timestamp?)?.toDate() ?? DateTime(0);
            final tB = (b['updatedAt'] as Timestamp?)?.toDate() ?? DateTime(0);
            return tB.compareTo(tA);
          });

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              final coffeeName = order['namaProduk'] ?? 'Tidak diketahui';
              final userName = order['userEmail'] ?? 'Anonim';
              final harga = order['harga']?.toString() ?? '-';
              final tanggal = (order['updatedAt'] as Timestamp?)?.toDate();

              return Card(
                color: const Color(0xFFF7F2EF),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: ListTile(
                  title: Text(
                    coffeeName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  subtitle: Text(
                    'Pelanggan: $userName\n'
                    'Harga: Rp $harga\n'
                    'Tanggal: ${tanggal != null ? tanggal.toString().split('.')[0] : '-'}',
                    style: const TextStyle(color: Colors.black87),
                  ),
                  trailing: const Icon(Icons.check_circle, color: Colors.green),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1B100B),
        selectedItemColor: const Color(0xFFD8A47F),
        unselectedItemColor: Colors.brown[400],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Orders'),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Completed',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Stok'),
        ],
      ),
    );
  }
}
