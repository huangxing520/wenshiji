// github_service.dart
// GitHub Releases 服务：检查仓库最新发布版本。
// 从 lib/common/http.dart 抽离，使 http.dart 仅保留 Dio 单例 + 拦截器。
import 'package:wenshiji/common/http.dart';
import 'package:wenshiji/constants/api_constants.dart';
import 'package:wenshiji/models/github_release.dart';

class GithubService {
  /// 获取指定仓库的最新 release tag（如 "v1.2.3"），无则返回 null。
  Future<String?> getLatestReleaseVersion(String owner, String repo) async {
    final data = await httpUtil.get<GithubRelease>(
      ApiConstants.githubReleasesUrl(owner, repo),
      decoder: (json) => GithubRelease.fromJson(json),
    );
    return data.tagName;
  }
}
