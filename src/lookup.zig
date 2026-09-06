const std = @import("std");
const RadixNode = @import("radix.zig").RadixNode;

pub fn lookupLpm(root: *const RadixNode, ip: u32) ?u32 {
    var current: ?*const RadixNode = root;
    var best_match: ?u32 = null;
    var bit: u5 = 31;
    while (current != null) {
        if (current.?.value != null) best_match = current.?.value;
        const branch: usize = @intCast((ip >> bit) & 1);
        current = current.?.children[branch];
        if (bit == 0) break;
        bit -= 1;
    }
    return best_match;
}
