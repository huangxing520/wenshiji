import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/weather.freezed.dart';
part 'generated/weather.g.dart';

/// 顶层天气响应
@freezed
abstract class WeatherResponse with _$WeatherResponse {
  const factory WeatherResponse({
    required double latitude,
    required double longitude,
    @JsonKey(name: 'generationtime_ms') required double generationtimeMs,
    @JsonKey(name: 'utc_offset_seconds') required int utcOffsetSeconds,
    required String timezone,
    @JsonKey(name: 'timezone_abbreviation') required String timezoneAbbreviation,
    required double elevation,
    @JsonKey(name: 'current_weather_units')
    required CurrentWeatherUnits currentWeatherUnits,
    @JsonKey(name: 'current_weather') required CurrentWeather currentWeather,
    @JsonKey(name: 'hourly_units') required HourlyUnits hourlyUnits,
    required Hourly hourly,
  }) = _WeatherResponse;

  factory WeatherResponse.fromJson(Map<String, dynamic> json) =>
      _$WeatherResponseFromJson(json);
}

/// current_weather_units 对象
@freezed
abstract class CurrentWeatherUnits with _$CurrentWeatherUnits {
  const factory CurrentWeatherUnits({
    required String time,
    required String interval,
    required String temperature,
    required String windspeed,
    required String winddirection,
    @JsonKey(name: 'is_day') required String isDay,
    required String weathercode,
  }) = _CurrentWeatherUnits;

  factory CurrentWeatherUnits.fromJson(Map<String, dynamic> json) =>
      _$CurrentWeatherUnitsFromJson(json);
}

/// current_weather 对象
@freezed
abstract class CurrentWeather with _$CurrentWeather {
  const factory CurrentWeather({
    required String time,
    required int interval,
    required double temperature,
    required double windspeed,
    required int winddirection,
    @JsonKey(name: 'is_day') required int isDay,
    required int weathercode,
  }) = _CurrentWeather;

  factory CurrentWeather.fromJson(Map<String, dynamic> json) =>
      _$CurrentWeatherFromJson(json);
}

/// hourly_units 对象
@freezed
abstract class HourlyUnits with _$HourlyUnits {
  const factory HourlyUnits({
    required String time,
    @JsonKey(name: 'temperature_2m') required String temperature2m,
  }) = _HourlyUnits;

  factory HourlyUnits.fromJson(Map<String, dynamic> json) =>
      _$HourlyUnitsFromJson(json);
}

/// hourly 对象，包含时间列表和温度列表
@freezed
abstract class Hourly with _$Hourly {
  const factory Hourly({
    required List<String> time,
    @JsonKey(name: 'temperature_2m') required List<double> temperature2m,
  }) = _Hourly;

  factory Hourly.fromJson(Map<String, dynamic> json) =>
      _$HourlyFromJson(json);
}