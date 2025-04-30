const std = @import("std");
const Chunk = @import("chunk.zig").Chunk;
const OpCode = @import("chunk.zig").OpCode;

pub const InterpretResult = enum(u8) {
    INTERPERT_OK,
    INTERPRET_COMPILE_ERROR,
    INTERPRET_RUNTIME_ERROR,
};

pub const VM = struct {
    const Self = @This();

    chunk: *Chunk,
    ip: *u8,

    pub fn init() VM {
        return VM{
            .chunk = undefined,
            .ip = undefined,
        };
    }

    pub fn free(_: *Self, _: std.mem.Allocator) void {}

    pub fn interpert(this: *Self, chunk: *Chunk) !InterpretResult {
        this.chunk = chunk;
        this.ip = &this.chunk.code[0];
        return try this.run();
    }

    fn readByte(this: *Self) OpCode {
        const raw: u8 = this.ip.*;
        const operation: OpCode = @enumFromInt(this.ip.*);
        this.ip = &this.chunk.code[raw + 1];
        return operation;
    }

    fn run(this: *Self) !InterpretResult {
        while (true) {
            const instruction = this.readByte();
            switch (instruction) {
                .OP_RETURN => return InterpretResult.INTERPERT_OK,
                .OP_CONSTANT => return InterpretResult.INTERPERT_OK,
            }
        }
    }
};
