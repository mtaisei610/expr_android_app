import 'package:flutter/material.dart'; 
import 'package:flutter_riverpod/flutter_riverpod.dart'; 

import '../../domain/timer_notifier.dart';
import '../../domain/settings_notifier.dart';

import 'timer_screen.dart';
import 'settings_screen.dart';
import '../widgets/egg_selector_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final settingsAsync = ref.watch(settingsNotifierProvider);

    
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
