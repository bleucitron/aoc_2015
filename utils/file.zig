const std = @import("std");
const File = std.Io.File;

pub fn read_file(io: std.Io, buf: []u8, filename: []const u8) (File.OpenError || File.ReadPositionalError)!void {
    const cwd = std.Io.Dir.cwd();

    const file = try cwd.openFile(io, filename, .{});
    defer file.close(io);

    _ = try file.readPositionalAll(io, buf, 0);
}

pub fn read_by_line(init: std.process.Init) !void {
    const io = init.io;

    const cwd: std.Io.Dir = std.Io.Dir.cwd();

    const file: std.Io.File = try cwd.openFile(io, "test.txt", .{});
    defer file.close(io);

    const file_buffer: []u8 = undefined;
    var file_reader = file.reader(io, file_buffer);
    const reader = &file_reader.interface;

    while (true) {
        const line = reader.takeDelimiter('\n') catch |e| {
            if (e == error.EndOfStream) {
                std.debug.print("EOS", .{});
                break;
            }
            return e;
        } orelse return;

        std.debug.print("{s}\n", .{line});
    }
}
