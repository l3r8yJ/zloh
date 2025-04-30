const std = @import("std");
const Chunk = @import("chunk.zig").Chunk;
const OpCode = @import("chunk.zig").OpCode;

pub fn disassembleChunk(chunk: *Chunk, name: []const u8) void {
    std.debug.print("== {s} ==\n", .{name});

    var offset: usize = 0;

    while (offset < chunk.count) {
        offset = disassembleInstruction(chunk, offset);
    }
}

fn disassembleInstruction(chunk: *Chunk, offset: usize) usize {
    std.debug.print("{:0>4} ", .{offset});

    const instruction: OpCode = @enumFromInt(chunk.code[offset]);

    return switch (instruction) {
        .OP_RETURN => simpleInstruction("OP_RETURN", offset),
    };
}

fn simpleInstruction(name: []const u8, offset: usize) usize {
    std.debug.print("{s}\n", .{name});
    return offset + 1;
}
