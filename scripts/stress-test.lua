local stress_test = {}

function stress_test.run()
    load_asset({ type = "texture", id = "tank-texture", file = "images/tank-tiger-up.png" })
    load_asset({ type = "texture", id = "bullet-texture", file = "images/bullet.png" })

    local count = 0
    for i = 0, game_window_width, 32 do
        for j = 0, game_window_height, 32 do
            local shooter = {
                group = "enemies",
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
                    projectile_emitter = {
                        projectile_velocity = { x = math.random(-100, 100), y = math.random(-100, 100) },
                        projectile_duration = 120,
                        repeat_frequency = .1,
                        hit_damage = 20,
                        friendly = false,
                        collision_mask = 4
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