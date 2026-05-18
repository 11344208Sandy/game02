# iOS 橫向捲軸跑酷遊戲規格

## 1. 專案目標

開發一款使用 SwiftUI 製作的 iOS 橫向捲軸跑酷遊戲。玩家操作一位可愛主角在畫面中奔跑、跳躍，閃避隨機出現的寵物主題障礙物，並透過存活時間與成功閃避來累積分數。

遊戲整體風格需俏皮可愛，主角與視覺元素圍繞貓與狗設計，讓畫面有輕鬆、有活力的寵物樂園感。

## 2. 遊戲定位

- 類型：2D 橫向捲軸跑酷
- 平台：iOS
- 技術：SwiftUI + Swift
- 架構：MVVM
- 操作方式：點擊螢幕或按鈕跳躍
- 畫面方向：建議支援直向畫面優先，遊戲內容呈現橫向捲動效果

## 3. 核心玩法

1. 玩家進入遊戲首頁後，可以選擇主角：貓或狗。
2. 點擊開始後，主角會固定在畫面左側附近奔跑。
3. 場景、地面與障礙物由右往左移動，形成橫向跑酷效果。
4. 玩家點擊螢幕讓主角跳躍，避開障礙物。
5. 主角碰到障礙物時遊戲結束。
6. 遊戲進行中會持續累積分數。
7. 遊戲結束畫面顯示本局分數，並提供重新開始。

## 4. 角色設定

### 主角

- 貓咪角色：可愛、敏捷，預設名稱「跳跳喵」。
- 狗狗角色：活潑、勇敢，預設名稱「衝衝汪」。
- 角色可先使用 SwiftUI 形狀、文字 emoji 或簡易圖形呈現，後續可替換成圖片素材。

### 主角狀態

- running：奔跑中
- jumping：跳躍中
- hit：碰撞後

## 5. 障礙物設計

障礙物以貓狗生活用品與寵物相關物件為主，隨機生成。

候選障礙物：

- 狗罐頭
- 貓跳台
- 毛線球
- 寵物碗
- 逗貓棒
- 小骨頭
- 紙箱
- 狗狗玩具球

每個障礙物需包含：

- 類型
- 位置
- 尺寸
- 移動速度
- 碰撞範圍

## 6. 計分規則

- 基礎分數：遊戲每秒增加固定分數。
- 閃避分數：障礙物成功通過主角後額外加分。
- 難度加成：遊戲時間越長，障礙物速度可逐步提升。

建議初始規則：

- 每 0.1 秒增加 1 分。
- 每成功閃避 1 個障礙物增加 10 分。
- 每 15 秒略微提升捲動速度。

## 7. 碰撞檢測

使用簡化矩形碰撞檢測即可。

檢測方式：

- 主角擁有 `CGRect` 碰撞框。
- 每個障礙物擁有 `CGRect` 碰撞框。
- 遊戲每一幀更新後，判斷主角框與任一障礙物框是否相交。
- 若相交，切換至 gameOver 狀態。

為了手感可愛且公平，主角碰撞框可比視覺外觀略小，避免玩家覺得「明明沒碰到」。

## 8. 遊戲狀態

定義 `GameState`：

- ready：等待開始
- playing：遊戲中
- gameOver：遊戲結束

主要狀態流程：

```text
ready -> playing -> gameOver -> ready/playing
```

## 9. MVVM 架構與檔案分析

本專案採用 MVVM 架構，目標是讓遊戲畫面、遊戲資料與遊戲邏輯各自分工，避免把跳躍、碰撞、計分與 UI 排版全部塞在同一個 SwiftUI View 裡。

目前實際資料夾結構：

```text
game02/game02
├── Models
│   ├── GameState.swift
│   ├── Obstacle.swift
│   └── PlayerCharacter.swift
├── ViewModels
│   └── GameViewModel.swift
├── Views
│   ├── GameOverView.swift
│   ├── GameView.swift
│   ├── HUDView.swift
│   ├── ObstacleView.swift
│   └── PlayerView.swift
├── Assets.xcassets
├── ContentView.swift
└── game02App.swift
```

