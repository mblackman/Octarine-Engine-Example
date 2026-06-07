-- physics-demo.lua
-- Demonstrates: AABB vs OBB collision, SAT narrowphase, spinning/pulsing OBBs,
-- collision masks, rigidbody velocity, box_collider offsets.

acquire_scene_assets({
    preload = {
        "chopper-texture",
        "tank-texture",
        "truck-texture",
        "bullet-texture",
        "arial-font-10",
        "charriot-16",
    }
})

set_game_map_dimensions(1920, 1080)
input_map.install()

-- ── Player ────────────────────────────────────────────────────────────────────
load_entity({
    name = "Player",
    tag  = "player",
    entity_mask = 1,
    components = {
        transform   = { position = { x = 960, y = 880 }, scale = { x = 1, y = 1 }, rotation = 0.0 },
        rigidbody   = { velocity = { x = 0, y = 0 } },
        sprite      = { texture_asset_id = "chopper-texture", width = 32, height = 32, layer = 4, fixed = false },
        animation   = { num_frames = 2, speed_rate = 10 },
        box_collider = { width = 32, height = 25, offset = { x = 0, y = 5 } },
        health      = { max_health = 200 },
        projectile_emitter = {
            projectile_velocity = { x = 0, y = -220 },
            projectile_duration = 4,
            repeat_frequency    = 0,
            hit_damage          = 25,
            friendly            = true,
            collision_mask      = 2,
            projectile_name     = "Player Shell",
        },
        script        = player_controller.new({ velocity = 160, sprite_width = 32, sprite_height = 32 }),
        camera_follow = { follow = true },
    }
})

-- ── Section helper: row label ─────────────────────────────────────────────────
local function row_label(x, y, text)
    load_entity({
        components = {
            transform  = { position = { x = x, y = y } },
            text_label = { text = text, font_id = "arial-font-10",
                           color = { r = 220, g = 200, b = 80, a = 255 }, is_fixed = false, layer = 6 },
        }
    })
end

-- ── Row 1: AABB — axis-aligned static targets ─────────────────────────────────
row_label(160, 140, "Row 1 — AABB (axis-aligned box colliders)")
local aabb_xs = { 200, 360, 520, 680, 840, 1000, 1160, 1320 }
for _, px in ipairs(aabb_xs) do
    load_entity({
        tag = "enemies",
        entity_mask = 2,
        components = {
            transform    = { position = { x = px, y = 200 } },
            sprite       = { texture_asset_id = "tank-texture", width = 32, height = 32, layer = 2 },
            box_collider = { width = 32, height = 32, offset = { x = 0, y = 0 } },
            health       = { max_health = 40 },
        }
    })
end

-- ── Row 2: OBB — pre-rotated at increasing angles ────────────────────────────
row_label(160, 310, "Row 2 — OBB (pre-rotated; SAT narrowphase detects overlap)")
local obb_configs = {
    { x = 200,  angle = 15 },
    { x = 380,  angle = 30 },
    { x = 560,  angle = 45 },
    { x = 740,  angle = 60 },
    { x = 920,  angle = 75 },
    { x = 1100, angle = 90 },
    { x = 1280, angle = 120 },
    { x = 1460, angle = 150 },
}
for _, cfg in ipairs(obb_configs) do
    load_entity({
        tag = "enemies",
        entity_mask = 2,
        components = {
            transform    = { position = { x = cfg.x, y = 370 }, rotation = math.rad(cfg.angle) },
            sprite       = { texture_asset_id = "truck-texture", width = 32, height = 32, layer = 2 },
            box_collider = { width = 32, height = 20, offset = { x = 0, y = 6 } },
            health       = { max_health = 40 },
        }
    })
    -- Angle label beneath each
    load_entity({
        components = {
            transform  = { position = { x = cfg.x - 8, y = 408 } },
            text_label = { text = cfg.angle .. "d", font_id = "arial-font-10",
                           color = { r = 160, g = 160, b = 160, a = 200 }, is_fixed = false, layer = 6 },
        }
    })
end

-- ── Row 3: Live OBB — continuously spinning squares ──────────────────────────
row_label(160, 480, "Row 3 — Live OBB (spinning; collider rotates each frame)")
local spin_configs = {
    { x = 220,  speed = 0.8,  r = 80,  g = 200, b = 255 },
    { x = 420,  speed = 1.2,  r = 100, g = 220, b = 200 },
    { x = 620,  speed = 1.6,  r = 120, g = 180, b = 255 },
    { x = 820,  speed = 2.0,  r = 140, g = 240, b = 180 },
    { x = 1020, speed = 2.5,  r = 160, g = 200, b = 255 },
    { x = 1220, speed = 3.0,  r = 180, g = 160, b = 255 },
}
for _, cfg in ipairs(spin_configs) do
    load_entity({
        tag = "enemies",
        entity_mask = 2,
        components = {
            transform    = { position = { x = cfg.x, y = 555 }, rotation = 0.0 },
            square       = { width = 48, height = 24, color = { r = cfg.r, g = cfg.g, b = cfg.b, a = 220 }, layer = 2, fixed = false },
            box_collider = { width = 48, height = 24, offset = { x = 0, y = 0 } },
            health       = { max_health = 50 },
            script       = spinner.new({ speed = cfg.speed }),
        }
    })
end

-- ── Row 4: Scale pulse — OBB grows and shrinks ───────────────────────────────
row_label(160, 660, "Row 4 — Scale pulse (OBB bounds grow each cycle)")
local pulse_configs = {
    { x = 300,  speed = 1.0, pulse = 0.3 },
    { x = 580,  speed = 1.5, pulse = 0.5 },
    { x = 860,  speed = 2.0, pulse = 0.4 },
    { x = 1140, speed = 0.8, pulse = 0.6 },
}
for _, cfg in ipairs(pulse_configs) do
    load_entity({
        tag = "enemies",
        entity_mask = 2,
        components = {
            transform    = { position = { x = cfg.x, y = 740 }, scale = { x = 1, y = 1 }, rotation = 0.0 },
            sprite       = { texture_asset_id = "tank-texture", width = 32, height = 32, layer = 2 },
            box_collider = { width = 32, height = 32, offset = { x = 0, y = 0 } },
            health       = { max_health = 60 },
            script       = spinner.new({ speed = cfg.speed, pulse = cfg.pulse, base_scale = 1.0 }),
        }
    })
end

demo_hud.install(
    "Physics & Collision",
    "WASD / Arrows: Move   Space: Fire\n\n"
    .. "Row 1 — AABB\n  Standard axis-aligned box colliders.\n\n"
    .. "Row 2 — OBB (pre-rotated)\n  SAT narrowphase resolves overlap\n  on tilted hitboxes.\n\n"
    .. "Row 3 — Live OBB (spinning)\n  Collider rotates every frame;\n  SAT re-tests each tick.\n\n"
    .. "Row 4 — Scale pulse\n  Collider grows/shrinks with the sprite.\n\n"
    .. "Collision masks: player=1, enemies=2.\n"
    .. "Player shells (mask=2) hit only enemies."
)
