// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
// import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:image_gallery_app/app.dart';

class PixabayService {
  final String _apiKey =
      'YOUR_API_KEY'; // Don't commit to git repo, save in environment and use. Env file should be in .gitignore

  Future<List<String>> fetchImages(int page) async {
    // try {
    final response = await http.get(Uri.parse(
        'https://pixabay.com/api/?key=$_apiKey&q=random&image_type=photo&per_page=20&page=$page'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List images = data['hits'];
      return images.map((image) => image['webformatURL'] as String).toList();
    } else {
      throw Exception('Failed to load images');
    }
    // } catch (e) {
    //   ScaffoldMessenger.of(globalContext).clearSnackBars();
    //   ScaffoldMessenger.of(globalContext).showSnackBar(const SnackBar(
    //     content: Text(
    //       "Oops... Something went wrong",
    //       style: TextStyle(color: Colors.white),
    //     ),
    //     backgroundColor: Colors.red,
    //   ));
    // }
    // return [];
  }
}
