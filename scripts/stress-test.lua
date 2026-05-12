local stress_test = {}

function stress_test.run()
    -- Deterministic seed so every run produces identical projectile velocities
    -- and stagger offsets, eliminating RNG-driven variance from benchmarks.
    math.randomseed(42)

    load_asset({ type = "texture", id = "tank-texture", file = "images/tank-tiger-up.png" })
    load_asset({ type = "texture", id = "bullet-texture", file = "images/bullet.png" })

    local frequency = 0.1

    local count = 0
    for i = 0, game_window_width, 32 do
        for j = 0, game_window_height, 32 do
            -- Stagger initial fire times across [0, frequency) so emitters don't
            -- all spawn projectiles on the same frame (thundering-herd effect).
            -- The deterministic seed above keeps this reproducible across runs.
            local initial_delay = math.random() * frequency

            local shooter = {
                tag = "enemies",
                mask = 2,
                components = {
                    transform = {
                        position = { x = i, y = j },
                        scale = { x = 1.0, y = 1.0 },
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
                        offset = { x = 0, y = 0 },
                        collision_mask = 2
                    },
                    health = {
                        max_health = 100,
                        current_health = 100
                    },
                    projectile_emitter = {
                        projectile_velocity = { x = math.random(-100, 100), y = math.random(-100, 100) },
                        -- Short lifetime so the scene reaches a stable ~20-bullets-per-shooter
                        -- steady state in ~2s — old 120s value never reached steady state in a
                        -- realistic bench window, leaving runs measuring only the ramp.
                        projectile_duration = 2,
                        repeat_frequency = frequency,
                        hit_damage = 20,
                        friendly = false,
                        collision_mask = 4,
                        -- Spread the first shot across [0, frequency) to avoid a massive
                        -- spike of ~2074 entity spawns on a single frame.
                        countdown_timer = initial_delay
                    }
                }
            }
            load_entity(shooter)
            count = count + 1
        end
    end

    print("Loaded " .. count .. " stress test entities")
end

return stress_test