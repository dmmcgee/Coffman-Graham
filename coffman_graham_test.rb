require File.expand_path('transitive_reduction.rb', File.dirname(__FILE__))
require File.expand_path('coffman_graham.rb', File.dirname(__FILE__))
require File.expand_path('kahn_tsort.rb', File.dirname(__FILE__))

class Hash
  include TransitiveReduction
  include CoffmanGraham
  include KahnTsort
end

dependencies = {}

# Values are the predecessors of the keys
dependencies[:T1] = []
dependencies[:T2] = []
dependencies[:T3] = []
dependencies[:T4] = [:T1, :T2]
dependencies[:T5] = [:T2, :T3]
dependencies[:T6] = [:T3]
dependencies[:T7] = [:T4, :T1]  # redundant T1 edge will be reduced out
dependencies[:T8] = [:T4, :T9]
dependencies[:T9] = [:T5, :T6]
dependencies[:T10] = [:T6]
dependencies[:T11] = [:T7, :T8]
dependencies[:T12] = [:T8]
dependencies[:T13] = [:T9, :T10, :T2]  # redundant T2 edge will be reduced out

puts "REDUCTION:"
puts "before"
puts dependencies
puts

dependencies.reduction

puts "after"
puts dependencies
puts

dependencies_copy = Marshal.load(Marshal.dump(dependencies))  # make a deep copy for comparison

puts "KAHN TSORTED"
p dependencies.kahn_tsort
puts

puts "COFFMAN-GRAHAM SORTED"
p dependencies_copy.coffman_graham
