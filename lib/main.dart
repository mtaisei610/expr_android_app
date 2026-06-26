import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Riverpodのインポートを追加
import 'infrastructure/notification_service.dart';
import 'domain/timer_notifier.dart'; // 動作確認用に一時的にインポート

void main() async {
  // Flutterのバインディング初期化（非同期の初期化処理を行う前に必須）
  WidgetsFlutterBinding.ensureInitialized();

  // 2. ローカル通知の初期化と権限リクエストを実行
  await NotificationService().initialize();

  runApp(
    // 3. アプリ全体でRiverpodの状態管理を有効にするため、ProviderScopeで囲む
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '茹で卵タイマー',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.amber), // 茹で卵っぽいカラーに変更
        useMaterial3: true,
      ),
      // 本来は担当Aが作成する初期画面（HomeScreen）に差し替えます。
      // ここでは動作確認用に一時的な仮の画面（MyHomePage）を指しています。
      home: const MyHomePage(title: '茹で卵タイマー 動作確認'),
    );
  }
}

// 4. Riverpodの状態変更を監視・操作するため、ConsumerStatefulWidgetに変更
class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // 5. TimerNotifierの状態（TimerState）を毎秒監視（購読）
    final timerState = ref.watch(timerNotifierProvider);
    // 6. メソッドを呼び出すためのnotifierを取得
    final timerNotifier = ref.read(timerNotifierProvider.notifier);

    // 残り秒数を「MM:SS」の形式に整形
    final minutes =
        (timerState.remainingSeconds / 60).floor().toString().padLeft(2, '0');
    final seconds =
        (timerState.remainingSeconds % 60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // タイマーの状態に応じて表示するテキストを切り替え
            if (timerState.isFinished)
              const Text(
                'タイマー終了！アラーム再生中...',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              )
            else if (timerState.isRunning)
              const Text('カウントダウン中...', style: TextStyle(fontSize: 18))
            else
              const Text('時間をえらんでスタートしてください', style: TextStyle(fontSize: 16)),

            const SizedBox(height: 20),

            // 残り時間の表示
            Text(
              '$minutes:$seconds',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 40),

            // テスト用のコントロールボタン
            if (!timerState.isRunning && !timerState.isFinished) ...[
              // 停止中：テスト開始ボタンを表示（例として1分＝60秒でスタート）
              ElevatedButton.icon(
                onPressed: () => timerNotifier.startTimer(1),
                icon: const Icon(Icons.play_arrow),
                label: const Text('テスト開始 (1分)'),
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12)),
              ),
            ] else ...[
              // 実行中または終了（アラーム中）：停止ボタンを表示
              ElevatedButton.icon(
                onPressed: () => timerNotifier.stopTimer(),
                icon: const Icon(Icons.stop),
                label: Text(timerState.isFinished ? 'アラーム停止' : 'タイマーキャンセル'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
