import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// TODO: 担当Bの実装完了後、以下のプロバイダーをインポートする
// import '../../domain/timer_notifier.dart';

class TimerScreen extends ConsumerWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: 担当Bの実装完了後、TimerNotifierから状態を購読する
    // final timerState = ref.watch(timerNotifierProvider);
    // final int remainingSeconds = timerState.remainingSeconds;
    // final bool isFinished = timerState.isFinished;

    // UI確認用のモック値
    const int remainingSeconds = 125; // 2分5秒
    const bool isFinished = false;

    // MM:SS形式へのフォーマット
    final String minutesStr = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final String secondsStr = (remainingSeconds % 60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        title: const Text('タイマー'),
        automaticallyImplyLeading: false, // 意図しないスワイプバック等を防ぐため戻るボタン非表示
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
                fontFeatures: [FontFeature.tabularFigures()], // 等幅フォント機能でガタつきを防止
              ),
            ),
            const SizedBox(height: 16),
            // 終了時のみ表示されるアラートUI
            if (isFinished) ...[
              const Icon(Icons.notifications_active, size: 48, color: Colors.redAccent),
              const SizedBox(height: 8),
              const Text(
                '時間です！',
                style: TextStyle(fontSize: 24, color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
            ] else ...[
              const SizedBox(height: 80), // スペース調整用
            ],
            const SizedBox(height: 48),
            ElevatedButton.icon(
              icon: const Icon(isFinished ? Icons.stop : Icons.cancel),
              label: const Text(
                isFinished ? '停止' : 'キャンセル',
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                backgroundColor: isFinished ? Colors.red.shade100 : Colors.grey.shade200,
                foregroundColor: isFinished ? Colors.red.shade900 : Colors.black87,
              ),
              onPressed: () {
                // TODO: 担当Bの実装完了後、タイマー停止処理を呼び出す
                // ref.read(timerNotifierProvider.notifier).stopTimer();
                Navigator.pop(context); // HomeScreenへ戻る
              },
            ),
          ],
        ),
      ),
    );
  }
}