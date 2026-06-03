// event_provider.dart
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wenshiji/common/picture_service.dart';
import 'package:wenshiji/widget/card.dart';
import 'dart:convert';
import '../common/preferences.dart';
import '../models/event.dart';

part 'generated/event.g.dart';

enum EventCategory { all, birthday, task, dailySignIn, star, holiday }

// ==================== 1. 核心事件管理（AsyncNotifier） ====================
/// 自动生成 provider 名称为 eventNotifierProvider
@riverpod
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
        return _getSampleEvents();
      }
    } catch (e) {
      if (kDebugMode) print('加载事件数据失败: $e');
      // 如果加载失败，可以抛出一个自定义异常，让 AsyncNotifier 进入 error 状态
      throw Exception('加载失败: $e');
    }
  }

  List<Event> _getSampleEvents() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return [
      // ========== birthday 生日类型 ==========
      Event(
        id: '1',
        name: '妈妈生日',
        date: today.add(const Duration(days: 3)),
        type: EventType.birthday,
        priority: EventPriority.high,
        isPinned: true,
        isStarred: true,
        description: '记得准备礼物和蛋糕',
        reminder: [EventReminder.daily, EventReminder.sevenDays],
      ),
      Event(
        id: '2',
        name: '爸爸生日',
        date: today.add(const Duration(days: 30)),
        type: EventType.birthday,
        priority: EventPriority.mid,
        isStarred: true,
        description: '提前准备礼物',
      ),
      Event(
        id: '3',
        name: '好朋友小明生日',
        date: today.add(const Duration(days: 15)),
        type: EventType.birthday,
        priority: EventPriority.low,
      ),

      // ========== task 倒计时任务类型 ==========
      Event(
        id: '4',
        name: '期末考试',
        date: today.add(const Duration(days: 20)),
        type: EventType.task,
        priority: EventPriority.high,
        isPinned: true,
        description: '高等数学期末考试',
        reminder: [EventReminder.sevenDays, EventReminder.threeDays],
      ),
      Event(
        id: '5',
        name: '项目截止日期',
        date: today.add(const Duration(days: 7)),
        type: EventType.task,
        priority: EventPriority.high,
        isStarred: true,
        description: '完成Flutter项目开发',
      ),
      Event(
        id: '6',
        name: '健身计划',
        date: today.add(const Duration(days: 60)),
        type: EventType.task,
        priority: EventPriority.mid,
        description: '坚持健身60天',
      ),

      // ========== dailySignIn 每日签到类型 ==========
      Event(
        id: '7',
        name: '每日背单词',
        date: today.subtract(const Duration(days: 10)),
        type: EventType.dailySignIn,
        priority: EventPriority.mid,
        hasCheckin: true,
        streak: 10,
        checkedToday: false,
        description: '每天背50个单词',
      ),
      Event(
        id: '8',
        name: '每日运动',
        date: today.subtract(const Duration(days: 5)),
        type: EventType.dailySignIn,
        priority: EventPriority.high,
        hasCheckin: true,
        streak: 5,
        checkedToday: true,
        isStarred: true,
        description: '每天运动30分钟',
      ),
      Event(
        id: '9',
        name: '每日阅读',
        date: today.subtract(const Duration(days: 20)),
        type: EventType.dailySignIn,
        priority: EventPriority.low,
        hasCheckin: true,
        streak: 20,
        checkedToday: false,
        description: '每天阅读1小时',
      ),

      // ========== holiday 节日类型 ==========
      Event(
        id: '10',
        name: '春节',
        date: DateTime(now.year + 1, 1, 1),
        type: EventType.holiday,
        priority: EventPriority.special,
        isPinned: true,
        isStarred: true,
        description: '农历新年',
      ),
      Event(
        id: '11',
        name: '中秋节',
        date: DateTime(now.year, 9, 15),
        type: EventType.holiday,
        priority: EventPriority.special,
        isStarred: true,
        description: '团圆节',
      ),
      Event(
        id: '12',
        name: '国庆节',
        date: DateTime(now.year, 10, 1),
        type: EventType.holiday,
        priority: EventPriority.high,
        description: '祖国生日',
      ),
    ];
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
    final updatedEvents = _currentEvents.map((e) {
      if (e.id == id && e.hasCheckin && !e.checkedToday) {
        return e.copyWith(checkedToday: true, streak: e.streak + 1);
      }
      return e;
    }).toList();
    state = AsyncValue.data(updatedEvents);
    await _saveEvents(updatedEvents);
  }

  // 3. 业务优化：每日重置打卡状态（必须加，否则第二天无法打卡）
  Future<void> resetDailyCheckin() async {
    final updatedEvents = _currentEvents
        .map((e) => e.copyWith(checkedToday: false))
        .toList();
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
// @riverpod
// final imageServiceProvider = Provider<ImageService>((ref) {
//   return ImageService();
// });

// // 保存的图片路径列表（异步）
// final savedImagePathsProvider = FutureProvider<List<String>>((ref) async {
//   final service = ref.watch(imageServiceProvider);
//   return await service.getSavedImagePaths();
// });

// // 保存的图片文件列表（异步）
// final savedImageFilesProvider = FutureProvider<List<File>>((ref) async {
//   final service = ref.watch(imageServiceProvider);
//   return await service.loadImageFiles();
// });
// 普通的单例 Provider
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
