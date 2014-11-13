require 'debugger'
load 'atms.rb'

debugger
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

puts "end of test"