### 架構分層邏輯

```text
App Entry
  ↓
ContentView
  ↓ 持有 GameViewModel
GameView
  ↓ 讀取狀態並轉成畫面
PlayerView / ObstacleView / HUDView / GameOverView

玩家輸入
  ↓
GameView 呼叫 GameViewModel 方法
  ↓
GameViewModel 更新狀態、分數、障礙與碰撞結果
  ↓
SwiftUI 依狀態重新渲染畫面
```

### Model 層

Model 層負責描述遊戲中的純資料與基本類型，不直接操作畫面，也不啟動遊戲迴圈。

- `GameState.swift`
  - 定義 `GameState`：`ready`、`playing`、`gameOver`。
  - 定義 `PlayerRunState`：`running`、`jumping`、`hit`。
  - 用來讓 ViewModel 與 View 用一致狀態判斷目前遊戲流程。

- `PlayerCharacter.swift`
  - 定義 `PlayerCharacter`，目前包含 `cat` 與 `dog`。
  - 集中管理角色名稱、emoji、主色與強調色。
  - View 不需要知道角色細節，只要讀取 `name`、`emoji`、`bodyColor` 等屬性即可。

- `Obstacle.swift`
  - 定義 `Obstacle`：障礙物 id、種類、x 位置、尺寸、是否已計分。
  - 定義 `ObstacleKind`：狗罐頭、貓跳台、毛線球、寵物碗、逗貓棒、小骨頭、紙箱、玩具球。
  - 提供 `collisionRect`，讓碰撞範圍跟視覺尺寸分開，手感更公平。

### ViewModel 層

`GameViewModel.swift` 是遊戲邏輯核心，也是目前狀態的單一來源。

主要責任：

- 保存目前遊戲狀態：`gameState`。
- 保存目前角色：`selectedCharacter`。
- 保存角色動作狀態：`playerRunState`。
- 保存障礙物陣列：`obstacles`。
- 保存分數：`score`。
- 保存最高分紀錄：`highScore`。
- 保存主角跳躍高度：`playerY`。
- 啟動與停止遊戲迴圈。
- 計算重力、跳躍速度與落地。
- 隨機生成障礙物。
- 更新障礙物由右往左移動。
- 判斷障礙物是否通過主角並加分。
- 使用矩形碰撞判斷是否 game over。
- 遊戲結束時比對本局分數與最高分，並使用 `UserDefaults` 保存最高分。
- 處理重新開始與回到角色選擇。

目前使用 `@Observable` 讓 SwiftUI 自動觀察狀態變化。這樣 View 可以保持輕量，只呼叫 `startGame`、`jump`、`restartGame`、`returnToReady` 等方法，不直接改寫遊戲規則。

### View 層

View 層只負責畫面與玩家輸入，不保存核心規則。

- `ContentView.swift`
  - App 的主要畫面入口。
  - 建立並持有 `GameViewModel`。
  - 將 ViewModel 傳給 `GameView`。

- `GameView.swift`
  - 遊戲主場景。
  - 使用 `GeometryReader` 取得畫面尺寸。
  - 繪製背景、地面、主角、障礙物、HUD、開始畫面與結束畫面。
  - 處理點擊螢幕跳躍，並呼叫 `viewModel.jump()`。
  - 根據 `gameState` 顯示 ready / playing / gameOver 對應 UI。

- `PlayerView.swift`
  - 顯示貓或狗主角。
  - 根據 `PlayerCharacter` 決定 emoji 與顏色。
  - 根據 `PlayerRunState` 做簡單旋轉與縮放，讓角色更活潑。

- `ObstacleView.swift`
  - 顯示單一障礙物。
  - 根據 `ObstacleKind` 顯示不同 emoji 與名稱。
  - 不處理移動與碰撞，只接收 ViewModel 計算後的位置資料。

- `HUDView.swift`
  - 顯示分數與目前角色。
  - 提供回到角色選擇的按鈕。
  - 不計算分數，只顯示 ViewModel 給的 `score`。

