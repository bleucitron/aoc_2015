const std = @import("std");
const Allocator = std.mem.Allocator;
const File = std.Io.File;

pub fn read_file(io: std.Io, buf: []u8, filename: []const u8) (File.OpenError || File.ReadPositionalError)!void {
    const cwd = std.Io.Dir.cwd();

    const file = try cwd.openFile(io, filename, .{});
    defer file.close(io);

    _ = try file.readPositionalAll(io, buf, 0);
}

pub fn read_by_line(io: std.Io, filename: []const u8, allocator: Allocator) ![][]const u8 {
    const cwd = std.Io.Dir.cwd();

    const file = try cwd.openFile(io, filename, .{});
    defer file.close(io);

    const buf: []u8 = try allocator.alloc(u8, 10_000);

    var file_reader = file.reader(io, buf);
    const reader = &file_reader.interface;

    var lines = std.ArrayList([]const u8).empty;

    while (true) {
        const line = reader.takeDelimiter('\n') catch |e| {
            if (e == error.EndOfStream) {
                std.debug.print("EOS", .{});
                break;
            }
            return e;
        } orelse break;

        try lines.append(allocator, line);
    }

    return lines.items;
}
