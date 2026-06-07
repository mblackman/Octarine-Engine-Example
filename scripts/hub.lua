-- hub.lua
-- Main menu / showcase navigator. Side-effect script (no return value needed).
-- Displays a title and four buttons that each load a focused demo scene.

acquire_scene_assets({ preload = { "arial-font-10", "charriot-16" } })

-- ── Background ────────────────────────────────────────────────────────────────
load_entity({
    name = "hub-bg",
    components = {
        transform = { position = { x = 0, y = 0 } },
        square    = { width = 1920, height = 1080, color = { r = 10, g = 15, b = 35, a = 255 }, layer = 0, fixed = true },
    }
})

-- ── Title / subtitle ─────────────────────────────────────────────────────────
load_entity({
    components = {
        transform  = { position = { x = 570, y = 80 } },
        text_label = { text = "Octarine Engine Showcase", font_id = "charriot-16",
                       color = { r = 220, g = 180, b = 60, a = 255 }, is_fixed = true, layer = 5 },
    }
})
load_entity({
    components = {
        transform  = { position = { x = 650, y = 140 } },
        text_label = { text = "Select a demo to explore engine features",
                       font_id = "arial-font-10",
                       color = { r = 160, g = 160, b = 160, a = 255 }, is_fixed = true, layer = 5 },
    }
})

-- ── Demo buttons ─────────────────────────────────────────────────────────────
local btn_x   = 680
local desc_x  = btn_x + 420
local btn_w   = 400
local btn_h   = 64
local start_y = 240
local gap     = 100

local demos = {
    {
        label = "Gameplay Demo",
        path  = "scripts/demos/gameplay-demo.lua",
        desc  = "Top-down helicopter combat. WASD + Space to fire.\nAnimated sprites, OBB collision, projectile emitters,\ncamera follow, health labels, spatial audio.",
    },
    {
        label = "Physics & Collision",
        path  = "scripts/demos/physics-demo.lua",
        desc  = "Shoot at AABB and OBB targets.\nSee how SAT collision handles pre-rotated shapes,\nlive-spinning colliders, and scale-pulsing entities.",
    },
    {
        label = "Audio & Spatial Audio",
        path  = "scripts/demos/audio-demo.lua",
        desc  = "Move toward and away from sound sources.\nHear volume falloff and stereo pan change.\nCompare spatial vs non-spatial sources.",
    },
    {
        label = "Rendering & Animation",
        path  = "scripts/demos/rendering-demo.lua",
        desc  = "Static visual showcase — no input needed.\nSprite animation, flip modes, layer ordering,\nalpha gradients, rotation/scale, font rendering.",
    },
}

for i, demo in ipairs(demos) do
    local by = start_y + (i - 1) * gap
    local path = demo.path
    hub_button.make({
        x = btn_x, y = by, w = btn_w, h = btn_h,
        label = demo.label,
        on_click = function()
            load_scene(path)
        end,
    })
    load_entity({
        components = {
            transform  = { position = { x = desc_x, y = by + 8 } },
            text_label = { text = demo.desc, font_id = "arial-font-10",
                           color = { r = 140, g = 140, b = 140, a = 255 }, is_fixed = true, layer = 5 },
        }
    })
end

-- ── Divider line between buttons and descriptions ─────────────────────────────
load_entity({
    components = {
        transform = { position = { x = desc_x - 12, y = start_y } },
        square    = { width = 2, height = (btn_h + gap) * #demos - (gap - btn_h),
                      color = { r = 60, g = 60, b = 90, a = 200 }, layer = 4, fixed = true },
    }
})

-- ── Version watermark ─────────────────────────────────────────────────────────
load_entity({
    components = {
        transform  = { position = { x = 1830, y = 1058 } },
        text_label = { text = "v0.1.0", font_id = "arial-font-10",
                       color = { r = 70, g = 70, b = 70, a = 160 }, is_fixed = true, layer = 5 },
    }
})
