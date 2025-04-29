const std = @import("std");

pub fn hi(name: []const u8) void {
    std.log.info("Hi, {s}!", .{name});
}
