const std = @import("std");
const fs  = std.fs;
const print = std.debug.print;


pub fn main() !void {
  // NOTE(m2sprite): var decalres variable that can be changed after initial assignment
  // GeneralPurposeAllocator is from the standard library heap module and we pass an empty config
  // {} at the end means we're creating an instance of it;
  var gpa = std.heap.GeneralPurposeAllocator(.{}){};
  //right before current function scope is exited defer statement gets hit and we ignore the return value by _
  defer _ = gpa.deinit();
  // allocator method on gpa returns a pointer to the allocators memory allocator
  const allocator = gpa.allocator();

  // try keyword is used for error handling if try fs.cwd().openFile("hello_world.txt", .{}) returns an error the error is propagated up to the caller
  // in this case ti will become this error !void returned by the main function
  const file = try fs.cwd().openFile("read_file_line_by_line.zig", .{});
  defer file.close();

  var buf_reader = std.io.bufferedReader(file.reader());
  const reader = buf_reader.reader();

  var line = std.ArrayList(u8).init(allocator);
  defer line.deinit();

  const writer = line.writer();
  var line_no: usize = 0;
  while(reader.streamUntilDelimiter(writer, '\n', null)) {
    defer line.clearRetainingCapacity();
    line_no += 1;
    print("{d}--{s}\n", .{line_no, line.items});
  } else |err| switch (err) {
    error.EndOfStream => {
      if(line.items.len > 0) {
        line_no += 1;
        print("{d}--{s}\n", .{line_no, line.items});
      }
    },
    else => return err,
  }
  print("Total lines: {d}\n", .{line_no});
}
