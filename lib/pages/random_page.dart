// import các package cần thiết
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// import trang đăng nhập
import 'login_page.dart';

// Trang hiển thị hình ảnh chó ngẫu nhiên
class RandomPage extends StatefulWidget {
  @override
  _RandomPageState createState() => _RandomPageState();
}

class _RandomPageState extends State<RandomPage> {
// biến chứa đường link ảnh chó
  String _imageUrl = '';

// Key của Scaffold để mở Drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _fetchRandomDog(); // Lấy ảnh chó ngẫu nhiên khi trang được mở
  }

// hàm lấy ảnh chó ngẫu nhiên từ API
  Future<void> _fetchRandomDog() async {
    final response =
        await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        _imageUrl = jsonResponse['message']; // cập nhật đường link ảnh chó mới
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

// hàm mở Drawer
  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Random'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // nút back
        ),
      ),
      body: Center(
        child: _imageUrl
                .isEmpty // nếu chưa có đường link ảnh chó thì hiển thị CircularProgressIndicator(Loading)
            ? CircularProgressIndicator()
            : Image.network(
                _imageUrl, // hiển thị ảnh chó
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchRandomDog, // khi ấn nút refresh thì lấy ảnh chó mới
        child: Icon(Icons.refresh),
      ),
    );
  }
}
