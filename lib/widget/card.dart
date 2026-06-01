import 'dart:io';

import 'package:flutter/material.dart';

class CardItem {
  final int id;
  final String name;
  final String imagePath;
  final bool isUploading;
  double? width;
  double? height;
  CardItem({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.isUploading,
  });
}

class ImageCardWidget extends StatefulWidget {
  final CardItem card;
  final Future<void> Function() onDelete;

  const ImageCardWidget({super.key, required this.card, required this.onDelete});

  @override
  State<ImageCardWidget> createState() => _ImageCardWidgetState();
}

class _ImageCardWidgetState extends State<ImageCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _deleteController;
  bool _isDeleting = false;
  @override
  void initState() {
    super.initState();
    _deleteController = AnimationController(
      duration: const Duration(milliseconds: 420),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _deleteController.dispose();
    super.dispose();
  }

  void _startDelete() {
    if (_isDeleting) return;
    setState(() => _isDeleting = true);
    _deleteController.forward().then((_) async {
      await widget.onDelete();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _deleteController,
      builder: (context, child) {
        if (_isDeleting) {
          final t = _deleteController.value;
          return Transform.scale(
            scale: 1.0 - (0.4 * t),
            child: Transform.rotate(
              angle: t * 0.14,
              child: Opacity(opacity: 1.0 - t, child: child),
            ),
          );
        }
        return child!;
      },
      child: Container(
        width: widget.card.width ?? 64,
        height: widget.card.height ?? 64,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE0E0E0).withOpacity(0.6),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF808080).withOpacity(0.18),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // 图片缩略图
              Positioned.fill(
                child: widget.card.isUploading
                    ? Container(
                        color: Colors.transparent,
                        child: const Center(
                          // child: CircularProgressIndicator(
                          //   strokeWidth: 3,
                          //   valueColor: AlwaysStoppedAnimation<Color>(
                          //     Color(0xFFA0C080),
                          //   ),
                          // ),
                        ),
                      )
                    : Image(
                        image: ResizeImage(
                          FileImage(File(widget.card.imagePath)),
                          width: 100,
                          height: 100,
                        ),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
              ),
              // 顶部上传遮罩
              if (widget.card.isUploading)
                Positioned.fill(
                  child: Container(
                    color: const Color(0xFFF0F0E8).withOpacity(0.85),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFFA0C080),
                            ),
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          '上传中…',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF608040),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          
              if (!widget.card.isUploading)
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: _startDelete,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: const Color(0xFF333333).withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
