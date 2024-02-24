const rl = @import("raylib");
const std = @import("std");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - basic window");
    defer rl.closeWindow();

    rl.setTargetFPS(60);
    var x: i32 = 20;
    var y: i32 = 20;
    var speed_x: f64 = 200;
    var speed_y: f64 = 200;
    while (!rl.windowShouldClose()) {
        const dt: f64 = 1.0 / 60.0;
        rl.beginDrawing();
        defer rl.endDrawing();
        const red = rl.Color.red;
        rl.drawRectangle(x, y, 20, 20, red);
        x += @as(i32, @intFromFloat(speed_x * dt));
        y += @as(i32, @intFromFloat(speed_y * dt));
        if (x + 10 > screenWidth or x < 0) {
            speed_x = -speed_x;
            speed_x *= 1.05;
        }
        if (y + 10 > screenHeight or y < 0) {
            speed_y = -speed_y;
            speed_y *= 1.05;
        }

        rl.clearBackground(rl.Color.black);

        // rl.drawText("Congrats! You created your first window!", 190, 200, 20, rl.Color.light_gray);
        //----------------------------------------------------------------------------------
    }
}
