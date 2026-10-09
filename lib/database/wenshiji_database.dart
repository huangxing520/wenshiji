// Drift (SQLite) 数据库定义：温时记事件持久化层。
// 替换旧的 SharedPreferences 全量 JSON 存储，支持结构化查询与增量读写。
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:wenshiji/common/app_logger.dart';

import 'event_dao.dart';

part 'generated/wenshiji_database.g.dart';

// ====================== 类型转换器 ======================

/// 枚举 ↔ TEXT（存储枚举名，便于人读与跨版本兼容）。
/// 重命名为 SafeEnumNameConverter 以避免与 drift 内置的 EnumNameConverter 冲突；
/// 与 drift 内置版本不同，遇到未知枚举名时回退到 [fallback] 并告警，
/// 而不是回退 `values.first`——后者对 EventPriority 会选中语义最强的 high，
/// 让脏数据被静默提升优先级且不可逆。
class SafeEnumNameConverter<T extends Enum> extends TypeConverter<T, String> {
  const SafeEnumNameConverter(this.values, {required this.fallback});

  final List<T> values;

  /// 未知枚举名时的回退值。由调用方显式指定（通常是语义最弱的值）。
  final T fallback;

  @override
  T fromSql(String fromDb) {
    for (final e in values) {
      if (e.name == fromDb) return e;
    }
    // 脏数据告警：降级应可被发现，而不是静默改写用户数据。
    AppLogger().warning(
      '未知枚举值 "$fromDb"，已降级为 ${fallback.name}',
    );
    return fallback;
  }

  @override
  String toSql(T value) => value.name;
}

/// `List<DateTime>` ↔ TEXT（JSON 数组，元素为自纪元毫秒）。
/// 容错：JSON 损坏或元素类型不符时降级为空列表，避免单行脏数据拖垮整表读取。
class DateTimeListConverter
    extends TypeConverter<List<DateTime>, String> {
  const DateTimeListConverter();
  @override
  List<DateTime> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    try {
      final decoded = jsonDecode(fromDb);
      if (decoded is! List) return [];
      return decoded
          .whereType<num>()
          .map((e) => DateTime.fromMillisecondsSinceEpoch(e.toInt()))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  String toSql(List<DateTime> value) {
    return jsonEncode(value.map((d) => d.millisecondsSinceEpoch).toList());
  }
}

/// `List<String>` ↔ TEXT（JSON 数组）。
/// 容错：JSON 损坏或元素类型不符时降级为空列表。
class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();
  @override
  List<String> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    try {
      final decoded = jsonDecode(fromDb);
      if (decoded is! List) return [];
      return decoded.whereType<String>().toList();
    } catch (_) {
      return [];
    }
  }

  @override
  String toSql(List<String> value) => jsonEncode(value);
}

// ====================== 表定义 ======================

/// 事件表。字段与 freezed Event 模型一一对应。
/// 行类命名为 EventRow，避免与 freezed 领域模型 Event 同名冲突。
@DataClassName('EventRow')
class Events extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get date => integer()(); // 自纪元毫秒
  IntColumn get nextEffectiveTime => integer()();
  TextColumn get type => text()();
  TextColumn get priority => text()();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  BoolColumn get isStarred => boolean().withDefault(const Constant(false))();
  TextColumn get checkinTimes => text().withDefault(const Constant(''))();
  IntColumn get checkinStreakCount =>
      integer().withDefault(const Constant(0))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  /// 归档时间（自纪元毫秒）。null = 未归档。用于「本月归档」等按归档时间统计，
  /// 取代此前误用 nextEffectiveTime 的做法。
  IntColumn get archivedAt => integer().nullable()();
  /// 是否农历日期。
  BoolColumn get isLunar => boolean().withDefault(const Constant(false))();
  TextColumn get repeatRule => text().withDefault(const Constant('none'))();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get picturePaths => text().withDefault(const Constant(''))();
  TextColumn get tags => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

// ====================== 数据库 ======================

@DriftDatabase(
  tables: [Events],
  daos: [EventDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  // 仅供测试注入。
  AppDatabase.forTesting(super.e);

  /// 当前 schema 版本。
  /// **约束：任何新增 / 修改列都必须同步 bump 此值，并在 [migration] 的
  /// onUpgrade 中补对应的 addColumn / alterTable，否则老用户升级后会因缺列
  /// 抛 `no such column`（且 drift 只看 user_version，不会自动补列）。
  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      // 全新安装：直接按最新 schema 建表。
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      // 逐版本迁移，禁止 drop table 兜底（会丢用户数据）。
      if (from < 2) {
        // v1 -> v2：新增 archivedAt（可空列，历史数据置 null 即「未归档」）。
        await m.addColumn(events, events.archivedAt);
      }
      if (from < 3) {
        // v2 -> v3：新增 isLunar（带默认值 false，历史数据均为公历）。
        await m.addColumn(events, events.isLunar);
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'wenshiji.sqlite'));
    return NativeDatabase.createInBackground(
      file,
      // setup 在连接建立后、drift 就绪前执行；此闭包不捕获任何变量，
      // 可安全地随 setup 一起发送到后台 isolate 运行。
      //
      // 同一个 wenshiji.sqlite 会被多处独立打开（主 isolate 的 ProviderScope、
      // 后台 WorkManager isolate 的 Utils.getDailyNotificationContent）。
      // SQLite 默认的 rollback journal 模式禁止读写并发，两处同时访问会抛
      // `database is locked`；改用 WAL 允许一写多读，并用 busy_timeout 让锁等待
      // 而非立即失败。synchronous=NORMAL 在 WAL 下兼顾安全与写入性能。
      setup: (db) {
        db.execute('PRAGMA journal_mode = WAL;');
        db.execute('PRAGMA busy_timeout = 5000;');
        db.execute('PRAGMA synchronous = NORMAL;');
      },
    );
  });
}
