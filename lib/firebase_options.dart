// TODO Implement this library.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: "AIzaSyDBEYcgVHYtKKJsGjV6kXmmDs24Vj0TbvI",
      appId: "1:491966579299:android:f6e162bc54faf163d6ee56",
      messagingSenderId: "491966579299",
      projectId: "awancoffe-1e249",
      storageBucket: "awancoffe-1e249.firebasestorage.app",
    );
  }
}
