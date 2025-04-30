const std = @import("std");
const expectEqual = std.testing.expectEqual;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const Chunk = @import("chunk.zig").Chunk;
const OpCode = @import("chunk.zig").OpCode;

test "chunk: initalizes an empty chunk" {
    const empty = Chunk.init();
    const expected = Chunk{
        .code = undefined,
        .constants = undefined,
        .lines = undefined,
        .capacity = 0,
        .count = 0,
    };
    try expectEqual(expected, empty);
}

test "chunk: reallocates the memory with enum" {
    const allocator = gpa.allocator();

    var chunk = Chunk.init();
    defer chunk.deinit(allocator);

    try chunk.write(allocator, @intFromEnum(OpCode.OP_RETURN), 3);
    const actual: OpCode = @enumFromInt(chunk.code[0]);

    try expectEqual(actual, OpCode.OP_RETURN);
}

test "chunk: reallocates the memory with correct capacity" {
    const allocator = gpa.allocator();

    var chunk = Chunk.init();
    defer chunk.deinit(allocator);

    try chunk.write(allocator, 0x10, 5);

    try expectEqual(chunk.capacity, 8);
}

test "chunk: writes constants correctly" {
    const allocator = gpa.allocator();

    var chunk = Chunk.init();
    defer chunk.deinit(allocator);

    _ = try chunk.addConstant(allocator, 1.2);

    try expectEqual(chunk.constants.values[0], 1.2);
}

test "chunk: reallocates the memory with correct count" {
    const allocator = gpa.allocator();

    var chunk = Chunk.init();
    defer chunk.deinit(allocator);

    try chunk.write(allocator, 0x10, 2);

    try expectEqual(chunk.count, 1);
}

test "chunk: reallocates the memory with correct code" {
    const allocator = gpa.allocator();

    var chunk = Chunk.init();
    defer chunk.deinit(allocator);

    try chunk.write(allocator, 0x1a, 3);

    try expectEqual(26, chunk.code[0]);
}

test "chunk: reallocates the memory many times" {
    const allocator = gpa.allocator();

    var chunk = Chunk.init();
    defer chunk.deinit(allocator);

    const size = 15;
    for (0..size) |idx| {
        try chunk.write(allocator, @intCast(idx), @intCast(idx));
    }

    try expectEqual(size, chunk.count);
}

const debug = @import("debug.zig");

test "debug: dissasembles a chunk" {
    const allocator = gpa.allocator();

    var chunk = Chunk.init();
    defer chunk.deinit(allocator);

    const constant = try chunk.addConstant(allocator, 1.2);

    try chunk.write(allocator, @intFromEnum(OpCode.OP_CONSTANT), 1);
    try chunk.write(allocator, @intCast(constant), 1);
    try chunk.write(allocator, @intFromEnum(OpCode.OP_RETURN), 1);
    try chunk.write(allocator, @intFromEnum(OpCode.OP_RETURN), 2);

    debug.disassembleChunk(&chunk, "Ruby's chunk");
}

const ValueArray = @import("value.zig").ValueArray;

test "value: creates value array empty correctly" {
    const values = ValueArray.init();
    const expected = ValueArray{
        .values = undefined,
        .count = 0,
        .capacity = 0,
    };
    try expectEqual(expected, values);
}

const vmMod = @import("vm.zig");
const VM = vmMod.VM;
const InterpertResult = vmMod.InterpretResult;

test "vm: interprets OP_RETURN correctly" {
    const allocator = gpa.allocator();

    var vm = VM.init();
    defer vm.free(allocator);

    var chunk = Chunk.init();
    defer chunk.deinit(allocator);

    try chunk.write(allocator, @intFromEnum(OpCode.OP_RETURN), 0);

    debug.disassembleChunk(&chunk, "test chunk");

    const actual = vm.interpert(&chunk);

    try expectEqual(InterpertResult.INTERPERT_OK, actual);
}

test "vm: interprets OP_CONSTANT correctly" {
    const allocator = gpa.allocator();

    var vm = VM.init();
    defer vm.free(allocator);

    var chunk = Chunk.init();
    defer chunk.deinit(allocator);

    try chunk.write(allocator, @intFromEnum(OpCode.OP_CONSTANT), 0);
    _ = try chunk.addConstant(allocator, 5.2);
    try chunk.write(allocator, @intFromEnum(OpCode.OP_RETURN), 0);

    debug.disassembleChunk(&chunk, "test chunk");

    const actual = vm.interpert(&chunk);

    try expectEqual(InterpertResult.INTERPERT_OK, actual);
}
