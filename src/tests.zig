const std = @import("std");
const expectEqual = std.testing.expectEqual;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const Chunk = @import("chunk.zig").Chunk;
const OpCode = @import("chunk.zig").OpCode;

test "chunk: initalizes an empty chunk" {
    const empty = Chunk.init();
    const expected = Chunk{ .code = undefined, .capacity = 0, .count = 0 };
    try expectEqual(expected, empty);
}

test "chunk: reallocates the memory with enum" {
    const allocator = gpa.allocator();

    var chunk = Chunk.init();
    defer chunk.deinit(allocator);

    try chunk.write(allocator, @intFromEnum(OpCode.OP_RETURN));
    const actual: OpCode = @enumFromInt(chunk.code[0]);

    try expectEqual(actual, OpCode.OP_RETURN);
}

test "chunk: reallocates the memory with correct capacity" {
    const allocator = gpa.allocator();

    var chunk = Chunk.init();
    defer chunk.deinit(allocator);

    try chunk.write(allocator, 0x10);

    try expectEqual(chunk.capacity, 8);
}

test "chunk: reallocates the memory with correct count" {
    const allocator = gpa.allocator();

    var chunk = Chunk.init();
    defer chunk.deinit(allocator);

    try chunk.write(allocator, 0x10);

    try expectEqual(chunk.count, 1);
}

test "chunk: reallocates the memory with correct code" {
    const allocator = gpa.allocator();

    var chunk = Chunk.init();
    defer chunk.deinit(allocator);

    try chunk.write(allocator, 0x1a);

    try expectEqual(26, chunk.code[0]);
}

test "chunk: reallocates the memory many times" {
    const allocator = gpa.allocator();

    var chunk = Chunk.init();
    defer chunk.deinit(allocator);

    const size = 15;
    for (0..size) |idx| {
        try chunk.write(allocator, @intCast(idx));
    }

    try expectEqual(size, chunk.count);
}
