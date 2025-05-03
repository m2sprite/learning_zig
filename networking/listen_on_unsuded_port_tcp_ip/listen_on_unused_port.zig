const std = @import("std");
const net = std.net;
const print = std.debug.print;

pub fn main() !void {
  const loopback = try net.Ip4Address.parse("127.0.0.1", 0);
  const localhost = net.Address{ .in = loopback };
  var server = try localhost.listen(.{
    .reuse_address = true,
  });
  defer server.deinit();

  const addr = server.listen_address;
  print("Listening on {}, access this port to end the program\n", .{addr.getPort()});

  while (true) {
    var client = try server.accept();
    defer client.stream.close();

    print("Connection received! {} is sending data.\n", .{client.address});

    // Read data from the client until a newline character
    var line_buffer: [1024]u8 = undefined;
    const reader = client.stream.reader();

    while (true) {
      const result = try reader.readUntilDelimiter(&line_buffer, '\n');
      if (result.len == 0) {
        break;
      }
      print("{} says: {s}\n", .{ client.address, line_buffer[0..result.len] });
    }
  }
}
