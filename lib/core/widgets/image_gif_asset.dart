import 'package:flutter/material.dart';

class DLAssetGifImage extends StatelessWidget {
  final String imageName;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final ImageErrorWidgetBuilder? errorBuilder;

  const DLAssetGifImage({
    super.key,
    required this.imageName,
    this.width,
    this.height,
    this.fit,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/gifs/$imageName",
      width: width,
      height: height,
      fit: fit ?? BoxFit.contain,
      errorBuilder:
          errorBuilder ??
          (context, error, stackTrace) {
            return const Center(
              child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
            );
          },
    );
  }
}
