// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_app/pages/random_page.dart';

class Dog {
  final String imageUrl;

  Dog({required this.imageUrl});

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
  final List<String> _breedOptions = ['all'];
  List<String> _breedsList = [];
  String _selectedBreed = 'all'; // giá trị mặc định
  List<Dog> _dogs = [];

  @override
  void initState() {
    super.initState();
    _fetchDogs();
    _fetchBreedsList();
  }

  Future<void> _fetchDogs() async {
    final breed = _selectedBreed == 'all'
        ? 'breeds/image'
        : 'breed/$_selectedBreed/images';
    final response =
        await http.get(Uri.parse('https://dog.ceo/api/$breed/random/20'));
    final data = jsonDecode(response.body);
    final dogs = List<Dog>.from(
        data['message'].map((imageUrl) => Dog(imageUrl: imageUrl)));
    setState(() {
      _dogs = dogs;
    });
  }

  Future<void> _fetchBreedsList() async {
    final response =
        await http.get(Uri.parse('https://dog.ceo/api/breeds/list'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final breedsList = List<String>.from(data['message']);
      setState(() {
        _breedsList = breedsList;
        _breedOptions.clear();
        _breedOptions.add('all');
        _breedOptions.addAll(breedsList);
      });
    } else {
      throw Exception('Failed to load breeds list');
    }
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Thêm key vào Scaffold
      appBar: AppBar(
        title: const Text('Dogs'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: _openDrawer,
        ),
        actions: [
          DropdownButton(
            value: _selectedBreed,
            onChanged: (value) {
              setState(() {
                _selectedBreed = value as String;
              });
              _fetchDogs(); // Gọi lại hàm _fetchDogs()
            },
            items: _breedOptions.map((breed) {
              return DropdownMenuItem(
                value: breed,
                child: Text(breed),
              );
            }).toList(),
          ),
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
