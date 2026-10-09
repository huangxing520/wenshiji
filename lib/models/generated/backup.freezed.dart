// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../backup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BackupRecord {

 String get id; String get timeStr; String get fileName; String get serverUrl; String get backupDirectory; String get size; int get eventCount;
/// Create a copy of BackupRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupRecordCopyWith<BackupRecord> get copyWith => _$BackupRecordCopyWithImpl<BackupRecord>(this as BackupRecord, _$identity);

  /// Serializes this BackupRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.timeStr, timeStr) || other.timeStr == timeStr)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.serverUrl, serverUrl) || other.serverUrl == serverUrl)&&(identical(other.backupDirectory, backupDirectory) || other.backupDirectory == backupDirectory)&&(identical(other.size, size) || other.size == size)&&(identical(other.eventCount, eventCount) || other.eventCount == eventCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,timeStr,fileName,serverUrl,backupDirectory,size,eventCount);

@override
String toString() {
  return 'BackupRecord(id: $id, timeStr: $timeStr, fileName: $fileName, serverUrl: $serverUrl, backupDirectory: $backupDirectory, size: $size, eventCount: $eventCount)';
}


}

/// @nodoc
abstract mixin class $BackupRecordCopyWith<$Res>  {
  factory $BackupRecordCopyWith(BackupRecord value, $Res Function(BackupRecord) _then) = _$BackupRecordCopyWithImpl;
@useResult
$Res call({
 String id, String timeStr, String fileName, String serverUrl, String backupDirectory, String size, int eventCount
});




}
/// @nodoc
class _$BackupRecordCopyWithImpl<$Res>
    implements $BackupRecordCopyWith<$Res> {
  _$BackupRecordCopyWithImpl(this._self, this._then);

  final BackupRecord _self;
  final $Res Function(BackupRecord) _then;

/// Create a copy of BackupRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? timeStr = null,Object? fileName = null,Object? serverUrl = null,Object? backupDirectory = null,Object? size = null,Object? eventCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,timeStr: null == timeStr ? _self.timeStr : timeStr // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,serverUrl: null == serverUrl ? _self.serverUrl : serverUrl // ignore: cast_nullable_to_non_nullable
as String,backupDirectory: null == backupDirectory ? _self.backupDirectory : backupDirectory // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as String,eventCount: null == eventCount ? _self.eventCount : eventCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BackupRecord].
extension BackupRecordPatterns on BackupRecord {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackupRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackupRecord() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackupRecord value)  $default,){
final _that = this;
switch (_that) {
case _BackupRecord():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackupRecord value)?  $default,){
final _that = this;
switch (_that) {
case _BackupRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String timeStr,  String fileName,  String serverUrl,  String backupDirectory,  String size,  int eventCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackupRecord() when $default != null:
return $default(_that.id,_that.timeStr,_that.fileName,_that.serverUrl,_that.backupDirectory,_that.size,_that.eventCount);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String timeStr,  String fileName,  String serverUrl,  String backupDirectory,  String size,  int eventCount)  $default,) {final _that = this;
switch (_that) {
case _BackupRecord():
return $default(_that.id,_that.timeStr,_that.fileName,_that.serverUrl,_that.backupDirectory,_that.size,_that.eventCount);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String timeStr,  String fileName,  String serverUrl,  String backupDirectory,  String size,  int eventCount)?  $default,) {final _that = this;
switch (_that) {
case _BackupRecord() when $default != null:
return $default(_that.id,_that.timeStr,_that.fileName,_that.serverUrl,_that.backupDirectory,_that.size,_that.eventCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BackupRecord implements BackupRecord {
  const _BackupRecord({required this.id, required this.timeStr, required this.fileName, required this.serverUrl, required this.backupDirectory, required this.size, required this.eventCount});
  factory _BackupRecord.fromJson(Map<String, dynamic> json) => _$BackupRecordFromJson(json);

@override final  String id;
@override final  String timeStr;
@override final  String fileName;
@override final  String serverUrl;
@override final  String backupDirectory;
@override final  String size;
@override final  int eventCount;

/// Create a copy of BackupRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupRecordCopyWith<_BackupRecord> get copyWith => __$BackupRecordCopyWithImpl<_BackupRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BackupRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.timeStr, timeStr) || other.timeStr == timeStr)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.serverUrl, serverUrl) || other.serverUrl == serverUrl)&&(identical(other.backupDirectory, backupDirectory) || other.backupDirectory == backupDirectory)&&(identical(other.size, size) || other.size == size)&&(identical(other.eventCount, eventCount) || other.eventCount == eventCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,timeStr,fileName,serverUrl,backupDirectory,size,eventCount);

@override
String toString() {
  return 'BackupRecord(id: $id, timeStr: $timeStr, fileName: $fileName, serverUrl: $serverUrl, backupDirectory: $backupDirectory, size: $size, eventCount: $eventCount)';
}


}

/// @nodoc
abstract mixin class _$BackupRecordCopyWith<$Res> implements $BackupRecordCopyWith<$Res> {
  factory _$BackupRecordCopyWith(_BackupRecord value, $Res Function(_BackupRecord) _then) = __$BackupRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String timeStr, String fileName, String serverUrl, String backupDirectory, String size, int eventCount
});




}
/// @nodoc
class __$BackupRecordCopyWithImpl<$Res>
    implements _$BackupRecordCopyWith<$Res> {
  __$BackupRecordCopyWithImpl(this._self, this._then);

  final _BackupRecord _self;
  final $Res Function(_BackupRecord) _then;

/// Create a copy of BackupRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? timeStr = null,Object? fileName = null,Object? serverUrl = null,Object? backupDirectory = null,Object? size = null,Object? eventCount = null,}) {
  return _then(_BackupRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,timeStr: null == timeStr ? _self.timeStr : timeStr // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,serverUrl: null == serverUrl ? _self.serverUrl : serverUrl // ignore: cast_nullable_to_non_nullable
as String,backupDirectory: null == backupDirectory ? _self.backupDirectory : backupDirectory // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as String,eventCount: null == eventCount ? _self.eventCount : eventCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$BackupData {

 int get version; DateTime? get exportedAt; List<Event> get events; AppConfig get appConfig;
/// Create a copy of BackupData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupDataCopyWith<BackupData> get copyWith => _$BackupDataCopyWithImpl<BackupData>(this as BackupData, _$identity);

  /// Serializes this BackupData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupData&&(identical(other.version, version) || other.version == version)&&(identical(other.exportedAt, exportedAt) || other.exportedAt == exportedAt)&&const DeepCollectionEquality().equals(other.events, events)&&(identical(other.appConfig, appConfig) || other.appConfig == appConfig));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,exportedAt,const DeepCollectionEquality().hash(events),appConfig);

@override
String toString() {
  return 'BackupData(version: $version, exportedAt: $exportedAt, events: $events, appConfig: $appConfig)';
}


}

/// @nodoc
abstract mixin class $BackupDataCopyWith<$Res>  {
  factory $BackupDataCopyWith(BackupData value, $Res Function(BackupData) _then) = _$BackupDataCopyWithImpl;
@useResult
$Res call({
 int version, DateTime? exportedAt, List<Event> events, AppConfig appConfig
});


$AppConfigCopyWith<$Res> get appConfig;

}
/// @nodoc
class _$BackupDataCopyWithImpl<$Res>
    implements $BackupDataCopyWith<$Res> {
  _$BackupDataCopyWithImpl(this._self, this._then);

  final BackupData _self;
  final $Res Function(BackupData) _then;

/// Create a copy of BackupData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? exportedAt = freezed,Object? events = null,Object? appConfig = null,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,exportedAt: freezed == exportedAt ? _self.exportedAt : exportedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<Event>,appConfig: null == appConfig ? _self.appConfig : appConfig // ignore: cast_nullable_to_non_nullable
as AppConfig,
  ));
}
/// Create a copy of BackupData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppConfigCopyWith<$Res> get appConfig {
  
  return $AppConfigCopyWith<$Res>(_self.appConfig, (value) {
    return _then(_self.copyWith(appConfig: value));
  });
}
}


