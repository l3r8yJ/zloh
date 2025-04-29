const std = @import("std");

const OpCode = enum {
    OP_RETURN,
};

const Chunk = struct {
    code: usize,
};
