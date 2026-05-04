-- level-loader.lua

local function create_tile_entity(tile_texture_id, tile_x, tile_y, scale, tile_width, tile_height, tile_rect_x, tile_rect_y)
    local tile = {
        tag = "tiles",
        components = {
            transform = {
                position = { x = tile_x, y = tile_y },
                scale = { x = scale, y = scale },
                rotation = 0.0,
            },
            sprite = {
                texture_asset_id = tile_texture_id,
                width = tile_width,
                height = tile_height,
                layer = 0,
                fixed = false,
                src_rect_x = tile_rect_x,
                src_rect_y = tile_rect_y
            },
        }
    }
    load_entity(tile)
end

-- Define a global function to load game data
local function load_level(levelNumber)
    -- Load assets
    local level_path = get_asset_path("scripts/level" .. levelNumber .. ".lua")
    log("Loading level script: " .. level_path)
    dofile(level_path)

    local assets = current_level.assets
    for _, v in ipairs(assets) do
        load_asset(v)
    end

    -- Load tilemap
    local tilemap = current_level.tilemap
    local map_file = get_asset_path(tilemap.map_file)
    local num_cols = tilemap.num_cols
    local texture_asset_id = tilemap.texture_asset_id
    local tile_size = tilemap.tile_size
    local scale = tilemap.scale

    log("Loading tilemap from file: " .. map_file)

    local lines = read_file_lines(map_file)
    local row_number = 0
    local max_columns = 0

    for row, line in ipairs(lines) do
        local row_data = {}
        for value in string.gmatch(line, "([^,]+)") do
            table.insert(row_data, tonumber(value))
        end
        
        local column_number = 0
        for column, item_value in ipairs(row_data) do
            local row_index = math.floor(item_value / num_cols)
            local column_index = item_value % num_cols
            local tile_x = tile_size * column_number * scale
            local tile_y = tile_size * row_number * scale
            local src_rect_x = column_index * tile_size;
            local src_rect_y = row_index * tile_size;
            create_tile_entity(texture_asset_id, tile_x, tile_y, scale, tile_size, tile_size, src_rect_x, src_rect_y)
            
            column_number = column_number + 1
        end
        if column_number > max_columns then
            max_columns = column_number
        end
        row_number = row_number + 1
    end

    set_game_map_dimensions(max_columns * tile_size * scale, row_number * tile_size * scale)


    -- Load entities
    local entities = current_level.entities
    for _, v in ipairs(entities) do
        v["entities"] = {
            {
                components = {
                    transform = {
                        position = { x = 0, y = -10 },
                        scale = { x = 1.0, y = 1.0 },
                        rotation = 0.0,
                    },
                    text_label = {
                        text = "100%",
                        font_id = "arial-font-10",
                        color = { r = 255, g = 255, b = 255, a = 255 },
                        is_fixed = false,
                        layer = 5
                    },
                    square = {
                        position = { x = 0, y = 0 },
                        width = 50,
                        height = 20,
                        color = { r = 255, g = 0, b = 0, a = 255 },
                        is_fixed = false,
                        layer = 5
                    }
                }
            }
        }

        load_entity(v)
    end
end

level_loader = {
    load_level = load_level
}

return level_loader