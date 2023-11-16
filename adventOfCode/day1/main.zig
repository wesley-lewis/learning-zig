const std = @import("std");

pub fn main() !void {
    const filename = "day1.txt";
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const read_buf = try file.readToEndAlloc(allocator, 1024 * 1024);
    defer allocator.free(read_buf);

    var it = std.mem.split(u8, read_buf, "\n");

    var elfArray = std.ArrayList(i32).init(allocator);
    defer elfArray.deinit();

    var max_amount: i32 = 0;
    var elf_sum: i32 = 0;
    while (it.next()) |amount| {
        if (amount.len > 0) {
            const result: i32 = try std.fmt.parseInt(i32, amount, 10);
            elf_sum += result;
        } else {
            try elfArray.append(elf_sum);
            if (max_amount < elf_sum) {
                max_amount = elf_sum;
            }
            elf_sum = 0;
        }
    }

    for (elfArray.items) |item| {
        std.debug.print("item: {}\n", .{item});
    }

    var max = std.mem.max(i32, elfArray.items);

    std.debug.print("Max using std.mem.max: {}\n", .{max});
    std.debug.print("Maximum Amount: {}\n", .{max_amount});
}
