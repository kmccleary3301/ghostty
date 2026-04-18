const std = @import("std");
const vt = @import("ghostty-vt");

test "libghostty-vt smoke: parse OSC 0 window title" {
    var parser = vt.osc.Parser.init(null);
    parser.next('0');
    parser.next(';');
    for ("smoke-title") |ch| parser.next(ch);

    const cmd = parser.end(null);
    try std.testing.expect(cmd != null);
    try std.testing.expect(cmd.?.* == .change_window_title);
    try std.testing.expectEqualStrings("smoke-title", cmd.?.*.change_window_title);
}

test "libghostty-vt smoke: terminal write and dump round trip" {
    const alloc = std.testing.allocator;

    var term = try vt.Terminal.init(alloc, .{
        .cols = 10,
        .rows = 3,
        .max_scrollback = 10,
    });
    defer term.deinit(alloc);

    try term.screens.active.testWriteString("hello");
    const out = try term.screens.active.dumpStringAlloc(alloc, .{ .screen = .{} });
    defer alloc.free(out);

    try std.testing.expectEqualStrings("hello", out);
}
