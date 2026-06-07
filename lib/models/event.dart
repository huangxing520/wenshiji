import 'package:freezed_annotation/freezed_annotation.dart';
part 'generated/event.freezed.dart';
part 'generated/event.g.dart';

enum EventType {
  // 生日
  @JsonValue(0)
  birthday,
  @JsonValue(1)
  // 倒计时任务
  task,
  @JsonValue(2)
  // 每日签到
  dailySignIn,
  @JsonValue(3)
  // 节假日
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
// enum EventReminder {
//   @JsonValue(0)
//   none,
//   @JsonValue(1)
//   daily,
//   @JsonValue(2)
//   weekly,
//   @JsonValue(3)
//   threeDays,
//   @JsonValue(4)
//   sevenDays,
//   @JsonValue(5)
//   fifteenDays,
//   @JsonValue(6)
//   thirtyDays,
//   @JsonValue(7)
//   oneHour,
// }
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
enum RepeatRule {
  @JsonValue(0)
  none,
  @JsonValue(1)
  daily,
  @JsonValue(2)
  weekly,
  @JsonValue(3)
  monthly,
  @JsonValue(4)
  yearly,
}
@freezed
abstract class Event with _$Event {
  factory Event(
      {required String id,
      required String name,
      /// 创建事件日期
      required DateTime date,
      /// 下次生效事件时间
      required DateTime nextEffectiveTime,
      /// 事件类型
      required EventType type,
      /// 事件优先级
      @Default(EventPriority.mid) EventPriority priority,
      /// 是否置顶
      @Default(false) bool isPinned,
      /// 是否收藏
      @Default(false) bool isStarred,
      /// 打卡时间
      @Default([]) List<DateTime> checkinTimes,
      /// 连续打卡天数
      @Default(0) int checkinStreakCount,
      /// 重复规则
      @Default(RepeatRule.none) RepeatRule repeatRule,
      @Default('') String description,
      @Default([]) List<String> picturePaths,
      @Default([]) List<String> tags,
     }) = _Event;
  factory Event.fromJson(Map<String, Object?> json) => _$EventFromJson(json);
}
