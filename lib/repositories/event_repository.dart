// EventRepository: 领域层访问持久化的入口。
// 薄封装 EventDao，保留 freezed Event 作为领域模型。
// 供 Provider 注入；后台 isolate 不走此处，直接用 AppDatabase。
import 'package:wenshiji/database/event_dao.dart';
import 'package:wenshiji/models/event.dart';

class EventRepository {
  EventRepository(this._dao);
  final EventDao _dao;

  Future<List<Event>> getAllEvents() => _dao.getAllEvents();
  Future<Event?> getEventById(String id) => _dao.getEventById(id);
  Future<void> upsertEvent(Event e) => _dao.upsertEvent(e);
  Future<void> upsertEvents(List<Event> items) => _dao.upsertEvents(items);
  Future<bool> updateExistingEvent(Event e) => _dao.updateExistingEvent(e);
  Future<void> replaceAllEvents(List<Event> items) => _dao.replaceAllEvents(items);
  Future<void> deleteEvent(String id) => _dao.deleteEvent(id);
}
