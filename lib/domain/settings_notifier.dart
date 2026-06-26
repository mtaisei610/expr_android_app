import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../infrastructure/storage_service.dart';

class SettingsState {
  final int customTime;
  final String soundPath;

  SettingsState({required this.customTime, required this.soundPath});

  SettingsState copyWith({int? customTime, String? soundPath}) {
    return SettingsState(
      customTime: customTime ?? this.customTime,
      soundPath: soundPath ?? this.soundPath,
    );
  }
}

final settingsNotifierProvider =
    AsyncNotifierProvider<SettingsNotifier, SettingsState>(() {
  return SettingsNotifier();
});

class SettingsNotifier extends AsyncNotifier<SettingsState> {
  late final StorageService _storageService;

  @override
  Future<SettingsState> build() async {
    _storageService = StorageService();

    final customTime = await _storageService.getCustomTime();
    final soundPath = await _storageService.getAlarmSound();

    return SettingsState(customTime: customTime, soundPath: soundPath);
  }

  Future<void> updateCustomTime(int minutes) async {
    await _storageService.saveCustomTime(minutes);

    state = await AsyncValue.guard(() async {
      final currentState = state.value!;
      return currentState.copyWith(customTime: minutes);
    });
  }

  Future<void> updateSound(String soundPath) async {
    await _storageService.saveAlarmSound(soundPath);

    state = await AsyncValue.guard(() async {
      final currentState = state.value!;
      return currentState.copyWith(soundPath: soundPath);
    });
  }
}
