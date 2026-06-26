import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/timer_notifier.dart';
import 'dart:ui'; 

class TimerScreen extends ConsumerWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerNotifierProvider);
    final int remainingSeconds = timerState.remainingSeconds;
    final bool isFinished = timerState.isFinished;

    
    final String minutesStr = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final String secondsStr = (remainingSeconds % 60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        title: const Text('タイマー'),
        automaticallyImplyLeading: false, 
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$minutesStr:$secondsStr',
              style: const TextStyle(
                fontSize: 88,
                fontWeight: FontWeight.bold,
                fontFeatures: [FontFeature.tabularFigures()], 
              ),
            ),
            const SizedBox(height: 16),
            
            if (isFinished) ...[
              const Icon(Icons.notifications_active, size: 48, color: Colors.redAccent),
              const SizedBox(height: 8),
              const Text(
                '時間です！',
                style: TextStyle(fontSize: 24, color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
            ] else ...[
              const SizedBox(height: 80), 
            ],
            const SizedBox(height: 48),
            ElevatedButton.icon(
              icon: Icon(isFinished ? Icons.stop : Icons.cancel),
              label: Text(
                isFinished ? '停止' : 'キャンセル',
                style: const TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                backgroundColor: isFinished ? Colors.red.shade100 : Colors.grey.shade200,
                foregroundColor: isFinished ? Colors.red.shade900 : Colors.black87,
              ),
              onPressed: () {
                ref.read(timerNotifierProvider.notifier).stopTimer();
                Navigator.pop(context); 
              },
            ),
          ],
        ),
      ),
    );
  }
}
