import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_app/routes/routes.dart';

void main() async {
  // Khởi tạo Firebase App
  try {
    // Đảm bảo Flutter đã khởi tạo xong trước khi sử dụng Firebase
    WidgetsFlutterBinding.ensureInitialized();
    // Sử dụng Firebase.initializeApp để khởi tạo ứng dụng Firebase
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        // Các tùy chọn cho ứng dụng Firebase, ví dụ: appId, apiKey, projectId
        appId: '1:662232437096:android:5f5e4b56bd92f178db06dd',
        apiKey: 'AIzaSyDVzh0EoLOkRw8yrMjvAGqea9eGySvMzs0',
        projectId: 'adnroid-cd529',
        messagingSenderId: 'your_messaging_sender_id',
        databaseURL: 'your_database_url',
        storageBucket: 'your_storage_bucket',
      ),
    );
  } catch (e) {
    // Xử lý nếu có lỗi khi khởi tạo Firebase
    print('Lỗi: $e');
  }
  // Khởi chạy ứng dụng Flutter
  runApp(MyApp());
}

// Định nghĩa ứng dụng Flutter
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Ẩn banner debug trong quá trình phát triển
      debugShowCheckedModeBanner: false,
      // Tiêu đề ứng dụng
      title: 'Flutter Demo',
      // Đường dẫn mặc định khi khởi chạy ứng dụng
      initialRoute: '/',
      // Các tuyến đường điều hướng trong ứng dụng
      routes: getAplicationsRoutes(),
    );
  }
}
