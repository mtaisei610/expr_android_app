import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  AudioService() {
    _player.setReleaseMode(ReleaseMode.loop);
  }

  /// Play a sound. If [soundPath] starts with "assets/" it will be treated
  /// as an asset path. Otherwise it will be treated as a file path/URL.
  Future<void> play(String soundPath) async {
    try {
      if (soundPath.startsWith('assets/')) {
        // audioplayers AssetSource expects path relative to assets/
        final relative = soundPath.replaceFirst('assets/', '');
        await _player.play(AssetSource(relative));
      } else {
        await _player.play(DeviceFileSource(soundPath));
      }
    } catch (_) {
      // ignore errors for now; higher-level code may log if needed
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (_) {}
  }
}
