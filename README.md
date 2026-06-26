# 茨城高専 情報工学実験IV 携帯端末アプリケーション開発

## アプリの内容

半熟・固茹でなど，ゆで加減を指定できるゆで卵用タイマー．

**Android** / **Flutter**

## 開発手順

1. 各自自分の名前のブランチで機能を開発し，push
2. `test`ブランチにmergeし，テストする
3. `main`ブランチにmerge

## 注意

### 高専校内ではgradleのプロキシを通す必要あり．

下の内容を`~/.gradle/gradle.properties`に保存

```gradle
systemProp.http.proxyHost=po.cc.ibaraki-ct.ac.jp
systemProp.http.proxyPort=3128

systemProp.https.proxyHost=po.cc.ibaraki-ct.ac.jp
systemProp.https.proxyPort=3128
```

## 仕様

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

- **`HomeScreen` (初期画面)**
- **仕様:** `AppBar`の`actions`に設定画面へ遷移する歯車アイコン(`IconButton`)を配置。画面中央に`EggSelectorButton`を4つ配置。
- **動作:** ボタンタップ時、選択された時間を`TimerNotifier`に渡し、`TimerScreen`へ遷移(`Navigator.push`)。

- **`TimerScreen` (タイマー画面)**
- **仕様:** `TimerNotifier`の残時間を購読し、`MM:SS`形式で大きく表示。下部に「キャンセル」ボタン。
- **動作:** ゼロになるとUI上でアラーム再生中であることを示し、「停止」ボタンを表示。キャンセル・停止で`HomeScreen`へ戻る(`Navigator.pop`)。

- **`SettingsScreen` (設定画面)**
- **仕様:** 「任意」の時間を設定する入力フォーム（またはピッカー）と、アラーム音を選択するドロップダウンリスト。
- **動作:** 変更時に`SettingsNotifier`を通じて`StorageService`に保存。

#### 2. Domain (状態管理・ロジック層)

- **`TimerNotifier`**
- **状態:** `remainingSeconds` (残秒数), `isRunning` (動作中フラグ).
- **メソッド:**
- `startTimer(int seconds)`: カウントダウン開始。1秒ごとに`remainingSeconds`をデクリメント。通知のスケジュール処理を呼び出す。
- `stopTimer()`: タイマー停止。通知のスケジュールをキャンセル。

- **`SettingsNotifier`**
- **状態:** `customMinutes` (任意の分数), `selectedAlarmSound` (選択された音のパス).
- **メソッド:** `loadSettings()`, `updateCustomTime(int minutes)`, `updateAlarmSound(String path)`.

#### 3. Infrastructure (インフラ層)

- **`StorageService`**
- **仕様:** `SharedPreferences`をラップし、設定データの永続化を行う。

- **`AudioService`**
- **仕様:** `audioplayers`等のパッケージを利用。
- **メソッド:** `playAlarm(String path)`, `stopAlarm()`.

- **`NotificationService`**
- **仕様:** `flutter_local_notifications`を利用。
- **メソッド:** `scheduleNotification(int seconds, String soundPath)`, `cancelNotification()`.

---

### 開発分担 (3名)

コンフリクトを防ぐため、レイヤーおよび機能単位で分割する。

- **担当A (UI/UX ＆ ルーティング)**
- **対象:** `main.dart`, `HomeScreen`, `TimerScreen`, `EggSelectorButton`
- **タスク:** 画面の静的モックアップ作成、画面遷移の実装。ロジック完成まではダミーデータでUIを構築する。

- **担当B (ビジネスロジック ＆ 状態管理)**
- **対象:** `TimerNotifier`, `SettingsNotifier`, `SettingsScreen`
- **タスク:** タイマーのカウントダウン処理の実装、設定画面のUIと状態管理の結びつけ。担当AのUIに状態を流し込む。

- **担当C (インフラ ＆ ネイティブ機能)**
- **対象:** `AudioService`, `NotificationService`, `StorageService`
- **タスク:** 音声再生ライブラリの選定と実装、バックグラウンド実行を担保するローカル通知機能の実装、設定値のローカル保存処理。最も技術的難易度が高い部分を専任する。

---

### インターフェース設計と詳細処理

以下にRiverpodを用いた状態管理を前提とした仕様を定義する。

#### 1. Infrastructure層（外部サービス）

**`StorageService` (設定の永続化)**

- `Future<int> getCustomTime()`
- 処理: SharedPreferencesから「任意」の設定時間（分）を取得。未設定ならデフォルト値（例: 5）を返す。