- `GameOverView.swift`
  - 顯示遊戲結束資訊、本局分數與角色。
  - 提供重新開始與換角色按鈕。
  - 按鈕行為透過 closure 回呼給 `GameViewModel`。

### 資料流與事件流

1. 玩家在 ready 畫面選擇貓或狗。
2. `GameView` 呼叫 `GameViewModel.selectCharacter(_:)` 更新角色。
3. 玩家點擊開始。
4. `GameView` 呼叫 `GameViewModel.startGame(playAreaSize:)`。
5. `GameViewModel` 啟動遊戲迴圈，持續更新角色高度、障礙物位置、分數與碰撞結果。
6. 玩家點擊畫面時，`GameView` 呼叫 `GameViewModel.jump()`。
7. 若碰撞發生，`GameViewModel` 將 `gameState` 改為 `gameOver`。
8. `GameView` 依 `gameState` 顯示 `GameOverView`。
9. 玩家可選擇重新開始或回到角色選擇。

### 設計原則

- ViewModel 是唯一處理遊戲規則的地方。
- View 不直接計算碰撞、分數或障礙生成。
- Model 不依賴 ViewModel 或 View。
- 各個 View 元件保持小而清楚，方便替換美術或新增動畫。
- 後續若加入最高分、音效、道具或關卡，只需擴充 Model 與 ViewModel，再讓 View 顯示新狀態。

## 10. 技術設計

### 遊戲更新迴圈

可使用 SwiftUI 的 `TimelineView(.animation)` 或 timer 驅動畫面更新。實作階段需選擇較適合此專案的方式，目標是保持邏輯清楚且容易控制。

### 跳躍物理

使用簡化物理：

- `playerY` 表示角色垂直位置。
- `verticalVelocity` 表示垂直速度。
- 點擊跳躍時給予向上初速度。
- 每次更新套用重力。
- 回到地面後停止下墜並允許再次跳躍。

### 隨機障礙

- 障礙由右側生成。
- 每次生成間隔使用隨機秒數。
- 同一時間可存在多個障礙。
- 超出左側畫面後移除。

## 11. 視覺風格

整體風格：俏皮、柔和、可愛。

建議元素：

- 明亮天空背景。
- 草地或木地板跑道。
- 圓潤的寵物用品障礙物。
- 分數顯示使用活潑但清楚的排版。
- 貓狗角色可用 emoji 或簡易插畫風造型先完成 MVP。

色彩方向：

- 背景：淺藍、柔和綠色。
- 貓咪：橘白或奶油色。
- 狗狗：棕白或柴犬色。
- UI：白底搭配高對比文字，避免影響遊戲辨識。

## 12. MVP 驗收標準

第一版完成後需符合：

- 可以選擇貓或狗作為主角。
- 可以開始遊戲。
- 點擊畫面可讓主角跳躍。
- 障礙物會隨機從右往左出現。
- 主角碰到障礙物會結束遊戲。
- 分數會隨時間增加。
- 成功閃避障礙物會加分。
- MVP 需加入最高分紀錄，並在遊戲結束後保存到本機。
- 遊戲中與遊戲結束畫面需顯示最高分。
- 遊戲結束後可以重新開始。
- 程式碼依 MVVM 拆分，不把主要遊戲邏輯集中在 View 內。

## 13. 後續可擴充項目

- 加入音效與碰撞回饋。
- 加入角色動畫。
- 加入不同場景主題，例如客廳、公園、寵物店。
- 加入道具，例如短暫無敵、雙倍分數、小魚乾加速。
- 加入難度選擇。
- 使用圖片素材替換 emoji 或 SwiftUI 簡易形狀。

## 14. 待確認事項

請確認以下方向後再進入實作：

1. 第一版主角是否可以先使用 emoji / SwiftUI 形狀呈現？
2. 是否需要固定只支援直向，還是要強制橫向遊玩？
3. 障礙物第一版是否以文字 emoji / 簡易圖形呈現即可？
4. 最高分紀錄已納入 MVP，使用本機保存。
5. 遊戲節奏要偏簡單可愛，還是偏快節奏挑戰型？
