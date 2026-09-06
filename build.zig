const std = @import("std");
pub fn build(b: *std.Build) void {
    const lib = b.addStaticLibrary(.{ .name = "zig-radix", .root_source_file = b.path("src/radix.zig"), .target = b.standardTargetOptions(.{}), .optimize = b.standardOptimizeOption({}) });
    b.installArtifact(lib);
}
