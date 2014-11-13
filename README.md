# atms.rb

- 作成者：03-133007 吉谷拓真
- 作成日：2014年11月13日

# このフォルダの内容物

- atms.rb
  - ATMSの実装（Rubyソースコード）
- atms_4color.rb
  - ATMSを用いて課題の4色問題を解くためのコード
- output.txt
  - atms_4color.rbの実行結果
- README.md
  - このファイル

# Usage

## atms.rb

```ruby
require 'atms.rb'
atms = ATMS.new
atms.create_node('A-', 'x=-1')
atms.create_node('A0', 'x=0')
atms.create_node('A+', 'x=1')
atms.create_node('B-', 'y=-1')
atms.create_node('B0', 'y=0')
atms.create_node('B+', 'y=1')
atms.assume_node('A-')
atms.assume_node('A0')
atms.assume_node('A+')
atms.assume_node('B-')
atms.assume_node('B0')
atms.assume_node('B+')
atms.create_node('P', 'x+y=-1')
atms.create_node('Q', 'x-y=1')
atms.create_node('R', 'x^2 - y^2 = -1')
atms.justify_node('P', ['A-', 'B0'])
atms.justify_node('P', ['A0', 'B-'])
atms.justify_node('Q', ['A0', 'B-'])
atms.justify_node('Q', ['A+', 'B0'])
atms.nogood_nodes(['A-', 'A0'])
atms.nogood_nodes(['A-', 'A+'])
atms.nogood_nodes(['A0', 'A+'])
atms.nogood_nodes(['B-', 'B0'])
atms.nogood_nodes(['B-', 'B+'])
atms.nogood_nodes(['B0', 'B+'])
atms.justify_node('R', ['P', 'Q'])
```

## atms_4color.rb

```
ruby atms_4color.rb > output.txt
```

# ノードの構造

```
[ノード名, ラベル（配列）, 正当化（配列）]
```

例：
上の例でノードRは以下のように格納されている。
```ruby
atms.nodes['R'] #=> ["x^2 - y^2 = -1", [["A0", "B-"]], [["P", "Q"]]]
```
