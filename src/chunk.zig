const std = @import("std");

const OpCode = enum {
    OP_RETURN,
};

const Chunk = struct {
    code: [*c]u8,
    capacity: usize,
    count: usize,
};
