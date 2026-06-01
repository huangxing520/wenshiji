// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../weather.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeatherResponse {

 double get latitude; double get longitude;@JsonKey(name: 'generationtime_ms') double get generationtimeMs;@JsonKey(name: 'utc_offset_seconds') int get utcOffsetSeconds; String get timezone;@JsonKey(name: 'timezone_abbreviation') String get timezoneAbbreviation; double get elevation;@JsonKey(name: 'current_weather_units') CurrentWeatherUnits get currentWeatherUnits;@JsonKey(name: 'current_weather') CurrentWeather get currentWeather;@JsonKey(name: 'hourly_units') HourlyUnits get hourlyUnits; Hourly get hourly;
/// Create a copy of WeatherResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherResponseCopyWith<WeatherResponse> get copyWith => _$WeatherResponseCopyWithImpl<WeatherResponse>(this as WeatherResponse, _$identity);

  /// Serializes this WeatherResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeatherResponse&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.generationtimeMs, generationtimeMs) || other.generationtimeMs == generationtimeMs)&&(identical(other.utcOffsetSeconds, utcOffsetSeconds) || other.utcOffsetSeconds == utcOffsetSeconds)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.timezoneAbbreviation, timezoneAbbreviation) || other.timezoneAbbreviation == timezoneAbbreviation)&&(identical(other.elevation, elevation) || other.elevation == elevation)&&(identical(other.currentWeatherUnits, currentWeatherUnits) || other.currentWeatherUnits == currentWeatherUnits)&&(identical(other.currentWeather, currentWeather) || other.currentWeather == currentWeather)&&(identical(other.hourlyUnits, hourlyUnits) || other.hourlyUnits == hourlyUnits)&&(identical(other.hourly, hourly) || other.hourly == hourly));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latitude,longitude,generationtimeMs,utcOffsetSeconds,timezone,timezoneAbbreviation,elevation,currentWeatherUnits,currentWeather,hourlyUnits,hourly);

@override
String toString() {
  return 'WeatherResponse(latitude: $latitude, longitude: $longitude, generationtimeMs: $generationtimeMs, utcOffsetSeconds: $utcOffsetSeconds, timezone: $timezone, timezoneAbbreviation: $timezoneAbbreviation, elevation: $elevation, currentWeatherUnits: $currentWeatherUnits, currentWeather: $currentWeather, hourlyUnits: $hourlyUnits, hourly: $hourly)';
}


}

/// @nodoc
abstract mixin class $WeatherResponseCopyWith<$Res>  {
  factory $WeatherResponseCopyWith(WeatherResponse value, $Res Function(WeatherResponse) _then) = _$WeatherResponseCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude,@JsonKey(name: 'generationtime_ms') double generationtimeMs,@JsonKey(name: 'utc_offset_seconds') int utcOffsetSeconds, String timezone,@JsonKey(name: 'timezone_abbreviation') String timezoneAbbreviation, double elevation,@JsonKey(name: 'current_weather_units') CurrentWeatherUnits currentWeatherUnits,@JsonKey(name: 'current_weather') CurrentWeather currentWeather,@JsonKey(name: 'hourly_units') HourlyUnits hourlyUnits, Hourly hourly
});


$CurrentWeatherUnitsCopyWith<$Res> get currentWeatherUnits;$CurrentWeatherCopyWith<$Res> get currentWeather;$HourlyUnitsCopyWith<$Res> get hourlyUnits;$HourlyCopyWith<$Res> get hourly;

}
/// @nodoc
class _$WeatherResponseCopyWithImpl<$Res>
    implements $WeatherResponseCopyWith<$Res> {
  _$WeatherResponseCopyWithImpl(this._self, this._then);

  final WeatherResponse _self;
  final $Res Function(WeatherResponse) _then;

/// Create a copy of WeatherResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = null,Object? longitude = null,Object? generationtimeMs = null,Object? utcOffsetSeconds = null,Object? timezone = null,Object? timezoneAbbreviation = null,Object? elevation = null,Object? currentWeatherUnits = null,Object? currentWeather = null,Object? hourlyUnits = null,Object? hourly = null,}) {
  return _then(_self.copyWith(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,generationtimeMs: null == generationtimeMs ? _self.generationtimeMs : generationtimeMs // ignore: cast_nullable_to_non_nullable
as double,utcOffsetSeconds: null == utcOffsetSeconds ? _self.utcOffsetSeconds : utcOffsetSeconds // ignore: cast_nullable_to_non_nullable
as int,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,timezoneAbbreviation: null == timezoneAbbreviation ? _self.timezoneAbbreviation : timezoneAbbreviation // ignore: cast_nullable_to_non_nullable
as String,elevation: null == elevation ? _self.elevation : elevation // ignore: cast_nullable_to_non_nullable
as double,currentWeatherUnits: null == currentWeatherUnits ? _self.currentWeatherUnits : currentWeatherUnits // ignore: cast_nullable_to_non_nullable
as CurrentWeatherUnits,currentWeather: null == currentWeather ? _self.currentWeather : currentWeather // ignore: cast_nullable_to_non_nullable
as CurrentWeather,hourlyUnits: null == hourlyUnits ? _self.hourlyUnits : hourlyUnits // ignore: cast_nullable_to_non_nullable
as HourlyUnits,hourly: null == hourly ? _self.hourly : hourly // ignore: cast_nullable_to_non_nullable
as Hourly,
  ));
}
/// Create a copy of WeatherResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CurrentWeatherUnitsCopyWith<$Res> get currentWeatherUnits {
  
  return $CurrentWeatherUnitsCopyWith<$Res>(_self.currentWeatherUnits, (value) {
    return _then(_self.copyWith(currentWeatherUnits: value));
  });
}/// Create a copy of WeatherResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CurrentWeatherCopyWith<$Res> get currentWeather {
  
  return $CurrentWeatherCopyWith<$Res>(_self.currentWeather, (value) {
    return _then(_self.copyWith(currentWeather: value));
  });
}/// Create a copy of WeatherResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HourlyUnitsCopyWith<$Res> get hourlyUnits {
  
  return $HourlyUnitsCopyWith<$Res>(_self.hourlyUnits, (value) {
    return _then(_self.copyWith(hourlyUnits: value));
  });
}/// Create a copy of WeatherResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HourlyCopyWith<$Res> get hourly {
  
  return $HourlyCopyWith<$Res>(_self.hourly, (value) {
    return _then(_self.copyWith(hourly: value));
  });
}
}


