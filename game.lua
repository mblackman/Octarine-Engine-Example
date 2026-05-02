-- game.lua

run_map_editor = false

if run_map_editor then
    print("Running map editor...")
    local map_editor_path = get_asset_path("scripts/map-editor.lua")
    print("Loading map editor script: " .. map_editor_path)
    dofile(map_editor_path)
    map_editor.load()
else
    print("Running game...")
    local level_loader_path = get_asset_path("scripts/level-loader.lua")
    print("Loading level loader script: " .. level_loader_path)
    dofile(level_loader_path)

    level_loader.load_level(1)
end
