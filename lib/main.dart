import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'Wealcome_Dwag/selamat_datang.dart';
import 'package:awan_coffe/data/product_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initProductListener(); // 🔥 sinkron realtime
  await ensureProductsExist();
  runApp(const AwanCoffeApp());
}

class AwanCoffeApp extends StatelessWidget {
  const AwanCoffeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Awan Coffe',
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFF4B2E28),
      ),
      home: const WelcomePage(), // mulai dari halaman selamat datang
    );
  }
}
