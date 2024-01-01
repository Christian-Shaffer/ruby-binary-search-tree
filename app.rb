class TreeNode
  attr_accessor :value, :left, :right

  def initialize(value)
    @value = value
    @left = nil
    @right = nil
  end
end

class BST
  attr_accessor :root

  def initialize(arr)
    @root = build_tree(arr.uniq.sort)
  end

  def build_tree(arr)
    return nil if arr.empty?
    mid_index = arr.length / 2
    node = TreeNode.new(arr[mid_index])
    node.left = build_tree(arr[0...mid_index])
    node.right = build_tree(arr[mid_index + 1..])
    node
  end

  def insert(value)
    if @root.nil?
      @root = TreeNode.new(value)
      return
    end
    current_node = @root
    previous_node = nil
    while current_node != nil
      return if current_node.value == value  # Skip duplicates
      previous_node = current_node
      if value < current_node.value
        current_node = current_node.left
      else
        current_node = current_node.right
      end
    end
    if value < previous_node.value
      previous_node.left = TreeNode.new(value)
    else
      previous_node.right = TreeNode.new(value)
    end
  end


  def delete(value)
    return if root.nil?
    current_node = @root
    previous_node = nil

    # Find the node to delete
    while current_node && current_node.value != value
      previous_node = current_node
      if value < current_node.value
        current_node = current_node.left
      else
        current_node = current_node.right
      end
    end

    return unless current_node  # Node not found

    # Case: Node has no children
    if current_node.left.nil? && current_node.right.nil?
      if previous_node.nil?  # Deleting the root node
        @root = nil
      else
        if previous_node.left == current_node
          previous_node.left = nil
        else
          previous_node.right = nil
        end
      end
    end

    # Case: Node has one child
    if current_node.left && current_node.right.nil?
      replace_node = current_node.left
    elsif current_node.right && current_node.left.nil?
      replace_node = current_node.right
    end

    if replace_node
      if previous_node.nil?  # Deleting the root node
        @root = replace_node
      else
        if previous_node.left == current_node
          previous_node.left = replace_node
        else
          previous_node.right = replace_node
        end
      end
      return
    end

    # Case: Node has two children
    if current_node.left && current_node.right
      successor = current_node.right
      successor_parent = current_node

      while successor.left
        successor_parent = successor
        successor = successor.left
      end

      current_node.value = successor.value  # Replace value

      # Remove the successor
      if successor_parent.left == successor
        successor_parent.left = successor.right
      else
        successor_parent.right = successor.right
      end
    end
  end

  def find(value)
    return if root.nil?
    current_node = @root
    previous_node = nil
    while current_node && current_node.value != value
      previous_node = current_node
      if value < current_node.value
        current_node = current_node.left
      else
        current_node = current_node.right
      end
    end
    return unless current_node
    current_node
  end

  def level_order
    return [] if @root.nil?
    queue = [@root]
    values = []
    while !queue.empty?
      current_node = queue.shift
      block_given? ? yield(current_node) : values.append(current_node.value)
      queue.append(current_node.left) if current_node.left
      queue.append(current_node.right) if current_node.right
    end
    values unless block_given?
  end

  def inorder(node = @root, &block)
    return [] if node.nil?
    values = []
    values.concat(inorder(node.left, &block)) if node.left
    block_given? ? yield(node.value) : values.append(node.value)
    values.concat(inorder(node.right, &block)) if node.right
    values
  end

  def preorder(node = @root, &block)
    return [] if node.nil?
    values = []
    block_given? ? yield(node.value) : values.append(node.value)
    values.concat(preorder(node.left, &block)) if node.left
    values.concat(preorder(node.right, &block)) if node.right
    values
  end

  def postorder(node = @root, &block)
    return [] if node.nil?
    values = []
    values.concat(postorder(node.left, &block)) if node.left
    values.concat(postorder(node.right, &block)) if node.right
    block_given? ? yield(node.value) : values.append(node.value)
    values
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def height(node)
    return -1 if node.nil?

    left_height = height(node.left)
    right_height = height(node.right)
    [left_height, right_height].max + 1 # Return the greater of the two heights, plus 1 for the current node
  end

  def depth(node)
    return nil if @root.nil? || node.nil? # Return nil if the tree is empty or the node is nil

    depth = 0
    current_node = node
    # Traverse up the tree from the node to the root
    while current_node != @root
      break unless current_node  # If the node is somehow not connected to the root, exit the loop
      current_node = find_parent(current_node)
      depth += 1
    end
    depth # Return the depth of the node
  end

  # Helper method to find the parent of a given node
  def find_parent(node)
    return nil if @root.nil? || @root == node # The root has no parent

    current_node = @root
    while current_node
      return current_node if current_node.left == node || current_node.right == node

      if node.value < current_node.value
        current_node = current_node.left
      else
        current_node = current_node.right
      end
    end
    nil  # Return nil if no parent is found (which shouldn't happen if the tree is intact)
  end

  def balanced?(node = @root)
    return [0, true] if node.nil?  # A nil node has height 0 and is balanced

    left_height, left_balanced = balanced?(node.left)
    right_height, right_balanced = balanced?(node.right)

    current_height = [left_height, right_height].max + 1
    is_balanced = (left_height - right_height).abs <= 1 && left_balanced && right_balanced

    node == @root ? is_balanced : [current_height, is_balanced]  # Return both the height and balance status
  end

  def rebalance
    node_values = self.inorder
    @root = build_tree(node_values)
  end
end

arr = (Array.new(15) { rand(1..100) })
my_tree = BST.new(arr)
my_tree.pretty_print
