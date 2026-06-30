
import 'package:nexus_net/nexus_net.dart';
import '../models/demo_storage.dart';

class JwtAuthProvider extends AuthProvider {
  JwtAuthProvider(
    this.storage,
  );

  final DemoStorage storage;

  @override
  Future<Map<String, String>> getHeaders() async {
    final token =
        await storage.getAccessToken();

    if (token == null || token.isEmpty) {
      return {};
    }

    return {
      'Authorization': 'Bearer $token',
    };
  }
}