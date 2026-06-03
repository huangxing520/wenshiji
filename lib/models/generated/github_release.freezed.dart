// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../github_release.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GithubRelease {

 String get url;@JsonKey(name: 'assets_url') String get assetsUrl;@JsonKey(name: 'upload_url') String get uploadUrl;@JsonKey(name: 'html_url') String get htmlUrl; int get id;@JsonKey(name: 'node_id') String get nodeId;@JsonKey(name: 'tag_name') String get tagName;@JsonKey(name: 'target_commitish') String get targetCommitish; String? get name; String? get body; bool get draft; bool get prerelease;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'published_at') String get publishedAt; GithubAuthor get author; List<GithubAsset> get assets;
/// Create a copy of GithubRelease
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GithubReleaseCopyWith<GithubRelease> get copyWith => _$GithubReleaseCopyWithImpl<GithubRelease>(this as GithubRelease, _$identity);

  /// Serializes this GithubRelease to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GithubRelease&&(identical(other.url, url) || other.url == url)&&(identical(other.assetsUrl, assetsUrl) || other.assetsUrl == assetsUrl)&&(identical(other.uploadUrl, uploadUrl) || other.uploadUrl == uploadUrl)&&(identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl)&&(identical(other.id, id) || other.id == id)&&(identical(other.nodeId, nodeId) || other.nodeId == nodeId)&&(identical(other.tagName, tagName) || other.tagName == tagName)&&(identical(other.targetCommitish, targetCommitish) || other.targetCommitish == targetCommitish)&&(identical(other.name, name) || other.name == name)&&(identical(other.body, body) || other.body == body)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.prerelease, prerelease) || other.prerelease == prerelease)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.author, author) || other.author == author)&&const DeepCollectionEquality().equals(other.assets, assets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,assetsUrl,uploadUrl,htmlUrl,id,nodeId,tagName,targetCommitish,name,body,draft,prerelease,createdAt,publishedAt,author,const DeepCollectionEquality().hash(assets));

@override
String toString() {
  return 'GithubRelease(url: $url, assetsUrl: $assetsUrl, uploadUrl: $uploadUrl, htmlUrl: $htmlUrl, id: $id, nodeId: $nodeId, tagName: $tagName, targetCommitish: $targetCommitish, name: $name, body: $body, draft: $draft, prerelease: $prerelease, createdAt: $createdAt, publishedAt: $publishedAt, author: $author, assets: $assets)';
}


}

/// @nodoc
abstract mixin class $GithubReleaseCopyWith<$Res>  {
  factory $GithubReleaseCopyWith(GithubRelease value, $Res Function(GithubRelease) _then) = _$GithubReleaseCopyWithImpl;
@useResult
$Res call({
 String url,@JsonKey(name: 'assets_url') String assetsUrl,@JsonKey(name: 'upload_url') String uploadUrl,@JsonKey(name: 'html_url') String htmlUrl, int id,@JsonKey(name: 'node_id') String nodeId,@JsonKey(name: 'tag_name') String tagName,@JsonKey(name: 'target_commitish') String targetCommitish, String? name, String? body, bool draft, bool prerelease,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'published_at') String publishedAt, GithubAuthor author, List<GithubAsset> assets
});


