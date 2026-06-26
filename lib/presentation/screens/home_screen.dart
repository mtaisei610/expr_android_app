import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/egg_selector_button.dart';
import 'timer_screen.dart';
import 'settings_screen.dart';
// TODO: 担当Bの実装完了後、以下のプロバイダーをインポートする
// import '../../domain/timer_notifier.dart';
// import '../../domain/settings_notifier.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: 担当Bの実装完了後、設定状態からカスタム分数を取得する
    // final customMinutes = ref.watch(settingsNotifierProvider).customTime;
    const int customMinutes = 15; // UI確認用のモック値

    void startTimer(int minutes) {
      // TODO: 担当Bの実装完了後、タイマー開始メソッドを呼び出す
      // ref.read(timerNotifierProvider.notifier).startTimer(minutes);

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
                label: '任意 ($customMinutes分)',
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