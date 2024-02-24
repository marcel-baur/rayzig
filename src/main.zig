const rl = @import("raylib");
const std = @import("std");

const Gamestate = struct {
    ball_x: f32,
    ball_y: f32,
    ball_h: f32,
    ball_w: f32,
    bat_w: f32,
    bat_h: f32,
    pos_bat: f32,
    speed_x: f32,
    speed_y: f32,
    bat_speed: f32,
    counter: i16,
    has_started: bool,
};

const screenWidth = 800;
const screenHeight = 450;
fn new_game_state() Gamestate {
    return Gamestate{
        .speed_x = 400,
        .speed_y = 400,
        .ball_x = 0,
        .ball_y = 0,
        .ball_w = 20,
        .ball_h = 20,

        .pos_bat = @divFloor(screenHeight, 2) - @divFloor(20, 2),
        .bat_speed = 400,
        .bat_w = 10,
        .bat_h = 80,
        .counter = 0,
        .has_started = false,
    };
}

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------

    rl.initWindow(screenWidth, screenHeight, "Pong without Friends");
    defer rl.closeWindow();

    rl.setTargetFPS(60);
    var state = new_game_state();
    while (!rl.windowShouldClose()) {
        const dt: f32 = 1.0 / 60.0;
        rl.beginDrawing();
        defer rl.endDrawing();
        const ball: rl.Rectangle = rl.Rectangle.init(state.ball_x, state.ball_y, state.ball_w, state.ball_h);
        const bat: rl.Rectangle = rl.Rectangle.init(screenWidth - 50, state.pos_bat, state.bat_w, state.bat_h);
        const coll = rl.getCollisionRec(ball, bat);
        rl.drawText(rl.textFormat("Score: %02i", .{state.counter}), 20, 20, 32, rl.Color.green);
        if (coll.x != 0) {
            state.speed_x = -state.speed_x;
            state.counter += 1;
        }
        {
            rl.drawRectangleRec(ball, rl.Color.red);
            if (state.has_started) {
                state.ball_x += state.speed_x * dt;
                state.ball_y += state.speed_y * dt;
            }
            if (state.ball_x + state.ball_h > screenWidth) {
                state = new_game_state();
            }
            if (state.ball_x + state.ball_h > screenWidth or state.ball_x < 0) {
                state.speed_x = -state.speed_x;
                state.speed_x *= 1.05;
                // box_w += 2;
                // box_h += 2;
            }
            if (state.ball_y + state.ball_w > screenHeight or state.ball_y < 0) {
                state.speed_y = -state.speed_y;
                state.speed_y *= 1.05;
            }
        }
        {
            rl.drawRectangleRec(bat, rl.Color.white);
            if (rl.isKeyDown(rl.KeyboardKey.key_k)) {
                state.pos_bat -= state.bat_speed * dt;
                state.has_started = true;
            }
            if (rl.isKeyDown(rl.KeyboardKey.key_j)) {
                state.pos_bat += state.bat_speed * dt;
                state.has_started = true;
            }
            state.pos_bat = std.math.clamp(state.pos_bat, 0, screenHeight - state.bat_h);
        }
        rl.clearBackground(rl.Color.black);
    }
}
