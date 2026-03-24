const std = @import("std");
const testing = std.testing;
const file_utils = @import("utils/file.zig");

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const file_buffer: []u8 = try allocator.alloc(u8, 10_000);

    _ = try file_utils.read_file(io, file_buffer, "01.txt");

    const output_1 = part_1(file_buffer);
    std.debug.print("part 1: {d}\n", .{output_1});

    const output_2 = part_2(file_buffer);
    std.debug.print("part 2: {d}\n", .{output_2});
}

fn part_1(chars: []const u8) i16 {
    var count: i16 = 0;

    for (chars) |char| {
        if (char == '(') {
            count = count + 1;
        } else if (char == ')') {
            count = count - 1;
        }
    }

    return count;
}

test "part_1" {
    try testing.expect(part_1("(())") == 0);
    try testing.expect(part_1("()()") == 0);
    try testing.expect(part_1("(((") == 3);
    try testing.expect(part_1("(()(()(") == 3);
    try testing.expect(part_1("))(((((") == 3);
    try testing.expect(part_1("())") == -1);
    try testing.expect(part_1("))(") == -1);
    try testing.expect(part_1(")))") == -3);
    try testing.expect(part_1(")())())") == -3);
}

fn part_2(chars: []const u8) i16 {
    var count: i16 = 0;
    var position: i16 = 0;

    for (chars) |char| {
        position = position + 1;

        if (char == '(') {
            count = count + 1;
        } else if (char == ')') {
            count = count - 1;
        }

        if (count < 0) return position;
    }

    return count;
}

test "part_2" {
    try testing.expect(part_2(")") == 1);
    try testing.expect(part_2("()())") == 5);
}
