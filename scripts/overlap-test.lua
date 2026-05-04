local overlap_test = {}

function overlap_test.run()
    load_asset({ type = "texture", id = "tank-texture", file = "images/tank-tiger-up.png" })

    local left = {
        tag = "enemies",
        mask = 2,
        components = {
            transform = {
                position = { x = 100, y = 100 },
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
                max_health = 100
            }
        }
    }
    local right = {
        tag = "enemies",
        mask = 2,
        components = {
            transform = {
                position = { x = 100, y = 120 },
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
                max_health = 100
            }
        }
    }
    load_entity(left)
    load_entity(right)
end

return overlap_test