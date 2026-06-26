import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../domain/settings_notifier.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late TextEditingController _timeController;

  @override
  void initState() {
    super.initState();
    // TODO: プロバイダーから現在のカスタム時間を取得して初期値にする
    // final initialTime = ref.read(settingsNotifierProvider).customTime;
    const int initialTime = 15; // モック値
    _timeController = TextEditingController(text: initialTime.toString());
  }

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: プロバイダーから現在のアラーム音を取得する
    // final selectedSound = ref.watch(settingsNotifierProvider).soundPath;
    const String selectedSound = 'alarm_1.mp3'; // モック値

    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '任意の茹で時間 (分)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _timeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '例: 15',
                suffixText: '分',
              ),
              onSubmitted: (value) {
                final minutes = int.tryParse(value);
                if (minutes != null && minutes > 0) {
                  // TODO: 担当Bのメソッドを呼び出して状態を更新
                  // ref.read(settingsNotifierProvider.notifier).updateCustomTime(minutes);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('任意の時間を保存しました')),
                  );
                }
              },
            ),
            const SizedBox(height: 40),
            const Text(
              'アラーム音',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedSound,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'alarm_1.mp3', child: Text('デフォルト (ピピピ)')),
                DropdownMenuItem(value: 'alarm_2.mp3', child: Text('ベル音')),
                DropdownMenuItem(value: 'alarm_3.mp3', child: Text('メロディ')),
              ],
              onChanged: (value) {
                if (value != null) {
                  // TODO: 担当Bのメソッドを呼び出して状態を更新
                  // ref.read(settingsNotifierProvider.notifier).updateSound(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}}