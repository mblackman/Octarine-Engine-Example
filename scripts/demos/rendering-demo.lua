-- rendering-demo.lua
-- Static visual showcase — no player or input needed.
-- Demonstrates: sprite animation, flip modes, layer ordering, live rotation
-- and scale via spinner.lua, square primitive alpha, and font rendering.

acquire_scene_assets({
    preload = {
        "chopper-texture",
        "tank-texture",
        "truck-texture",
        "arial-font-10",
        "charriot-16",
    }
})

set_game_map_dimensions(1920, 1080)

-- ── Section header helper ─────────────────────────────────────────────────────
local function section_heading(x, y, text)
    load_entity({
        components = {
            transform  = { position = { x = x, y = y } },
            text_label = { text = text, font_id = "charriot-16",
                           color = { r = 220, g = 180, b = 60, a = 255 }, is_fixed = false, layer = 7 },
        }
    })
end

local function caption(x, y, text)
    load_entity({
        components = {
            transform  = { position = { x = x, y = y } },
            text_label = { text = text, font_id = "arial-font-10",
                           color = { r = 180, g = 180, b = 180, a = 220 }, is_fixed = false, layer = 7 },
        }
    })
end

-- ══════════════════════════════════════════════════════════════════════════════
-- Section 1: Sprite animation — two choppers at different frame rates (top-left)
-- ══════════════════════════════════════════════════════════════════════════════
section_heading(60, 40, "1. Sprite Animation")

local anim_variants = {
    { x = 90,  speed = 2,  label = "2 fps" },
    { x = 220, speed = 10, label = "10 fps" },
    { x = 350, speed = 30, label = "30 fps" },
}
for _, v in ipairs(anim_variants) do
    load_entity({
        components = {
            transform = { position = { x = v.x, y = 100 }, scale = { x = 3, y = 3 } },
            sprite    = { texture_asset_id = "chopper-texture", width = 32, height = 32, layer = 4,
                          fixed = false, src_rect_x = 0, src_rect_y = 0 },
            animation = { num_frames = 2, speed_rate = v.speed },
        }
    })
    caption(v.x - 8, 205, v.label)
end

-- ══════════════════════════════════════════════════════════════════════════════
-- Section 2: Sprite flip modes (top-center)
-- ══════════════════════════════════════════════════════════════════════════════
section_heading(540, 40, "2. Sprite Flip")

local flip_variants = {
    { x = 570,  flip = 0, label = "None" },
    { x = 690,  flip = 1, label = "Horiz" },
    { x = 810,  flip = 2, label = "Vert" },
    { x = 930,  flip = 3, label = "Both" },
}
for _, v in ipairs(flip_variants) do
    load_entity({
        components = {
            transform = { position = { x = v.x, y = 100 }, scale = { x = 2.5, y = 2.5 } },
            sprite    = { texture_asset_id = "truck-texture", width = 32, height = 32, layer = 4,
                          fixed = false, flip = v.flip },
        }
    })
    caption(v.x - 4, 190, v.label)
end

-- ══════════════════════════════════════════════════════════════════════════════
-- Section 3: Layer ordering (top-right) — four overlapping squares
-- ══════════════════════════════════════════════════════════════════════════════
section_heading(1100, 40, "3. Layer Ordering")

local layer_colors = {
    { r = 255, g = 80,  b = 80,  a = 210 },
    { r = 80,  g = 220, b = 80,  a = 210 },
    { r = 80,  g = 100, b = 255, a = 210 },
    { r = 255, g = 240, b = 60,  a = 210 },
}
local layer_labels = { "layer 1 (bottom)", "layer 2", "layer 3", "layer 4 (top)" }
for i = 1, 4 do
    load_entity({
        components = {
            transform = { position = { x = 1120 + (i - 1) * 40, y = 90 + (i - 1) * 35 } },
            square    = { width = 100, height = 80, color = layer_colors[i], layer = i, fixed = false },
        }
    })
end
-- Labels along the right side
for i = 1, 4 do
    caption(1300, 90 + (i - 1) * 35, layer_labels[i])
end

