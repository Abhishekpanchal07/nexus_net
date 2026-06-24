import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  ConnectivityService._();

  /// Returns whether internet connectivity is available.
  static Future<bool> isConnected() async {
    final connectivityResult =
        await Connectivity().checkConnectivity();

    if (connectivityResult.contains(
      ConnectivityResult.none,
    )) {
      return false;
    }

    try {
      final result = await InternetAddress.lookup(
        'google.com',
      );

      return result.isNotEmpty &&
          result.first.rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }
}