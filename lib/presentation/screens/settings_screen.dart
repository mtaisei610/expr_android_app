import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/settings_notifier.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  
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
    
    final settingsAsync = ref.watch(settingsNotifierProvider);

    
    return settingsAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('設定の読み込みに失敗しました: $error')),
      ),
      data: (settingsState) {
        
        if (!_isControllerInitialized) {
          _timeController.text = settingsState.customTime.toString();
          _isControllerInitialized = true;
        }

        
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
                  }, 
                ),
                const SizedBox(height: 40),
                const Text(
                  'アラーム音',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value:
                      selectedSound, 
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: 'assets/sounds/default_alarm.mp3', child: Text('デフォルト (ピピピ)')),
                    DropdownMenuItem(value: 'assets/sounds/bell.mp3', child: Text('ベル音')),
                    DropdownMenuItem(value: 'assets/sounds/melody.mp3', child: Text('メロディ')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(settingsNotifierProvider.notifier)
                          .updateSound(value);
                    }
                  }, 
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
