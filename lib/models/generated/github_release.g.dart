// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../github_release.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GithubRelease _$GithubReleaseFromJson(Map<String, dynamic> json) =>
    _GithubRelease(
      url: json['url'] as String,
      assetsUrl: json['assets_url'] as String,
      uploadUrl: json['upload_url'] as String,
      htmlUrl: json['html_url'] as String,
      id: (json['id'] as num).toInt(),
      nodeId: json['node_id'] as String,
      tagName: json['tag_name'] as String,
      targetCommitish: json['target_commitish'] as String,
      name: json['name'] as String?,
      body: json['body'] as String?,
      draft: json['draft'] as bool? ?? false,
      prerelease: json['prerelease'] as bool? ?? false,
      createdAt: json['created_at'] as String,
      publishedAt: json['published_at'] as String,
      author: GithubAuthor.fromJson(json['author'] as Map<String, dynamic>),
      assets:
          (json['assets'] as List<dynamic>?)
              ?.map((e) => GithubAsset.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$GithubReleaseToJson(_GithubRelease instance) =>
    <String, dynamic>{
      'url': instance.url,
      'assets_url': instance.assetsUrl,
      'upload_url': instance.uploadUrl,
      'html_url': instance.htmlUrl,
      'id': instance.id,
      'node_id': instance.nodeId,
      'tag_name': instance.tagName,
      'target_commitish': instance.targetCommitish,
      'name': instance.name,
      'body': instance.body,
      'draft': instance.draft,
      'prerelease': instance.prerelease,
      'created_at': instance.createdAt,
      'published_at': instance.publishedAt,
      'author': instance.author,
      'assets': instance.assets,
    };

_GithubAuthor _$GithubAuthorFromJson(Map<String, dynamic> json) =>
    _GithubAuthor(
      login: json['login'] as String,
      id: (json['id'] as num).toInt(),
      avatarUrl: json['avatar_url'] as String,
      htmlUrl: json['html_url'] as String,
      reposUrl: json['repos_url'] as String,
    );

Map<String, dynamic> _$GithubAuthorToJson(_GithubAuthor instance) =>
    <String, dynamic>{
      'login': instance.login,
      'id': instance.id,
      'avatar_url': instance.avatarUrl,
      'html_url': instance.htmlUrl,
      'repos_url': instance.reposUrl,
    };

_GithubAsset _$GithubAssetFromJson(Map<String, dynamic> json) => _GithubAsset(
  url: json['url'] as String,
  id: (json['id'] as num).toInt(),
  nodeId: json['node_id'] as String,
  name: json['name'] as String,
  browserDownloadUrl: json['browser_download_url'] as String,
  content_type: json['content_type'] as String?,
  size: (json['size'] as num).toInt(),
  downloadCount: (json['download_count'] as num).toInt(),
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$GithubAssetToJson(_GithubAsset instance) =>
    <String, dynamic>{
      'url': instance.url,
      'id': instance.id,
      'node_id': instance.nodeId,
      'name': instance.name,
      'browser_download_url': instance.browserDownloadUrl,
      'content_type': instance.content_type,
      'size': instance.size,
      'download_count': instance.downloadCount,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
