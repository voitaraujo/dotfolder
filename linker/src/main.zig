const std = @import("std");
const io = std.io;
const fs = std.fs;
const process = std.process;
const testing = std.testing;

const out = io.getStdOut().writer();
var cwd = fs.cwd();
const String = []const u8;

pub fn main() !void {
    // memory allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();

        if (deinit_status == .leak) {
            @panic("memory leak");
        }
    }

    // process args
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    // check if we're in dev mode
    const devMode: bool = if (args.len > 1) std.mem.eql(u8, args[1], "dev") else false;

    // go one dir bellow when on dev mode
    if (devMode) {
        cwd = try cwd.openDir("../", .{});
    }

    try out.print(
        \\Linking paths defined in 'link-map.txt'
        \\
        \\
    , .{});

    const link_map = getLinkMapFile() catch {
        try out.print("Failed to open 'link-map.txt', make sure the file exists and it's on the same folder as this program.\n", .{});
        return;
    };
    defer link_map.close();

    const link_map_stat = try link_map.stat();

    // read contents of the link map file
    const link_map_contents = try link_map.readToEndAlloc(allocator, link_map_stat.size);
    defer allocator.free(link_map_contents);

    try linkMaps(link_map_contents, &allocator);
}

fn linkMaps(lmc: []u8, allocator: *const std.mem.Allocator) !void {
    //split link map file contents on each new line
    var link_map_line_iter = std.mem.splitSequence(u8, lmc, "\n");

    outer: while (link_map_line_iter.next()) |line| {
        if (line.len == 0) {
            try out.print(
                \\X  skipping empty line
                \\
                \\
            , .{});

            continue :outer;
        }

        // spliting the link map of a single line using the ":" char
        var link_map_iter = std.mem.tokenizeAny(u8, line, ":");

        var i: usize = 0;

        var target: ?[]const u8 = null;
        var origin: ?[]const u8 = null;
        defer {
            if (target) |_t| {
                allocator.free(_t);
            }
            if (origin) |_o| {
                allocator.free(_o);
            }
        }

        // resolving the origin and target path before linking then
        while (link_map_iter.next()) |entry| : (i += 1) {
            switch (i) {
                0 => {
                    origin = getOriginPath(entry, allocator) catch {
                        try out.print(
                            \\X  skipping map where origin path could not be resolved: '{s}'
                            \\
                            \\
                        , .{entry});
                        continue :outer;
                    };
                },
                1 => {
                    target = getTargetPath(entry, allocator) catch {
                        try out.print(
                            \\X  skipping map where target path could not be resolved: '{s}'
                            \\
                            \\
                        , .{entry});
                        continue :outer;
                    };
                },
                else => {
                    try out.print(
                        \\X  skipping map with more than 2 paths correlations: '{s}'
                        \\
                        \\
                    , .{line});
                    continue :outer;
                },
            }
        }

        try link(origin.?, target.?);
    }
}

fn getLinkMapFile() !fs.File {
    return try cwd.openFile("link-map.txt", .{
        .mode = .read_only,
    });
}

fn getTargetPath(path: []const u8, allocator: *const std.mem.Allocator) ![]const u8 {
    // the target path have to start with "~/" and be resolved from the user home,
    // otherwise, if we accept relative paths (eg. "../../some_folder/folder/")
    // it would need to be resolved and throw an error since "folder" would
    // not be created yet.
    if (std.mem.startsWith(u8, path, "~/")) {
        var env_variables = try process.getEnvMap(allocator.*);
        defer env_variables.deinit();
        const home_path = env_variables.get("HOME");

        // surely everyone should have a home, right?
        if (home_path) |hp| {
            const to_join = [_]String{ hp, path[2..] };
            return fs.path.join(allocator.*, &to_join);
        }

        unreachable;
    }

    unreachable;
}

fn getOriginPath(path: []const u8, allocator: *const std.mem.Allocator) ![]const u8 {
    // unlike target path, the origin path can be resolved from a relative string
    // since it SHOULD already exists.
    return try cwd.realpathAlloc(allocator.*, path);
}

fn link(origin: []const u8, target: []const u8) !void {
    try out.print(
        \\~> linking '{s}' to '{s}'
        \\
    , .{ origin, target });

    // effectively linking the origin path to the target path,
    // notice that the origin and target paths are inverted on the function call.
    fs.symLinkAbsolute(origin, target, .{ .is_directory = isDir(origin) }) catch |err| switch (err) {
        error.FileNotFound => {
            try out.print(
                \\   FAILED: the target link folder couldn't be found, if it's a subdirectory make sure the parent directory exists.
                \\
                \\
            , .{});
            return;
        },
        error.PathAlreadyExists => {
            try out.print(
                \\   FAILED: there is already an link/folder/file with the same name at the target directory.
                \\
                \\
            , .{});
            return;
        },
        else => {
            try out.print(
                \\   unexpected error: {}
                \\
                \\
            , .{err});
            return;
        },
    };

    try out.print(
        \\   SUCCESS
        \\
        \\
    , .{});
}

fn isDir(path: []const u8) bool {
    var dir = fs.openDirAbsolute(path, .{}) catch {
        return false;
    };

    defer dir.close();

    return true;
}
