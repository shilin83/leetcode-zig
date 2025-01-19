const std = @import("std");

fn findMedianSortedArrays(nums1: []const i32, nums2: []const i32) f64 {
    // * 获取两个数组的长度
    // * 确保 nums1 的长度小于等于 nums2
    const m = nums1.len;
    const n = nums2.len;
    if (m > n) {
        return findMedianSortedArrays(nums2, nums1);
    }

    // * 在 nums1 上进行二分查找
    // * low, high 分别表示 nums1 的左右边界
    var low: usize = 0;
    var high: usize = m;
    while (low <= high) {
        // * i, j 分别表示 nums1 和 nums2 的分割点
        const i = low + (high - low) / 2;
        const j = (m + n + 1) / 2 - i;

        // * 处理 nums1 分割点左边的边界情况
        const max_left1 = if (i == 0) std.math.minInt(i32) else nums1[i - 1];
        // * 处理 nums1 分割点右边的边界情况
        const min_right1 = if (i == m) std.math.maxInt(i32) else nums1[i];
        // * 处理 nums2 分割点左边的边界情况
        const max_left2 = if (j == 0) std.math.minInt(i32) else nums2[j - 1];
        // * 处理 nums2 分割点右边的边界情况
        const min_right2 = if (j == n) std.math.maxInt(i32) else nums2[j];

        // * nums1:  ……………… nums1[i-1] | nums1[i] ……………………
        // * nums2:  ……………… nums2[j-1] | nums2[j] ……………………
        // * 判断是否找到了正确的分割点
        if (max_left1 <= min_right2 and max_left2 <= min_right1) {
            if ((m + n) % 2 == 0) {
                // * 数组长度为偶数，返回两个中间值的平数
                return @as(f64, @floatFromInt(@max(max_left1, max_left2) + @min(min_right1, min_right2))) / 2.0;
            } else {
                // * 数组长度为奇数，返回左半部分的最大值
                return @floatFromInt(@max(max_left1, max_left2));
            }
        } else if (max_left1 > min_right2) {
            // * 如果 nums1 左边太大，需要缩小右边界
            high = i - 1;
        } else {
            // * 如果 nums1 左边太小，需要增大左边界
            low = i + 1;
        }
    }

    return 0.0;
}

test "4.寻找两个正序数组的中位数" {
    const cases: [2]struct { nums1: []const i32, nums2: []const i32, expected: f64 } = .{ .{
        .nums1 = &.{ 1, 3 },
        .nums2 = &.{2},
        .expected = 2.0,
    }, .{
        .nums1 = &.{ 1, 2 },
        .nums2 = &.{ 3, 4 },
        .expected = 2.5,
    } };

    inline for (cases) |c| {
        const actual = findMedianSortedArrays(c.nums1, c.nums2);

        try std.testing.expectEqual(c.expected, actual);
    }
}
