const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "leetcode-zig",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const tests = b.addTest(.{
        .root_source_file = b.path("src/tests.zig"),
        .target = target,
        .optimize = optimize,
    });
    tests.root_module.addImport("module", b.addModule(
        "",
        .{
            .root_source_file = b.path("src/structures/module.zig"),
        },
    ));

    const run_tests = b.addRunArtifact(tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_tests.step);

    const run_cover = b.addSystemCommand(&.{
        "kcov",
        "--clean",
        "--include-pattern=src/",
        b.pathJoin(&.{ b.install_path, "coverage" }),
    });
    run_cover.addArtifactArg(tests);
    const cover_step = b.step("coverage", "Generate test coverage report");
    cover_step.dependOn(&run_cover.step);
}
