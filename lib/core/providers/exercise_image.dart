// 图片路径映射 (懒加载)
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final exerciseImageMapProvider = FutureProvider<Map<String, String>>((
  ref,
) async {
  final manifestContent = await rootBundle.loadString('AssetManifest.json');
  // 解析 manifest 找到所有 images/xxx-*.jpg 文件
  final imagePaths = _parseImagePaths(manifestContent);

  final Map<String, String> imageMap = {};
  for (final path in imagePaths) {
    // path like: assets/images/0001-abc.jpg
    final filename = path.split('/').last; // 0001-abc.jpg
    final id = filename.split('-').first; // 0001
    imageMap[id] = path;
  }
  return imageMap;
});

List<String> _parseImagePaths(String manifestContent) {
  // 简单解析：提取 "assets/images/*.jpg" 路径
  final regex = RegExp(r'"(assets/images/[^"]+\.jpg)"');
  return regex.allMatches(manifestContent).map((m) => m.group(1)!).toList();
}
