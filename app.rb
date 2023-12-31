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

    # Find the node to delete
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

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11] # add to this
my_tree = BST.new(arr)
my_tree.delete(11)
p my_tree.find(5)
my_tree.pretty_print