$GithubAuthorCopyWith<$Res> get author;

}
/// @nodoc
class _$GithubReleaseCopyWithImpl<$Res>
    implements $GithubReleaseCopyWith<$Res> {
  _$GithubReleaseCopyWithImpl(this._self, this._then);

  final GithubRelease _self;
  final $Res Function(GithubRelease) _then;

/// Create a copy of GithubRelease
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? assetsUrl = null,Object? uploadUrl = null,Object? htmlUrl = null,Object? id = null,Object? nodeId = null,Object? tagName = null,Object? targetCommitish = null,Object? name = freezed,Object? body = freezed,Object? draft = null,Object? prerelease = null,Object? createdAt = null,Object? publishedAt = null,Object? author = null,Object? assets = null,}) {
  return _then(_self.copyWith(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,assetsUrl: null == assetsUrl ? _self.assetsUrl : assetsUrl // ignore: cast_nullable_to_non_nullable
as String,uploadUrl: null == uploadUrl ? _self.uploadUrl : uploadUrl // ignore: cast_nullable_to_non_nullable
as String,htmlUrl: null == htmlUrl ? _self.htmlUrl : htmlUrl // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,nodeId: null == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String,tagName: null == tagName ? _self.tagName : tagName // ignore: cast_nullable_to_non_nullable
as String,targetCommitish: null == targetCommitish ? _self.targetCommitish : targetCommitish // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as bool,prerelease: null == prerelease ? _self.prerelease : prerelease // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,publishedAt: null == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as GithubAuthor,assets: null == assets ? _self.assets : assets // ignore: cast_nullable_to_non_nullable
as List<GithubAsset>,
  ));
}
/// Create a copy of GithubRelease
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GithubAuthorCopyWith<$Res> get author {
  
  return $GithubAuthorCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}


/// Adds pattern-matching-related methods to [GithubRelease].
extension GithubReleasePatterns on GithubRelease {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GithubRelease value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GithubRelease() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GithubRelease value)  $default,){
final _that = this;
switch (_that) {
case _GithubRelease():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GithubRelease value)?  $default,){
final _that = this;
switch (_that) {
case _GithubRelease() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String url, @JsonKey(name: 'assets_url')  String assetsUrl, @JsonKey(name: 'upload_url')  String uploadUrl, @JsonKey(name: 'html_url')  String htmlUrl,  int id, @JsonKey(name: 'node_id')  String nodeId, @JsonKey(name: 'tag_name')  String tagName, @JsonKey(name: 'target_commitish')  String targetCommitish,  String? name,  String? body,  bool draft,  bool prerelease, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'published_at')  String publishedAt,  GithubAuthor author,  List<GithubAsset> assets)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GithubRelease() when $default != null:
return $default(_that.url,_that.assetsUrl,_that.uploadUrl,_that.htmlUrl,_that.id,_that.nodeId,_that.tagName,_that.targetCommitish,_that.name,_that.body,_that.draft,_that.prerelease,_that.createdAt,_that.publishedAt,_that.author,_that.assets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String url, @JsonKey(name: 'assets_url')  String assetsUrl, @JsonKey(name: 'upload_url')  String uploadUrl, @JsonKey(name: 'html_url')  String htmlUrl,  int id, @JsonKey(name: 'node_id')  String nodeId, @JsonKey(name: 'tag_name')  String tagName, @JsonKey(name: 'target_commitish')  String targetCommitish,  String? name,  String? body,  bool draft,  bool prerelease, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'published_at')  String publishedAt,  GithubAuthor author,  List<GithubAsset> assets)  $default,) {final _that = this;
switch (_that) {
case _GithubRelease():
return $default(_that.url,_that.assetsUrl,_that.uploadUrl,_that.htmlUrl,_that.id,_that.nodeId,_that.tagName,_that.targetCommitish,_that.name,_that.body,_that.draft,_that.prerelease,_that.createdAt,_that.publishedAt,_that.author,_that.assets);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String url, @JsonKey(name: 'assets_url')  String assetsUrl, @JsonKey(name: 'upload_url')  String uploadUrl, @JsonKey(name: 'html_url')  String htmlUrl,  int id, @JsonKey(name: 'node_id')  String nodeId, @JsonKey(name: 'tag_name')  String tagName, @JsonKey(name: 'target_commitish')  String targetCommitish,  String? name,  String? body,  bool draft,  bool prerelease, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'published_at')  String publishedAt,  GithubAuthor author,  List<GithubAsset> assets)?  $default,) {final _that = this;
switch (_that) {
case _GithubRelease() when $default != null:
return $default(_that.url,_that.assetsUrl,_that.uploadUrl,_that.htmlUrl,_that.id,_that.nodeId,_that.tagName,_that.targetCommitish,_that.name,_that.body,_that.draft,_that.prerelease,_that.createdAt,_that.publishedAt,_that.author,_that.assets);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GithubRelease implements GithubRelease {
  const _GithubRelease({required this.url, @JsonKey(name: 'assets_url') required this.assetsUrl, @JsonKey(name: 'upload_url') required this.uploadUrl, @JsonKey(name: 'html_url') required this.htmlUrl, required this.id, @JsonKey(name: 'node_id') required this.nodeId, @JsonKey(name: 'tag_name') required this.tagName, @JsonKey(name: 'target_commitish') required this.targetCommitish, required this.name, required this.body, this.draft = false, this.prerelease = false, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'published_at') required this.publishedAt, required this.author, final  List<GithubAsset> assets = const []}): _assets = assets;
  factory _GithubRelease.fromJson(Map<String, dynamic> json) => _$GithubReleaseFromJson(json);

@override final  String url;
@override@JsonKey(name: 'assets_url') final  String assetsUrl;
@override@JsonKey(name: 'upload_url') final  String uploadUrl;
@override@JsonKey(name: 'html_url') final  String htmlUrl;
@override final  int id;
@override@JsonKey(name: 'node_id') final  String nodeId;
@override@JsonKey(name: 'tag_name') final  String tagName;
@override@JsonKey(name: 'target_commitish') final  String targetCommitish;
@override final  String? name;
@override final  String? body;
@override@JsonKey() final  bool draft;
@override@JsonKey() final  bool prerelease;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'published_at') final  String publishedAt;
@override final  GithubAuthor author;
 final  List<GithubAsset> _assets;
@override@JsonKey() List<GithubAsset> get assets {
  if (_assets is EqualUnmodifiableListView) return _assets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assets);
}


