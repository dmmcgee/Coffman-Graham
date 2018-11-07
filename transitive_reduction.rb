module TransitiveReduction
  
  # Finds redundant edges and removes them
  def reduction
    coffman_each_node do |node|
      coffman_all_preds(node).each do |pred|
        dfs_and_destroy(pred, node)
      end
    end
  end
  
private
  
  def dfs_and_destroy(start_node, parent_node, discovered = [])
    parent = parent_node
    discovered << start_node
    coffman_all_preds(start_node).each do |pred|
      if coffman_all_preds(parent).include?(pred)
        coffman_delete_edge(pred, parent)
      end
      if !discovered.include?(pred)
        dfs_and_destroy(pred, parent, discovered)
      end
    end
  end
  
end