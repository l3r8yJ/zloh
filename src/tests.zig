const std = @import("std");
const expectEqual = std.testing.expectEqual;

const Chunk = @import("chunk.zig").Chunk;

test "chunk: initalizes an empty chunk" {
    const empty = Chunk.init();
    const expected = Chunk{ .code = null, .capacity = 0, .count = 0 };
    try expectEqual(expected, empty);
}