/// Create a copy of GithubRelease
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GithubReleaseCopyWith<_GithubRelease> get copyWith => __$GithubReleaseCopyWithImpl<_GithubRelease>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GithubReleaseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GithubRelease&&(identical(other.url, url) || other.url == url)&&(identical(other.assetsUrl, assetsUrl) || other.assetsUrl == assetsUrl)&&(identical(other.uploadUrl, uploadUrl) || other.uploadUrl == uploadUrl)&&(identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl)&&(identical(other.id, id) || other.id == id)&&(identical(other.nodeId, nodeId) || other.nodeId == nodeId)&&(identical(other.tagName, tagName) || other.tagName == tagName)&&(identical(other.targetCommitish, targetCommitish) || other.targetCommitish == targetCommitish)&&(identical(other.name, name) || other.name == name)&&(identical(other.body, body) || other.body == body)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.prerelease, prerelease) || other.prerelease == prerelease)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.author, author) || other.author == author)&&const DeepCollectionEquality().equals(other._assets, _assets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,assetsUrl,uploadUrl,htmlUrl,id,nodeId,tagName,targetCommitish,name,body,draft,prerelease,createdAt,publishedAt,author,const DeepCollectionEquality().hash(_assets));

@override
String toString() {
  return 'GithubRelease(url: $url, assetsUrl: $assetsUrl, uploadUrl: $uploadUrl, htmlUrl: $htmlUrl, id: $id, nodeId: $nodeId, tagName: $tagName, targetCommitish: $targetCommitish, name: $name, body: $body, draft: $draft, prerelease: $prerelease, createdAt: $createdAt, publishedAt: $publishedAt, author: $author, assets: $assets)';
}


}

/// @nodoc
abstract mixin class _$GithubReleaseCopyWith<$Res> implements $GithubReleaseCopyWith<$Res> {
  factory _$GithubReleaseCopyWith(_GithubRelease value, $Res Function(_GithubRelease) _then) = __$GithubReleaseCopyWithImpl;
@override @useResult
$Res call({
 String url,@JsonKey(name: 'assets_url') String assetsUrl,@JsonKey(name: 'upload_url') String uploadUrl,@JsonKey(name: 'html_url') String htmlUrl, int id,@JsonKey(name: 'node_id') String nodeId,@JsonKey(name: 'tag_name') String tagName,@JsonKey(name: 'target_commitish') String targetCommitish, String? name, String? body, bool draft, bool prerelease,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'published_at') String publishedAt, GithubAuthor author, List<GithubAsset> assets
});


