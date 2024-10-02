import 'package:flutter/material.dart';
import 'package:image_gallery_app/api_service/pixabay_service.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageGalleryPage extends StatefulWidget {
  const ImageGalleryPage({super.key});

  @override
  ImageGalleryPageState createState() => ImageGalleryPageState();
}

class ImageGalleryPageState extends State<ImageGalleryPage> {
  static const _pageSize = 20;
  final PixabayService _pixabayService = PixabayService();
  final PagingController<int, String> _pagingController =
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Random Image Gallery')),
      body: PagedGridView<int, String>(
        pagingController: _pagingController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
        ),
        builderDelegate: PagedChildBuilderDelegate<String>(
          itemBuilder: (context, imageUrl, index) => CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
