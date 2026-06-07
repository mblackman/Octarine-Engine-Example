-- hub_button.lua
-- Factory for screen-space UIButton + label pairs.
-- Usage: hub_button.make({ x=..., y=..., w=..., h=..., label="...", on_click=fn })

hub_button = {}

function hub_button.make(opts)
    local x     = opts.x     or 0
    local y     = opts.y     or 0
    local w     = opts.w     or 300
    local h     = opts.h     or 60
    local label = opts.label or "Button"
    local click = opts.on_click

    -- Button body: colored square + hit region + click handler.
    -- scene_path is forwarded into the ui_button table so on_click can read
    -- it via `self` (the buttonTable the system passes as the first arg) instead
    -- of relying on a Lua closure upvalue. The handler also sets is_active=false
    -- on itself before navigating, which prevents the ECS ForEach from re-firing
    -- the same button if scene loading happens synchronously mid-iteration.
    load_entity({
        name = "btn_" .. label,
        components = {
            transform    = { position = { x = x, y = y }, scale = { x = 1, y = 1 } },
            square       = { width = w, height = h, color = { r = 40, g = 80, b = 160, a = 220 }, layer = 10, fixed = true },
            box_collider = { width = w, height = h, offset = { x = 0, y = 0 } },
            ui_button    = { is_active = true, is_fixed = true, scene_path = opts.scene_path, on_click = click },
        },
    })

    -- Label as a separate fixed entity so there is no child-transform ambiguity
    load_entity({
        components = {
            transform  = { position = { x = x + 14, y = y + math.floor(h / 2) - 8 } },
            text_label = {
                text     = label,
                font_id  = "charriot-16",
                color    = { r = 255, g = 255, b = 255, a = 255 },
                is_fixed = true,
                layer    = 11,
            },
        }
    })
end

return hub_button
