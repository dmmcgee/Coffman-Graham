# Coffman-Graham

Coffman-Graham algorithm in Ruby for efficient task scheduling.

This implementation models tasks as nodes in a directed acyclic graph (DAG). It extends Ruby's Hash class, where each key is a node with the corresponding value as an array of its predecessors.

The basic idea of the algorithm is that when scheduling tasks that have prior dependencies, schedule them in such a way that maximizes the time between executing a particular task and executing that task's direct predecessor. This maximizes the number of tasks that can be run in parellel, and reduces the overall makespan (execution time for all tasks). The algorithm assumes each task takes unit time. 

This implementation also performs a transitive reduction on the DAG first to remove any redundant dependencies.

### Requirements
* Tested on Ruby 2.3

## Usage

Include the following modules in your Hash class:

```
class Hash
  include TransitiveReduction
  include CoffmanGraham
end
```

Optionally, to compare the coffman-graham sort to a regular topological sort using Kahn's algorithm, also `include KahnTsort`. This module is used by the `coffman_graham_test.rb` script.

Create your hash of tasks and their predecessors (dependencies). The following is a basic example, but any object can be used in place of the symbols:

````
dependencies[:T1] = []
dependencies[:T2] = []
dependencies[:T3] = []
dependencies[:T4] = [:T1, :T2]
dependencies[:T5] = [:T2, :T3]

etc.
````

Now call the method on your dependency hash:

`array = dependencies.coffman_graham`

The method returns a sorted array of your tasks. 

## License
[MIT](https://choosealicense.com/licenses/mit/)
