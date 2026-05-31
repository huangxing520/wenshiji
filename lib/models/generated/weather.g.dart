// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeatherResponse _$WeatherResponseFromJson(Map<String, dynamic> json) =>
    _WeatherResponse(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      generationtimeMs: (json['generationtime_ms'] as num).toDouble(),
      utcOffsetSeconds: (json['utc_offset_seconds'] as num).toInt(),
      timezone: json['timezone'] as String,
      timezoneAbbreviation: json['timezone_abbreviation'] as String,
      elevation: (json['elevation'] as num).toDouble(),
      currentWeatherUnits: CurrentWeatherUnits.fromJson(
          json['current_weather_units'] as Map<String, dynamic>),
      currentWeather: CurrentWeather.fromJson(
          json['current_weather'] as Map<String, dynamic>),
      hourlyUnits:
          HourlyUnits.fromJson(json['hourly_units'] as Map<String, dynamic>),
      hourly: Hourly.fromJson(json['hourly'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WeatherResponseToJson(_WeatherResponse instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'generationtime_ms': instance.generationtimeMs,
      'utc_offset_seconds': instance.utcOffsetSeconds,
      'timezone': instance.timezone,
      'timezone_abbreviation': instance.timezoneAbbreviation,
      'elevation': instance.elevation,
      'current_weather_units': instance.currentWeatherUnits,
      'current_weather': instance.currentWeather,
      'hourly_units': instance.hourlyUnits,
      'hourly': instance.hourly,
    };

_CurrentWeatherUnits _$CurrentWeatherUnitsFromJson(Map<String, dynamic> json) =>
    _CurrentWeatherUnits(
      time: json['time'] as String,
      interval: json['interval'] as String,
      temperature: json['temperature'] as String,
      windspeed: json['windspeed'] as String,
      winddirection: json['winddirection'] as String,
      isDay: json['is_day'] as String,
      weathercode: json['weathercode'] as String,
    );

Map<String, dynamic> _$CurrentWeatherUnitsToJson(
        _CurrentWeatherUnits instance) =>
    <String, dynamic>{
      'time': instance.time,
      'interval': instance.interval,
      'temperature': instance.temperature,
      'windspeed': instance.windspeed,
      'winddirection': instance.winddirection,
      'is_day': instance.isDay,
      'weathercode': instance.weathercode,
    };

_CurrentWeather _$CurrentWeatherFromJson(Map<String, dynamic> json) =>
    _CurrentWeather(
      time: json['time'] as String,
      interval: (json['interval'] as num).toInt(),
      temperature: (json['temperature'] as num).toDouble(),
      windspeed: (json['windspeed'] as num).toDouble(),
      winddirection: (json['winddirection'] as num).toInt(),
      isDay: (json['is_day'] as num).toInt(),
      weathercode: (json['weathercode'] as num).toInt(),
    );

Map<String, dynamic> _$CurrentWeatherToJson(_CurrentWeather instance) =>
    <String, dynamic>{
      'time': instance.time,
      'interval': instance.interval,
      'temperature': instance.temperature,
      'windspeed': instance.windspeed,
      'winddirection': instance.winddirection,
      'is_day': instance.isDay,
      'weathercode': instance.weathercode,
    };

_HourlyUnits _$HourlyUnitsFromJson(Map<String, dynamic> json) => _HourlyUnits(
      time: json['time'] as String,
      temperature2m: json['temperature_2m'] as String,
    );

Map<String, dynamic> _$HourlyUnitsToJson(_HourlyUnits instance) =>
    <String, dynamic>{
      'time': instance.time,
      'temperature_2m': instance.temperature2m,
    };

_Hourly _$HourlyFromJson(Map<String, dynamic> json) => _Hourly(
      time: (json['time'] as List<dynamic>).map((e) => e as String).toList(),
      temperature2m: (json['temperature_2m'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$HourlyToJson(_Hourly instance) => <String, dynamic>{
      'time': instance.time,
      'temperature_2m': instance.temperature2m,
    };
