const std = @import("std");

const OpCode = enum {
    OP_RETURN,
};

pub const Chunk = struct {
    code: *u8,
    capacity: usize,
    count: usize,

    pub fn init() Chunk {
        return Chunk{
            .count = 0,
            .capacity = 0,
            .code = null,
        };
    }
};
