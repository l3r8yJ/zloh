const std = @import("std");

pub const OpCode = enum {
    OP_RETURN,
};

pub const Chunk = struct {
    const Self = @This();

    code: []u8,
    capacity: usize,
    count: usize,

    pub fn init() Chunk {
        return Chunk{
            .count = 0,
            .capacity = 0,
            .code = undefined,
        };
    }

    pub fn deinit(this: *Self, allocator: std.mem.Allocator) void {
        allocator.free(this.code);
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

    inline fn growCapacity(capacity: usize) usize {
        return if (capacity < 8) 8 else capacity * 2;
    }
};
