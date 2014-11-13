require 'debugger'

class ATMS
  attr_accessor :nodes, :nogood

  def initialize()
    @nodes = {}
    @nogood= []
  end
  
  # dataを内容とするノードnode_nameを生成する
  def create_node(node_name, data)
    @nodes[node_name] = [data, [], []]
  end

  # ノードnode_nameを仮定する
  def assume_node(node_name)
    @nodes[node_name][1] = [[node_name]]
    @nodes[node_name][2] = [[node_name]]
  end

  # ノードnode_nameをノード群node_namesで正当化する
  def justify_node(node_name, node_names)
    @nodes[node_name][2] += [node_names.clone]
    @nodes[node_name][2].uniq!
    propagate({node_name => node_names}, nil, [[]])
  end

  # 環境node_namesをNogoodに格納する
  def nogood_nodes(node_names)
    @nogood.push node_names
  end

  # ノードを正当化する際に呼ばれる。
  # justificationの前提に対して新たに追加された環境environmentsに対してjustificationの帰結ノードのラベルの更新を行う。
  def propagate(justification, node_name, environments)
    node_names = justification.values[0]
    l = weave(node_name, environments, node_names)
    unless l.empty? then
      c = justification.keys[0]
      update(l, c)
    end
  end

  # ノードの集合node_namesのひとつのノードnode_nameに環境の集合environmentsが追加されたとき、
  # ノード集合node_namesに対応するラベルに追加すべき環境の集合を計算する。
  def weave(node_name, environments, node_names)
    while not node_names.empty? do
      h = node_names.shift
      # r = node_names.last
      if h != node_name then
        environments = environments.product(@nodes[h][1]).map{|e| e.flatten}
        environments.map{|env| env.uniq!}
        environments.uniq!
        @nogood.each do |ng|
          environments = remove_above(environments, ng)
        end
      end
    end
    return environments
  end

  # ノードnode_nameのラベルに環境の集合environmentsが追加された場合を取扱う。
  # node_nameを前提の中で参照している正当化があれば、propagateを起動してラベルの更新を伝播する。
  def update(environments, node_name)
    if node_name == nil then
      environments.each do |environment|
        nogood_nodes(environment)
      end
    else
      @nodes[node_name][1].each do |env|
        environments = remove_above(environments, env)
      end
      environments.each do |env|
        @nodes[node_name][1] = remove_above(@nodes[node_name][1], env)
      end
      @nodes[node_name][1] += environments
      justifications = []
      @nodes.each do |node_key, node|
        node[2].each do |justification|
          if justification.include? node_name then
            justifications += {node_key => justification.clone}
          end
        end
      end
      justifications.each do |justification|
        propagate(justification, node_name, environments)
        @nogood.each do |ng|
          environments = remove_above(environments, ng)
        end
        return if environments.empty?
      end
    end
  end

  # environmentsから、node_namesの上の環境を除く
  def remove_above(environments, node_names)
    _es = environments.clone
    environments.each do |environment|
      if is_above(environment, node_names) then
        _es -= [environment]
      end
    end
    return _es
  end

  # above_environmentがenvironmentの上であれば真を、そうでなければ偽を返す
  def is_above(above_environment, environment)
    ret = true
    environment.each do |node_name|
      ret = false if not above_environment.include? node_name
    end
    return ret
  end
end

