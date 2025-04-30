const std = @import("std");
const ValueArray = @import("value.zig").ValueArray;
const Value = @import("value.zig").Value;
const growCapacity = @import("common.zig").growCapacity;

pub const OpCode = enum(u8) {
    OP_RETURN,
    OP_CONSTANT,
};

pub const Chunk = struct {
    const Self = @This();

    code: []u8,
    lines: []u8,
    constants: ValueArray,
    capacity: usize,
    count: usize,

    pub fn init() Chunk {
        return Chunk{
            .count = 0,
            .capacity = 0,
            .lines = undefined,
            .code = undefined,
            .constants = undefined,
        };
    }

    pub fn deinit(this: *Self, allocator: std.mem.Allocator) void {
        allocator.free(this.code);
        this.constants.deinit(allocator);
        this.lines = &.{};
        this.code = &.{};
        this.count = 0;
        this.capacity = 0;
    }

    pub fn write(this: *Self, allocator: std.mem.Allocator, byte: u8) !void {
        if (this.capacity < this.count + 1) {
            this.capacity = growCapacity(this.capacity);
            this.code = try allocator.realloc(this.code, this.capacity);
        }
        this.code[this.count] = byte;
        this.count = this.count + 1;
    }

    pub fn addConstant(this: *Self, allocator: std.mem.Allocator, constant: Value) !usize {
        try this.constants.write(allocator, constant);
        // maybe + 1, not - 1, idk for a while...
        return this.constants.count - 1;
    }
};