/// Adds pattern-matching-related methods to [BackupData].
extension BackupDataPatterns on BackupData {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackupData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackupData() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackupData value)  $default,){
final _that = this;
switch (_that) {
case _BackupData():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackupData value)?  $default,){
final _that = this;
switch (_that) {
case _BackupData() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int version,  DateTime? exportedAt,  List<Event> events,  AppConfig appConfig)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackupData() when $default != null:
return $default(_that.version,_that.exportedAt,_that.events,_that.appConfig);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int version,  DateTime? exportedAt,  List<Event> events,  AppConfig appConfig)  $default,) {final _that = this;
switch (_that) {
case _BackupData():
return $default(_that.version,_that.exportedAt,_that.events,_that.appConfig);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int version,  DateTime? exportedAt,  List<Event> events,  AppConfig appConfig)?  $default,) {final _that = this;
switch (_that) {
case _BackupData() when $default != null:
return $default(_that.version,_that.exportedAt,_that.events,_that.appConfig);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BackupData implements BackupData {
  const _BackupData({this.version = 1, this.exportedAt, final  List<Event> events = const <Event>[], required this.appConfig}): _events = events;
  factory _BackupData.fromJson(Map<String, dynamic> json) => _$BackupDataFromJson(json);

@override@JsonKey() final  int version;
@override final  DateTime? exportedAt;
 final  List<Event> _events;
@override@JsonKey() List<Event> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}

@override final  AppConfig appConfig;

/// Create a copy of BackupData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupDataCopyWith<_BackupData> get copyWith => __$BackupDataCopyWithImpl<_BackupData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BackupDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupData&&(identical(other.version, version) || other.version == version)&&(identical(other.exportedAt, exportedAt) || other.exportedAt == exportedAt)&&const DeepCollectionEquality().equals(other._events, _events)&&(identical(other.appConfig, appConfig) || other.appConfig == appConfig));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,exportedAt,const DeepCollectionEquality().hash(_events),appConfig);

@override
String toString() {
  return 'BackupData(version: $version, exportedAt: $exportedAt, events: $events, appConfig: $appConfig)';
}


}

/// @nodoc
abstract mixin class _$BackupDataCopyWith<$Res> implements $BackupDataCopyWith<$Res> {
  factory _$BackupDataCopyWith(_BackupData value, $Res Function(_BackupData) _then) = __$BackupDataCopyWithImpl;
@override @useResult
$Res call({
 int version, DateTime? exportedAt, List<Event> events, AppConfig appConfig
});


@override $AppConfigCopyWith<$Res> get appConfig;

}
/// @nodoc
class __$BackupDataCopyWithImpl<$Res>
    implements _$BackupDataCopyWith<$Res> {
  __$BackupDataCopyWithImpl(this._self, this._then);

  final _BackupData _self;
  final $Res Function(_BackupData) _then;

/// Create a copy of BackupData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? exportedAt = freezed,Object? events = null,Object? appConfig = null,}) {
  return _then(_BackupData(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,exportedAt: freezed == exportedAt ? _self.exportedAt : exportedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<Event>,appConfig: null == appConfig ? _self.appConfig : appConfig // ignore: cast_nullable_to_non_nullable
as AppConfig,
  ));
}

/// Create a copy of BackupData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppConfigCopyWith<$Res> get appConfig {
  
  return $AppConfigCopyWith<$Res>(_self.appConfig, (value) {
    return _then(_self.copyWith(appConfig: value));
  });
}
}

// dart format on