- `Future<void> saveCustomTime(int minutes)`
- 処理: 引数の数値をSharedPreferencesに保存。

- `Future<String> getAlarmSound()`
- 処理: SharedPreferencesからアラーム音のファイルパス（または識別子）を取得。未設定ならデフォルトパスを返す。

- `Future<void> saveAlarmSound(String soundPath)`
- 処理: 引数のパスをSharedPreferencesに保存。

**`NotificationService` (バックグラウンド通知)**

- `Future<void> initialize()`
- 処理: `flutter_local_notifications`の初期化処理と権限リクエストを行う。`main.dart`で実行。

- `Future<void> scheduleAlarm(int seconds, String soundPath)`
- 処理: 現在時刻から`seconds`秒後に、指定された`soundPath`の音を鳴らす通知をOSにスケジュール登録する。

- `Future<void> cancelAlarm()`
- 処理: 登録済みの保留中通知をすべてキャンセルする。

**`AudioService` (フォアグラウンド音声再生)**

- `Future<void> play(String soundPath)`
- 処理: `audioplayers`等を用いて指定パスの音源をループ再生する。

- `Future<void> stop()`
- 処理: 再生中の音声を停止する。

#### 2. Domain層（状態管理・ビジネスロジック）

**`SettingsNotifier` (設定状態の管理)**

- **状態 (State):** `SettingsState` (メンバ: `int customTime`, `String soundPath`)
- `Future<void> build()` (戻り値: `SettingsState`)
- 処理: `StorageService`を呼び出し、保存された時間と音声を読み込んで状態を初期化する。

- `Future<void> updateCustomTime(int minutes)`
- 処理: `StorageService.saveCustomTime`を呼び出し、成功後にStateの`customTime`を更新する。

- `Future<void> updateSound(String soundPath)`
- 処理: `StorageService.saveAlarmSound`を呼び出し、成功後にStateの`soundPath`を更新する。

**`TimerNotifier` (タイマー状態の管理)**

- **状態 (State):** `TimerState` (メンバ: `int remainingSeconds`, `bool isRunning`, `bool isFinished`)
- `TimerState build()`
- 処理: 初期状態(`0`, `false`, `false`)を返す。

- `void startTimer(int minutes)`
- 処理:

1. Stateを(`minutes * 60`, `true`, `false`)に更新。
2. `SettingsNotifier`から現在の`soundPath`を取得。
3. `NotificationService.scheduleAlarm(minutes * 60, soundPath)`を実行（バックグラウンド保険）。
4. Dartの`Timer.periodic`を1秒間隔で起動し、毎秒`remainingSeconds`を減算してStateを更新。
5. `remainingSeconds`が0になったら`Timer.periodic`を破棄し、Stateを(`0`, `false`, `true`)に更新。`AudioService.play(soundPath)`を呼び出す。

- `void stopTimer()`
- 処理:

1. 動作中の`Timer.periodic`を破棄。
2. `NotificationService.cancelAlarm()`を実行。
3. `AudioService.stop()`を実行。
4. Stateを初期状態に戻す。

---

### アプリケーションの処理の流れ

1. **アプリ起動時:** `main()`関数内で`NotificationService.initialize()`を実行し、通知権限を確保する。
2. **初期画面 (`HomeScreen`):**

- 描画時: `SettingsNotifier`がストレージから「任意」の時間設定を読み込む。
- 操作時: 4つのいずれかのボタンを押下。固定値（7, 9, 12）、または`SettingsNotifier`が保持する「任意」の数値を`TimerNotifier.startTimer(minutes)`の引数として渡す。
- 遷移: `TimerScreen`へ遷移(`Navigator.push`)。

1. **タイマー実行中 (`TimerScreen`):**

- 描画: `TimerNotifier`の`remainingSeconds`を購読し、分・秒に変換してUIに毎秒反映する。
- バックグラウンド移行時: OSの仕様でDartの処理が止まっても、手順2で登録されたOSへのローカル通知スケジュールが生きているため、時間になれば確実に通知と音が鳴る。

1. **タイマー終了時:**

- フォアグラウンドの場合、`TimerNotifier`内で`AudioService.play`が呼ばれ音が鳴る。
- UIは`isFinished == true`を検知し、「キャンセル」ボタンを「停止」ボタンに切り替え、終了エフェクトを表示する。

1. **停止・キャンセル操作:**

- 「停止/キャンセル」ボタン押下時、`TimerNotifier.stopTimer()`が呼ばれる。
- アラーム音の停止、OS通知スケジュールの破棄が行われ、`Navigator.pop`で`HomeScreen`へ戻る。
