import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_gallery_app/models/image_data.dart';

class PixabayService {
  final String _apiKey =
      'YOUR_PIXABAY_API_KEY'; // Dont commit pixabay api key to git repo

  Future<List<ImageData>> fetchImages(int page) async {
    final response = await http.get(Uri.parse(
        'https://pixabay.com/api/?key=$_apiKey&q=random&image_type=photo&per_page=20&page=$page'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List images = data['hits'];
      return images.map((image) {
        return ImageData(
          imageUrl: image['webformatURL'] as String,
          likes: image['likes'] as int,
          views: image['views'] as int,
        );
      }).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }
}
