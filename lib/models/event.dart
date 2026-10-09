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
  yearly;

  /// 安全解析：未知名称回退 [RepeatRule.none]，不抛异常。
  /// 不要用 `values.byName`（遇未知值会抛）。
  static RepeatRule fromName(String? name) {
    if (name == null) return RepeatRule.none;
    for (final v in RepeatRule.values) {
      if (v.name == name) return v;
    }
    return RepeatRule.none;
  }
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
      /// 是否归档
      @Default(false) bool isArchived,
      /// 归档时间；null 表示未归档
      DateTime? archivedAt,
      /// 日期是否为农历。true 时 [date] 仍是农历对应的公历日，
      /// 但周年前滚按农历月/日计算（见 Utils.nextEffectiveOf）。
      @Default(false) bool isLunar,
      /// 重复规则
      @Default(RepeatRule.none) RepeatRule repeatRule,
      @Default('') String description,
      @Default([]) List<String> picturePaths,
      @Default([]) List<String> tags,
     }) = _Event;
  factory Event.fromJson(Map<String, Object?> json) => _$EventFromJson(json);
}
