const std = @import("std");
const testing = std.testing;
const file_utils = @import("utils/file.zig");

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    const cwd: std.Io.Dir = std.Io.Dir.cwd();

    const file: std.Io.File = try cwd.openFile(io, "01.txt", .{});
    defer file.close(io);

    const file_buffer: []u8 = undefined;
    var file_reader = file.reader(io, file_buffer);
    const reader = &file_reader.interface;

    var count: i16 = 0;
    var position: i16 = 0;
    var first_negative_position: i16 = 0;

    while (true) {
        position = position + 1;
        const char = reader.takeByte() catch |e| {
            if (e == error.EndOfStream) {
                break;
            }
            return e;
        };

        if (char == '(') {
            count = count + 1;
        } else if (char == ')') {
            count = count - 1;
        }

        if (first_negative_position != 0) continue;
        if (count < 0) first_negative_position = position;
    }

    std.debug.print("Part 1: {d}\n", .{count});
    std.debug.print("Part 2: {d}\n", .{first_negative_position});
}
