import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/github_release.freezed.dart';
part 'generated/github_release.g.dart';

@freezed
abstract class GithubRelease with _$GithubRelease {
  const factory GithubRelease({
    required String url,
    @JsonKey(name: 'assets_url') required String assetsUrl,
    @JsonKey(name: 'upload_url') required String uploadUrl,
    @JsonKey(name: 'html_url') required String htmlUrl,
    required int id,
    @JsonKey(name: 'node_id') required String nodeId,
    @JsonKey(name: 'tag_name') required String tagName,
    @JsonKey(name: 'target_commitish') required String targetCommitish,
    required String? name,
    required String? body,
    @Default(false) bool draft,
    @Default(false) bool prerelease,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'published_at') required String publishedAt,
    required GithubAuthor author,
    @Default([]) List<GithubAsset> assets,
  }) = _GithubRelease;

  factory GithubRelease.fromJson(Map<String, dynamic> json) =>
      _$GithubReleaseFromJson(json);
}

@freezed
abstract class GithubAuthor with _$GithubAuthor {
  const factory GithubAuthor({
    required String login,
    required int id,
    @JsonKey(name: 'avatar_url') required String avatarUrl,
    @JsonKey(name: 'html_url') required String htmlUrl,
    @JsonKey(name: 'repos_url') required String reposUrl,
  }) = _GithubAuthor;

  factory GithubAuthor.fromJson(Map<String, dynamic> json) =>
      _$GithubAuthorFromJson(json);
}

@freezed
abstract class GithubAsset with _$GithubAsset {
  const factory GithubAsset({
    required String url,
    required int id,
    @JsonKey(name: 'node_id') required String nodeId,
    required String name,
    @JsonKey(name: 'browser_download_url') required String browserDownloadUrl,
    required String? content_type,
    required int size,
    @JsonKey(name: 'download_count') required int downloadCount,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _GithubAsset;

  factory GithubAsset.fromJson(Map<String, dynamic> json) =>
      _$GithubAssetFromJson(json);
}