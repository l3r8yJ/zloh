const std = @import("std");
const expectEqual = std.testing.expectEqual;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const Chunk = @import("chunk.zig").Chunk;

test "chunk: initalizes an empty chunk" {
    const empty = Chunk.init();
    const expected = Chunk{ .code = undefined, .capacity = 0, .count = 0 };
    try expectEqual(expected, empty);
}

test "chunk: reallocates the memory with correct capacity" {
    var chunk = Chunk.init();
    const allocator = gpa.allocator();
    try chunk.write(allocator, 0x10);
    try expectEqual(chunk.capacity, 8);
}

test "chunk: reallocates the memory with correct count" {
    var chunk = Chunk.init();
    const allocator = gpa.allocator();
    try chunk.write(allocator, 0x10);
    try expectEqual(chunk.count, 1);
}

test "chunk: reallocates the memory with correct code" {
    var chunk = Chunk.init();
    const allocator = gpa.allocator();
    try chunk.write(allocator, 0x1a);
    try expectEqual(26, chunk.code[0]);
}
