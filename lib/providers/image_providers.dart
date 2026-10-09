// image_providers.dart
// 从 event.dart 拆分：图片相关 Provider。
import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wenshiji/services/image_service.dart';
import 'package:wenshiji/widget/card.dart';

part 'generated/image_providers.g.dart';

@riverpod
ImageService imageService(Ref ref) {
  return ImageService();
}

// 按 id 获取图片路径列表 → 会自动生成 .family 版本
@riverpod
Future<List<String>> savedImagePathsForId(Ref ref, String id) async {
  final service = ref.watch(imageServiceProvider);
  return await service.getSavedImagePathsForId(id);
}

// 按 id 获取图片文件列表 → 自动 .family
@riverpod
Future<List<File>> savedImageFilesForId(Ref ref, String id) async {
  final service = ref.watch(imageServiceProvider);
  return await service.loadImageFilesForId(id);
}

@riverpod
Future<List<CardItem>> getCardItems(Ref ref, String id) async {
  final paths = await ref.watch(savedImagePathsForIdProvider(id).future);
  return paths
      .map(
        (e) =>
            CardItem(id: e.hashCode, name: e, imagePath: e, isUploading: false),
      )
      .toList();
}
