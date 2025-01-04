const std = @import("std");

fn lengthOfLongestSubstring(s: []const u8) usize {
    var hash_table = std.AutoHashMap(u8, usize).init(std.heap.page_allocator);
    defer hash_table.deinit();

    var left: usize = 0;
    var right: usize = 0;
    var max_len: usize = 0;

    while (right < s.len) {
        // * 如果哈希表中存在当前元素，则移动滑动窗口的左边界到当前元素的下一个位置
        const char = s[right];
        if (hash_table.contains(char)) {
            left = @max(left, hash_table.get(char).? + 1);
        }

        // * 将当前元素及其索引存入哈希表
        // * 移动滑动窗口的右边界
        // * 计算滑动窗口的最大长度
        hash_table.put(char, right) catch unreachable;
        right += 1;
        max_len = @max(max_len, right - left);
    }

    return max_len;
}

test "3.无重复字符的最长子串" {
    const cases: [3]struct {
        s: []const u8,
        expected: usize,
    } = .{
        .{
            .s = "abcabcbb",
            .expected = 3,
        },
        .{
            .s = "bbbbb",
            .expected = 1,
        },
        .{
            .s = "pwwkew",
            .expected = 3,
        },
    };

    for (cases) |c| {
        try std.testing.expectEqual(
            c.expected,
            lengthOfLongestSubstring(c.s),
        );
    }
}
