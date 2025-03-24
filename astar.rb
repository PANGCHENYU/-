class AStar
  Node = Struct.new(:x, :y, :parent, :g, :h, :f)

  def initialize(map)
    @map = map
    @rows = map.size
    @cols = map[0].size
  end

  def search(start_node, end_node)
    open_list = []
    closed_list = []

    start_node = Node.new(start_node[0], start_node[1], nil, 0, heuristic(start_node, end_node), 0)
    start_node.f = start_node.g + start_node.h
    open_list << start_node

    until open_list.empty?
      current_node = open_list.min_by(&:f)
      open_list.delete(current_node)
      closed_list << current_node

      return reconstruct_path(current_node) if current_node.x == end_node[0] && current_node.y == end_node[1]

      neighbors(current_node).each do |neighbor|
        next if closed_list.any? { |node| node.x == neighbor.x && node.y == neighbor.y }

        tentative_g = current_node.g + 1

        existing_node = open_list.find { |node| node.x == neighbor.x && node.y == neighbor.y }
        if existing_node.nil?
          neighbor.g = tentative_g
          neighbor.h = heuristic([neighbor.x, neighbor.y], end_node)
          neighbor.f = neighbor.g + neighbor.h
          open_list << neighbor
        elsif tentative_g < existing_node.g
          existing_node.parent = current_node
          existing_node.g = tentative_g
          existing_node.f = existing_node.g + existing_node.h
        end
      end
    end

    []
  end

  private

  def heuristic(node, end_node)
    (node[0] - end_node[0]).abs + (node[1] - end_node[1]).abs
  end

  def neighbors(node)
    neighbors = []

    [[0, 1], [1, 0], [0, -1], [-1, 0]].each do |offset|
      new_x = node.x + offset[0]
      new_y = node.y + offset[1]

      if valid_position?(new_x, new_y)
        neighbors << Node.new(new_x, new_y, node, 0, 0, 0)
      end
    end

    neighbors
  end

  def valid_position?(x, y)
    x >= 0 && y >= 0 && x < @cols && y < @rows && @map[y][x] == 0
  end

  def reconstruct_path(node)
    path = []
    while node
      path << [node.x, node.y]
      node = node.parent
    end
    path.reverse
  end
end
