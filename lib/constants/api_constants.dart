/// 第三方 API 地址与超时/状态码常量 —— 单一真相源。
///
/// 移除原占位 `baseUrl = 'https://api.example.com'`（从未被引用），
/// 将散落在 github_service / profile 中的硬编码 URL 集中到此，
/// 避免拼写漂移与版本号遗漏。
class ApiConstants {
  ApiConstants._();

  // ==================== 超时与状态码 ====================
  static const int connectTimeout = 10000;
  static const int receiveTimeout = 10000;
  static const int success = 200;
  static const int unauthorized = 401;

  // ==================== API 地址 ====================
  /// GitHub Releases 最新版本接口。
  static String githubReleasesUrl(String owner, String repo) =>
      'https://api.github.com/repos/$owner/$repo/releases/latest';

  /// DiceBear 头像 API 基础地址（notionists 风格）。
  static const String dicebearBaseUrl =
      'https://api.dicebear.com/10.x/notionists/png';

  /// 构造 DiceBear 头像完整 URL（含固定样式参数 + seed）。
  static String dicebearApiUrl(String seed) =>
      '$dicebearBaseUrl?size=256&borderRadius=50&backgroundColor=D4A75F&seed=$seed';
}
