const std = @import("std");

pub const ListNode = struct {
    val: u8,
    next: ?*ListNode = null,
};

pub fn array_to_list(nums: []const u8) ?*ListNode {
    const length = nums.len;
    var head: ?*ListNode = null;

    if (length != 0) {
        for (0..length) |i| {
            const node = std.heap.page_allocator.create(ListNode) catch unreachable;
            node.* = ListNode{
                .val = nums[length - i - 1],
                .next = head,
            };
            head = node;
        }
    }

    return head;
}
