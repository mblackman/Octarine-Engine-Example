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

function create_debug_gui()
    log("Creating debug GUI...")
    spawn_enemy_gui_entity = {
        components = { script = { on_debug_gui = spawn_enemy_gui } }
    }

    load_entity(spawn_enemy_gui_entity)
end

local bootstrapper_script = {
    test_selected = 0,
    show_menu = true,
    tests = {"Main Game", "Map Editor", "Stress Test", "Overlap Test"},
    on_update = function(self, entity, delta_time)
        -- Toggle the menu when Escape is pressed
        if is_key_pressed("escape") then
            self.show_menu = not self.show_menu
        end
    end,
    on_debug_gui = function(self, entity)
        if self.show_menu then
            if (ImGui.Begin("Mode Selector")) then
                local clicked
                self.test_selected, clicked = ImGui.Combo("Select Mode", self.test_selected, self.tests, 4)
                
                if ImGui.Button("Load Mode") then
                    self.show_menu = false
                    log("Loading mode index: " .. self.test_selected)
                    
                    -- Call an engine function to clear the current map/entities to avoid overlaps
                    if clear_scene then
                        clear_scene()
                        -- Re-initialize the bootstrapper so it survives the clear
                        load_entity({ components = { script = bootstrapper_script } })
                    else
                        log("WARNING: Implement a clear_scene() binding in C++ to prevent overlap!")
                    end
                    
                    if self.test_selected == 0 then
                        -- Main Game
                        local level_loader_path = get_asset_path("scripts/level-loader.lua")
                        dofile(level_loader_path)
                        level_loader.load_level(1)
                        create_debug_gui()
                    elseif self.test_selected == 1 then
                        -- Map Editor
                        local map_editor_path = get_asset_path("scripts/map-editor.lua")
                        dofile(map_editor_path)
                        map_editor.load()
                    elseif self.test_selected == 2 then
                        -- Stress Test
                        local stress_test_path = get_asset_path("scripts/stress-test.lua")
                        local stress_test = dofile(stress_test_path)
                        stress_test.run()
                    elseif self.test_selected == 3 then
                        -- Overlap Test
                        local overlap_test_path = get_asset_path("scripts/overlap-test.lua")
                        local overlap_test = dofile(overlap_test_path)
                        overlap_test.run()
                    end
                end
            end
            ImGui.End()
        end
    end
}

log("Starting game engine bootstrapper...")

-- If the engine was launched with --startup-mode, skip the menu and run that mode
-- directly. Used by automated benchmarks to bypass the interactive selector.
local mode_to_index = {
    main = 0,
    map_editor = 1,
    stress = 2,
    overlap = 3,
}
local requested_mode = oct_startup_mode
if requested_mode and requested_mode ~= "" then
    local idx = mode_to_index[requested_mode]
    if idx ~= nil then
        log("Auto-launching startup mode: " .. requested_mode)
        if idx == 2 then
            local stress_test_path = get_asset_path("scripts/stress-test.lua")
            local stress_test = dofile(stress_test_path)
            stress_test.run()
        elseif idx == 3 then
            local overlap_test_path = get_asset_path("scripts/overlap-test.lua")
            local overlap_test = dofile(overlap_test_path)
            overlap_test.run()
        elseif idx == 1 then
            local map_editor_path = get_asset_path("scripts/map-editor.lua")
            dofile(map_editor_path)
            map_editor.load()
        else
            local level_loader_path = get_asset_path("scripts/level-loader.lua")
            dofile(level_loader_path)
            level_loader.load_level(1)
        end
        return
    else
        log("WARNING: Unknown startup mode '" .. requested_mode .. "', falling back to menu")
    end
end

local bootstrapper_entity = {
    components = { script = bootstrapper_script }
}
load_entity(bootstrapper_entity)
