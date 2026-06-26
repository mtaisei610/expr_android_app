import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './settings_notifier.dart';
import '../infrastructure/audio_service.dart';
import '../infrastructure/notification_service.dart';

class TimerState {
  final int remainingSeconds;
  final bool isRunning;
  final bool isFinished;

  TimerState({
    required this.remainingSeconds,
    required this.isRunning,
    required this.isFinished,
  });

  TimerState copyWith({
    int? remainingSeconds,
    bool? isRunning,
    bool? isFinished,
  }) {
    return TimerState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      isFinished: isFinished ?? this.isFinished,
    );
  }
}

final timerNotifierProvider = NotifierProvider<TImerNotifier, TimerState>(() {
  return TimerNotifier();
});

class TimerNotifier extends Notifier<TimerState> {
  Timer? _ticker;

  final AudioService _audioService = AudioService();
  final NotificationService _notificationService = NottificationService();

  @override
  TimerState build() {
    return TimerState(
      remainingSeconds: 0,
      isRunning: false,
      isFinished: false,
    );
  }

  void startTimer(int minutes) {
    _ticker?.cancel();

    final totalSeconds = minutes * 60;

    state = TimerState(
      remainingSeconds: totalSeconds,
      isRunning: true,
      isFinished: false,
    );

    final settings = ref.read(settingsNotifierProvider).value;
    final soundPath = settings?.soundPath ?? 'defalut_sound.mp3';

    _notificationService.scheduleAlarm(totalSeconds, soundPath);

    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentSeconds = state.remainingSeconds - 1;

      if (currentSeconds <= 0) {
        _ticker?.cancel();
        state = TimerState(
          remainingSeconds: 0,
          isRunning: false,
          isFinished: true,
        );

        _audioService.play(soundPath);
      } else {
        state = state.copyWith(remainingSeconds: currentSeconds);
      }
    });
  }

  void stopTimer() {
    _ticker?.cancel();

    _notificationService.cancelAlarm();

    _audioService.stop();

    state = TimerState(
      remainingSeconds: 0,
      isRunning: false,
      isFinished: false,
    );
  }
}
