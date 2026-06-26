import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/settings_notifier.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // TextEditingControllerの初期化を、データロード後に安全に行うためのフラグ
  bool _isControllerInitialized = false;
  late TextEditingController _timeController;

  @override
  void initState() {
    super.initState();
    _timeController = TextEditingController();
  }

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. AsyncValue<SettingsState> として状態を監視
    final settingsAsync = ref.watch(settingsNotifierProvider);

    // Riverpodの .when を使って、ロード中、エラー、データありの状態を綺麗に分岐
    return settingsAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('設定の読み込みに失敗しました: $error')),
      ),
      data: (settingsState) {
        // 2. データがロードされたら、1度だけTextEditingControllerに初期値をセット
        if (!_isControllerInitialized) {
          _timeController.text = settingsState.customTime.toString();
          _isControllerInitialized = true;
        }

        // 保存されている音源パスを取得
        final selectedSound = settingsState.soundPath;

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
                      ref
                          .read(settingsNotifierProvider.notifier)
                          .updateCustomTime(minutes);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('任意の時間を保存しました')),
                      );
                    }
                  }, // 不要なバックスラッシュを削除
                ),
                const SizedBox(height: 40),
                const Text(
                  'アラーム音',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value:
                      selectedSound, // initialValue から value に変更（状態変更に追従させるため）
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: 'alarm_1.mp3', child: Text('デフォルト (ピピピ)')),
                    DropdownMenuItem(value: 'alarm_2.mp3', child: Text('ベル音')),
                    DropdownMenuItem(value: 'alarm_3.mp3', child: Text('メロディ')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(settingsNotifierProvider.notifier)
                          .updateSound(value);
                    }
                  }, // 不要なバックスラッシュを削除
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
