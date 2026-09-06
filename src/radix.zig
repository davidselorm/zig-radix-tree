const std = @import("std");

pub const RadixNode = struct {
    is_leaf: bool = false,
    value: ?u32 = null,
    children: [2]?*RadixNode = .{ null, null },
};
