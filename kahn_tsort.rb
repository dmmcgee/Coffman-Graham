module KahnTsort
  
  attr_accessor :sorted
  
  def kahn_tsort
    sorted = []
    no_incoming = []
    edges = 0
    
    coffman_each_node do |n|
      if coffman_all_preds(n).empty?
        no_incoming << n
      else
        edges += coffman_all_preds(n).length
      end
    end
  
    while !no_incoming.empty?
      no_pred = no_incoming.shift
      sorted << no_pred
      
      coffman_each_node do |n|
        if coffman_all_preds(n).include?(no_pred)
          coffman_delete_edge(no_pred, n)
          edges -= 1
          if coffman_all_preds(n).empty?
            no_incoming << n
          end
        end
      end
    end
    
    if edges != 0
      raise "Graph has at least one cycle"
    else
      return sorted
    end
    
  end

end

