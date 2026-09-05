import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkImageCard extends StatelessWidget {
  const NetworkImageCard({super.key, required this.imageLink});
  final String imageLink;

  String get _formattedImageLink {
    if (imageLink.isEmpty) return '';
    const String baseUrl = 'https://storage.biddabari.online/biddabari-bucket';
    if (imageLink.contains('backend')) {
      final String path = imageLink.substring(imageLink.indexOf('backend'));
      return '$baseUrl/$path';
    }
    if (imageLink.startsWith('http://') || imageLink.startsWith('https://')) {
      return imageLink;
    }
    return imageLink.startsWith('/') ? '$baseUrl$imageLink' : '$baseUrl/$imageLink';
  }

  @override
  Widget build(BuildContext context) {
    final formattedUrl = _formattedImageLink;
    if (formattedUrl.isEmpty) {
      return const SizedBox.shrink();
    }
    return CachedNetworkImage(
      imageUrl: formattedUrl,
      height: 180,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        height: 180,
        color: Colors.grey[200],
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) => Image.network(
        formattedUrl,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 180,
          color: Colors.grey[200],
          child: const Center(child: Icon(Icons.error, color: Colors.red)),
        ),
      ),
    );
  }
}