/// Adds pattern-matching-related methods to [WeatherResponse].
extension WeatherResponsePatterns on WeatherResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeatherResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeatherResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeatherResponse value)  $default,){
final _that = this;
switch (_that) {
case _WeatherResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeatherResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WeatherResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double latitude,  double longitude, @JsonKey(name: 'generationtime_ms')  double generationtimeMs, @JsonKey(name: 'utc_offset_seconds')  int utcOffsetSeconds,  String timezone, @JsonKey(name: 'timezone_abbreviation')  String timezoneAbbreviation,  double elevation, @JsonKey(name: 'current_weather_units')  CurrentWeatherUnits currentWeatherUnits, @JsonKey(name: 'current_weather')  CurrentWeather currentWeather, @JsonKey(name: 'hourly_units')  HourlyUnits hourlyUnits,  Hourly hourly)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeatherResponse() when $default != null:
return $default(_that.latitude,_that.longitude,_that.generationtimeMs,_that.utcOffsetSeconds,_that.timezone,_that.timezoneAbbreviation,_that.elevation,_that.currentWeatherUnits,_that.currentWeather,_that.hourlyUnits,_that.hourly);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double latitude,  double longitude, @JsonKey(name: 'generationtime_ms')  double generationtimeMs, @JsonKey(name: 'utc_offset_seconds')  int utcOffsetSeconds,  String timezone, @JsonKey(name: 'timezone_abbreviation')  String timezoneAbbreviation,  double elevation, @JsonKey(name: 'current_weather_units')  CurrentWeatherUnits currentWeatherUnits, @JsonKey(name: 'current_weather')  CurrentWeather currentWeather, @JsonKey(name: 'hourly_units')  HourlyUnits hourlyUnits,  Hourly hourly)  $default,) {final _that = this;
switch (_that) {
case _WeatherResponse():
return $default(_that.latitude,_that.longitude,_that.generationtimeMs,_that.utcOffsetSeconds,_that.timezone,_that.timezoneAbbreviation,_that.elevation,_that.currentWeatherUnits,_that.currentWeather,_that.hourlyUnits,_that.hourly);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double latitude,  double longitude, @JsonKey(name: 'generationtime_ms')  double generationtimeMs, @JsonKey(name: 'utc_offset_seconds')  int utcOffsetSeconds,  String timezone, @JsonKey(name: 'timezone_abbreviation')  String timezoneAbbreviation,  double elevation, @JsonKey(name: 'current_weather_units')  CurrentWeatherUnits currentWeatherUnits, @JsonKey(name: 'current_weather')  CurrentWeather currentWeather, @JsonKey(name: 'hourly_units')  HourlyUnits hourlyUnits,  Hourly hourly)?  $default,) {final _that = this;
switch (_that) {
case _WeatherResponse() when $default != null:
return $default(_that.latitude,_that.longitude,_that.generationtimeMs,_that.utcOffsetSeconds,_that.timezone,_that.timezoneAbbreviation,_that.elevation,_that.currentWeatherUnits,_that.currentWeather,_that.hourlyUnits,_that.hourly);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeatherResponse implements WeatherResponse {
  const _WeatherResponse({required this.latitude, required this.longitude, @JsonKey(name: 'generationtime_ms') required this.generationtimeMs, @JsonKey(name: 'utc_offset_seconds') required this.utcOffsetSeconds, required this.timezone, @JsonKey(name: 'timezone_abbreviation') required this.timezoneAbbreviation, required this.elevation, @JsonKey(name: 'current_weather_units') required this.currentWeatherUnits, @JsonKey(name: 'current_weather') required this.currentWeather, @JsonKey(name: 'hourly_units') required this.hourlyUnits, required this.hourly});
  factory _WeatherResponse.fromJson(Map<String, dynamic> json) => _$WeatherResponseFromJson(json);

@override final  double latitude;
@override final  double longitude;
@override@JsonKey(name: 'generationtime_ms') final  double generationtimeMs;
@override@JsonKey(name: 'utc_offset_seconds') final  int utcOffsetSeconds;
@override final  String timezone;
@override@JsonKey(name: 'timezone_abbreviation') final  String timezoneAbbreviation;
@override final  double elevation;
@override@JsonKey(name: 'current_weather_units') final  CurrentWeatherUnits currentWeatherUnits;
@override@JsonKey(name: 'current_weather') final  CurrentWeather currentWeather;
@override@JsonKey(name: 'hourly_units') final  HourlyUnits hourlyUnits;
@override final  Hourly hourly;

/// Create a copy of WeatherResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeatherResponseCopyWith<_WeatherResponse> get copyWith => __$WeatherResponseCopyWithImpl<_WeatherResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeatherResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeatherResponse&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.generationtimeMs, generationtimeMs) || other.generationtimeMs == generationtimeMs)&&(identical(other.utcOffsetSeconds, utcOffsetSeconds) || other.utcOffsetSeconds == utcOffsetSeconds)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.timezoneAbbreviation, timezoneAbbreviation) || other.timezoneAbbreviation == timezoneAbbreviation)&&(identical(other.elevation, elevation) || other.elevation == elevation)&&(identical(other.currentWeatherUnits, currentWeatherUnits) || other.currentWeatherUnits == currentWeatherUnits)&&(identical(other.currentWeather, currentWeather) || other.currentWeather == currentWeather)&&(identical(other.hourlyUnits, hourlyUnits) || other.hourlyUnits == hourlyUnits)&&(identical(other.hourly, hourly) || other.hourly == hourly));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latitude,longitude,generationtimeMs,utcOffsetSeconds,timezone,timezoneAbbreviation,elevation,currentWeatherUnits,currentWeather,hourlyUnits,hourly);

@override
String toString() {
  return 'WeatherResponse(latitude: $latitude, longitude: $longitude, generationtimeMs: $generationtimeMs, utcOffsetSeconds: $utcOffsetSeconds, timezone: $timezone, timezoneAbbreviation: $timezoneAbbreviation, elevation: $elevation, currentWeatherUnits: $currentWeatherUnits, currentWeather: $currentWeather, hourlyUnits: $hourlyUnits, hourly: $hourly)';
}


}

/// @nodoc
abstract mixin class _$WeatherResponseCopyWith<$Res> implements $WeatherResponseCopyWith<$Res> {
  factory _$WeatherResponseCopyWith(_WeatherResponse value, $Res Function(_WeatherResponse) _then) = __$WeatherResponseCopyWithImpl;
@override @useResult
$Res call({
 double latitude, double longitude,@JsonKey(name: 'generationtime_ms') double generationtimeMs,@JsonKey(name: 'utc_offset_seconds') int utcOffsetSeconds, String timezone,@JsonKey(name: 'timezone_abbreviation') String timezoneAbbreviation, double elevation,@JsonKey(name: 'current_weather_units') CurrentWeatherUnits currentWeatherUnits,@JsonKey(name: 'current_weather') CurrentWeather currentWeather,@JsonKey(name: 'hourly_units') HourlyUnits hourlyUnits, Hourly hourly
});


@override $CurrentWeatherUnitsCopyWith<$Res> get currentWeatherUnits;@override $CurrentWeatherCopyWith<$Res> get currentWeather;@override $HourlyUnitsCopyWith<$Res> get hourlyUnits;@override $HourlyCopyWith<$Res> get hourly;

}
/// @nodoc
class __$WeatherResponseCopyWithImpl<$Res>
    implements _$WeatherResponseCopyWith<$Res> {
  __$WeatherResponseCopyWithImpl(this._self, this._then);

  final _WeatherResponse _self;
  final $Res Function(_WeatherResponse) _then;

/// Create a copy of WeatherResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,Object? generationtimeMs = null,Object? utcOffsetSeconds = null,Object? timezone = null,Object? timezoneAbbreviation = null,Object? elevation = null,Object? currentWeatherUnits = null,Object? currentWeather = null,Object? hourlyUnits = null,Object? hourly = null,}) {
  return _then(_WeatherResponse(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,generationtimeMs: null == generationtimeMs ? _self.generationtimeMs : generationtimeMs // ignore: cast_nullable_to_non_nullable
as double,utcOffsetSeconds: null == utcOffsetSeconds ? _self.utcOffsetSeconds : utcOffsetSeconds // ignore: cast_nullable_to_non_nullable
as int,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,timezoneAbbreviation: null == timezoneAbbreviation ? _self.timezoneAbbreviation : timezoneAbbreviation // ignore: cast_nullable_to_non_nullable
as String,elevation: null == elevation ? _self.elevation : elevation // ignore: cast_nullable_to_non_nullable
as double,currentWeatherUnits: null == currentWeatherUnits ? _self.currentWeatherUnits : currentWeatherUnits // ignore: cast_nullable_to_non_nullable
as CurrentWeatherUnits,currentWeather: null == currentWeather ? _self.currentWeather : currentWeather // ignore: cast_nullable_to_non_nullable
as CurrentWeather,hourlyUnits: null == hourlyUnits ? _self.hourlyUnits : hourlyUnits // ignore: cast_nullable_to_non_nullable
as HourlyUnits,hourly: null == hourly ? _self.hourly : hourly // ignore: cast_nullable_to_non_nullable
as Hourly,
  ));
}

/// Create a copy of WeatherResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CurrentWeatherUnitsCopyWith<$Res> get currentWeatherUnits {
  
  return $CurrentWeatherUnitsCopyWith<$Res>(_self.currentWeatherUnits, (value) {
    return _then(_self.copyWith(currentWeatherUnits: value));
  });
}/// Create a copy of WeatherResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CurrentWeatherCopyWith<$Res> get currentWeather {
  
  return $CurrentWeatherCopyWith<$Res>(_self.currentWeather, (value) {
    return _then(_self.copyWith(currentWeather: value));
  });
}/// Create a copy of WeatherResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HourlyUnitsCopyWith<$Res> get hourlyUnits {
  
  return $HourlyUnitsCopyWith<$Res>(_self.hourlyUnits, (value) {
    return _then(_self.copyWith(hourlyUnits: value));
  });
}/// Create a copy of WeatherResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HourlyCopyWith<$Res> get hourly {
  
  return $HourlyCopyWith<$Res>(_self.hourly, (value) {
    return _then(_self.copyWith(hourly: value));
  });
}
}


