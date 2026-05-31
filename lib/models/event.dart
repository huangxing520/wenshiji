import 'package:freezed_annotation/freezed_annotation.dart';
part 'generated/event.freezed.dart';
part 'generated/event.g.dart';

enum EventType {
  @JsonValue(0)
  birthday,
  @JsonValue(1)
  task,
  @JsonValue(2)
  countup,
  @JsonValue(3)
  holiday
}
enum EventPriority {
  @JsonValue(0)
  high,
  @JsonValue(1)
  mid,
  @JsonValue(2)
  low
}

@freezed
abstract class Event with _$Event {
  factory Event(
      {required String id,
      required String name,
      required DateTime date,
      required EventType type,
      @Default(EventPriority.mid) EventPriority priority,
      @Default(false) bool isPinned,
      @Default(false) bool isStarred,
      @Default(false) bool hasCheckin,
      @Default(0) int streak,
      @Default(false) bool checkedToday}) = _Event;
  factory Event.fromJson(Map<String, Object?> json) => _$EventFromJson(json);
}
