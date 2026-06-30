import 'package:flutter/material.dart';

/// Displays one runnable example.
class ExampleSection extends StatelessWidget {
  const ExampleSection({
    super.key,
    required this.title,
    required this.description,
    required this.child,
  });

  /// Example title.
  final String title;

  /// Short description.
  final String description;

  /// Example content.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 24,
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          20,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(
                    fontWeight:
                        FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 8),

            Text(description),

            const SizedBox(height: 20),

            child,
          ],
        ),
      ),
    );
  }
}