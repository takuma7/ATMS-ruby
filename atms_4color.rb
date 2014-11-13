# encoding: UTF-8

require 'debugger'
load 'atms.rb'

# solve: 与えられた問題グラフをATMSで矛盾解決まで行い4色に塗り分ける候補を生成する
#   graph: グラフデータ(string)
#   atms: ATMSのインスタンス
def solve(graph, atms)
  graph = graph.split("\n")
  graph = graph.map{|e| e.split('-').sort}
  symbol_num = 0      # グラフに含まれる固有な頂点の個数
  known_symbols = {}  # 頂点のシンボルを記録するためのハッシュ
  graph.each do |pair|
    unless known_symbols[pair[0]] then
      known_symbols[pair[0]] = true
      symbol_num += 1
    end
    unless known_symbols[pair[1]] then
      known_symbols[pair[1]] = true
      symbol_num += 1
    end
  end
  
  # 仮定ノードAi_Cjを生成する。これは領域iが色jに塗り分けられるとする仮定である。
  1.upto(symbol_num) do |i|
    1.upto(4) do |j|
      atms.create_node("A#{i}_C#{j}", "a#{i} = c#{j}")
      atms.assume_node("A#{i}_C#{j}")
    end
  end
  
  # 問題グラフの隣接関係からNogoodを生成する。隣接する領域で同じ色を持つ環境はNogoodに指定する。
  graph.each do |pair|
    1.upto(4) do |k|
      atms.nogood_nodes(["A#{pair[0]}_C#{k}", "A#{pair[1]}_C#{k}"])
    end
  end
  
  # 領域iに関するメタなノードを生成する。
  1.upto(symbol_num) do |i|
    atms.create_node("A#{i}", "Area #{i}")
    1.upto(4) do |j|
      atms.justify_node("A#{i}", ["A#{i}_C#{j}"])
    end
  end
  
  # ノードFCTはそのラベルに四色に塗り分ける候補を格納するノードである。
  # 領域iに関するメタノードを正当化に使用し、ラベルの更新を行うことで候補を生成する。
  atms.create_node("FCT", "Four Color Theorem")
  justification = []
  1.upto(symbol_num) do |i|
    justification.push "A#{i}"
  end
  atms.justify_node("FCT", justification)
end

# グラフの書式
# - 隣接する領域をハイフンで結ぶ
# - 各指定は改行で区切る
graph1 = <<GRAPH
1-2
1-3
1-4
2-3
2-4
3-4
GRAPH

graph2 = <<GRAPH
1-2
1-3
1-4
1-5
2-3
2-5
2-6
2-7
3-4
3-7
3-8
4-5
4-8
4-9
5-6
5-9
6-7
6-9
7-8
8-9
GRAPH

graph3 = <<GRAPH
1-2
1-3
1-4
1-5
1-6
1-7
2-3
2-7
3-4
4-5
5-6
5-9
6-7
6-9
7-8
7-9
GRAPH

# 各問題のためにATMSインスタンス生成
atms1 = ATMS.new
atms2 = ATMS.new
atms3 = ATMS.new

solve(graph1, atms1)
solve(graph2, atms2)
solve(graph3, atms3)

# 結果表示

puts "\#"*80
puts "\# Problem 1"
puts "\#"*80
atms1.nodes['FCT'][1].each do |env|
  p env
end

puts ""

puts "\#"*80
puts "\# Problem 2"
puts "\#"*80
atms2.nodes['FCT'][1].each do |env|
  p env
end

puts ""

puts "\#"*80
puts "\# Problem 3"
puts "\#"*80
atms3.nodes['FCT'][1].each do |env|
  p env
end
