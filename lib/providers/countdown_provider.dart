import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/event.dart';

final eventNotifierProvider = StateNotifierProvider<EventNotifier, AsyncValue<List<Event>>>((ref) {
  return EventNotifier();
});

class EventNotifier extends StateNotifier<AsyncValue<List<Event>>> {
  EventNotifier() : super(const AsyncLoading()) {
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? data = prefs.getString('events');
      if (data != null) {
        final List<dynamic> jsonList = json.decode(data);
        final events = jsonList.map((json) => Event.fromJson(json as Map<String, dynamic>)).toList();
        state = AsyncData(events);
      } else {
        state = AsyncData(_getSampleEvents());
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('加载事件数据失败: $e');
      }
      state = AsyncError(e, stackTrace);
    }
  }

  List<Event> _getSampleEvents() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return [
      Event(
        id: '1',
        name: '妈妈生日',
        date: today.add(const Duration(days: 3)),
        type: EventType.birthday,
        priority: EventPriority.high,
        isPinned: true,
        isStarred: true,
      ),
      Event(
        id: '2',
        name: '项目一期交付',
        date: today.add(const Duration(days: 1)),
        type: EventType.task,
        priority: EventPriority.high,
      ),
      Event(
        id: '3',
        name: '戒烟',
        date: DateTime(2025, 3, 8),
        type: EventType.countup,
        priority: EventPriority.mid,
        isStarred: true,
        hasCheckin: true,
        streak: 12,
        checkedToday: true,
      ),
      Event(
        id: '4',
        name: '每日冥想',
        date: DateTime(2025, 6, 15),
        type: EventType.countup,
        priority: EventPriority.mid,
        hasCheckin: true,
      ),
      Event(
        id: '5',
        name: '小李生日',
        date: today.add(const Duration(days: 7)),
        type: EventType.birthday,
        priority: EventPriority.mid,
      ),
      Event(
        id: '6',
        name: '健身卡续费',
        date: today.add(const Duration(days: 5)),
        type: EventType.task,
        priority: EventPriority.low,
      ),
      Event(
        id: '7',
        name: '和小雨在一起',
        date: DateTime(2024, 11, 20),
        type: EventType.countup,
        priority: EventPriority.high,
        isStarred: true,
        hasCheckin: true,
        streak: 45,
        checkedToday: true,
      ),
      // Event(
      //   id: '8',
      //   name: '国庆节',
      //   date: today.add(const Duration(days: 18)),
      //   type: EventType.holiday,
      //   priority: EventPriority.mid,
      // ),
      Event(
        id: '9',
        name: '老王生日',
        date: today,
        type: EventType.birthday,
        priority: EventPriority.mid,
        isStarred: true,
      ),
      Event(
        id: '10',
        name: '日语N2备考',
        date: DateTime(2025, 5, 1),
        type: EventType.countup,
        priority: EventPriority.mid,
        hasCheckin: true,
        streak: 2,
        checkedToday: true,
      ),
    ];
  }

  Future<void> _saveEvents(List<Event> events) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> jsonList = 
          events.map((e) => e.toJson()).toList();
      await prefs.setString('events', json.encode(jsonList));
    } catch (e) {
      if (kDebugMode) {
        print('保存事件数据失败: $e');
      }
    }
  }

  void addEvent(Event event) {
    state.whenData((currentEvents) {
      final updatedEvents = [...currentEvents, event];
      state = AsyncData(updatedEvents);
      _saveEvents(updatedEvents);
    });
  }

  void updateEvent(String id, Event updated) {
    state.whenData((currentEvents) {
      final updatedEvents = currentEvents.map((e) => e.id == id ? updated : e).toList();
      state = AsyncData(updatedEvents);
      _saveEvents(updatedEvents);
    });
  }

  void deleteEvent(String id) {
    state.whenData((currentEvents) {
      final updatedEvents = currentEvents.where((e) => e.id != id).toList();
      state = AsyncData(updatedEvents);
      _saveEvents(updatedEvents);
    });
  }

  void togglePin(String id) {
    state.whenData((currentEvents) {
      final updatedEvents = currentEvents.map((e) {
        if (e.id == id) {
          return e.copyWith(isPinned: !e.isPinned);
        }
        return e;
      }).toList();
      state = AsyncData(updatedEvents);
      _saveEvents(updatedEvents);
    });
  }

  void toggleStar(String id) {
    state.whenData((currentEvents) {
      final updatedEvents = currentEvents.map((e) {
        if (e.id == id) {
          return e.copyWith(isStarred: !e.isStarred);
        }
        return e;
      }).toList();
      state = AsyncData(updatedEvents);
      _saveEvents(updatedEvents);
    });
  }

  void quickCheckin(String id) {
    state.whenData((currentEvents) {
      final updatedEvents = currentEvents.map((e) {
        if (e.id == id && e.hasCheckin && !e.checkedToday) {
          return e.copyWith(checkedToday: true, streak: e.streak + 1);
        }
        return e;
      }).toList();
      state = AsyncData(updatedEvents);
      _saveEvents(updatedEvents);
    });
  }
}

enum EventCategory { all, birthday, task, countup, star, holiday }

final selectedCategoryProvider = StateProvider<EventCategory>((ref) => EventCategory.all);

final filteredEventsProvider = Provider<List<Event>>((ref) {
  final eventsState = ref.watch(eventNotifierProvider);
  final category = ref.watch(selectedCategoryProvider);
  
  return eventsState.when(
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
        case EventCategory.countup:
          filtered = events.where((e) => e.type == EventType.countup).toList();
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
        
        final aDays = a.type == EventType.countup 
            ? today.difference(a.date).inDays
            : a.date.difference(today).inDays;
        final bDays = b.type == EventType.countup 
            ? today.difference(b.date).inDays
            : b.date.difference(today).inDays;
        
        return a.type == EventType.countup ? bDays.compareTo(aDays) : aDays.compareTo(bDays);
      });
      
      return filtered;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

final statsProvider = Provider<Map<String, int>>((ref) {
  final events = ref.watch(filteredEventsProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final threeDaysLater = today.add(const Duration(days: 3));
  
  final todayCount = events.where((e) => 
    e.type != EventType.countup && 
    e.date.year == today.year && 
    e.date.month == today.month && 
    e.date.day == today.day
  ).length;
  
  final upcomingCount = events.where((e) => 
    e.type != EventType.countup && 
    e.date.isAfter(today.subtract(const Duration(days: 1))) &&
    e.date.isBefore(threeDaysLater.add(const Duration(days: 1)))
  ).length;
  
  final countupCount = events.where((e) => e.type == EventType.countup).length;
  
  return {
    'today': todayCount,
    'upcoming': upcomingCount,
    'countup': countupCount,
  };
});