-- ══════════════════════════════════════════════════════════════════════════════
-- Section 4: Rotation + scale mutation via spinner.lua (middle row)
-- ══════════════════════════════════════════════════════════════════════════════
section_heading(60, 280, "4. Rotation & Scale (spinner.lua)")

local transform_demos = {
    { x = 110,  speed = 1.0,  pulse = 0,   label = "Rotate" },
    { x = 290,  speed = 2.5,  pulse = 0,   label = "Fast rotate" },
    { x = 470,  speed = -1.2, pulse = 0,   label = "Counter-CW" },
    { x = 650,  speed = 1.5,  pulse = 0.4, label = "Rotate + pulse" },
    { x = 830,  speed = 0.6,  pulse = 0.7, label = "Slow + big pulse" },
}
for _, v in ipairs(transform_demos) do
    load_entity({
        components = {
            transform = { position = { x = v.x, y = 380 }, scale = { x = 2, y = 2 }, rotation = 0.0 },
            sprite    = { texture_asset_id = "tank-texture", width = 32, height = 32, layer = 3, fixed = false },
            script    = spinner.new({ speed = v.speed, pulse = v.pulse, base_scale = 1.0 }),
        }
    })
    caption(v.x - 20, 460, v.label)
end

-- ══════════════════════════════════════════════════════════════════════════════
-- Section 5: Square primitives with alpha gradient (middle-right)
-- ══════════════════════════════════════════════════════════════════════════════
section_heading(1080, 280, "5. Square Primitives & Alpha")

local alpha_steps = { 255, 210, 160, 110, 65, 25 }
for i, alpha in ipairs(alpha_steps) do
    load_entity({
        components = {
            transform = { position = { x = 1100 + (i - 1) * 110, y = 360 } },
            square    = { width = 90, height = 90, color = { r = 160, g = 80, b = 220, a = alpha }, layer = 2, fixed = false },
        }
    })
    caption(1100 + (i - 1) * 110, 460, "a=" .. alpha)
end

-- ══════════════════════════════════════════════════════════════════════════════
-- Section 6: Font rendering — two typefaces, sizes, and colors (bottom)
-- ══════════════════════════════════════════════════════════════════════════════
section_heading(60, 540, "6. Font Rendering")

local text_samples = {
    { y = 610, text = "arial-font-10 — body text / captions",       font = "arial-font-10",  r = 220, g = 220, b = 220 },
    { y = 650, text = "charriot-16 — display headings",             font = "charriot-16",    r = 220, g = 180, b = 60  },
    { y = 700, text = "Colored text (r=80, g=200, b=255)",          font = "arial-font-10",  r = 80,  g = 200, b = 255 },
    { y = 740, text = "text_label is_fixed=false — scrolls w/ world", font = "arial-font-10", r = 160, g = 160, b = 160 },
}
for _, s in ipairs(text_samples) do
    load_entity({
        components = {
            transform  = { position = { x = 80, y = s.y } },
            text_label = { text = s.text, font_id = s.font,
                           color = { r = s.r, g = s.g, b = s.b, a = 255 }, is_fixed = false, layer = 6 },
        }
    })
end

-- is_fixed=true sample on the right (doesn't move with camera)
load_entity({
    components = {
        transform  = { position = { x = 1100, y = 610 } },
        text_label = { text = "text_label is_fixed=true — always on screen",
                       font_id = "arial-font-10",
                       color = { r = 80, g = 255, b = 160, a = 255 }, is_fixed = true, layer = 6 },
    }
})

demo_hud.install(
    "Rendering & Animation",
    "No input needed — observe the scene.\n\n"
    .. "1. Sprite Animation\n"
    .. "   num_frames, speed_rate\n\n"
    .. "2. Sprite Flip\n"
    .. "   flip = 0/1/2/3 (none/H/V/HV)\n\n"
    .. "3. Layer Ordering\n"
    .. "   Higher layer draws on top.\n\n"
    .. "4. Rotation & Scale (spinner.lua)\n"
    .. "   Live rot/scale via script callbacks.\n\n"
    .. "5. Square Primitives\n"
    .. "   Color { r,g,b,a } with alpha.\n\n"
    .. "6. Font Rendering\n"
    .. "   Two fonts, colors, is_fixed modes."
)
