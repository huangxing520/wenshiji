// image_service.dart
import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  // 为每个 id 生成独立的存储 key
   String _getKey(String id) => 'saved_images_$id';

  // 获取应用文档目录
   Future<Directory> _getAppDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  // 为指定 id 选择多张图片并保存到本地，返回新增的路径列表
   Future<List<String>> pickAndSaveMultipleImagesForId(String id) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();
    if (pickedFiles == null || pickedFiles.isEmpty) return [];

    final List<String> savedPaths = [];
    final Directory appDir = await _getAppDirectory();

    for (XFile pickedFile in pickedFiles) {
      try {
        final File originalFile = File(pickedFile.path);
        // 文件名包含 id 和时间戳，避免冲突
        final String fileName =
            '${id}_${DateTime.now().millisecondsSinceEpoch}_${path.basename(pickedFile.path)}';
        final String newPath = '${appDir.path}/$fileName';
        final File savedImage = await originalFile.copy(newPath);
        savedPaths.add(savedImage.path);
      } catch (e) {
        print('保存图片失败: $e');
      }
    }

    // 合并现有列表
    final existing = await getSavedImagePathsForId(id);
    final newList = [...existing, ...savedPaths];
    await saveImagePathsForId(id, newList);
    return savedPaths;
  }

  // 保存指定 id 的图片路径列表
   Future<void> saveImagePathsForId(String id, List<String> paths) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(paths);
    await prefs.setString(_getKey(id), jsonString);
  }

  // 获取指定 id 的图片路径列表
   Future<List<String>> getSavedImagePathsForId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_getKey(id));
    if (jsonString == null) return [];
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.cast<String>();
    } catch (e) {
      return [];
    }
  }

  // 加载指定 id 的图片文件列表（仅返回存在的文件）
   Future<List<File>> loadImageFilesForId(String id) async {
    final paths = await getSavedImagePathsForId(id);
    final List<File> files = [];
    for (String p in paths) {
      final File file = File(p);
      if (await file.exists()) {
        files.add(file);
      }
    }
    return files;
  }

  // 删除指定 id 中的某张图片（同时删除物理文件）
   Future<void> deleteImageAtIndexForId(String id, int index) async {
    final paths = await getSavedImagePathsForId(id);
    if (index >= 0 && index < paths.length) {
      final pathToDelete = paths[index];
      final file = File(pathToDelete);
      if (await file.exists()) {
        await file.delete();
      }
      paths.removeAt(index);
      await saveImagePathsForId(id, paths);
    }
  }

  // 删除指定 id 的所有图片（物理文件 + 记录）
   Future<void> deleteAllImagesForId(String id) async {
    final paths = await getSavedImagePathsForId(id);
    for (String p in paths) {
      final file = File(p);
      if (await file.exists()) await file.delete();
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_getKey(id));
  }
}