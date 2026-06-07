-- gameplay-demo.lua
-- Enhanced gameplay demo: wraps level1 and appends the demo HUD overlay.
-- Click-to-spawn and debug GUI panels are installed here (not globally).

dofile(get_asset_path("scripts/level-loader.lua"))
level_loader.load_level(1)

spawn.install_click_spawn()
create_debug_gui()

demo_hud.install(
    "Gameplay Demo",
    "WASD / Arrows: Move   Space: Fire\nLeft Click: Spawn tank at cursor\n\n"
    .. "Features shown:\n"
    .. "  Sprite animation (chopper spritesheet)\n"
    .. "  Camera follow\n"
    .. "  OBB collision + SAT narrowphase\n"
    .. "  Projectile emitters (player + enemies)\n"
    .. "  Health labels (script-driven)\n"
    .. "  Spatial audio (helicopter loop)\n"
    .. "  Tilemap rendering\n"
    .. "  Click-to-spawn entity API"
)
