# 仕様

### libディレクトリ構造

状態管理にはProviderまたはRiverpodを使用し、関心事を分離した構成とする。

```text
lib/
├── main.dart
├── core/                  # 定数、テーマ、共通設定
│   └── constants.dart     # 7分、9分、12分などの固定値
├── presentation/          # UI層
│   ├── screens/
│   │   ├── home_screen.dart       # 初期画面（時間セレクタ）
│   │   ├── timer_screen.dart      # カウントダウン画面
│   │   └── settings_screen.dart   # 設定画面
│   └── widgets/
│       └── egg_selector_button.dart # セレクタボタン部品
├── domain/                # ビジネスロジック・状態管理層
│   ├── timer_notifier.dart      # タイマー状態管理
│   └── settings_notifier.dart   # 設定状態管理
└── infrastructure/        # 外部操作・インフラ層
    ├── audio_service.dart       # アラーム音再生機能
    ├── notification_service.dart# バックグラウンド通知（代案適用分）
    └── storage_service.dart     # SharedPreferencesによる設定保存

```

---

### クラスの詳細仕様

#### 1. Presentation (UI層)

* **`HomeScreen` (初期画面)**
* **仕様:** `AppBar`の`actions`に設定画面へ遷移する歯車アイコン(`IconButton`)を配置。画面中央に`EggSelectorButton`を4つ配置。
* **動作:** ボタンタップ時、選択された時間を`TimerNotifier`に渡し、`TimerScreen`へ遷移(`Navigator.push`)。

* **`TimerScreen` (タイマー画面)**
* **仕様:** `TimerNotifier`の残時間を購読し、`MM:SS`形式で大きく表示。下部に「キャンセル」ボタン。
* **動作:** ゼロになるとUI上でアラーム再生中であることを示し、「停止」ボタンを表示。キャンセル・停止で`HomeScreen`へ戻る(`Navigator.pop`)。

* **`SettingsScreen` (設定画面)**
* **仕様:** 「任意」の時間を設定する入力フォーム（またはピッカー）と、アラーム音を選択するドロップダウンリスト。
* **動作:** 変更時に`SettingsNotifier`を通じて`StorageService`に保存。

#### 2. Domain (状態管理・ロジック層)

* **`TimerNotifier`**
* **状態:** `remainingSeconds` (残秒数), `isRunning` (動作中フラグ).
* **メソッド:**
* `startTimer(int seconds)`: カウントダウン開始。1秒ごとに`remainingSeconds`をデクリメント。通知のスケジュール処理を呼び出す。
* `stopTimer()`: タイマー停止。通知のスケジュールをキャンセル。

* **`SettingsNotifier`**
* **状態:** `customMinutes` (任意の分数), `selectedAlarmSound` (選択された音のパス).
* **メソッド:** `loadSettings()`, `updateCustomTime(int minutes)`, `updateAlarmSound(String path)`.

#### 3. Infrastructure (インフラ層)

* **`StorageService`**
* **仕様:** `SharedPreferences`をラップし、設定データの永続化を行う。

* **`AudioService`**
* **仕様:** `audioplayers`等のパッケージを利用。
* **メソッド:** `playAlarm(String path)`, `stopAlarm()`.

* **`NotificationService`**
* **仕様:** `flutter_local_notifications`を利用。
* **メソッド:** `scheduleNotification(int seconds, String soundPath)`, `cancelNotification()`.

---

### 開発分担 (3名)

コンフリクトを防ぐため、レイヤーおよび機能単位で分割する。

* **担当A (UI/UX ＆ ルーティング)**
* **対象:** `main.dart`, `HomeScreen`, `TimerScreen`, `EggSelectorButton`
* **タスク:** 画面の静的モックアップ作成、画面遷移の実装。ロジック完成まではダミーデータでUIを構築する。

* **担当B (ビジネスロジック ＆ 状態管理)**
* **対象:** `TimerNotifier`, `SettingsNotifier`, `SettingsScreen`
* **タスク:** タイマーのカウントダウン処理の実装、設定画面のUIと状態管理の結びつけ。担当AのUIに状態を流し込む。

* **担当C (インフラ ＆ ネイティブ機能)**
* **対象:** `AudioService`, `NotificationService`, `StorageService`
* **タスク:** 音声再生ライブラリの選定と実装、バックグラウンド実行を担保するローカル通知機能の実装、設定値のローカル保存処理。最も技術的難易度が高い部分を専任する。
