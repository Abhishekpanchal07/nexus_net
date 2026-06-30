import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nexus_net/nexus_net.dart';

import '../widgets/code_block.dart';
import '../widgets/example_section.dart';
import '../widgets/result_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _api = const ApiService();

  String _response = 'Tap "Run GET" to execute the request.';

  bool _isLoading = false;

  Future<void> _runGet() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _api.get('/posts/1');

      if (!mounted) return;

      setState(() {
         _response = const JsonEncoder.withIndent(
            '  ',
          ).convert(response.data);
      });
    } on NetworkException catch (error) {
      if (!mounted) return;

      setState(() {
        _response = error.message;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _response = error.toString();
      });
    } finally {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NexusNet Example',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ExampleSection(
            title: 'GET Request',
            description: 'Fetch a list of posts using ApiService.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FilledButton.icon(
                  onPressed: _isLoading ? null : _runGet,
                  icon: _isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(
                          Icons.play_arrow,
                        ),
                  label: Text(
                    _isLoading ? 'Loading...' : 'Run GET',
                  ),
                ),
                const SizedBox(height: 20),
                ResultCard(
                  result: _response,
                ),
                const SizedBox(height: 20),
                const CodeBlock(
                  code: '''
final api = ApiService();

final response = await api.get(
  '/posts',
);

print(response.data);
''',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
