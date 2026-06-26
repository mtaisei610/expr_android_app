import 'package:flutter/material.dart'; // 1. Flutter基本UIのインポート
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 2. Riverpodのインポート

import '../../domain/timer_notifier.dart';
import '../../domain/settings_notifier.dart';
// 3. 遷移先の画面や使用するウィジェットのインポート（実際のパスに合わせて調整してください）
import 'timer_screen.dart';
import 'settings_screen.dart';
import '../egg_selector_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 4. AsyncNotifierの状態（AsyncValue）から安全に値を取り出す
    final settingsAsync = ref.watch(settingsNotifierProvider);

    // データがロード中、またはエラーの場合はデフォルトの 5 分、ロード完了なら保存された値を使用
    final int customMinutes = settingsAsync.when(
      data: (state) => state.customTime,
      loading: () => 5,
      error: (_, __) => 5,
    );

    void startTimer(int minutes) {
      ref.read(timerNotifierProvider.notifier).startTimer(minutes);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TimerScreen()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('ゆで卵タイマー'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 24.0,
            runSpacing: 24.0,
            alignment: WrapAlignment.center,
            children: [
              EggSelectorButton(
                label: '半熟 (7分)',
                minutes: 7,
                onPressed: () => startTimer(7),
              ),
              EggSelectorButton(
                label: '普通 (9分)',
                minutes: 9,
                onPressed: () => startTimer(9),
              ),
              EggSelectorButton(
                label: '固茹で (12分)',
                minutes: 12,
                onPressed: () => startTimer(12),
              ),
              EggSelectorButton(
                label: 'プリセット ($customMinutes分)',
                minutes: customMinutes,
                onPressed: () => startTimer(customMinutes),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
