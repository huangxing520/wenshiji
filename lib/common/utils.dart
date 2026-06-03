import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hyper_snackbar/hyper_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wenshiji/constants/config_constant.dart';

class Utils {
  static Utils? _instance;
  Utils._internal();
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

  void showToast(String? label, String? message) {
    HyperSnackbar.show(
      title: label,
      message: message,
      icon: Icon(Icons.notification_important, color: Colors.white),
      backgroundColor: const Color.fromARGB(255, 132, 129, 129),
      enterAnimationType: HyperSnackAnimationType.scale,
      enterCurve: Curves.elasticOut,
      enterAnimationDuration: const Duration(milliseconds: 500),
      displayDuration: Duration(milliseconds: 500),

      maxWidth: 300,
    );
  }

  void showErrorToast(String? label, String? message) {
    HyperSnackbar.show(
      title: label,
      message: message,
      backgroundColor: const Color.fromARGB(255, 224, 7, 7),
      icon: Icon(Icons.error, color: Colors.white),
      enterAnimationType: HyperSnackAnimationType.scale,
      enterCurve: Curves.easeOut,
      enterAnimationDuration: const Duration(milliseconds: 500),
      displayDuration: Duration(milliseconds: 500),

      maxWidth: 300,
    );
  }

  Future<String?> getVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String version = packageInfo.version;
    final String buildNumber = packageInfo.buildNumber;
    return version;
  }

  Future<void> launchInBrowser(String url) async {
    try {
      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
     Utils().showErrorToast('打开失败', '无法打开链接，请检查网络或安装浏览器');
      
    }
  }
}
