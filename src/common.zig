const std = @import("std");

pub inline fn growCapacity(capacity: usize) usize {
    return if (capacity < 8) 8 else capacity * 2;
}

pub inline fn movePtr(comptime T: type, ptr: *T) *T {
    var movable: [*]T  = @ptrCast(ptr);
    movable += 1;
    return @ptrCast(movable);
}
