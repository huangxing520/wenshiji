import 'package:flutter/material.dart';

/// 备份记录为空时的占位提示。
class BackupEmptyState extends StatelessWidget {
  const BackupEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0D3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.cloud_upload_outlined,
              size: 36,
              color: Color(0xFFF5B041),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '暂无云端备份',
            style: TextStyle(
              fontFamily: 'LXGW WenKai',
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4A3828),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            '点击上方「云端备份」开始首次备份',
            style: TextStyle(fontSize: 13, color: Color(0xFF9E8870), height: 1.6),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

/// 底部确认弹层（用于删除备份等二次确认）。
///
/// [isDanger] 为真时主按钮使用危险色。
class ConfirmSheet extends StatelessWidget {
  const ConfirmSheet({
    super.key,
    required this.title,
    required this.desc,
    required this.confirmText,
    required this.isDanger,
    required this.onConfirm,
    required this.onCancel,
  });

  final String title;
  final String desc;
  final String confirmText;
  final bool isDanger;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: onCancel,
            child: Container(color: const Color(0xFF4A3828).withValues(alpha: 0.45)),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE0D0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4A3828),
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    desc,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF9E8870),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _SheetButton(
                          text: '取消',
                          onTap: onCancel,
                          isPrimary: false,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _SheetButton(
                          text: confirmText,
                          onTap: onConfirm,
                          isPrimary: true,
                          isDanger: isDanger,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SheetButton extends StatelessWidget {
  const _SheetButton({
    required this.text,
    required this.onTap,
    required this.isPrimary,
    this.isDanger = false,
  });

  final String text;
  final VoidCallback onTap;
  final bool isPrimary;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isPrimary
              ? (isDanger ? const Color(0xFFD65A31) : const Color(0xFFF5B041))
              : const Color(0xFFFFFFFF),
          border: isPrimary
              ? null
              : Border.all(color: const Color(0xFFEDE0D0), width: 1.5),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isPrimary ? FontWeight.w700 : FontWeight.w600,
            color: isPrimary ? Colors.white : const Color(0xFF4A3828),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
