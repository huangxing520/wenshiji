// event_provider.dart
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wenshiji/common/picture_service.dart';
import 'package:wenshiji/common/utils.dart';
import 'package:wenshiji/widget/card.dart';
import 'dart:convert';
import '../common/preferences.dart';
import '../models/event.dart';

part 'generated/event.g.dart';

enum EventCategory { all, birthday, task, dailySignIn, star, holiday }

// ==================== 1. 核心事件管理（AsyncNotifier） ====================
/// 自动生成 provider 名称为 eventNotifierProvider
@Riverpod(keepAlive: true)
class EventNotifier extends _$EventNotifier {
  /// 初始化加载（相当于原来的 _loadEvents）
  @override
  Future<List<Event>> build() async {
    return _loadEvents();
  }

  List<Event> get _currentEvents {
    return state.value ?? [];
  }

  Future<List<Event>> _loadEvents() async {
    try {
      final events = await preferences.getEvents();
      if (events.isNotEmpty) {
        return events;
      } else {
        //todo
        return Utils().getSampleEvents();
      }
    } catch (e) {
      if (kDebugMode) print('加载事件数据失败: $e');
      // 如果加载失败，可以抛出一个自定义异常，让 AsyncNotifier 进入 error 状态
      throw Exception('加载失败: $e');
    }
  }

  

  // 保存到本地（异步，不阻塞状态更新）
  Future<void> _saveEvents(List<Event> events) async {
    try {
      final List<Map<String, dynamic>> jsonList = events
          .map((e) => e.toJson())
          .toList();
      await preferences.setEvents(json.encode(jsonList));
    } catch (e) {
      if (kDebugMode) print('保存事件数据失败: $e');
    }
  }

  // 增删改查方法（操作 state 自动触发 UI 重建）
  Future<void> addEvent(Event event) async {
    final updatedEvents = [..._currentEvents, event];
    print(updatedEvents);
    state = AsyncValue.data(updatedEvents); // 正确赋值状态
    await _saveEvents(updatedEvents);
  }

  Future<void> updateEvent(String id, Event updated) async {
    final updatedEvents = _currentEvents
        .map((e) => e.id == id ? updated : e)
        .toList();
    state = AsyncValue.data(updatedEvents);
    await _saveEvents(updatedEvents);
  }

  // 删除事件
  Future<void> deleteEvent(String id) async {
    final updatedEvents = _currentEvents.where((e) => e.id != id).toList();
    state = AsyncValue.data(updatedEvents);
    await _saveEvents(updatedEvents);
  }

  // 切换置顶
  Future<void> togglePin(String id) async {
    final updatedEvents = _currentEvents.map((e) {
      return e.id == id ? e.copyWith(isPinned: !e.isPinned) : e;
    }).toList();
    state = AsyncValue.data(updatedEvents);
    await _saveEvents(updatedEvents);
  }

  // 切换收藏
  Future<void> toggleStar(String id) async {
    final updatedEvents = _currentEvents.map((e) {
      return e.id == id ? e.copyWith(isStarred: !e.isStarred) : e;
    }).toList();
    state = AsyncValue.data(updatedEvents);
    await _saveEvents(updatedEvents);
  }

  // 快速打卡（修复空安全，保留业务逻辑）
  Future<void> quickCheckin(String id) async {
    final today = DateTime.now().toLocal();
    final updatedEvents = _currentEvents.map((e) {
      if (e.id == id && !Utils().hasToday(e.checkinTimes)) {
        return e.copyWith(
          checkinTimes: [
            ...e.checkinTimes,
            DateTime(today.year, today.month, today.day),
          ],
          checkinStreakCount: e.checkinTimes.length + 1,
        );
      }
      return e;
    }).toList();
    state = AsyncValue.data(updatedEvents);
    await _saveEvents(updatedEvents);
  }
}

// ==================== 2. 分类选择（可修改状态 Notifier） ====================
@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  EventCategory build() => EventCategory.all;

  void setCategory(EventCategory category) => state = category;
}

// ==================== 3. 派生 Provider：过滤 & 排序 ====================
@riverpod
List<Event> filteredEvents(Ref ref) {
  // 监听异步状态 - AsyncNotifierProvider 返回的是 AsyncValue<List<Event>>
  final eventsAsync = ref.watch(eventProvider);
  final category = ref.watch(selectedCategoryProvider); // 自动生成的 provider 名称

  return eventsAsync.when(
    data: (events) {
      List<Event> filtered;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      switch (category) {
        case EventCategory.all:
          filtered = events;
          break;
        case EventCategory.birthday:
          filtered = events.where((e) => e.type == EventType.birthday).toList();
          break;
        case EventCategory.task:
          filtered = events.where((e) => e.type == EventType.task).toList();
          break;
        case EventCategory.dailySignIn:
          filtered = events
              .where((e) => e.type == EventType.dailySignIn)
              .toList();
          break;
        case EventCategory.star:
          filtered = events.where((e) => e.isStarred).toList();
          break;
        case EventCategory.holiday:
          filtered = events.where((e) => e.type == EventType.holiday).toList();
          break;
      }

      filtered.sort((a, b) {
        if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;
        final aDays = a.type == EventType.dailySignIn
            ? today.difference(a.date).inDays
            : a.date.difference(today).inDays;
        final bDays = b.type == EventType.dailySignIn
            ? today.difference(b.date).inDays
            : b.date.difference(today).inDays;
        return a.type == EventType.dailySignIn
            ? bDays.compareTo(aDays)
            : aDays.compareTo(bDays);
      });
      return filtered;
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

// ==================== 4. 派生 Provider：统计信息 ====================
@riverpod
Map<String, int> stats(Ref ref) {
  final events = ref.watch(filteredEventsProvider); // 注意自动生成的名称
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final threeDaysLater = today.add(const Duration(days: 3));

  final todayCount = events
      .where(
        (e) =>
            e.type != EventType.dailySignIn &&
            e.date.year == today.year &&
            e.date.month == today.month &&
            e.date.day == today.day,
      )
      .length;

  final upcomingCount = events
      .where(
        (e) =>
            e.type != EventType.dailySignIn &&
            e.date.isAfter(today.subtract(const Duration(days: 1))) &&
            e.date.isBefore(threeDaysLater.add(const Duration(days: 1))),
      )
      .length;

  final dailySignInCount = events
      .where((e) => e.type == EventType.dailySignIn)
      .length;

  return {
    'today': todayCount,
    'upcoming': upcomingCount,
    'dailySignIn': dailySignInCount,
  };
}

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
