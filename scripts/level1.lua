-- Define a table with the values of the first level
current_level = {
    ----------------------------------------------------
    -- Assets are auto-discovered from the project folder (see the .meta sidecars next to the
    -- image/font files) and the required set is derived from this scene's data by the engine's
    -- scene scanner. `preload` lists only what the static scan cannot see: runtime spawns
    -- (enemy tanks/trucks, bullets) and the load-time-injected health label font. The tilemap
    -- texture and the Player sprite are picked up automatically from `tilemap` / `entities`.
    ----------------------------------------------------
    preload = {
        "tank-texture",    -- spawned enemies (game.lua spawn_enemy_gui)
        "truck-texture",   -- spawned enemies
        "bullet-texture",  -- fired projectiles
        "arial-font-5",    -- runtime labels
        "arial-font-10",   -- load-time-injected health label (level-loader.lua)
        "helicopter",      -- audio played on spawn
    },

    ----------------------------------------------------
    -- table to define the map config variables
    ----------------------------------------------------
    tilemap = {
        map_file = "tilemaps/jungle.map",
        texture_asset_id = "tilemap-texture",
        num_cols = 10,
        tile_size = 32,
        scale = 2.0
    },

    ----------------------------------------------------
    -- table to define entities and their components
    ----------------------------------------------------
    entities = {
        {
            -- Player
            name = "Player",
            tag = { "player" },
            entity_mask = 1,
            components = {
                transform = {
                    position = { x = 242, y = 110 },
                    scale    = { x = 1.0, y = 1.0 },
                    rotation = 0.0,
                },
                rigidbody = {
                    velocity = { x = 0.0, y = 0.0 }
                },
                sprite = {
                    texture_asset_id = "chopper-texture",
                    width = 32,
                    height = 32,
                    layer = 4,
                    fixed = false,
                    src_rect_x = 0,
                    src_rect_y = 0
                },
                animation = {
                    num_frames = 2,
                    speed_rate = 10 -- fps
                },
                box_collider = {
                    width = 32,
                    height = 25,
                    offset = { x = 0, y = 5 }
                },
                health = {
                    max_health = 100
                },
                projectile_emitter = {
                    projectile_velocity = { x = 100, y = 100 },
                    projectile_duration = 10, -- seconds
                    repeat_frequency = 0, -- seconds
                    hit_damage = 10,
                    friendly = true,
                    collision_mask = 2,
                    projectile_name = "Player Projectile"
                },
                script = player_controller.new({ velocity = 80, sprite_width = 32, sprite_height = 32 }),
                camera_follow = {
                    follow = true
                },
                audio_source = { 
                    clip_id = "helicopter", 
                    loop = true 
                }
            }
        },
        {
            -- Tank
            tag = "enemies",
            name = "Tank",
            entity_mask = 2,
            components = {
                transform = {
                    position = { x = 200, y = 497 },
                },
                sprite = {
                    texture_asset_id = "tank-texture",
                    width = 32,
                    height = 32,
                    layer = 2
                },
                box_collider = {
                    width = 25,
                    height = 18,
                    offset = { x = 0, y = 7 }
                },
                health = {
                    max_health = 100
                },
                projectile_emitter = {
                    projectile_velocity = { x = 100, y = 0 },
                    projectile_duration = 2, -- seconds
                    repeat_frequency = 1, -- seconds — drives the engine ProjectileEmitSystem auto-fire
                    hit_damage = 20,
                    friendly = false,
                    collision_mask = 1,
                    projectile_name = "Tank Projectile"
                }
                -- Auto-fire runs engine-side now (repeat_frequency above); no Lua fire loop needed.
            }
        },
        {
            -- Truck
            tag = "enemies",
            name = "Truck",
            entity_mask = 2,
            components = {
                transform = {
                    position = { x = 500, y = 497 },
                },
                sprite = {
                    texture_asset_id = "truck-texture",
                    width = 32,
                    height = 32,
                    layer = 2
                },
                box_collider = {
                    width = 25,
                    height = 18,
                    offset = { x = 0, y = 7 }
                },
                health = {
                    max_health = 100
                },
                projectile_emitter = {
                    projectile_velocity = { x = 100, y = 0 },
                    projectile_duration = 2, -- seconds
                    repeat_frequency = 1, -- seconds — drives the engine ProjectileEmitSystem auto-fire
                    hit_damage = 20,
                    friendly = false,
                    collision_mask = 1,
                    projectile_name = "Truck Projectile"
                }
                -- Auto-fire runs engine-side now (repeat_frequency above); no Lua fire loop needed.
            }
        },
        {
            -- Truck Sin
            tag = "enemies",
            name = "Truck Sin",
            entity_mask = 2,
            components = {
                transform = {
                    position = { x = 500, y = 250 },
                },
                sprite = {
                    texture_asset_id = "truck-texture",
                    width = 32,
                    height = 32,
                    layer = 2
                },
                box_collider = {
                    width = 25,
                    height = 18,
                    offset = { x = 0, y = 7 }
                },
                health = {
                    max_health = 100
                },
                projectile_emitter = {
                    projectile_velocity = { x = 100, y = 0 },
                    projectile_duration = 2, -- seconds
                    repeat_frequency = 1, -- seconds — drives the engine ProjectileEmitSystem auto-fire
                    hit_damage = 20,
                    friendly = false,
                    collision_mask = 1,
                    projectile_name = "Truck Sin Projectile"
                },
                -- Movement-only script: auto-fire now runs engine-side (repeat_frequency above),
                -- so this drives just the sinusoidal path. Demonstrates scripted movement
                -- composing with C++ auto-fire on the same entity.
                script = {
                    elapsed_time = 0.0,
                    on_update = function(self, entity, dt)
                        self.elapsed_time = self.elapsed_time + dt
                        local change = self.elapsed_time * 1000
                        local new_x = change * 0.09
                        local new_y = 200 + (math.sin(change * 0.001) * 50)
                        set_position(entity, new_x, new_y)
                    end
                }
            }
        },
        -- Rotation showcase entities. Demonstrate rotated sprite, rotated colliders,
        -- and rotated square primitives. Use the new registry.get_rotation / get_scale
        -- bindings via lib/spinner.lua.
        {
            -- Spinning tank: rotates continuously; box collider rotates with it (OBB SAT
            -- in CollisionSystem). Hit it with a player projectile to confirm.
            tag = "enemies",
            name = "Spinning Tank",
            entity_mask = 2,
            components = {
                transform = {
                    position = { x = 320, y = 300 },
                    rotation = 0.0,
                },
                sprite = {
                    texture_asset_id = "tank-texture",
                    width = 32,
                    height = 32,
                    layer = 2
                },
                box_collider = {
                    width = 32,
                    height = 32,
                    offset = { x = 0, y = 0 }
                },
                health = { max_health = 60 },
                script = spinner.new({ speed = 1.5 })
            }
        },
        {
            -- Pulsing truck: rotates AND breathes in scale every frame. Showcases the
            -- mutating scale binding (registry.get_scale(e).value.x = ...).
            tag = "enemies",
            name = "Pulsing Truck",
            entity_mask = 2,
            components = {
                transform = {
                    position = { x = 420, y = 300 },
                    scale    = { x = 1.0, y = 1.0 },
                    rotation = 0.0,
                },
                sprite = {
                    texture_asset_id = "truck-texture",
                    width = 32,
                    height = 32,
                    layer = 2
                },
                box_collider = {
                    width = 32,
                    height = 32,
                    offset = { x = 0, y = 0 }
                },
                health = { max_health = 60 },
                script = spinner.new({ speed = 1.0, pulse = 0.35, base_scale = 1.0 })
            }
        },
        {
            -- Static rotated block: square primitive frozen at 30deg. Verifies rotated
            -- SDL_RenderGeometry path and that DrawColliderSystem traces the OBB.
            tag = "obstacle",
            name = "Static Rotated Block",
            entity_mask = 2,
            components = {
                transform = {
                    position = { x = 520, y = 280 },
                    rotation = math.rad(30),
                },
                square = {
                    width = 48,
                    height = 24,
                    color = { r = 255, g = 200, b = 80, a = 255 },
                    layer = 1,
                    fixed = false
                },
                box_collider = {
                    width = 48,
                    height = 24,
                    offset = { x = 0, y = 0 }
                }
            }
        },
        {
            -- Spinning block: square primitive driven by the spinner script. Rotates
            -- through its rest position so the OBB-vs-OBB collision path lights up
            -- when the static block is nearby.
            tag = "obstacle",
            name = "Spinning Block",
            entity_mask = 2,
            components = {
                transform = {
                    position = { x = 620, y = 280 },
                    rotation = 0.0,
                },
                square = {
                    width = 48,
                    height = 24,
                    color = { r = 80, g = 200, b = 255, a = 255 },
                    layer = 1,
                    fixed = false
                },
                box_collider = {
                    width = 48,
                    height = 24,
                    offset = { x = 0, y = 0 }
                },
                script = spinner.new({ speed = 2.0 })
            }
        }
    }
}

-- Re-install bindings/callbacks in case this level was entered via load_scene(), which
-- runs ResetLuaState. install_*() are idempotent — see lib/input_map.lua, lib/spawn.lua.
current_level.setup = function(scene)
    input_map.install()
    spawn.install_click_spawn()
end

return current_level