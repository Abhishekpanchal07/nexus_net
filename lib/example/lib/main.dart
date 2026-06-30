import 'package:flutter/material.dart';

import 'app.dart';
import 'initialization/nexus_initializer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NexusInitializer.initialize();

  runApp(
    const NexusExampleApp(),
  );
}