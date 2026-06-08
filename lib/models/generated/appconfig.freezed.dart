// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../appconfig.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppConfig {

 bool get notificationDndOn; bool get notificationDigestOn; int get notificationStartHour; int get notificationStartMinute; int get notificationEndHour; int get notificationEndMinute; String get notificationDigestTime; List<bool> get notificationDndDays; String get backupDirectory; String get backupServerUrl; String get backupUsername; String get backupPassword;
/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppConfigCopyWith<AppConfig> get copyWith => _$AppConfigCopyWithImpl<AppConfig>(this as AppConfig, _$identity);

  /// Serializes this AppConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppConfig&&(identical(other.notificationDndOn, notificationDndOn) || other.notificationDndOn == notificationDndOn)&&(identical(other.notificationDigestOn, notificationDigestOn) || other.notificationDigestOn == notificationDigestOn)&&(identical(other.notificationStartHour, notificationStartHour) || other.notificationStartHour == notificationStartHour)&&(identical(other.notificationStartMinute, notificationStartMinute) || other.notificationStartMinute == notificationStartMinute)&&(identical(other.notificationEndHour, notificationEndHour) || other.notificationEndHour == notificationEndHour)&&(identical(other.notificationEndMinute, notificationEndMinute) || other.notificationEndMinute == notificationEndMinute)&&(identical(other.notificationDigestTime, notificationDigestTime) || other.notificationDigestTime == notificationDigestTime)&&const DeepCollectionEquality().equals(other.notificationDndDays, notificationDndDays)&&(identical(other.backupDirectory, backupDirectory) || other.backupDirectory == backupDirectory)&&(identical(other.backupServerUrl, backupServerUrl) || other.backupServerUrl == backupServerUrl)&&(identical(other.backupUsername, backupUsername) || other.backupUsername == backupUsername)&&(identical(other.backupPassword, backupPassword) || other.backupPassword == backupPassword));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,notificationDndOn,notificationDigestOn,notificationStartHour,notificationStartMinute,notificationEndHour,notificationEndMinute,notificationDigestTime,const DeepCollectionEquality().hash(notificationDndDays),backupDirectory,backupServerUrl,backupUsername,backupPassword);

@override
String toString() {
  return 'AppConfig(notificationDndOn: $notificationDndOn, notificationDigestOn: $notificationDigestOn, notificationStartHour: $notificationStartHour, notificationStartMinute: $notificationStartMinute, notificationEndHour: $notificationEndHour, notificationEndMinute: $notificationEndMinute, notificationDigestTime: $notificationDigestTime, notificationDndDays: $notificationDndDays, backupDirectory: $backupDirectory, backupServerUrl: $backupServerUrl, backupUsername: $backupUsername, backupPassword: $backupPassword)';
}


}

