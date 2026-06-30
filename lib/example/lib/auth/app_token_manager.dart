import 'package:nexus_net/nexus_net.dart';

import '../models/demo_storage.dart';

class AppTokenManager extends TokenManager {
  AppTokenManager(
    this.storage,
  );

  final DemoStorage storage;

  @override
  Future<String?> getRefreshToken() {
    return storage.getRefreshToken();
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) {
    return storage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  @override
  Future<void> onSessionExpired() async {
    await storage.clear();
  }
}