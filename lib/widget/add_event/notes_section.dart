import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wenshiji/providers/event.dart';
import 'package:wenshiji/widget/card.dart';

/// 备注输入 + 已选图片网格。
///
/// [eventId] 为图片所属 id（新建时为预生成 uuid，编辑时为原事件 id）。
/// 图片列表通过 [getCardItemsProvider] 监听，删除由 [onDeleteImage] 回调处理。
class NotesSection extends ConsumerWidget {
  const NotesSection({
    super.key,
    required this.eventId,
    required this.notesController,
    required this.onDeleteImage,
    required this.onPickImages,
    required this.surfaceColor,
    required this.accentSoftColor,
    required this.accentDeepColor,
    required this.borderColor,
    required this.fgColor,
    required this.mutedColor,
  });

  final String eventId;
  final TextEditingController notesController;
  final Future<void> Function(int index) onDeleteImage;
  final Future<void> Function() onPickImages;
  final Color surfaceColor;
  final Color accentSoftColor;
  final Color accentDeepColor;
  final Color borderColor;
  final Color fgColor;
  final Color mutedColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardItemsAsync = ref.watch(getCardItemsProvider(eventId));
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              '备注',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: mutedColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor, width: 1.5),
              color: surfaceColor,
            ),
            child: TextField(
              controller: notesController,
              maxLines: null,
              minLines: 4,
              style: TextStyle(fontSize: 15, color: fgColor, height: 1.6),
              decoration: InputDecoration(
                hintText: '记录一些想说的话…',
                hintStyle: TextStyle(color: mutedColor),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          cardItemsAsync.when(
            loading: () => const CircularProgressIndicator(),
            error: (err, stack) => Text('Error: $err'),
            data: (imagePaths) => Wrap(
              runSpacing: 12,
              spacing: 12,
              crossAxisAlignment: WrapCrossAlignment.end,
              runAlignment: WrapAlignment.end,
              children: [
                ...imagePaths.map(
                  (e) => ImageCardWidget(
                    key: Key(e.imagePath),
                    card: e,
                    onDelete: () async {
                      await onDeleteImage(imagePaths.indexOf(e));
                    },
                  ),
                ),
                AddImageThumb(
                  borderColor: borderColor,
                  accentSoftColor: accentSoftColor,
                  accentDeepColor: accentDeepColor,
                  onTap: onPickImages,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 图片网格末尾的「添加」占位块。
class AddImageThumb extends StatelessWidget {
  const AddImageThumb({
    super.key,
    required this.borderColor,
    required this.accentSoftColor,
    required this.accentDeepColor,
    required this.onTap,
  });

  final Color borderColor;
  final Color accentSoftColor;
  final Color accentDeepColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: borderColor,
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: Icon(Icons.add, color: accentDeepColor, size: 24),
      ),
    );
  }
}
