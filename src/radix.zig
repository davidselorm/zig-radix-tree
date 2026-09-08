const std = @import("std");

pub const RadixTree = struct {
    const Node = struct {
        prefix: []const u8,
        value: ?u64,
        children: std.ArrayList(*Node),

        pub fn init(allocator: std.mem.Allocator, prefix: []const u8, value: ?u64) !*Node {
            const node = try allocator.create(Node);
            node.prefix = try allocator.dupe(u8, prefix);
            node.value = value;
            node.children = std.ArrayList(*Node).init(allocator);
            return node;
        }

        pub fn deinit(self: *Node, allocator: std.mem.Allocator) void {
            for (self.children.items) |child| {
                child.deinit(allocator);
            }
            self.children.deinit();
            allocator.free(self.prefix);
            allocator.destroy(self);
        }
    };

    allocator: std.mem.Allocator,
    root: *Node,

    pub fn init(allocator: std.mem.Allocator) !RadixTree {
        const root = try Node.init(allocator, "", null);
        return .{
            .allocator = allocator,
            .root = root,
        };
    }

    pub fn deinit(self: *RadixTree) void {
        self.root.deinit(self.allocator);
    }

    pub fn insert(self: *RadixTree, key: []const u8, value: u64) !void {
        var curr = self.root;
        var rem = key;

        for (curr.children.items) |child| {
            if (rem.len > 0 and child.prefix.len > 0 and child.prefix[0] == rem[0]) {
                child.value = value;
                return;
            }
        }

        const new_node = try Node.init(self.allocator, rem, value);
        try curr.children.append(new_node);
    }

    pub fn lookup(self: *RadixTree, key: []const u8) ?u64 {
        for (self.root.children.items) |child| {
            if (std.mem.eql(u8, child.prefix, key)) {
                return child.value;
            }
        }
        return null;
    }
};

test "radix tree basic operations" {
    var tree = try RadixTree.init(std.testing.allocator);
    defer tree.deinit();

    try tree.insert("apple", 100);
    try tree.insert("app", 50);

    try std.testing.expectEqual(tree.lookup("apple"), 100);
    try std.testing.expectEqual(tree.lookup("app"), 50);
    try std.testing.expectEqual(tree.lookup("banana"), null);
}
