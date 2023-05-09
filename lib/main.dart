import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_app/routes/routes.dart';

void main() async {
  // Khởi tạo Firebase App
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        appId: '1:662232437096:android:5f5e4b56bd92f178db06dd',
        apiKey: 'AIzaSyDVzh0EoLOkRw8yrMjvAGqea9eGySvMzs0',
        projectId: 'adnroid-cd529',
        messagingSenderId: 'your_messaging_sender_id',
        databaseURL: 'your_database_url',
        storageBucket: 'your_storage_bucket',
      ),
    );
  } catch (e) {
    print('Lỗi: $e');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: getAplicationsRoutes(),
    );
  }
}
