const std = @import("std");
const testing = std.testing;
const file_utils = @import("utils/file.zig");

const print = std.debug.print;

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const lines = try file_utils.read_by_line(io, "02.txt", allocator);

    const output_1 = part_1(lines);
    std.debug.print("part 1: {d}\n", .{output_1});

    const output_2 = part_2(lines);
    std.debug.print("part 2: {d}\n", .{output_2});
}

fn part_1(lines: [][]const u8) u32 {
    var total: u32 = 0;

    for (lines) |line| {
        const q = compute_quantity(line);
        total = total + q;
    }

    return total;
}

fn part_2(lines: [][]const u8) u32 {
    var total: u32 = 0;

    for (lines) |line| {
        const q = compute_ribbon(line);
        total = total + q;
    }

    return total;
}

const Dimension = struct { w: u32, h: u32, l: u32 };

fn compute_quantity(line: []const u8) u32 {
    var iterator = std.mem.splitAny(u8, line, "x");

    var x = Dimension{ .w = 0, .h = 0, .l = 0 };

    inline for (@typeInfo(Dimension).@"struct".fields) |f| {
        const s = iterator.next() orelse "";
        const value: u32 = std.fmt.parseInt(u32, s, 10) catch 1;
        @field(x, f.name) = value;
    }

    var sorted = [_]u32{ x.w, x.h, x.l };
    std.mem.sort(u32, &sorted, {}, comptime std.sort.asc(u32));

    const min = sorted[0] * sorted[1];
    const wh = x.w * x.h;
    const wl = x.w * x.l;
    const hl = x.h * x.l;

    const surface: u32 = 2 * (wh + wl + hl);

    return surface + min;
}

fn compute_ribbon(line: []const u8) u32 {
    var iterator = std.mem.splitAny(u8, line, "x");

    var x = Dimension{ .w = 0, .h = 0, .l = 0 };

    inline for (@typeInfo(Dimension).@"struct".fields) |f| {
        const s = iterator.next() orelse "";
        const value: u32 = std.fmt.parseInt(u32, s, 10) catch 1;
        @field(x, f.name) = value;
    }

    var sorted = [_]u32{ x.w, x.h, x.l };
    std.mem.sort(u32, &sorted, {}, comptime std.sort.asc(u32));

    const smallest_perimeter = 2 * (sorted[0] + sorted[1]);
    const volume = x.w * x.h * x.l;

    return smallest_perimeter + volume;
}

test "compute_quantity" {
    try testing.expect(compute_quantity("2x3x4") == 58);
    try testing.expect(compute_quantity("1x1x10") == 43);
}

test "compute_ribbon" {
    try testing.expect(compute_ribbon("2x3x4") == 34);
    try testing.expect(compute_ribbon("1x1x10") == 14);
}
