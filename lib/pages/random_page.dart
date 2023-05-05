import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'login_page.dart';

class RandomPage extends StatefulWidget {
  @override
  _RandomPageState createState() => _RandomPageState();
}

class _RandomPageState extends State<RandomPage> {
  String _imageUrl = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _fetchRandomDog();
  }

  Future<void> _fetchRandomDog() async {
    final response =
        await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        _imageUrl = jsonResponse['message'];
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: _imageUrl.isEmpty
            ? CircularProgressIndicator()
            : Image.network(
                _imageUrl,
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchRandomDog,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
