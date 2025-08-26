<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

A 4bit toy CPU "TD4" from "[CPU の創りかた](https://book.mynavi.jp/ec/products/detail/id=22065)" by 渡波郁.

This chip has a CPU and a program memory.  
It has three modes; "Load", "Read" and "Execution".
The mode can be selected with ui_in[6] & ui_in[7].

_Truth table for mode select_

| ui_in[6]: Read | ui_in[7]: Execution | Operating mode |
| -------------- | ------------------- | -------------- |
| 0              | 1                   | Execution      |
| 0              | 0                   | Load           |
| 1              | 1                   | Execution      |
| 1              | 0                   | Read           |

For every operating mode, each pin has a different function; for detailed pin assignments, refer to `info.yaml`

---

渡波郁 著 "[CPU の創りかた](https://book.mynavi.jp/ec/products/detail/id=22065)"の 4bit CPU TD4 を実装しました．

純粋な TD4 のみを実装したわけではなく，プログラムを格納する 8bit 16word の ROM もチップ上に実装しています．  
そのため，プログラムを ROM に書き込む Write モード，ROM の値を読み取る Read モード，プログラムを実行する Execution モードの 3 モードを取ります．  
この切換は ui_in[6]及び ui_in[7]によって行えます．
上に掲載した真理値表(Truth table for mode select)を参照してください．

また，ピンの機能は動作モードにより異なります．
その割り当ては`info.yaml`を参照して確認してください．

このプロジェクトは[セキュリティ・キャンプ 2025 全国大会](https://www.ipa.go.jp/jinzai/security-camp/2025/camp/zenkoku/index.html) 開発コース L2 ゼミの指導の下行われました．

## How to test

```cmd
cd test/
make -B
```

## External hardware

- Some LED or an Arduino for read or write data
