const std = @import("std");

fn twoSum(nums: []const i32, target: i32) []const i32 {
    // * 创建哈希表，用于存储已遍历元素及其索引
    var hash_table = std.AutoHashMap(i32, i32).init(std.heap.page_allocator);
    defer hash_table.deinit();

    for (nums, 0..) |value, key| {
        // * 计算目标值与当前元素的差值
        const diff = target - value;

        // * 如果哈希表中存在差值，则返回差值与当前元素的索引
        if (hash_table.contains(diff)) {
            return &.{ hash_table.get(diff).?, @intCast(key) };
        }

        // * 将当前元素及其索引存入哈希表
        hash_table.put(value, @intCast(key)) catch unreachable;
    }

    return &.{};
}

test "1.两数之和" {
    const cases: [3]struct {
        nums: []const i32,
        target: i32,
        expected: []const i32,
    } = .{
        .{
            .nums = &.{ 2, 7, 11, 15 },
            .target = 9,
            .expected = &.{ 0, 1 },
        },
        .{
            .nums = &.{ 3, 2, 4 },
            .target = 6,
            .expected = &.{ 1, 2 },
        },
        .{
            .nums = &.{ 3, 3 },
            .target = 6,
            .expected = &.{ 0, 1 },
        },
    };

    inline for (cases) |c| {
        const actual = twoSum(c.nums, c.target);

        try std.testing.expectEqualSlices(i32, c.expected, actual);
    }
}
