const std = @import("std");

pub fn main() !void {
  std.debug.print("Starting server\n", .{});
  const self_addr = try std.net.Address.resolveIp("127.0.0.1", 42069);
  var listener = try self_addr.listen(.{ .reuse_address = true});
  std.debug.print("Listening on {}\n", .{self_addr});
  while (listener.accept()) |conn| {
    std.debug.print("Accpeted connection from: {}\n", .{conn.address});
    _ = try conn.stream.write("Welcome to my server.\n");
    var buffer: [4096]u8 = undefined;
    while(true) {
      const bytes_recieved = try conn.stream.read(&buffer);
      const chunk = buffer[0..bytes_recieved];
      if(chunk.len == 0) break;
      std.debug.print("message: {s}", .{chunk});
      _ = try conn.stream.writer().print("No u {s}", .{chunk});
    }
  } else  |err| {
    std.debug.print("error in accept: {}\n", .{err});
  }
}
