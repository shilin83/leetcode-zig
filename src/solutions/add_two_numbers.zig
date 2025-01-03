const std = @import("std");
const module = @import("module");

const ListNode = module.ListNode;

fn add_two_numbers(l1: ?*ListNode, l2: ?*ListNode) ?*ListNode {
    const head = std.heap.page_allocator.create(ListNode) catch unreachable;
    var current = head;
    var p1 = l1;
    var p2 = l2;
    var carry: u8 = 0;

    // * 遍历两个链表，计算每个节点的和，并与当前进位值相加
    // * 遍历结束后，如果还有进位值，则在链表末尾添加新的节点
    while (p1 != null or p2 != null or carry != 0) {
        const sum = (if (p1 != null) p1.?.val else 0) + (if (p2 != null) p2.?.val else 0) + carry;

        p1 = if (p1 != null) p1.?.next else null;
        p2 = if (p2 != null) p2.?.next else null;

        current.next = std.heap.page_allocator.create(ListNode) catch unreachable;
        current = current.next.?;
        current.* = ListNode{ .val = @mod(sum, 10) };
        carry = @divFloor(sum, 10);
    }

    return head.next;
}

test "2.两数相加" {
    const IntToList = module.ArrayToList;

    const cases: [3]struct {
        nums1: []const u8,
        nums2: []const u8,
        expected: []const u8,
    } = .{
        .{
            .nums1 = &.{ 2, 4, 3 },
            .nums2 = &.{ 5, 6, 4 },
            .expected = &.{ 7, 0, 8 },
        },
        .{
            .nums1 = &.{0},
            .nums2 = &.{0},
            .expected = &.{0},
        },
        .{
            .nums1 = &.{ 9, 9, 9, 9, 9, 9, 9 },
            .nums2 = &.{ 9, 9, 9, 9 },
            .expected = &.{ 8, 9, 9, 9, 0, 0, 0, 1 },
        },
    };

    for (cases) |c| {
        var expected = IntToList(c.expected);
        var actual = add_two_numbers(IntToList(c.nums1), IntToList(c.nums2));

        while (expected != null and actual != null) {
            try std.testing.expectEqual(
                expected.?.val,
                actual.?.val,
            );

            expected = expected.?.next;
            actual = actual.?.next;
        }
    }
}
