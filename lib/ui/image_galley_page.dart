import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_gallery_app/api_service/pixabay_service.dart';
import 'package:image_gallery_app/models/image_data.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ImageGalleryPage extends StatefulWidget {
  const ImageGalleryPage({super.key});

  @override
  ImageGalleryPageState createState() => ImageGalleryPageState();
}

class ImageGalleryPageState extends State<ImageGalleryPage> {
  static const _pageSize = 20;
  final PixabayService _pixabayService = PixabayService();
  final PagingController<int, ImageData> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newImages = await _pixabayService.fetchImages(pageKey);
      final isLastPage = newImages.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newImages);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newImages, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  /// Method to calculate number of columns based on screen width
  int _calculateColumns(double screenWidth) {
    if (screenWidth >= 1200) {
      // Desktop/Laptop screen
      return 4;
    } else if (screenWidth >= 800) {
      // Tablet/iPad screen
      return 3;
    } else {
      // Phone screen
      return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width dynamically
    double screenWidth = MediaQuery.of(context).size.width;
    int columns = _calculateColumns(screenWidth);

    return Scaffold(
      appBar: AppBar(title: const Text('Random Image Gallery')),
      body: PagedGridView<int, ImageData>(
        pagingController: _pagingController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns, // Dynamic number of columns
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 0.8, // Adjust based on design
        ),
        builderDelegate: PagedChildBuilderDelegate<ImageData>(
          itemBuilder: (context, imageData, index) => Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: imageData.imageUrl,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.thumb_up, color: Colors.red),
                          const SizedBox(width: 4),
                          Text('${imageData.likes}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.visibility, color: Colors.blue),
                          const SizedBox(width: 4),
                          Text('${imageData.views}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
