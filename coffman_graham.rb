module CoffmanGraham
  
   attr_reader :sorted
  
   def coffman_graham
     no_preds = []  #holds root nodes (those with no predecessors)
     loop_nodes = [] #holds nodes to loop each iteration in while loop
     counter = 0
     
     # initialize by adding existing root nodes, removing them from loop list
     coffman_each_node do |n|
       if coffman_all_preds(n).empty?
         no_preds << n
       else
         loop_nodes << n
       end
       counter += 1
     end
  
     while no_preds.length < counter
       candidates = []   # holds candidate nodes that could be placed in ordered list next
       
       loop_nodes.each do |n|
         # for each node, find its predecessor nodes that have already been ordered
         pred_arr = coffman_all_preds(n)
         intersect = (pred_arr & no_preds) 

         # if the node has predecessors in this list, delete these predecessors from the node's predecessor list
         if !intersect.empty?
           intersect.each { |deletable| coffman_delete_edge(deletable, n) }

           # if the current node depends only on the ones already ordered, it is a candidate
           if coffman_all_preds(n).empty?
             candidates << n
           end
          
           # add the node's predecessors back for later
           intersect.each { |add_back| coffman_add_edge(add_back, n) }
         end
       end
       
       # create and populate a hash that holds candidates, in the format 
       # node id => array of indices of its predecessors that are already ordered
       pred_indices = {}
       
       candidates.each do |c|
         pred_indices[c] = []
         coffman_all_preds(c).each do |pred|
           pred_indices[c] << no_preds.index(pred)
         end
         # sort just in case
         pred_indices[c].sort!
       end
      
       # see method below that will figure out which candidate comes next
       next_up = calc_next_id(pred_indices)
        
       # we now know our next node in the order. we delete all of its predecessors so it won't
       # be a candidate again, and then we add it to the ordered list
       no_preds << next_up
       loop_nodes.delete(next_up)
     end
     
     @sorted = no_preds
     return @sorted        
    end

  private
  
   def calc_next_id(pred_hash)
     # select the candidate node that will maximize space on the ordered list between 
     # nodes and their predecessors, so that we can maximize parallel execution
    
     keys = pred_hash.keys
     most_recents = []
    
     # for all of the candidates, get the index of their most recently ordered task and collect them in 
     # a new array
     pred_hash.each_value { |v| most_recents << v.pop }
    
     # If there are no ties (ie, the earliest belongs to 2 candidates), we pick that node to come next
     # in the ordered list. If there is a tie, we delete the non contenders, make a new hash,
     # and pass it back to the method. It will now take the 2nd most recent for each candidate 
     # and comapre, etc. etc.
     # We set any nil = -1, which will be the automatic minimum; if we break a tie and a task has 
     # no other predecessors, it makes sense to schedule the one next with the fewest predecessors to 
     # minimize delays. 
     # If we have a tie where all candidates have the same preds and no others, we take a random candidate.
     
     most_recents = most_recents.map {|r| r.nil? ? r = -1 : r = r }
     earliest = most_recents.min      # take the most recent tasks for each candidate, and pick the earliest one
    
     if most_recents.count(earliest) == 1
       idx = most_recents.index(earliest)
       return keys[idx]
      
     elsif most_recents.compact.length == 1 && most_recents.compact[0] == -1
       idx = most_recents.index(most_recents.sample)
       return keys[idx]
      
     else
       deletable_idx = most_recents.each_index.select {|i| most_recents[i] != earliest}
       deletable_idx.each { |d| pred_hash.delete(keys[d]) }
       calc_next_id(pred_hash)
     end
   end
   
   def coffman_each_node(&block)
     each_key(&block)
   end  
  
   def coffman_all_preds(node)
     self[node]
   end
  
   def coffman_delete_edge(pred, succ)
     self[succ].delete(pred)
   end
  
   def coffman_add_edge(pred, succ)
     self[succ] << pred
   end
  
 end