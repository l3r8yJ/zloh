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

    // TODO:
    // “Devise an encoding that compresses the line information for a
    //series of instructions on the same line. Change writeChunk() to write this
    //compressed form, and implement a getLine() function that, given the index
    //of an instruction, determines the line where the instruction occurs.
    //Hint: It’s not necessary for getLine() to be particularly efficient.
    //Since it is called only when a runtime error occurs, it is well off the
    //critical path where performance matters.”
    pub fn write(this: *Self, allocator: std.mem.Allocator, byte: u8, line: u8) !void {
        if (this.capacity < this.count + 1) {
            this.capacity = growCapacity(this.capacity);
            this.code = try allocator.realloc(this.code, this.capacity);
            this.lines = try allocator.realloc(this.lines, this.capacity);
        }
        this.code[this.count] = byte;
        this.lines[this.count] = line;
        this.count = this.count + 1;
    }

    pub fn addConstant(this: *Self, allocator: std.mem.Allocator, constant: Value) !usize {
        try this.constants.write(allocator, constant);
        // maybe + 1, not - 1, idk for a while...
        return this.constants.count - 1;
    }
};
