-- player_controller.lua
-- Player movement driver. Attach via:
--   script = player_controller.new({ velocity = 80, sprite_width = 32, sprite_height = 32 })

local row_by_dir = { up = 0, right = 1, down = 2, left = 3 }
local vec_by_dir = { up = {0,-1}, down = {0,1}, left = {-1,0}, right = {1,0} }

local function update(self, entity, dt)
    local dx, dy = 0, 0
    if input.is_action_down("move_up")    then dy = dy - 1 end
    if input.is_action_down("move_down")  then dy = dy + 1 end
    if input.is_action_down("move_left")  then dx = dx - 1 end
    if input.is_action_down("move_right") then dx = dx + 1 end

    if     input.is_action_pressed("move_up")    then self.last_dir = "up"
    elseif input.is_action_pressed("move_down")  then self.last_dir = "down"
    elseif input.is_action_pressed("move_left")  then self.last_dir = "left"
    elseif input.is_action_pressed("move_right") then self.last_dir = "right"
    end

    if dx ~= 0 or dy ~= 0 then
        local len = math.sqrt(dx * dx + dy * dy)
        dx, dy = dx / len, dy / len
        local pos = get_position(entity)
        local dim = get_game_map_dimensions()
        local nx = pos.x + dx * self.velocity * dt
        local ny = pos.y + dy * self.velocity * dt
        if nx < 0 then nx = 0 end
        if ny < 0 then ny = 0 end
        if dim.x > 0 and nx + self.sprite_width  > dim.x then nx = dim.x - self.sprite_width  end
        if dim.y > 0 and ny + self.sprite_height > dim.y then ny = dim.y - self.sprite_height end
        set_position(entity, nx, ny)
    end

    set_sprite_src_rect(entity, 0, row_by_dir[self.last_dir] * self.sprite_height)

    if input.is_action_pressed("fire") then
        local v = vec_by_dir[self.last_dir]
        fire_projectile(entity, v[1], v[2])
    end
end

player_controller = {
    new = function(opts)
        opts = opts or {}
        return {
            velocity      = opts.velocity      or 80,
            sprite_width  = opts.sprite_width  or 32,
            sprite_height = opts.sprite_height or 32,
            last_dir      = opts.last_dir      or "up",
            on_update     = update,
        }
    end,
    update = update,
}

return player_controller
