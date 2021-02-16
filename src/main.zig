const std = @import("std");
const c = @cImport({
    @cInclude("zlib.h");
    @cInclude("stdio.h");
    @cInclude("string.h");
});

pub fn main() anyerror!void {
    var a = std.mem.zeroes([50]u8);
    std.mem.copy(u8, &a, "greetings this is not a drill");
    var b: [50]u8 = undefined;
    var d: [50]u8 = undefined;

    _ = c.printf("Uncompressed size is: %lu\n", c.strlen(&a));
    _ = c.printf("Uncompressed string is: %s\n", &a);
    _ = c.printf("\n----------\n\n");

    var defstream: c.z_stream = undefined;
    defstream.zalloc = null;
    defstream.zfree = null;
    defstream.@"opaque" = null;
    defstream.avail_in = a.len;
    defstream.next_in = &a;
    defstream.avail_out = b.len;
    defstream.next_out = &b;

    _ = c.deflateInit((&defstream), c.Z_BEST_COMPRESSION);
    _ = c.deflate(&defstream, c.Z_FINISH);
    _ = c.deflateEnd(&defstream);
    _ = c.printf("Compressed size is: %lu\n", c.strlen(&b));
    _ = c.printf("Compressed string is: %s\n", &b);
    _ = c.printf("\n----------\n\n");
}