@override $GithubAuthorCopyWith<$Res> get author;

}
/// @nodoc
class __$GithubReleaseCopyWithImpl<$Res>
    implements _$GithubReleaseCopyWith<$Res> {
  __$GithubReleaseCopyWithImpl(this._self, this._then);

  final _GithubRelease _self;
  final $Res Function(_GithubRelease) _then;

/// Create a copy of GithubRelease
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? assetsUrl = null,Object? uploadUrl = null,Object? htmlUrl = null,Object? id = null,Object? nodeId = null,Object? tagName = null,Object? targetCommitish = null,Object? name = freezed,Object? body = freezed,Object? draft = null,Object? prerelease = null,Object? createdAt = null,Object? publishedAt = null,Object? author = null,Object? assets = null,}) {
  return _then(_GithubRelease(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,assetsUrl: null == assetsUrl ? _self.assetsUrl : assetsUrl // ignore: cast_nullable_to_non_nullable
as String,uploadUrl: null == uploadUrl ? _self.uploadUrl : uploadUrl // ignore: cast_nullable_to_non_nullable
as String,htmlUrl: null == htmlUrl ? _self.htmlUrl : htmlUrl // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,nodeId: null == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String,tagName: null == tagName ? _self.tagName : tagName // ignore: cast_nullable_to_non_nullable
as String,targetCommitish: null == targetCommitish ? _self.targetCommitish : targetCommitish // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as bool,prerelease: null == prerelease ? _self.prerelease : prerelease // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,publishedAt: null == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as GithubAuthor,assets: null == assets ? _self._assets : assets // ignore: cast_nullable_to_non_nullable
as List<GithubAsset>,
  ));
}

/// Create a copy of GithubRelease
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GithubAuthorCopyWith<$Res> get author {
  
  return $GithubAuthorCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}


/// @nodoc
mixin _$GithubAuthor {

 String get login; int get id;@JsonKey(name: 'avatar_url') String get avatarUrl;@JsonKey(name: 'html_url') String get htmlUrl;@JsonKey(name: 'repos_url') String get reposUrl;
/// Create a copy of GithubAuthor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GithubAuthorCopyWith<GithubAuthor> get copyWith => _$GithubAuthorCopyWithImpl<GithubAuthor>(this as GithubAuthor, _$identity);

  /// Serializes this GithubAuthor to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GithubAuthor&&(identical(other.login, login) || other.login == login)&&(identical(other.id, id) || other.id == id)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl)&&(identical(other.reposUrl, reposUrl) || other.reposUrl == reposUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,login,id,avatarUrl,htmlUrl,reposUrl);

@override
String toString() {
  return 'GithubAuthor(login: $login, id: $id, avatarUrl: $avatarUrl, htmlUrl: $htmlUrl, reposUrl: $reposUrl)';
}


}

