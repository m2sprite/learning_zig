const std = @import("std");
//NOTE(m2_sprite): an exclamation mark in the return type of a function indicatres the function can return an error
pub fn main() !void {
  const stdout = std.io.getStdOut().writer();
  try stdout.print("Hello World!\n", .{});
}
