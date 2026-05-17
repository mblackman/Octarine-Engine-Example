-- spawn.lua
-- Enemy spawn helpers + click-to-spawn callback registration.

local function spawn_tank(x, y, opts)
    opts = opts or {}
    load_entity({
        tag = "enemies",
        entity_mask = 2,
        components = {
            transform   = { position = { x = x, y = y } },
            sprite      = { texture_asset_id = "tank-texture", width = 32, height = 32, layer = 2 },
            box_collider = { width = 25, height = 18, offset = { x = 0, y = 7 } },
            health      = { max_health = opts.max_health or 50 },
        }
    })
end

local click_spawn_registered = false
local function install_click_spawn()
    if click_spawn_registered then return end
    input.on_mouse_down(function(btn, x, y)
        if btn ~= 1 then return end
        log("Click-spawn tank at " .. x .. "," .. y)
        spawn_tank(x, y)
    end)
    click_spawn_registered = true
end

spawn = {
    tank                = spawn_tank,
    install_click_spawn = install_click_spawn,
}

return spawn
