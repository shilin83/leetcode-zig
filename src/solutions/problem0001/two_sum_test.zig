const std = @import("std");
const two_sum = @import("two_sum.zig").twoSum;

const Case = struct {
    nums: []const i32,
    target: i32,
    expected: []const i32,
};

test "1.两数之和" {
    const cases: [4]Case = .{
        Case{
            .nums = &[_]i32{ 2, 7, 11, 15 },
            .target = 9,
            .expected = &[_]i32{ 0, 1 },
        },
        Case{
            .nums = &[_]i32{ 3, 2, 4 },
            .target = 6,
            .expected = &[_]i32{ 1, 2 },
        },
        Case{
            .nums = &[_]i32{ 3, 3 },
            .target = 6,
            .expected = &[_]i32{ 0, 1 },
        },
        Case{
            .nums = &[_]i32{ 1, 2 },
            .target = 4,
            .expected = &[_]i32{},
        },
    };

    inline for (cases) |c| {
        const actual = two_sum(c.nums, c.target);

        try std.testing.expectEqualSlices(i32, c.expected, actual);
    }
}