/// @nodoc
abstract mixin class $GithubAuthorCopyWith<$Res>  {
  factory $GithubAuthorCopyWith(GithubAuthor value, $Res Function(GithubAuthor) _then) = _$GithubAuthorCopyWithImpl;
@useResult
$Res call({
 String login, int id,@JsonKey(name: 'avatar_url') String avatarUrl,@JsonKey(name: 'html_url') String htmlUrl,@JsonKey(name: 'repos_url') String reposUrl
});




}
/// @nodoc
class _$GithubAuthorCopyWithImpl<$Res>
    implements $GithubAuthorCopyWith<$Res> {
  _$GithubAuthorCopyWithImpl(this._self, this._then);

  final GithubAuthor _self;
  final $Res Function(GithubAuthor) _then;

/// Create a copy of GithubAuthor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? login = null,Object? id = null,Object? avatarUrl = null,Object? htmlUrl = null,Object? reposUrl = null,}) {
  return _then(_self.copyWith(
login: null == login ? _self.login : login // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,htmlUrl: null == htmlUrl ? _self.htmlUrl : htmlUrl // ignore: cast_nullable_to_non_nullable
as String,reposUrl: null == reposUrl ? _self.reposUrl : reposUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GithubAuthor].
extension GithubAuthorPatterns on GithubAuthor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GithubAuthor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GithubAuthor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GithubAuthor value)  $default,){
final _that = this;
switch (_that) {
case _GithubAuthor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GithubAuthor value)?  $default,){
final _that = this;
switch (_that) {
case _GithubAuthor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String login,  int id, @JsonKey(name: 'avatar_url')  String avatarUrl, @JsonKey(name: 'html_url')  String htmlUrl, @JsonKey(name: 'repos_url')  String reposUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GithubAuthor() when $default != null:
return $default(_that.login,_that.id,_that.avatarUrl,_that.htmlUrl,_that.reposUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String login,  int id, @JsonKey(name: 'avatar_url')  String avatarUrl, @JsonKey(name: 'html_url')  String htmlUrl, @JsonKey(name: 'repos_url')  String reposUrl)  $default,) {final _that = this;
switch (_that) {
case _GithubAuthor():
return $default(_that.login,_that.id,_that.avatarUrl,_that.htmlUrl,_that.reposUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String login,  int id, @JsonKey(name: 'avatar_url')  String avatarUrl, @JsonKey(name: 'html_url')  String htmlUrl, @JsonKey(name: 'repos_url')  String reposUrl)?  $default,) {final _that = this;
switch (_that) {
case _GithubAuthor() when $default != null:
return $default(_that.login,_that.id,_that.avatarUrl,_that.htmlUrl,_that.reposUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GithubAuthor implements GithubAuthor {
  const _GithubAuthor({required this.login, required this.id, @JsonKey(name: 'avatar_url') required this.avatarUrl, @JsonKey(name: 'html_url') required this.htmlUrl, @JsonKey(name: 'repos_url') required this.reposUrl});
  factory _GithubAuthor.fromJson(Map<String, dynamic> json) => _$GithubAuthorFromJson(json);

@override final  String login;
@override final  int id;
@override@JsonKey(name: 'avatar_url') final  String avatarUrl;
@override@JsonKey(name: 'html_url') final  String htmlUrl;
@override@JsonKey(name: 'repos_url') final  String reposUrl;

/// Create a copy of GithubAuthor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GithubAuthorCopyWith<_GithubAuthor> get copyWith => __$GithubAuthorCopyWithImpl<_GithubAuthor>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GithubAuthorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GithubAuthor&&(identical(other.login, login) || other.login == login)&&(identical(other.id, id) || other.id == id)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl)&&(identical(other.reposUrl, reposUrl) || other.reposUrl == reposUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,login,id,avatarUrl,htmlUrl,reposUrl);

@override
String toString() {
  return 'GithubAuthor(login: $login, id: $id, avatarUrl: $avatarUrl, htmlUrl: $htmlUrl, reposUrl: $reposUrl)';
}


}

/// @nodoc
abstract mixin class _$GithubAuthorCopyWith<$Res> implements $GithubAuthorCopyWith<$Res> {
  factory _$GithubAuthorCopyWith(_GithubAuthor value, $Res Function(_GithubAuthor) _then) = __$GithubAuthorCopyWithImpl;
@override @useResult
$Res call({
 String login, int id,@JsonKey(name: 'avatar_url') String avatarUrl,@JsonKey(name: 'html_url') String htmlUrl,@JsonKey(name: 'repos_url') String reposUrl
});




}
/// @nodoc
class __$GithubAuthorCopyWithImpl<$Res>
    implements _$GithubAuthorCopyWith<$Res> {
  __$GithubAuthorCopyWithImpl(this._self, this._then);

  final _GithubAuthor _self;
  final $Res Function(_GithubAuthor) _then;

/// Create a copy of GithubAuthor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? login = null,Object? id = null,Object? avatarUrl = null,Object? htmlUrl = null,Object? reposUrl = null,}) {
  return _then(_GithubAuthor(
login: null == login ? _self.login : login // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,htmlUrl: null == htmlUrl ? _self.htmlUrl : htmlUrl // ignore: cast_nullable_to_non_nullable
as String,reposUrl: null == reposUrl ? _self.reposUrl : reposUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$GithubAsset {

 String get url; int get id;@JsonKey(name: 'node_id') String get nodeId; String get name;@JsonKey(name: 'browser_download_url') String get browserDownloadUrl; String? get content_type; int get size;@JsonKey(name: 'download_count') int get downloadCount;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'updated_at') String get updatedAt;
/// Create a copy of GithubAsset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GithubAssetCopyWith<GithubAsset> get copyWith => _$GithubAssetCopyWithImpl<GithubAsset>(this as GithubAsset, _$identity);

  /// Serializes this GithubAsset to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GithubAsset&&(identical(other.url, url) || other.url == url)&&(identical(other.id, id) || other.id == id)&&(identical(other.nodeId, nodeId) || other.nodeId == nodeId)&&(identical(other.name, name) || other.name == name)&&(identical(other.browserDownloadUrl, browserDownloadUrl) || other.browserDownloadUrl == browserDownloadUrl)&&(identical(other.content_type, content_type) || other.content_type == content_type)&&(identical(other.size, size) || other.size == size)&&(identical(other.downloadCount, downloadCount) || other.downloadCount == downloadCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,id,nodeId,name,browserDownloadUrl,content_type,size,downloadCount,createdAt,updatedAt);

@override
String toString() {
  return 'GithubAsset(url: $url, id: $id, nodeId: $nodeId, name: $name, browserDownloadUrl: $browserDownloadUrl, content_type: $content_type, size: $size, downloadCount: $downloadCount, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $GithubAssetCopyWith<$Res>  {
  factory $GithubAssetCopyWith(GithubAsset value, $Res Function(GithubAsset) _then) = _$GithubAssetCopyWithImpl;
@useResult
$Res call({
 String url, int id,@JsonKey(name: 'node_id') String nodeId, String name,@JsonKey(name: 'browser_download_url') String browserDownloadUrl, String? content_type, int size,@JsonKey(name: 'download_count') int downloadCount,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}
/// @nodoc
class _$GithubAssetCopyWithImpl<$Res>
    implements $GithubAssetCopyWith<$Res> {
  _$GithubAssetCopyWithImpl(this._self, this._then);

  final GithubAsset _self;
  final $Res Function(GithubAsset) _then;

/// Create a copy of GithubAsset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? id = null,Object? nodeId = null,Object? name = null,Object? browserDownloadUrl = null,Object? content_type = freezed,Object? size = null,Object? downloadCount = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,nodeId: null == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,browserDownloadUrl: null == browserDownloadUrl ? _self.browserDownloadUrl : browserDownloadUrl // ignore: cast_nullable_to_non_nullable
as String,content_type: freezed == content_type ? _self.content_type : content_type // ignore: cast_nullable_to_non_nullable
as String?,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,downloadCount: null == downloadCount ? _self.downloadCount : downloadCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GithubAsset].
extension GithubAssetPatterns on GithubAsset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GithubAsset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GithubAsset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GithubAsset value)  $default,){
final _that = this;
switch (_that) {
case _GithubAsset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GithubAsset value)?  $default,){
final _that = this;
switch (_that) {
case _GithubAsset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String url,  int id, @JsonKey(name: 'node_id')  String nodeId,  String name, @JsonKey(name: 'browser_download_url')  String browserDownloadUrl,  String? content_type,  int size, @JsonKey(name: 'download_count')  int downloadCount, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GithubAsset() when $default != null:
return $default(_that.url,_that.id,_that.nodeId,_that.name,_that.browserDownloadUrl,_that.content_type,_that.size,_that.downloadCount,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String url,  int id, @JsonKey(name: 'node_id')  String nodeId,  String name, @JsonKey(name: 'browser_download_url')  String browserDownloadUrl,  String? content_type,  int size, @JsonKey(name: 'download_count')  int downloadCount, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _GithubAsset():
return $default(_that.url,_that.id,_that.nodeId,_that.name,_that.browserDownloadUrl,_that.content_type,_that.size,_that.downloadCount,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String url,  int id, @JsonKey(name: 'node_id')  String nodeId,  String name, @JsonKey(name: 'browser_download_url')  String browserDownloadUrl,  String? content_type,  int size, @JsonKey(name: 'download_count')  int downloadCount, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _GithubAsset() when $default != null:
return $default(_that.url,_that.id,_that.nodeId,_that.name,_that.browserDownloadUrl,_that.content_type,_that.size,_that.downloadCount,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GithubAsset implements GithubAsset {
  const _GithubAsset({required this.url, required this.id, @JsonKey(name: 'node_id') required this.nodeId, required this.name, @JsonKey(name: 'browser_download_url') required this.browserDownloadUrl, required this.content_type, required this.size, @JsonKey(name: 'download_count') required this.downloadCount, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt});
  factory _GithubAsset.fromJson(Map<String, dynamic> json) => _$GithubAssetFromJson(json);

@override final  String url;
@override final  int id;
@override@JsonKey(name: 'node_id') final  String nodeId;
@override final  String name;
@override@JsonKey(name: 'browser_download_url') final  String browserDownloadUrl;
@override final  String? content_type;
@override final  int size;
@override@JsonKey(name: 'download_count') final  int downloadCount;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'updated_at') final  String updatedAt;

/// Create a copy of GithubAsset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GithubAssetCopyWith<_GithubAsset> get copyWith => __$GithubAssetCopyWithImpl<_GithubAsset>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GithubAssetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GithubAsset&&(identical(other.url, url) || other.url == url)&&(identical(other.id, id) || other.id == id)&&(identical(other.nodeId, nodeId) || other.nodeId == nodeId)&&(identical(other.name, name) || other.name == name)&&(identical(other.browserDownloadUrl, browserDownloadUrl) || other.browserDownloadUrl == browserDownloadUrl)&&(identical(other.content_type, content_type) || other.content_type == content_type)&&(identical(other.size, size) || other.size == size)&&(identical(other.downloadCount, downloadCount) || other.downloadCount == downloadCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,id,nodeId,name,browserDownloadUrl,content_type,size,downloadCount,createdAt,updatedAt);

@override
String toString() {
  return 'GithubAsset(url: $url, id: $id, nodeId: $nodeId, name: $name, browserDownloadUrl: $browserDownloadUrl, content_type: $content_type, size: $size, downloadCount: $downloadCount, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$GithubAssetCopyWith<$Res> implements $GithubAssetCopyWith<$Res> {
  factory _$GithubAssetCopyWith(_GithubAsset value, $Res Function(_GithubAsset) _then) = __$GithubAssetCopyWithImpl;
@override @useResult
$Res call({
 String url, int id,@JsonKey(name: 'node_id') String nodeId, String name,@JsonKey(name: 'browser_download_url') String browserDownloadUrl, String? content_type, int size,@JsonKey(name: 'download_count') int downloadCount,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}
/// @nodoc
class __$GithubAssetCopyWithImpl<$Res>
    implements _$GithubAssetCopyWith<$Res> {
  __$GithubAssetCopyWithImpl(this._self, this._then);

  final _GithubAsset _self;
  final $Res Function(_GithubAsset) _then;

/// Create a copy of GithubAsset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? id = null,Object? nodeId = null,Object? name = null,Object? browserDownloadUrl = null,Object? content_type = freezed,Object? size = null,Object? downloadCount = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_GithubAsset(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,nodeId: null == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,browserDownloadUrl: null == browserDownloadUrl ? _self.browserDownloadUrl : browserDownloadUrl // ignore: cast_nullable_to_non_nullable
as String,content_type: freezed == content_type ? _self.content_type : content_type // ignore: cast_nullable_to_non_nullable
as String?,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,downloadCount: null == downloadCount ? _self.downloadCount : downloadCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