/// @nodoc
mixin _$CurrentWeatherUnits {

 String get time; String get interval; String get temperature; String get windspeed; String get winddirection;@JsonKey(name: 'is_day') String get isDay; String get weathercode;
/// Create a copy of CurrentWeatherUnits
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CurrentWeatherUnitsCopyWith<CurrentWeatherUnits> get copyWith => _$CurrentWeatherUnitsCopyWithImpl<CurrentWeatherUnits>(this as CurrentWeatherUnits, _$identity);

  /// Serializes this CurrentWeatherUnits to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CurrentWeatherUnits&&(identical(other.time, time) || other.time == time)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.windspeed, windspeed) || other.windspeed == windspeed)&&(identical(other.winddirection, winddirection) || other.winddirection == winddirection)&&(identical(other.isDay, isDay) || other.isDay == isDay)&&(identical(other.weathercode, weathercode) || other.weathercode == weathercode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,interval,temperature,windspeed,winddirection,isDay,weathercode);

@override
String toString() {
  return 'CurrentWeatherUnits(time: $time, interval: $interval, temperature: $temperature, windspeed: $windspeed, winddirection: $winddirection, isDay: $isDay, weathercode: $weathercode)';
}


}

/// @nodoc
abstract mixin class $CurrentWeatherUnitsCopyWith<$Res>  {
  factory $CurrentWeatherUnitsCopyWith(CurrentWeatherUnits value, $Res Function(CurrentWeatherUnits) _then) = _$CurrentWeatherUnitsCopyWithImpl;
@useResult
$Res call({
 String time, String interval, String temperature, String windspeed, String winddirection,@JsonKey(name: 'is_day') String isDay, String weathercode
});




}
/// @nodoc
class _$CurrentWeatherUnitsCopyWithImpl<$Res>
    implements $CurrentWeatherUnitsCopyWith<$Res> {
  _$CurrentWeatherUnitsCopyWithImpl(this._self, this._then);

  final CurrentWeatherUnits _self;
  final $Res Function(CurrentWeatherUnits) _then;

/// Create a copy of CurrentWeatherUnits
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? interval = null,Object? temperature = null,Object? windspeed = null,Object? winddirection = null,Object? isDay = null,Object? weathercode = null,}) {
  return _then(_self.copyWith(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as String,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as String,windspeed: null == windspeed ? _self.windspeed : windspeed // ignore: cast_nullable_to_non_nullable
as String,winddirection: null == winddirection ? _self.winddirection : winddirection // ignore: cast_nullable_to_non_nullable
as String,isDay: null == isDay ? _self.isDay : isDay // ignore: cast_nullable_to_non_nullable
as String,weathercode: null == weathercode ? _self.weathercode : weathercode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CurrentWeatherUnits].
extension CurrentWeatherUnitsPatterns on CurrentWeatherUnits {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CurrentWeatherUnits value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CurrentWeatherUnits() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CurrentWeatherUnits value)  $default,){
final _that = this;
switch (_that) {
case _CurrentWeatherUnits():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CurrentWeatherUnits value)?  $default,){
final _that = this;
switch (_that) {
case _CurrentWeatherUnits() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String time,  String interval,  String temperature,  String windspeed,  String winddirection, @JsonKey(name: 'is_day')  String isDay,  String weathercode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CurrentWeatherUnits() when $default != null:
return $default(_that.time,_that.interval,_that.temperature,_that.windspeed,_that.winddirection,_that.isDay,_that.weathercode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String time,  String interval,  String temperature,  String windspeed,  String winddirection, @JsonKey(name: 'is_day')  String isDay,  String weathercode)  $default,) {final _that = this;
switch (_that) {
case _CurrentWeatherUnits():
return $default(_that.time,_that.interval,_that.temperature,_that.windspeed,_that.winddirection,_that.isDay,_that.weathercode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String time,  String interval,  String temperature,  String windspeed,  String winddirection, @JsonKey(name: 'is_day')  String isDay,  String weathercode)?  $default,) {final _that = this;
switch (_that) {
case _CurrentWeatherUnits() when $default != null:
return $default(_that.time,_that.interval,_that.temperature,_that.windspeed,_that.winddirection,_that.isDay,_that.weathercode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CurrentWeatherUnits implements CurrentWeatherUnits {
  const _CurrentWeatherUnits({required this.time, required this.interval, required this.temperature, required this.windspeed, required this.winddirection, @JsonKey(name: 'is_day') required this.isDay, required this.weathercode});
  factory _CurrentWeatherUnits.fromJson(Map<String, dynamic> json) => _$CurrentWeatherUnitsFromJson(json);

@override final  String time;
@override final  String interval;
@override final  String temperature;
@override final  String windspeed;
@override final  String winddirection;
@override@JsonKey(name: 'is_day') final  String isDay;
@override final  String weathercode;

/// Create a copy of CurrentWeatherUnits
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CurrentWeatherUnitsCopyWith<_CurrentWeatherUnits> get copyWith => __$CurrentWeatherUnitsCopyWithImpl<_CurrentWeatherUnits>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CurrentWeatherUnitsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CurrentWeatherUnits&&(identical(other.time, time) || other.time == time)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.windspeed, windspeed) || other.windspeed == windspeed)&&(identical(other.winddirection, winddirection) || other.winddirection == winddirection)&&(identical(other.isDay, isDay) || other.isDay == isDay)&&(identical(other.weathercode, weathercode) || other.weathercode == weathercode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,interval,temperature,windspeed,winddirection,isDay,weathercode);

@override
String toString() {
  return 'CurrentWeatherUnits(time: $time, interval: $interval, temperature: $temperature, windspeed: $windspeed, winddirection: $winddirection, isDay: $isDay, weathercode: $weathercode)';
}


}

/// @nodoc
abstract mixin class _$CurrentWeatherUnitsCopyWith<$Res> implements $CurrentWeatherUnitsCopyWith<$Res> {
  factory _$CurrentWeatherUnitsCopyWith(_CurrentWeatherUnits value, $Res Function(_CurrentWeatherUnits) _then) = __$CurrentWeatherUnitsCopyWithImpl;
@override @useResult
$Res call({
 String time, String interval, String temperature, String windspeed, String winddirection,@JsonKey(name: 'is_day') String isDay, String weathercode
});




}
/// @nodoc
class __$CurrentWeatherUnitsCopyWithImpl<$Res>
    implements _$CurrentWeatherUnitsCopyWith<$Res> {
  __$CurrentWeatherUnitsCopyWithImpl(this._self, this._then);

  final _CurrentWeatherUnits _self;
  final $Res Function(_CurrentWeatherUnits) _then;

/// Create a copy of CurrentWeatherUnits
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? interval = null,Object? temperature = null,Object? windspeed = null,Object? winddirection = null,Object? isDay = null,Object? weathercode = null,}) {
  return _then(_CurrentWeatherUnits(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as String,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as String,windspeed: null == windspeed ? _self.windspeed : windspeed // ignore: cast_nullable_to_non_nullable
as String,winddirection: null == winddirection ? _self.winddirection : winddirection // ignore: cast_nullable_to_non_nullable
as String,isDay: null == isDay ? _self.isDay : isDay // ignore: cast_nullable_to_non_nullable
as String,weathercode: null == weathercode ? _self.weathercode : weathercode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CurrentWeather {

 String get time; int get interval; double get temperature; double get windspeed; int get winddirection;@JsonKey(name: 'is_day') int get isDay; int get weathercode;
/// Create a copy of CurrentWeather
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CurrentWeatherCopyWith<CurrentWeather> get copyWith => _$CurrentWeatherCopyWithImpl<CurrentWeather>(this as CurrentWeather, _$identity);

  /// Serializes this CurrentWeather to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CurrentWeather&&(identical(other.time, time) || other.time == time)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.windspeed, windspeed) || other.windspeed == windspeed)&&(identical(other.winddirection, winddirection) || other.winddirection == winddirection)&&(identical(other.isDay, isDay) || other.isDay == isDay)&&(identical(other.weathercode, weathercode) || other.weathercode == weathercode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,interval,temperature,windspeed,winddirection,isDay,weathercode);

@override
String toString() {
  return 'CurrentWeather(time: $time, interval: $interval, temperature: $temperature, windspeed: $windspeed, winddirection: $winddirection, isDay: $isDay, weathercode: $weathercode)';
}


}

/// @nodoc
abstract mixin class $CurrentWeatherCopyWith<$Res>  {
  factory $CurrentWeatherCopyWith(CurrentWeather value, $Res Function(CurrentWeather) _then) = _$CurrentWeatherCopyWithImpl;
@useResult
$Res call({
 String time, int interval, double temperature, double windspeed, int winddirection,@JsonKey(name: 'is_day') int isDay, int weathercode
});




}
/// @nodoc
class _$CurrentWeatherCopyWithImpl<$Res>
    implements $CurrentWeatherCopyWith<$Res> {
  _$CurrentWeatherCopyWithImpl(this._self, this._then);

  final CurrentWeather _self;
  final $Res Function(CurrentWeather) _then;

/// Create a copy of CurrentWeather
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? interval = null,Object? temperature = null,Object? windspeed = null,Object? winddirection = null,Object? isDay = null,Object? weathercode = null,}) {
  return _then(_self.copyWith(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,windspeed: null == windspeed ? _self.windspeed : windspeed // ignore: cast_nullable_to_non_nullable
as double,winddirection: null == winddirection ? _self.winddirection : winddirection // ignore: cast_nullable_to_non_nullable
as int,isDay: null == isDay ? _self.isDay : isDay // ignore: cast_nullable_to_non_nullable
as int,weathercode: null == weathercode ? _self.weathercode : weathercode // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CurrentWeather].
extension CurrentWeatherPatterns on CurrentWeather {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CurrentWeather value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CurrentWeather() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CurrentWeather value)  $default,){
final _that = this;
switch (_that) {
case _CurrentWeather():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CurrentWeather value)?  $default,){
final _that = this;
switch (_that) {
case _CurrentWeather() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String time,  int interval,  double temperature,  double windspeed,  int winddirection, @JsonKey(name: 'is_day')  int isDay,  int weathercode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CurrentWeather() when $default != null:
return $default(_that.time,_that.interval,_that.temperature,_that.windspeed,_that.winddirection,_that.isDay,_that.weathercode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String time,  int interval,  double temperature,  double windspeed,  int winddirection, @JsonKey(name: 'is_day')  int isDay,  int weathercode)  $default,) {final _that = this;
switch (_that) {
case _CurrentWeather():
return $default(_that.time,_that.interval,_that.temperature,_that.windspeed,_that.winddirection,_that.isDay,_that.weathercode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String time,  int interval,  double temperature,  double windspeed,  int winddirection, @JsonKey(name: 'is_day')  int isDay,  int weathercode)?  $default,) {final _that = this;
switch (_that) {
case _CurrentWeather() when $default != null:
return $default(_that.time,_that.interval,_that.temperature,_that.windspeed,_that.winddirection,_that.isDay,_that.weathercode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CurrentWeather implements CurrentWeather {
  const _CurrentWeather({required this.time, required this.interval, required this.temperature, required this.windspeed, required this.winddirection, @JsonKey(name: 'is_day') required this.isDay, required this.weathercode});
  factory _CurrentWeather.fromJson(Map<String, dynamic> json) => _$CurrentWeatherFromJson(json);

@override final  String time;
@override final  int interval;
@override final  double temperature;
@override final  double windspeed;
@override final  int winddirection;
@override@JsonKey(name: 'is_day') final  int isDay;
@override final  int weathercode;

/// Create a copy of CurrentWeather
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CurrentWeatherCopyWith<_CurrentWeather> get copyWith => __$CurrentWeatherCopyWithImpl<_CurrentWeather>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CurrentWeatherToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CurrentWeather&&(identical(other.time, time) || other.time == time)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.windspeed, windspeed) || other.windspeed == windspeed)&&(identical(other.winddirection, winddirection) || other.winddirection == winddirection)&&(identical(other.isDay, isDay) || other.isDay == isDay)&&(identical(other.weathercode, weathercode) || other.weathercode == weathercode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,interval,temperature,windspeed,winddirection,isDay,weathercode);

@override
String toString() {
  return 'CurrentWeather(time: $time, interval: $interval, temperature: $temperature, windspeed: $windspeed, winddirection: $winddirection, isDay: $isDay, weathercode: $weathercode)';
}


}

/// @nodoc
abstract mixin class _$CurrentWeatherCopyWith<$Res> implements $CurrentWeatherCopyWith<$Res> {
  factory _$CurrentWeatherCopyWith(_CurrentWeather value, $Res Function(_CurrentWeather) _then) = __$CurrentWeatherCopyWithImpl;
@override @useResult
$Res call({
 String time, int interval, double temperature, double windspeed, int winddirection,@JsonKey(name: 'is_day') int isDay, int weathercode
});




}
/// @nodoc
class __$CurrentWeatherCopyWithImpl<$Res>
    implements _$CurrentWeatherCopyWith<$Res> {
  __$CurrentWeatherCopyWithImpl(this._self, this._then);

  final _CurrentWeather _self;
  final $Res Function(_CurrentWeather) _then;

/// Create a copy of CurrentWeather
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? interval = null,Object? temperature = null,Object? windspeed = null,Object? winddirection = null,Object? isDay = null,Object? weathercode = null,}) {
  return _then(_CurrentWeather(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,windspeed: null == windspeed ? _self.windspeed : windspeed // ignore: cast_nullable_to_non_nullable
as double,winddirection: null == winddirection ? _self.winddirection : winddirection // ignore: cast_nullable_to_non_nullable
as int,isDay: null == isDay ? _self.isDay : isDay // ignore: cast_nullable_to_non_nullable
as int,weathercode: null == weathercode ? _self.weathercode : weathercode // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$HourlyUnits {

 String get time;@JsonKey(name: 'temperature_2m') String get temperature2m;
/// Create a copy of HourlyUnits
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HourlyUnitsCopyWith<HourlyUnits> get copyWith => _$HourlyUnitsCopyWithImpl<HourlyUnits>(this as HourlyUnits, _$identity);

  /// Serializes this HourlyUnits to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HourlyUnits&&(identical(other.time, time) || other.time == time)&&(identical(other.temperature2m, temperature2m) || other.temperature2m == temperature2m));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,temperature2m);

@override
String toString() {
  return 'HourlyUnits(time: $time, temperature2m: $temperature2m)';
}


}

/// @nodoc
abstract mixin class $HourlyUnitsCopyWith<$Res>  {
  factory $HourlyUnitsCopyWith(HourlyUnits value, $Res Function(HourlyUnits) _then) = _$HourlyUnitsCopyWithImpl;
@useResult
$Res call({
 String time,@JsonKey(name: 'temperature_2m') String temperature2m
});




}
/// @nodoc
class _$HourlyUnitsCopyWithImpl<$Res>
    implements $HourlyUnitsCopyWith<$Res> {
  _$HourlyUnitsCopyWithImpl(this._self, this._then);

  final HourlyUnits _self;
  final $Res Function(HourlyUnits) _then;

/// Create a copy of HourlyUnits
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? temperature2m = null,}) {
  return _then(_self.copyWith(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,temperature2m: null == temperature2m ? _self.temperature2m : temperature2m // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HourlyUnits].
extension HourlyUnitsPatterns on HourlyUnits {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HourlyUnits value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HourlyUnits() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HourlyUnits value)  $default,){
final _that = this;
switch (_that) {
case _HourlyUnits():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HourlyUnits value)?  $default,){
final _that = this;
switch (_that) {
case _HourlyUnits() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String time, @JsonKey(name: 'temperature_2m')  String temperature2m)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HourlyUnits() when $default != null:
return $default(_that.time,_that.temperature2m);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String time, @JsonKey(name: 'temperature_2m')  String temperature2m)  $default,) {final _that = this;
switch (_that) {
case _HourlyUnits():
return $default(_that.time,_that.temperature2m);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String time, @JsonKey(name: 'temperature_2m')  String temperature2m)?  $default,) {final _that = this;
switch (_that) {
case _HourlyUnits() when $default != null:
return $default(_that.time,_that.temperature2m);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HourlyUnits implements HourlyUnits {
  const _HourlyUnits({required this.time, @JsonKey(name: 'temperature_2m') required this.temperature2m});
  factory _HourlyUnits.fromJson(Map<String, dynamic> json) => _$HourlyUnitsFromJson(json);

@override final  String time;
@override@JsonKey(name: 'temperature_2m') final  String temperature2m;

/// Create a copy of HourlyUnits
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HourlyUnitsCopyWith<_HourlyUnits> get copyWith => __$HourlyUnitsCopyWithImpl<_HourlyUnits>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HourlyUnitsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HourlyUnits&&(identical(other.time, time) || other.time == time)&&(identical(other.temperature2m, temperature2m) || other.temperature2m == temperature2m));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,temperature2m);

@override
String toString() {
  return 'HourlyUnits(time: $time, temperature2m: $temperature2m)';
}


}

/// @nodoc
abstract mixin class _$HourlyUnitsCopyWith<$Res> implements $HourlyUnitsCopyWith<$Res> {
  factory _$HourlyUnitsCopyWith(_HourlyUnits value, $Res Function(_HourlyUnits) _then) = __$HourlyUnitsCopyWithImpl;
@override @useResult
$Res call({
 String time,@JsonKey(name: 'temperature_2m') String temperature2m
});




}
/// @nodoc
class __$HourlyUnitsCopyWithImpl<$Res>
    implements _$HourlyUnitsCopyWith<$Res> {
  __$HourlyUnitsCopyWithImpl(this._self, this._then);

  final _HourlyUnits _self;
  final $Res Function(_HourlyUnits) _then;

/// Create a copy of HourlyUnits
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? temperature2m = null,}) {
  return _then(_HourlyUnits(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,temperature2m: null == temperature2m ? _self.temperature2m : temperature2m // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Hourly {

 List<String> get time;@JsonKey(name: 'temperature_2m') List<double> get temperature2m;
/// Create a copy of Hourly
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HourlyCopyWith<Hourly> get copyWith => _$HourlyCopyWithImpl<Hourly>(this as Hourly, _$identity);

  /// Serializes this Hourly to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Hourly&&const DeepCollectionEquality().equals(other.time, time)&&const DeepCollectionEquality().equals(other.temperature2m, temperature2m));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(time),const DeepCollectionEquality().hash(temperature2m));

@override
String toString() {
  return 'Hourly(time: $time, temperature2m: $temperature2m)';
}


}

/// @nodoc
abstract mixin class $HourlyCopyWith<$Res>  {
  factory $HourlyCopyWith(Hourly value, $Res Function(Hourly) _then) = _$HourlyCopyWithImpl;
@useResult
$Res call({
 List<String> time,@JsonKey(name: 'temperature_2m') List<double> temperature2m
});




}
/// @nodoc
class _$HourlyCopyWithImpl<$Res>
    implements $HourlyCopyWith<$Res> {
  _$HourlyCopyWithImpl(this._self, this._then);

  final Hourly _self;
  final $Res Function(Hourly) _then;

/// Create a copy of Hourly
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? temperature2m = null,}) {
  return _then(_self.copyWith(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as List<String>,temperature2m: null == temperature2m ? _self.temperature2m : temperature2m // ignore: cast_nullable_to_non_nullable
as List<double>,
  ));
}

}


/// Adds pattern-matching-related methods to [Hourly].
extension HourlyPatterns on Hourly {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Hourly value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Hourly() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Hourly value)  $default,){
final _that = this;
switch (_that) {
case _Hourly():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Hourly value)?  $default,){
final _that = this;
switch (_that) {
case _Hourly() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> time, @JsonKey(name: 'temperature_2m')  List<double> temperature2m)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Hourly() when $default != null:
return $default(_that.time,_that.temperature2m);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> time, @JsonKey(name: 'temperature_2m')  List<double> temperature2m)  $default,) {final _that = this;
switch (_that) {
case _Hourly():
return $default(_that.time,_that.temperature2m);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> time, @JsonKey(name: 'temperature_2m')  List<double> temperature2m)?  $default,) {final _that = this;
switch (_that) {
case _Hourly() when $default != null:
return $default(_that.time,_that.temperature2m);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Hourly implements Hourly {
  const _Hourly({required final  List<String> time, @JsonKey(name: 'temperature_2m') required final  List<double> temperature2m}): _time = time,_temperature2m = temperature2m;
  factory _Hourly.fromJson(Map<String, dynamic> json) => _$HourlyFromJson(json);

 final  List<String> _time;
@override List<String> get time {
  if (_time is EqualUnmodifiableListView) return _time;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_time);
}

 final  List<double> _temperature2m;
@override@JsonKey(name: 'temperature_2m') List<double> get temperature2m {
  if (_temperature2m is EqualUnmodifiableListView) return _temperature2m;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_temperature2m);
}


/// Create a copy of Hourly
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HourlyCopyWith<_Hourly> get copyWith => __$HourlyCopyWithImpl<_Hourly>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HourlyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Hourly&&const DeepCollectionEquality().equals(other._time, _time)&&const DeepCollectionEquality().equals(other._temperature2m, _temperature2m));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_time),const DeepCollectionEquality().hash(_temperature2m));

@override
String toString() {
  return 'Hourly(time: $time, temperature2m: $temperature2m)';
}


}

/// @nodoc
abstract mixin class _$HourlyCopyWith<$Res> implements $HourlyCopyWith<$Res> {
  factory _$HourlyCopyWith(_Hourly value, $Res Function(_Hourly) _then) = __$HourlyCopyWithImpl;
@override @useResult
$Res call({
 List<String> time,@JsonKey(name: 'temperature_2m') List<double> temperature2m
});




}
/// @nodoc
class __$HourlyCopyWithImpl<$Res>
    implements _$HourlyCopyWith<$Res> {
  __$HourlyCopyWithImpl(this._self, this._then);

  final _Hourly _self;
  final $Res Function(_Hourly) _then;

/// Create a copy of Hourly
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? temperature2m = null,}) {
  return _then(_Hourly(
time: null == time ? _self._time : time // ignore: cast_nullable_to_non_nullable
as List<String>,temperature2m: null == temperature2m ? _self._temperature2m : temperature2m // ignore: cast_nullable_to_non_nullable
as List<double>,
  ));
}


}

// dart format on