/// @nodoc
abstract mixin class $AppConfigCopyWith<$Res>  {
  factory $AppConfigCopyWith(AppConfig value, $Res Function(AppConfig) _then) = _$AppConfigCopyWithImpl;
@useResult
$Res call({
 bool notificationDndOn, bool notificationDigestOn, int notificationStartHour, int notificationStartMinute, int notificationEndHour, int notificationEndMinute, String notificationDigestTime, List<bool> notificationDndDays, String backupDirectory, String backupServerUrl, String backupUsername, String backupPassword
});




}
/// @nodoc
class _$AppConfigCopyWithImpl<$Res>
    implements $AppConfigCopyWith<$Res> {
  _$AppConfigCopyWithImpl(this._self, this._then);

  final AppConfig _self;
  final $Res Function(AppConfig) _then;

/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? notificationDndOn = null,Object? notificationDigestOn = null,Object? notificationStartHour = null,Object? notificationStartMinute = null,Object? notificationEndHour = null,Object? notificationEndMinute = null,Object? notificationDigestTime = null,Object? notificationDndDays = null,Object? backupDirectory = null,Object? backupServerUrl = null,Object? backupUsername = null,Object? backupPassword = null,}) {
  return _then(_self.copyWith(
notificationDndOn: null == notificationDndOn ? _self.notificationDndOn : notificationDndOn // ignore: cast_nullable_to_non_nullable
as bool,notificationDigestOn: null == notificationDigestOn ? _self.notificationDigestOn : notificationDigestOn // ignore: cast_nullable_to_non_nullable
as bool,notificationStartHour: null == notificationStartHour ? _self.notificationStartHour : notificationStartHour // ignore: cast_nullable_to_non_nullable
as int,notificationStartMinute: null == notificationStartMinute ? _self.notificationStartMinute : notificationStartMinute // ignore: cast_nullable_to_non_nullable
as int,notificationEndHour: null == notificationEndHour ? _self.notificationEndHour : notificationEndHour // ignore: cast_nullable_to_non_nullable
as int,notificationEndMinute: null == notificationEndMinute ? _self.notificationEndMinute : notificationEndMinute // ignore: cast_nullable_to_non_nullable
as int,notificationDigestTime: null == notificationDigestTime ? _self.notificationDigestTime : notificationDigestTime // ignore: cast_nullable_to_non_nullable
as String,notificationDndDays: null == notificationDndDays ? _self.notificationDndDays : notificationDndDays // ignore: cast_nullable_to_non_nullable
as List<bool>,backupDirectory: null == backupDirectory ? _self.backupDirectory : backupDirectory // ignore: cast_nullable_to_non_nullable
as String,backupServerUrl: null == backupServerUrl ? _self.backupServerUrl : backupServerUrl // ignore: cast_nullable_to_non_nullable
as String,backupUsername: null == backupUsername ? _self.backupUsername : backupUsername // ignore: cast_nullable_to_non_nullable
as String,backupPassword: null == backupPassword ? _self.backupPassword : backupPassword // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppConfig].
extension AppConfigPatterns on AppConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppConfig value)  $default,){
final _that = this;
switch (_that) {
case _AppConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppConfig value)?  $default,){
final _that = this;
switch (_that) {
case _AppConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool notificationDndOn,  bool notificationDigestOn,  int notificationStartHour,  int notificationStartMinute,  int notificationEndHour,  int notificationEndMinute,  String notificationDigestTime,  List<bool> notificationDndDays,  String backupDirectory,  String backupServerUrl,  String backupUsername,  String backupPassword)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppConfig() when $default != null:
return $default(_that.notificationDndOn,_that.notificationDigestOn,_that.notificationStartHour,_that.notificationStartMinute,_that.notificationEndHour,_that.notificationEndMinute,_that.notificationDigestTime,_that.notificationDndDays,_that.backupDirectory,_that.backupServerUrl,_that.backupUsername,_that.backupPassword);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool notificationDndOn,  bool notificationDigestOn,  int notificationStartHour,  int notificationStartMinute,  int notificationEndHour,  int notificationEndMinute,  String notificationDigestTime,  List<bool> notificationDndDays,  String backupDirectory,  String backupServerUrl,  String backupUsername,  String backupPassword)  $default,) {final _that = this;
switch (_that) {
case _AppConfig():
return $default(_that.notificationDndOn,_that.notificationDigestOn,_that.notificationStartHour,_that.notificationStartMinute,_that.notificationEndHour,_that.notificationEndMinute,_that.notificationDigestTime,_that.notificationDndDays,_that.backupDirectory,_that.backupServerUrl,_that.backupUsername,_that.backupPassword);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool notificationDndOn,  bool notificationDigestOn,  int notificationStartHour,  int notificationStartMinute,  int notificationEndHour,  int notificationEndMinute,  String notificationDigestTime,  List<bool> notificationDndDays,  String backupDirectory,  String backupServerUrl,  String backupUsername,  String backupPassword)?  $default,) {final _that = this;
switch (_that) {
case _AppConfig() when $default != null:
return $default(_that.notificationDndOn,_that.notificationDigestOn,_that.notificationStartHour,_that.notificationStartMinute,_that.notificationEndHour,_that.notificationEndMinute,_that.notificationDigestTime,_that.notificationDndDays,_that.backupDirectory,_that.backupServerUrl,_that.backupUsername,_that.backupPassword);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppConfig implements AppConfig {
   _AppConfig({this.notificationDndOn = false, this.notificationDigestOn = false, this.notificationStartHour = 22, this.notificationStartMinute = 0, this.notificationEndHour = 7, this.notificationEndMinute = 0, this.notificationDigestTime = 'evening', final  List<bool> notificationDndDays = const [true, true, true, true, true, true, true], this.backupDirectory = '/温时记', this.backupServerUrl = '', this.backupUsername = '', this.backupPassword = ''}): _notificationDndDays = notificationDndDays;
  factory _AppConfig.fromJson(Map<String, dynamic> json) => _$AppConfigFromJson(json);

@override@JsonKey() final  bool notificationDndOn;
@override@JsonKey() final  bool notificationDigestOn;
@override@JsonKey() final  int notificationStartHour;
@override@JsonKey() final  int notificationStartMinute;
@override@JsonKey() final  int notificationEndHour;
@override@JsonKey() final  int notificationEndMinute;
@override@JsonKey() final  String notificationDigestTime;
 final  List<bool> _notificationDndDays;
@override@JsonKey() List<bool> get notificationDndDays {
  if (_notificationDndDays is EqualUnmodifiableListView) return _notificationDndDays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notificationDndDays);
}

@override@JsonKey() final  String backupDirectory;
@override@JsonKey() final  String backupServerUrl;
@override@JsonKey() final  String backupUsername;
@override@JsonKey() final  String backupPassword;

/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppConfigCopyWith<_AppConfig> get copyWith => __$AppConfigCopyWithImpl<_AppConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppConfig&&(identical(other.notificationDndOn, notificationDndOn) || other.notificationDndOn == notificationDndOn)&&(identical(other.notificationDigestOn, notificationDigestOn) || other.notificationDigestOn == notificationDigestOn)&&(identical(other.notificationStartHour, notificationStartHour) || other.notificationStartHour == notificationStartHour)&&(identical(other.notificationStartMinute, notificationStartMinute) || other.notificationStartMinute == notificationStartMinute)&&(identical(other.notificationEndHour, notificationEndHour) || other.notificationEndHour == notificationEndHour)&&(identical(other.notificationEndMinute, notificationEndMinute) || other.notificationEndMinute == notificationEndMinute)&&(identical(other.notificationDigestTime, notificationDigestTime) || other.notificationDigestTime == notificationDigestTime)&&const DeepCollectionEquality().equals(other._notificationDndDays, _notificationDndDays)&&(identical(other.backupDirectory, backupDirectory) || other.backupDirectory == backupDirectory)&&(identical(other.backupServerUrl, backupServerUrl) || other.backupServerUrl == backupServerUrl)&&(identical(other.backupUsername, backupUsername) || other.backupUsername == backupUsername)&&(identical(other.backupPassword, backupPassword) || other.backupPassword == backupPassword));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,notificationDndOn,notificationDigestOn,notificationStartHour,notificationStartMinute,notificationEndHour,notificationEndMinute,notificationDigestTime,const DeepCollectionEquality().hash(_notificationDndDays),backupDirectory,backupServerUrl,backupUsername,backupPassword);

