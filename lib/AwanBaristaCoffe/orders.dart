import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awan_coffe/AwanBaristaCoffe/order_detail.dart';
import 'package:awan_coffe/AwanBaristaCoffe/complite.dart';
import 'status_stok.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int _selectedIndex = 0;

  // Navigasi antar halaman
  void _onItemTapped(int index) {
    if (index == 0) return; // Sudah di halaman Orders
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CompletedPage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StatusStokPage()),
      );
    }
  }

  Future<void> _updateOrderStatus(String orderId, String newStatus) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    await _firestore.collection('Orders').doc(orderId).update({
      'status': newStatus,
      'processedBy': currentUser.email,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3B241E),
      appBar: AppBar(
        title: const Text(
          'Daftar Pesanan',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2E1B15),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Orders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.brown),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada pesanan masuk.',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final allOrders = snapshot.data!.docs.map((doc) {
            return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
          }).toList();

          final orders = allOrders
              .where((order) => order['status'] != 'Selesai')
              .toList();

          orders.sort((a, b) {
            final tA = (a['tanggal'] as Timestamp?)?.toDate() ?? DateTime(0);
            final tB = (b['tanggal'] as Timestamp?)?.toDate() ?? DateTime(0);
            return tB.compareTo(tA);
          });

          if (orders.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada pesanan yang aktif.',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final orderId = order['id'];

              final coffeeName = order['namaProduk'] ?? 'Tidak diketahui';
              final userName = order['userEmail'] ?? 'Anonim';
              final harga = order['harga']?.toString() ?? '-';
              final status = order['status'] ?? 'Menunggu konfirmasi';
              final tanggal = (order['tanggal'] as Timestamp?)?.toDate();

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
                    'Status: $status\n'
                    'Tanggal: ${tanggal != null ? tanggal.toString().split('.')[0] : '-'}',
                    style: const TextStyle(color: Colors.black87),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      await _updateOrderStatus(orderId, 'Diproses');
                      if (!mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OrderDetailPage(orderId: orderId, order: order),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown.shade700,
                    ),
                    child: const Text(
                      'Mulai',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
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
        currentIndex: 0, // halaman Orders aktif
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
