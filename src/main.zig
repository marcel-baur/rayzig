const rl = @import("raylib");
const std = @import("std");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "Pong without Friends");
    defer rl.closeWindow();

    rl.setTargetFPS(60);
    var ball_x: f32 = 0;
    var ball_y: f32 = 0;
    var ball_h: f32 = 20;
    var ball_w: f32 = 20;
    var bat_h: f32 = 80;
    var bat_w: f32 = 10;
    var pos_bat: f32 = @divFloor(screenHeight, 2) - @divFloor(bat_h, 2);
    var speed_x: f32 = 200;
    var speed_y: f32 = 200;
    var bat_speed: f32 = 400;
    while (!rl.windowShouldClose()) {
        const dt: f32 = 1.0 / 60.0;
        rl.beginDrawing();
        defer rl.endDrawing();
        const ball: rl.Rectangle = rl.Rectangle.init(ball_x, ball_y, ball_w, ball_h);
        const bat: rl.Rectangle = rl.Rectangle.init(screenWidth - 50, pos_bat, bat_w, bat_h);
        const coll = rl.getCollisionRec(ball, bat);
        if (coll.x != 0) {
            speed_x = -speed_x;
        }
        {
            rl.drawRectangleRec(ball, rl.Color.red);
            ball_x += speed_x * dt;
            ball_y += speed_y * dt;
            if (ball_x + ball_h > screenWidth or ball_x < 0) {
                speed_x = -speed_x;
                speed_x *= 1.05;
                // box_w += 2;
                // box_h += 2;
            }
            if (ball_y + ball_w > screenHeight or ball_y < 0) {
                speed_y = -speed_y;
                speed_y *= 1.05;
            }
        }
        {
            rl.drawRectangleRec(bat, rl.Color.white);
            if (rl.isKeyDown(rl.KeyboardKey.key_k)) {
                pos_bat -= bat_speed * dt;
            }
            if (rl.isKeyDown(rl.KeyboardKey.key_j)) {
                pos_bat += bat_speed * dt;
            }
            pos_bat = std.math.clamp(pos_bat, 0, screenHeight - bat_h);
        }
        rl.clearBackground(rl.Color.black);
    }
}
