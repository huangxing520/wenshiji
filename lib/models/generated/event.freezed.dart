// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Event {

 String get id; String get name; DateTime get date; EventType get type; EventPriority get priority; bool get isPinned; bool get isStarred; bool get hasCheckin; int get streak; bool get checkedToday; List<EventReminder> get reminder; String get description; List<String> get picturePaths; List<String> get tags;
/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventCopyWith<Event> get copyWith => _$EventCopyWithImpl<Event>(this as Event, _$identity);

  /// Serializes this Event to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Event&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.date, date) || other.date == date)&&(identical(other.type, type) || other.type == type)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.isStarred, isStarred) || other.isStarred == isStarred)&&(identical(other.hasCheckin, hasCheckin) || other.hasCheckin == hasCheckin)&&(identical(other.streak, streak) || other.streak == streak)&&(identical(other.checkedToday, checkedToday) || other.checkedToday == checkedToday)&&const DeepCollectionEquality().equals(other.reminder, reminder)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.picturePaths, picturePaths)&&const DeepCollectionEquality().equals(other.tags, tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,date,type,priority,isPinned,isStarred,hasCheckin,streak,checkedToday,const DeepCollectionEquality().hash(reminder),description,const DeepCollectionEquality().hash(picturePaths),const DeepCollectionEquality().hash(tags));

@override
String toString() {
  return 'Event(id: $id, name: $name, date: $date, type: $type, priority: $priority, isPinned: $isPinned, isStarred: $isStarred, hasCheckin: $hasCheckin, streak: $streak, checkedToday: $checkedToday, reminder: $reminder, description: $description, picturePaths: $picturePaths, tags: $tags)';
}


}

/// @nodoc
abstract mixin class $EventCopyWith<$Res>  {
  factory $EventCopyWith(Event value, $Res Function(Event) _then) = _$EventCopyWithImpl;
@useResult
$Res call({
 String id, String name, DateTime date, EventType type, EventPriority priority, bool isPinned, bool isStarred, bool hasCheckin, int streak, bool checkedToday, List<EventReminder> reminder, String description, List<String> picturePaths, List<String> tags
});




}
/// @nodoc
class _$EventCopyWithImpl<$Res>
    implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._self, this._then);

  final Event _self;
  final $Res Function(Event) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? date = null,Object? type = null,Object? priority = null,Object? isPinned = null,Object? isStarred = null,Object? hasCheckin = null,Object? streak = null,Object? checkedToday = null,Object? reminder = null,Object? description = null,Object? picturePaths = null,Object? tags = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as EventType,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as EventPriority,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,isStarred: null == isStarred ? _self.isStarred : isStarred // ignore: cast_nullable_to_non_nullable
