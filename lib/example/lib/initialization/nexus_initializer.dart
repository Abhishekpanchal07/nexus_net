import 'package:nexus_net/nexus_net.dart';

import '../auth/app_token_manager.dart';
import '../auth/jwt_auth_provider.dart';
import '../models/demo_storage.dart';

class NexusInitializer {
  NexusInitializer._();

  static final DemoStorage storage =
      DemoStorage();

  static Future<void> initialize() async {
    // Demo tokens.
    await storage.saveTokens(
      accessToken: 'demo_access_token',
      refreshToken: 'demo_refresh_token',
    );

    await NexusClient.initialize(
      config: NetworkConfig(
        baseUrl:
            'https://jsonplaceholder.typicode.com',

        authProvider:
            JwtAuthProvider(
          storage,
        ),

        tokenManager:
            AppTokenManager(
          storage,
        ),

        refreshEndpoint:
            '/auth/refresh',

        refreshRequestBodyBuilder:
            (
          refreshToken,
        ) {
          return {
            'refresh_token':
                refreshToken,
          };
        },

        refreshTokenParser:
            (
          json,
        ) {
          return TokenPair(
            accessToken:
                json['access_token']
                    as String,
            refreshToken:
                json['refresh_token']
                    as String,
          );
        },

        enableLogs: true,
      ),
    );
  }
}