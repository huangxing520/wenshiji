// webdav_service.dart
// WebDAV 服务：封装 webdav_client_plus 的远程文件操作。
// 凭据来自 SecureStorage，调用方无需直接处理 WebdavClient 构造。
import 'package:webdav_client_plus/webdav_client_plus.dart';
import 'package:wenshiji/common/secure_storage.dart';

class WebdavService {
  WebdavService(this._client);
  final WebdavClient _client;

  /// 从凭据构造（用户名为空时走 noAuth）。
  /// 强制 https，避免 BasicAuth 凭据以明文出网；并设置收发/连接超时。
  factory WebdavService.fromCredentials({
    required String url,
    required String user,
    required String pwd,
  }) {
    final normalized = _normalizeUrl(url);
    final client = user.isEmpty
        ? WebdavClient.noAuth(url: normalized)
        : WebdavClient(url: normalized, auth: BasicAuth(user: user, pwd: pwd));
    client.setConnectTimeout(10000);
    client.setSendTimeout(30000);
    client.setReceiveTimeout(30000);
    return WebdavService(client);
  }

  /// 归一化 URL：无 scheme 时补 https；http 时给出告警（仍允许，便于内网自建）。
  static String _normalizeUrl(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('WebDAV 地址为空');
    }
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    return 'https://$trimmed';
  }

  /// 从 SecureStorage 读取凭据并构造；未保存过凭据返回 null。
  static Future<WebdavService?> fromStorage() async {
    final creds = await SecureStorage().getWebdavCredentials();
    if (creds == null) return null;
    return WebdavService.fromCredentials(
      url: creds.serverUrl,
      user: creds.username,
      pwd: creds.password,
    );
  }

  /// 测试连通性：读取根目录。
  Future<void> testConnection() => _client.readDir('/');

  /// 递归创建远端目录（已存在则跳过）。
  Future<void> mkdirAll(String dir) => _client.mkdirAll(dir);

  /// 列出远端目录下的文件。
  Future<List<WebdavFile>> readDir(String dir) => _client.readDir(dir);

  /// 上传本地文件到远端路径。
  Future<void> uploadFile(String localPath, String remotePath) =>
      _client.writeFile(localPath, remotePath);

  /// 下载远端文件到本地路径。
  Future<void> downloadFile(String remotePath, String localPath) =>
      _client.readFile(remotePath, localPath);

  /// 删除远端文件。
  Future<void> remove(String remotePath) => _client.remove(remotePath);
}
