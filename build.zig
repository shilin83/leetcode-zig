const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    const tests = b.addTest(.{
        .root_source_file = b.path("src/tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    tests.root_module.addImport("include", b.addModule(
        "",
        .{
            .root_source_file = b.path("src/structures/include.zig"),
        },
    ));

    const run_tests = b.addRunArtifact(tests);

    const test_step = b.step("test", "Run leetcode tests");

    test_step.dependOn(&run_tests.step);

    const run_cover = b.addSystemCommand(&.{
        "kcov",
        "--clean",
        "--include-pattern=src",
        "--exclude-pattern=tests,_test",
        "coverage",
    });

    run_cover.addArtifactArg(tests);

    const cover_step = b.step("coverage", "Generate test coverage report");

    cover_step.dependOn(&run_cover.step);
}
