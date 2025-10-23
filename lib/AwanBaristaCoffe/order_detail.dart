import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetailPage extends StatefulWidget {
  final String orderId;
  final Map<String, dynamic> order;

  const OrderDetailPage({Key? key, required this.orderId, required this.order})
    : super(key: key);

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  bool isProcessing = false;
  bool isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: isCompleted,
      child: Scaffold(
        backgroundColor: const Color(0xFF3B241E),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF2E1B15),
          title: const Text(
            '☕ Detail Pesanan',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Info
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF4E342E),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.order['namaProduk'] ?? 'Produk tidak diketahui',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "ID Pesanan: ${widget.orderId}",
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Tanggal: ${DateTime.now().toString().split(' ')[0]}",
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Detail Info
              Card(
                color: const Color(0xFF5D4037),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      _infoRow('Harga', 'Rp ${widget.order['harga'] ?? '-'}'),
                      const Divider(color: Colors.white24, height: 20),
                      _infoRow(
                        'Jumlah',
                        '${widget.order['jumlah'] ?? '1'} Cup',
                      ),
                      const Divider(color: Colors.white24, height: 20),
                      _infoRow('Catatan', widget.order['catatan'] ?? '-'),
                      const Divider(color: Colors.white24, height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Status:',
                            style: TextStyle(color: Colors.white70),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? Colors.greenAccent.withOpacity(0.2)
                                  : Colors.orangeAccent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              isCompleted ? 'Selesai' : 'Diproses',
                              style: TextStyle(
                                color: isCompleted
                                    ? Colors.greenAccent
                                    : Colors.orangeAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Progress Indicator
              if (isProcessing)
                const Center(
                  child: CircularProgressIndicator(color: Colors.orangeAccent),
                )
              else
                AnimatedOpacity(
                  opacity: isCompleted ? 1 : 0.9,
                  duration: const Duration(milliseconds: 500),
                  child: Center(
                    child: Icon(
                      isCompleted ? Icons.check_circle : Icons.local_cafe,
                      color: isCompleted
                          ? Colors.greenAccent
                          : Colors.brown[200],
                      size: 70,
                    ),
                  ),
                ),

              const SizedBox(height: 40),

              // Button
              ElevatedButton(
                onPressed: isProcessing
                    ? null
                    : () async {
                        setState(() {
                          isProcessing = true;
                        });

                        await FirebaseFirestore.instance
                            .collection('Orders')
                            .doc(widget.orderId)
                            .update({'status': 'Selesai'});

                        setState(() {
                          isCompleted = true;
                          isProcessing = false;
                        });

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Pesanan selesai 🎉'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCompleted
                      ? Colors.green.shade700
                      : Colors.brown.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 6,
                ),
                child: Text(
                  isProcessing
                      ? 'Memproses...'
                      : (isCompleted ? 'Selesai' : 'Selesaikan Pesanan'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              if (!isCompleted)
                const Center(
                  child: Text(
                    '⚠️ Barista tidak dapat kembali sebelum pesanan selesai.',
                    style: TextStyle(color: Colors.white60, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 15),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ],
    );
  }
}
