import 'package:freezed_annotation/freezed_annotation.dart';
part 'generated/event.freezed.dart';
part 'generated/event.g.dart';

enum EventType {
  @JsonValue(0)
  birthday,
  @JsonValue(1)
  // 倒计时任务
  task,
  @JsonValue(2)
  // 每日签到
  dailySignIn,
  @JsonValue(3)
  holiday
}
enum EventPriority {
  @JsonValue(0)
  high,
  @JsonValue(1)
  mid,
  @JsonValue(2)
  low,
  @JsonValue(3)
  special
}
enum EventReminder {
  @JsonValue(0)
  none,
  @JsonValue(1)
  daily,
  @JsonValue(2)
  weekly,
  @JsonValue(3)
  threeDays,
  @JsonValue(4)
  sevenDays,
  @JsonValue(5)
  fifteenDays,
  @JsonValue(6)
  thirtyDays,
  @JsonValue(7)
  oneHour,
}
enum TaskType {
  @JsonValue(0)
  countdown,
  @JsonValue(1)
  task,
  @JsonValue(2)
  dailySignIn,
  @JsonValue(3)
  holiday
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
      @Default(false) bool checkedToday,
      @Default([EventReminder.none]) List<EventReminder> reminder,
      @Default('') String description,
      @Default([]) List<String> picturePaths,
      @Default([]) List<String> tags,
     }) = _Event;
  factory Event.fromJson(Map<String, Object?> json) => _$EventFromJson(json);
}
