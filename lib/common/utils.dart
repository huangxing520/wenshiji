import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:wenshiji/constants/config_constant.dart';

class Utils {
  static ImagePicker? _picker;
  static Utils? _instance;
  Utils._internal() {}
  factory Utils() {
    _instance ??= Utils._internal();
    return _instance!;
  }
  static Season getSeason(DateTime time) {
    switch (time.month) {
      case 3 || 4 || 5:
        return Season.spring;
      case 6 || 7 || 8:
        return Season.summer;
      case 9 || 10 || 11:
        return Season.autumn;
      case 12 || 1 || 2:
        return Season.winter;
      default:
        return Season.spring;
    }
  }

 // 选择多张图片的函数
static Future<List<File>?> pickMultipleImages({
  double? maxWidth,
  double? maxHeight,
  int? imageQuality, // 范围 0-100
}) async {
  try {
    final ImagePicker picker = ImagePicker();
    
    // 调用多图选择方法
    final List<XFile>? pickedFiles = await picker.pickMultiImage(
      maxWidth: maxWidth,      // 可选：限制最大宽度
      maxHeight: maxHeight,    // 可选：限制最大高度
      imageQuality: imageQuality, // 可选：压缩质量
    );
    
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      // 将 XFile 列表转换为 File 列表
      return pickedFiles.map((xfile) => File(xfile.path)).toList();
    }
    
    return null; // 用户取消选择
  } catch (e) {
    print('选择图片失败: $e');
    return null;
  }
}

  // 方法：调用相机拍摄一张照片
  static Future<String?> _takePhoto() async {
     _picker ??= ImagePicker();
    try {
      final XFile? pickedFile = await _picker!.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (pickedFile != null) {
       return pickedFile.path;
      } else {
        print('用户取消了拍照');
      }
    } catch (e) {
      print('拍照时出错: $e');
    }
  }
}
