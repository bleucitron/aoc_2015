const std = @import("std");
const file_utils = @import("utils/file.zig");

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const file_buffer: []u8 = try allocator.alloc(u8, 1024);

    _ = try file_utils.read_file(io, file_buffer, "01.txt");

    std.debug.print("{s}", .{file_buffer});
}

const File = std.Io.File;
