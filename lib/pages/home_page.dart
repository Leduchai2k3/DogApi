import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_app/pages/random_page.dart';

// Lớp Dog đại diện cho một con chó với đường dẫn ảnh của nó.
class Dog {
  final String imageUrl;

  Dog({required this.imageUrl});

  // Phương thức tạo mới một đối tượng Dog từ một đối tượng Map được phân tích từ JSON.
  factory Dog.fromJson(Map<String, dynamic> json) {
    return Dog(imageUrl: json['message']);
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Danh sách các tùy chọn giống chó để người dùng có thể chọn.
  final List<String> _breedOptions = ['all'];
  List<String> _breedsList = [];

  // Loại chó được chọn, mặc định là 'all'.
  String _selectedBreed = 'all';

  // Danh sách chứa các đối tượng Dog được tải xuống từ API.
  List<Dog> _dogs = [];

  @override
  void initState() {
    super.initState();

    // Tải danh sách tùy chọn giống chó và danh sách giống chó.
    _fetchBreedsList();
    _fetchDogs();
  }

  // Phương thức tải danh sách chó dựa trên giống được chọn.
  Future<void> _fetchDogs() async {
    final breed = _selectedBreed == 'all'
        ? 'breeds/image'
        : 'breed/$_selectedBreed/images';

    // Gọi API để lấy danh sách các đường dẫn hình ảnh của chó và tạo ra danh sách các đối tượng Dog từ đó.
    final response =
        await http.get(Uri.parse('https://dog.ceo/api/$breed/random/20'));
    final data = jsonDecode(response.body);
    final dogs = List<Dog>.from(
        data['message'].map((imageUrl) => Dog(imageUrl: imageUrl)));
    setState(() {
      _dogs = dogs;
    });
  }

  // Phương thức tải danh sách tùy chọn giống chó.
  Future<void> _fetchBreedsList() async {
    final response =
        await http.get(Uri.parse('https://dog.ceo/api/breeds/list'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Tạo ra danh sách các giống chó từ dữ liệu trả về và thêm giá trị 'all' vào danh sách tùy chọn.
      final breedsList = List<String>.from(data['message']);
      setState(() {
// Gán danh sách giống chó mới cho danh sách giống chó đã lấy được
        _breedsList = breedsList;
// Xóa tất cả các tùy chọn giống chó cũ
        _breedOptions.clear();
// Thêm tùy chọn "all" vào danh sách tùy chọn
        _breedOptions.add('all');
// Thêm danh sách giống chó mới vào danh sách tùy chọn
        _breedOptions.addAll(breedsList);
      });
// Nếu không lấy được danh sách giống chó, thông báo lỗi
    } else {
      throw Exception('Failed to load breeds list');
    }
  }

// Mở thanh điều hướng
  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Dogs'),
        // Thêm nút mở thanh điều hướng
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: _openDrawer,
        ),
        // Thêm danh sách thả xuống để lựa chọn giống chó
        actions: [
          DropdownButton(
            value: _selectedBreed,
            onChanged: (value) {
              setState(() {
                _selectedBreed = value as String;
              });
              _fetchDogs();
            },
            items: _breedOptions.map((breed) {
              return DropdownMenuItem(
                value: breed,
                child: Text(breed),
              );
            }).toList(),
          ),
          // Thêm nút để chuyển đến trang ngẫu nhiên
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RandomPage()),
              );
            },
            child: const Text(
              'Random',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      // Thanh điều hướng
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Text('Dogs APP'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Đăng nhập'),
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
            ListTile(
              title: Text('Đăng ký'),
              onTap: () {
                Navigator.pushNamed(context, '/register');
              },
            ),
          ],
        ),
      ),
      // Hiển thị danh sách chó
      body: _dogs == null
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 350 / 500,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: _dogs.length,
              itemBuilder: (context, index) {
                final dog = _dogs[index];
                return CachedNetworkImage(
                  imageUrl: dog.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                );
              },
            ),
    );
  }
}
