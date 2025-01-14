import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../bloc/ai_bloc.dart';
import '../bloc/ai_event.dart';
import '../bloc/ai_state.dart';

class AIScreen extends StatelessWidget {
  const AIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final aiBloc = BlocProvider.of<AIBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Image Recognition'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Simulate selecting an image
                const imagePath =
                    'assets/sample.jpg'; // Replace with actual path
                aiBloc.add(PerformImageRecognitionEvent(imagePath: imagePath));
              },
              child: const Text('Recognize Image'),
            ),
            const SizedBox(height: 20),
            BlocBuilder<AIBloc, AIState>(
              builder: (context, state) {
                if (state is AILoading) {
                  return const CircularProgressIndicator();
                } else if (state is AIImageRecognitionSuccess) {
                  return Column(
                    children: state.results.map((result) {
                      return Text(result['label'] ?? 'Unknown');
                    }).toList(),
                  );
                } else if (state is AIError) {
                  return Text(state.message,
                      style: const TextStyle(color: Colors.red));
                } else {
                  return const Text('Press the button to start recognition.');
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                var box = Hive.box('recognition_results');
                var lastResults = box.get('last_results') ?? [];
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Saved Results'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        lastResults.length,
                        (index) =>
                            Text(lastResults[index]['label'] ?? 'Unknown'),
                      ),
                    ),
                  ),
                );
              },
              child: const Text('Show Last Results'),
            ),
          ],
        ),
      ),
    );
  }
}