as bool,hasCheckin: null == hasCheckin ? _self.hasCheckin : hasCheckin // ignore: cast_nullable_to_non_nullable
as bool,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,checkedToday: null == checkedToday ? _self.checkedToday : checkedToday // ignore: cast_nullable_to_non_nullable
as bool,reminder: null == reminder ? _self.reminder : reminder // ignore: cast_nullable_to_non_nullable
as List<EventReminder>,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,picturePaths: null == picturePaths ? _self.picturePaths : picturePaths // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Event].
extension EventPatterns on Event {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Event value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Event() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Event value)  $default,){
final _that = this;
switch (_that) {
case _Event():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Event value)?  $default,){
final _that = this;
switch (_that) {
case _Event() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  DateTime date,  EventType type,  EventPriority priority,  bool isPinned,  bool isStarred,  bool hasCheckin,  int streak,  bool checkedToday,  List<EventReminder> reminder,  String description,  List<String> picturePaths,  List<String> tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Event() when $default != null:
return $default(_that.id,_that.name,_that.date,_that.type,_that.priority,_that.isPinned,_that.isStarred,_that.hasCheckin,_that.streak,_that.checkedToday,_that.reminder,_that.description,_that.picturePaths,_that.tags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  DateTime date,  EventType type,  EventPriority priority,  bool isPinned,  bool isStarred,  bool hasCheckin,  int streak,  bool checkedToday,  List<EventReminder> reminder,  String description,  List<String> picturePaths,  List<String> tags)  $default,) {final _that = this;
switch (_that) {
case _Event():
return $default(_that.id,_that.name,_that.date,_that.type,_that.priority,_that.isPinned,_that.isStarred,_that.hasCheckin,_that.streak,_that.checkedToday,_that.reminder,_that.description,_that.picturePaths,_that.tags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  DateTime date,  EventType type,  EventPriority priority,  bool isPinned,  bool isStarred,  bool hasCheckin,  int streak,  bool checkedToday,  List<EventReminder> reminder,  String description,  List<String> picturePaths,  List<String> tags)?  $default,) {final _that = this;
switch (_that) {
case _Event() when $default != null:
return $default(_that.id,_that.name,_that.date,_that.type,_that.priority,_that.isPinned,_that.isStarred,_that.hasCheckin,_that.streak,_that.checkedToday,_that.reminder,_that.description,_that.picturePaths,_that.tags);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Event implements Event {
   _Event({required this.id, required this.name, required this.date, required this.type, this.priority = EventPriority.mid, this.isPinned = false, this.isStarred = false, this.hasCheckin = false, this.streak = 0, this.checkedToday = false, final  List<EventReminder> reminder = const [EventReminder.none], this.description = '', final  List<String> picturePaths = const [], final  List<String> tags = const []}): _reminder = reminder,_picturePaths = picturePaths,_tags = tags;
  factory _Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

@override final  String id;
@override final  String name;
@override final  DateTime date;
@override final  EventType type;
@override@JsonKey() final  EventPriority priority;
@override@JsonKey() final  bool isPinned;
@override@JsonKey() final  bool isStarred;
@override@JsonKey() final  bool hasCheckin;
@override@JsonKey() final  int streak;
@override@JsonKey() final  bool checkedToday;
 final  List<EventReminder> _reminder;
@override@JsonKey() List<EventReminder> get reminder {
  if (_reminder is EqualUnmodifiableListView) return _reminder;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reminder);
}

@override@JsonKey() final  String description;
 final  List<String> _picturePaths;
@override@JsonKey() List<String> get picturePaths {
  if (_picturePaths is EqualUnmodifiableListView) return _picturePaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_picturePaths);
}

 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventCopyWith<_Event> get copyWith => __$EventCopyWithImpl<_Event>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Event&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.date, date) || other.date == date)&&(identical(other.type, type) || other.type == type)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.isStarred, isStarred) || other.isStarred == isStarred)&&(identical(other.hasCheckin, hasCheckin) || other.hasCheckin == hasCheckin)&&(identical(other.streak, streak) || other.streak == streak)&&(identical(other.checkedToday, checkedToday) || other.checkedToday == checkedToday)&&const DeepCollectionEquality().equals(other._reminder, _reminder)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._picturePaths, _picturePaths)&&const DeepCollectionEquality().equals(other._tags, _tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,date,type,priority,isPinned,isStarred,hasCheckin,streak,checkedToday,const DeepCollectionEquality().hash(_reminder),description,const DeepCollectionEquality().hash(_picturePaths),const DeepCollectionEquality().hash(_tags));

@override
String toString() {
  return 'Event(id: $id, name: $name, date: $date, type: $type, priority: $priority, isPinned: $isPinned, isStarred: $isStarred, hasCheckin: $hasCheckin, streak: $streak, checkedToday: $checkedToday, reminder: $reminder, description: $description, picturePaths: $picturePaths, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$EventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$EventCopyWith(_Event value, $Res Function(_Event) _then) = __$EventCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, DateTime date, EventType type, EventPriority priority, bool isPinned, bool isStarred, bool hasCheckin, int streak, bool checkedToday, List<EventReminder> reminder, String description, List<String> picturePaths, List<String> tags
});




}
/// @nodoc
class __$EventCopyWithImpl<$Res>
    implements _$EventCopyWith<$Res> {
  __$EventCopyWithImpl(this._self, this._then);

  final _Event _self;
  final $Res Function(_Event) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? date = null,Object? type = null,Object? priority = null,Object? isPinned = null,Object? isStarred = null,Object? hasCheckin = null,Object? streak = null,Object? checkedToday = null,Object? reminder = null,Object? description = null,Object? picturePaths = null,Object? tags = null,}) {
  return _then(_Event(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as EventType,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as EventPriority,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,isStarred: null == isStarred ? _self.isStarred : isStarred // ignore: cast_nullable_to_non_nullable
as bool,hasCheckin: null == hasCheckin ? _self.hasCheckin : hasCheckin // ignore: cast_nullable_to_non_nullable
as bool,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,checkedToday: null == checkedToday ? _self.checkedToday : checkedToday // ignore: cast_nullable_to_non_nullable
as bool,reminder: null == reminder ? _self._reminder : reminder // ignore: cast_nullable_to_non_nullable
as List<EventReminder>,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,picturePaths: null == picturePaths ? _self._picturePaths : picturePaths // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
