// WebDAV 凭据安全存储（替代旧 AppConfig 中的明文凭据字段）。
// 使用 flutter_secure_storage：Android Keystore / iOS Keychain / Windows DPAPI。
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// WebDAV 凭据记录。
typedef WebdavCredentials = ({
  String username,
  String password,
  String serverUrl,
});

class SecureStorage {
  static final SecureStorage instance = SecureStorage._internal();
  factory SecureStorage() => instance;
  SecureStorage._internal();

  static const _keyUsername = 'webdav_username';
  static const _keyPassword = 'webdav_password';
  static const _keyServerUrl = 'webdav_server_url';

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    // encryptedSharedPreferences 已废弃（Jetpack Security 弃用），
    // 平台会自动迁移到自定义 cipher，该参数被忽略，故移除。
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  /// 保存 WebDAV 凭据。空值走 delete（避免留下空串被误判为「已配置」）。
  Future<void> saveWebdavCredentials({
    required String username,
    required String password,
    required String serverUrl,
  }) async {
    await _writeOrDelete(_keyUsername, username);
    await _writeOrDelete(_keyPassword, password);
    await _writeOrDelete(_keyServerUrl, serverUrl);
  }

  Future<void> _writeOrDelete(String key, String value) async {
    if (value.isEmpty) {
      await _storage.delete(key: key);
    } else {
      await _storage.write(key: key, value: value);
    }
  }

  /// 读取 WebDAV 凭据。以 serverUrl 是否为空作为「未配置」判据
  /// （用户名/密码可为空：服务端允许匿名时合法）。
  Future<WebdavCredentials?> getWebdavCredentials() async {
    final username = await _storage.read(key: _keyUsername);
    final password = await _storage.read(key: _keyPassword);
    final serverUrl = await _storage.read(key: _keyServerUrl);
    if (serverUrl == null || serverUrl.isEmpty) {
      return null;
    }
    return (
      username: username ?? '',
      password: password ?? '',
      serverUrl: serverUrl,
    );
  }

  Future<String> getServerUrl() async =>
      await _storage.read(key: _keyServerUrl) ?? '';

  Future<String> getUsername() async =>
      await _storage.read(key: _keyUsername) ?? '';

  Future<String> getPassword() async =>
      await _storage.read(key: _keyPassword) ?? '';

  Future<void> clearWebdavCredentials() async {
    await _storage.delete(key: _keyUsername);
    await _storage.delete(key: _keyPassword);
    await _storage.delete(key: _keyServerUrl);
  }

  /// 一次性迁移：将旧 SharedPreferences 中的明文凭据迁入 secure storage。
  /// 幂等：若 secure storage 已有凭据则跳过。
  /// [readLegacyCredentials] 返回旧存储中的 (username, password, serverUrl) 或 null。
  Future<bool> migrateFromLegacy({
    required Future<({String username, String password, String serverUrl})?>
        Function() readLegacyCredentials,
    required Future<void> Function() clearLegacyCredentials,
  }) async {
    final existing = await getWebdavCredentials();
    if (existing != null && existing.serverUrl.isNotEmpty) {
      return false;
    }
    final legacy = await readLegacyCredentials();
    if (legacy == null) return false;
    await saveWebdavCredentials(
      username: legacy.username,
      password: legacy.password,
      serverUrl: legacy.serverUrl,
    );
    await clearLegacyCredentials();
    return true;
  }
}
