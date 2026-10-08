# Game Design Project Prototype

## 介紹

Prototype 以 **Awaria 第一關**為基礎，主要用來測試目前的核心玩法。

玩家需要在場地中取得零件、修理故障的 Machine，同時避開 Enemy，成功修理 Machine 2 次即可通關。

---

## 場地物件

| 物件                 | 功能                               |
| ------------------ | -------------------------------- |
| **Player (P)**     | (有godot圖片的那隻) 玩家角色，可以移動、拿取零件與修理 Machine        |
| **Enemy (E)**      | (紅色方塊)會追蹤 Player，碰到 Player 時 Game Over |
| **Machine (M)**    | (綠色方塊)會隨機故障，需要指定零件才能修理                 |
| **ItemMaker (IM)** | (白色方塊)製造修理 Machine 所需的零件               |
| **Item (I)**       | (粉色方塊)Player 可以拿取的零件                   |
| **Wall**           | (當前不可見)場地邊界，無法穿越                        |

目前只有 **1** 種零件

---

## 如何操作

### 移動

```text
W / ↑    向上
A / ←    向左
S / ↓    向下
D / →    向右
```

### 互動

```text
ENTER
```

靠近物件後按 `ENTER` 進行互動。

## 參數

* Machine 故障後有 **15 秒** 修理時間，旁邊會倒數表示壞了
* Player 移動速度 **300.0**
* Enemy 移動速度 **100.0**
* 零件製作時長 **2 秒**
---

## 通關流程
```
1. 看到 Machine 故障( Machine 開始倒數 )
        ↓
4. 前往對應的 ItemMaker
        ↓
5. 按 ENTER 製造零件
        ↓
6. 等待零件製造完成
        ↓
7. 撿起零件
        ↓
8. 回到 Machine
        ↓
9. 按 ENTER 修理
        ↓
10. 重複以上流程 2 次
        ↓
11. 通關
```

## 下一步？

* Enemy 的攻擊手段
* 實現 machine 壞掉需要互動一次才能知道需要什麼零件
* Player 可以一次拿多個零件
