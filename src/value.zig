const std = @import("std");
const growCapacity = @import("common.zig").growCapacity;

pub const Value = f64;

pub const ValueArray = struct {
    const Self = @This();

    values: []Value,
    capacity: usize,
    count: usize,

    pub fn init() ValueArray {
        return ValueArray{
            .count = 0,
            .capacity = 0,
            .values = undefined,
        };
    }

    pub fn deinit(this: *Self, allocator: std.mem.Allocator) void {
        allocator.free(this.code);
        this.code = &.{};
        this.count = 0;
        this.capacity = 0;
    }

    pub fn write(this: *Self, allocator: std.mem.Allocator, value: Value) !void {
        if (this.capacity < this.count + 1) {
            this.capacity = growCapacity(this.capacity);
            this.values = try allocator.realloc(this.values, this.capacity);
        }
        this.values[this.count] = value;
        this.count = this.count + 1;
    }
};
