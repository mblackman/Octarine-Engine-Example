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
                tag = "enemies",
                components = {
                    transform = {
                        position = { x = debug_x_position, y = debug_y_position },
                        scale = { x = debug_scale, y = debug_scale },
                        rotation = debug_rotation,
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

-- Live transform inspector for the Player. Exercises the new Lua bindings:
--   registry.has_position / get_position
--   registry.has_rotation / get_rotation
--   registry.has_scale    / get_scale
-- Mutations write straight back into the component via the usertype's `value` field.
function player_transform_gui(self, entity)
    if (ImGui.Begin("Player Transform")) then
        local player = find_entity_by_name("Player")
        if player == nil then
            ImGui.Text("No player entity loaded.")
        else
            if registry.has_position(player) then
                local pos = registry.get_position(player)
                pos.value.x = ImGui.InputFloat("Pos X", pos.value.x)
                pos.value.y = ImGui.InputFloat("Pos Y", pos.value.y)
            end
            if registry.has_rotation(player) then
                local rot = registry.get_rotation(player)
                local deg = math.deg(rot.value)
                deg = ImGui.SliderFloat("Rotation (deg)", deg, -180.0, 180.0)
                rot.value = math.rad(deg)
            else
                ImGui.Text("Player has no rotation component.")
            end
            if registry.has_scale(player) then
                local scl = registry.get_scale(player)
                local s = ImGui.SliderFloat("Uniform Scale", scl.value.x, 0.25, 4.0)
                scl.value.x = s
                scl.value.y = s
            else
                ImGui.Text("Player has no scale component.")
            end
        end
    end
    ImGui.End()
end

function create_debug_gui()
    log("Creating debug GUI...")
    spawn_enemy_gui_entity = {
        components = { script = { on_debug_gui = spawn_enemy_gui } }
    }
    player_transform_gui_entity = {
        components = { script = { on_debug_gui = player_transform_gui } }
    }

    load_entity(spawn_enemy_gui_entity)
    load_entity(player_transform_gui_entity)
end

-- Load shared lib modules once. Each sets a global table (input_map, player_controller, spawn, …).
-- Globals survive load_scene() calls so every demo scene can use them without re-dofile.
dofile(get_asset_path("scripts/lib/input_map.lua"))
dofile(get_asset_path("scripts/lib/player_controller.lua"))
dofile(get_asset_path("scripts/lib/auto_fire.lua"))
dofile(get_asset_path("scripts/lib/spawn.lua"))
dofile(get_asset_path("scripts/lib/health_label.lua"))
dofile(get_asset_path("scripts/lib/spinner.lua"))
dofile(get_asset_path("scripts/lib/hub_button.lua"))
dofile(get_asset_path("scripts/lib/demo_hud.lua"))

-- install_click_spawn() is deferred to gameplay-demo.lua so it does not fire in the hub.
input_map.install()

-- Scene selection. The engine exposes --startup-mode as the global `oct_startup_mode`.
if oct_startup_mode == "stress" then
    local stress_test = dofile(get_asset_path("scripts/stress-test.lua"))
    stress_test.run()
else
    load_scene("scripts/hub.lua")
end