@override
String toString() {
  return 'AppConfig(notificationDndOn: $notificationDndOn, notificationDigestOn: $notificationDigestOn, notificationStartHour: $notificationStartHour, notificationStartMinute: $notificationStartMinute, notificationEndHour: $notificationEndHour, notificationEndMinute: $notificationEndMinute, notificationDigestTime: $notificationDigestTime, notificationDndDays: $notificationDndDays, backupDirectory: $backupDirectory, backupServerUrl: $backupServerUrl, backupUsername: $backupUsername, backupPassword: $backupPassword)';
}


}

/// @nodoc
abstract mixin class _$AppConfigCopyWith<$Res> implements $AppConfigCopyWith<$Res> {
  factory _$AppConfigCopyWith(_AppConfig value, $Res Function(_AppConfig) _then) = __$AppConfigCopyWithImpl;
@override @useResult
$Res call({
 bool notificationDndOn, bool notificationDigestOn, int notificationStartHour, int notificationStartMinute, int notificationEndHour, int notificationEndMinute, String notificationDigestTime, List<bool> notificationDndDays, String backupDirectory, String backupServerUrl, String backupUsername, String backupPassword
});




}
/// @nodoc
class __$AppConfigCopyWithImpl<$Res>
    implements _$AppConfigCopyWith<$Res> {
  __$AppConfigCopyWithImpl(this._self, this._then);

  final _AppConfig _self;
  final $Res Function(_AppConfig) _then;

/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? notificationDndOn = null,Object? notificationDigestOn = null,Object? notificationStartHour = null,Object? notificationStartMinute = null,Object? notificationEndHour = null,Object? notificationEndMinute = null,Object? notificationDigestTime = null,Object? notificationDndDays = null,Object? backupDirectory = null,Object? backupServerUrl = null,Object? backupUsername = null,Object? backupPassword = null,}) {
  return _then(_AppConfig(
notificationDndOn: null == notificationDndOn ? _self.notificationDndOn : notificationDndOn // ignore: cast_nullable_to_non_nullable
as bool,notificationDigestOn: null == notificationDigestOn ? _self.notificationDigestOn : notificationDigestOn // ignore: cast_nullable_to_non_nullable
as bool,notificationStartHour: null == notificationStartHour ? _self.notificationStartHour : notificationStartHour // ignore: cast_nullable_to_non_nullable
as int,notificationStartMinute: null == notificationStartMinute ? _self.notificationStartMinute : notificationStartMinute // ignore: cast_nullable_to_non_nullable
as int,notificationEndHour: null == notificationEndHour ? _self.notificationEndHour : notificationEndHour // ignore: cast_nullable_to_non_nullable
as int,notificationEndMinute: null == notificationEndMinute ? _self.notificationEndMinute : notificationEndMinute // ignore: cast_nullable_to_non_nullable
as int,notificationDigestTime: null == notificationDigestTime ? _self.notificationDigestTime : notificationDigestTime // ignore: cast_nullable_to_non_nullable
as String,notificationDndDays: null == notificationDndDays ? _self._notificationDndDays : notificationDndDays // ignore: cast_nullable_to_non_nullable
as List<bool>,backupDirectory: null == backupDirectory ? _self.backupDirectory : backupDirectory // ignore: cast_nullable_to_non_nullable
as String,backupServerUrl: null == backupServerUrl ? _self.backupServerUrl : backupServerUrl // ignore: cast_nullable_to_non_nullable
as String,backupUsername: null == backupUsername ? _self.backupUsername : backupUsername // ignore: cast_nullable_to_non_nullable
as String,backupPassword: null == backupPassword ? _self.backupPassword : backupPassword // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
