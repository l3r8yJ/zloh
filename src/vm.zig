const std = @import("std");
const movePtr = @import("common.zig").movePtr;
const Chunk = @import("chunk.zig").Chunk;
const OpCode = @import("chunk.zig").OpCode;
const Value = @import("value.zig").Value;

pub const InterpretResult = enum(u8) {
    INTERPERT_OK,
    INTERPRET_COMPILE_ERROR,
    INTERPRET_RUNTIME_ERROR,
    BROKEN_VM,
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

    pub fn interpert(this: *Self, chunk: *Chunk) InterpretResult {
        this.chunk = chunk;
        this.ip = @ptrCast(this.chunk.code.ptr);
        return this.run();
    }

    fn run(this: *Self) InterpretResult {
        while (true) {
            const instruction = this.readByte();
            switch (instruction) {
                .OP_CONSTANT => {
                    const constant = this.readConstant();
                    std.debug.print("{d}\n", .{constant});
                    break;
                },
                .OP_RETURN => return InterpretResult.INTERPERT_OK,
            }
        }
        return InterpretResult.INTERPERT_OK;
    }

    fn readByte(this: *Self) OpCode {
        const operation = this.ip.*;
        this.ip = movePtr(u8, this.ip);
        return @enumFromInt(operation);
    }

    fn readConstant(this: *Self) Value {
        const pos = @intFromEnum(this.readByte());
        return this.chunk.constants.values[pos];
    }
};
