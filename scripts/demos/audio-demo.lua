-- audio-demo.lua
-- Demonstrates: spatial audio falloff, stereo panning, non-spatial (global)
-- sources, audio_listener, min/max distance configuration.
-- Move the player (green square) to hear volume and pan change.

acquire_scene_assets({
    preload = { "helicopter", "arial-font-10", "charriot-16" }
})

set_game_map_dimensions(1920, 1080)
input_map.install()

-- ── Player / audio listener ───────────────────────────────────────────────────
load_entity({
    name = "Player",
    components = {
        transform     = { position = { x = 960, y = 540 }, scale = { x = 2, y = 2 } },
        rigidbody     = { velocity = { x = 0, y = 0 } },
        square        = { width = 28, height = 28, color = { r = 60, g = 200, b = 80, a = 255 }, layer = 4, fixed = false },
        box_collider  = { width = 28, height = 28, offset = { x = 0, y = 0 } },
        audio_listener = { max_distance = 900, rolloff = 1.0, doppler_factor = 0.0 },
        script         = player_controller.new({ velocity = 180, sprite_width = 28, sprite_height = 28 }),
        camera_follow  = { follow = true },
    }
})

-- Listener label (follows player)
load_entity({
    components = {
        transform  = { position = { x = 960, y = 510 } },
        text_label = { text = "You (listener)", font_id = "arial-font-10",
                       color = { r = 80, g = 255, b = 100, a = 255 }, is_fixed = false, layer = 6 },
    }
})

-- ── Spatial source A — orange; tight falloff ──────────────────────────────────
load_entity({
    name = "Source-A",
    components = {
        transform    = { position = { x = 280, y = 280 } },
        square       = { width = 32, height = 32, color = { r = 255, g = 100, b = 40, a = 230 }, layer = 2, fixed = false },
        audio_source = {
            clip_id      = "helicopter",
            loop         = true,
            play_on_spawn = true,
            volume       = 0.9,
            spatial      = true,
            min_distance = 80,
            max_distance = 500,
        },
    }
})
load_entity({
    components = {
        transform  = { position = { x = 240, y = 248 } },
        text_label = { text = "Spatial A  min=80  max=500", font_id = "arial-font-10",
                       color = { r = 255, g = 140, b = 80, a = 255 }, is_fixed = false, layer = 6 },
    }
})

-- Range ring A (visual guide)
load_entity({
    components = {
        transform = { position = { x = 280 - 500, y = 280 - 500 } },
        square    = { width = 1000, height = 1000, color = { r = 255, g = 100, b = 40, a = 18 }, layer = 1, fixed = false },
    }
})

-- ── Spatial source B — blue; wider falloff ───────────────────────────────────
load_entity({
    name = "Source-B",
    components = {
        transform    = { position = { x = 1600, y = 750 } },
        square       = { width = 32, height = 32, color = { r = 60, g = 130, b = 255, a = 230 }, layer = 2, fixed = false },
        audio_source = {
            clip_id      = "helicopter",
            loop         = true,
            play_on_spawn = true,
            volume       = 0.8,
            spatial      = true,
            min_distance = 120,
            max_distance = 800,
        },
    }
})
load_entity({
    components = {
        transform  = { position = { x = 1560, y = 718 } },
        text_label = { text = "Spatial B  min=120  max=800", font_id = "arial-font-10",
                       color = { r = 100, g = 160, b = 255, a = 255 }, is_fixed = false, layer = 6 },
    }
})

-- Range ring B
load_entity({
    components = {
        transform = { position = { x = 1600 - 800, y = 750 - 800 } },
        square    = { width = 1600, height = 1600, color = { r = 60, g = 130, b = 255, a = 12 }, layer = 1, fixed = false },
    }
})

-- ── Non-spatial (global) source — yellow; volume never changes ────────────────
load_entity({
    name = "Source-Global",
    components = {
        transform    = { position = { x = 960, y = 160 } },
        square       = { width = 32, height = 32, color = { r = 255, g = 240, b = 60, a = 230 }, layer = 2, fixed = false },
        audio_source = {
            clip_id      = "helicopter",
            loop         = true,
            play_on_spawn = true,
            volume       = 0.25,
            spatial      = false,
        },
    }
})
load_entity({
    components = {
        transform  = { position = { x = 918, y = 128 } },
        text_label = { text = "Non-spatial (constant volume)", font_id = "arial-font-10",
                       color = { r = 255, g = 240, b = 80, a = 255 }, is_fixed = false, layer = 6 },
    }
})

demo_hud.install(
    "Audio & Spatial Audio",
    "WASD / Arrows: Move\n\n"
    .. "Orange (Source A)\n"
    .. "  spatial=true\n"
    .. "  min_distance = 80\n"
    .. "  max_distance = 500\n\n"
    .. "Blue (Source B)\n"
    .. "  spatial=true\n"
    .. "  min_distance = 120\n"
    .. "  max_distance = 800\n\n"
    .. "Yellow (Global)\n"
    .. "  spatial=false\n"
    .. "  Volume stays constant\n"
    .. "  regardless of position.\n\n"
    .. "Colored squares show max-range\n"
    .. "falloff zones. Move toward a\n"
    .. "source to hear stereo pan shift."
)
