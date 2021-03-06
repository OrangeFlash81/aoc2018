Node = Struct.new('Node', :child_nodes, :metadata_entries) do
    def size
        child_nodes.map(&:size).sum + metadata_entries.length + 2
    end

    def inspect
        to_s
    end

    def to_s
        "Node(#{child_nodes.empty? ? "-" : child_nodes.join(", ")} : #{metadata_entries})"
    end
end

def read_node(numbers, start_location)
    number_of_child_nodes = numbers[start_location]
    number_of_metadata_entries = numbers[start_location + 1]

    child_nodes = []
    number_of_child_nodes.times do |n|
        child_nodes << read_node(
            numbers,
            start_location + 2 + child_nodes.map(&:size).sum
        )
    end

    metadata_entries = number_of_metadata_entries.times.map do |n|
        numbers[start_location + 2 + child_nodes.map(&:size).sum + n]
    end

    Node.new(child_nodes, metadata_entries)
end

def node_value(node)
    return node.metadata_entries.sum if node.child_nodes.empty?

    node.metadata_entries.map do |i|
        next 0 unless i <= node.child_nodes.length
        node_value(node.child_nodes[i - 1])
    end.sum
end

input_numbers = File.read(ARGV[0]).split.map(&:to_i)

puts node_value(read_node(input_numbers, 0))
