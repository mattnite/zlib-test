const Builder = @import("std").build.Builder;
const ZLibBuilder = @import("ZLibBuilder");

pub fn build(b: *Builder) !void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const link_type = b.option(ZLibBuilder.LinkType, "link", "how you want to link to zlib") orelse .static;
    var zlib = try ZLibBuilder.init(b, target, mode, link_type);
    defer zlib.deinit();

    const exe = b.addExecutable("zlib-test", "src/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    zlib.link(exe);
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
