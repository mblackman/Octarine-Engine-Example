-- game.lua

local debug_x_position = 0
local debug_y_position = 0
local debug_scale = 1.0
local debug_rotation = 0.0
local debug_x_velocity = 0
local debug_y_velocity = 0
local sprites = {"truck-texture", "tank-texture"}
local debug_sprite_index = 1
local debug_projectile_angle = 0.0
local debug_projectile_frequency = 1.0
local debug_projectile_duration = 5.0
local debug_projectile_speed = 100.0
local debug_projectile_damage = 20
local debug_max_health = 100
local debug_starting_health = 100

function spawn_enemy_gui(self, entity)
    if (ImGui.Begin("Spawn Enemy")) then
        debug_x_position = ImGui.InputInt("Spawn X", debug_x_position)
        debug_y_position = ImGui.InputInt("Spawn Y", debug_y_position)
        debug_scale = ImGui.InputFloat("Scale", debug_scale)
        debug_rotation = ImGui.InputFloat("Rotation", debug_rotation)
        debug_x_velocity = ImGui.InputInt("X Velocity", debug_x_velocity)
        debug_y_velocity = ImGui.InputInt("Y Velocity", debug_y_velocity)

        ImGui.Separator()

        debug_sprite_index, clicked = ImGui.Combo("Sprite", debug_sprite_index, sprites, 2)

        ImGui.Separator("Projectile Settings")
        debug_projectile_angle = ImGui.InputFloat("Projectile Angle", debug_projectile_angle)
        debug_projectile_frequency = ImGui.InputFloat("Projectile Frequency", debug_projectile_frequency)
        debug_projectile_duration = ImGui.InputFloat("Projectile Duration", debug_projectile_duration)
        debug_projectile_speed = ImGui.InputFloat("Projectile Speed", debug_projectile_speed)
        debug_projectile_damage = ImGui.InputInt("Projectile Damage", debug_projectile_damage)

        ImGui.Separator("Health Settings")
        debug_max_health = ImGui.InputInt("Max Health", debug_max_health)
        debug_starting_health = ImGui.InputInt("Starting Health", debug_starting_health)

        ImGui.Separator()
        if ImGui.Button("Spawn Enemy") then
            log("Spawning enemy at (" .. debug_x_position .. ", " .. debug_y_position .. ") with scale " .. debug_scale)
            local enemy_entity = {
                group = "enemies",
                components = {
                    transform = {
                        position = { x = debug_x_position, y = debug_y_position },
                        scale = { x = debug_scale, y = debug_scale },
                        rotation = rotation,
                    },
                    sprite = {
                        texture_asset_id = sprites[debug_sprite_index + 1],
                        width = 32,
                        height = 32,
                        layer = 1
                    },
                    box_collider = {
                        width = 32,
                        height = 32,
                        offset = { x = 0, y = 0 }
                    },
                    health = {
                        max_health = debug_max_health,
                        current_health = debug_starting_health
                    },
                    projectile_emitter = {
                        projectile_velocity = { x = math.cos(math.rad(debug_projectile_angle)) * debug_projectile_speed, 
                                                y = math.sin(math.rad(debug_projectile_angle)) * debug_projectile_speed },
                        projectile_duration = debug_projectile_duration,
                        repeat_frequency = debug_projectile_frequency,
                        hit_damage = debug_projectile_damage,
                        friendly = false
                    }
                }
            }
            load_entity(enemy_entity)
        end
    end
    ImGui.End()
end

function create_debug_gui()
    log("Creating debug GUI...")
    spawn_enemy_gui = {
        components = { script = { on_debug_gui = spawn_enemy_gui } }
    }

    load_entity(spawn_enemy_gui)
end

run_map_editor = false
log("Starting game...")
if run_map_editor then
    log("Running map editor...")
    local map_editor_path = get_asset_path("scripts/map-editor.lua")
    log("Loading map editor script: " .. map_editor_path)
    dofile(map_editor_path)
    map_editor.load()
else
    log("Running game...")
    local level_loader_path = get_asset_path("scripts/level-loader.lua")
    log("Loading level loader script: " .. level_loader_path)
    dofile(level_loader_path)

    level_loader.load_level(1)
    create_debug_gui()
    log("Game started successfully.")
end
