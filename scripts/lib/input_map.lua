-- input_map.lua
-- Game-wide action bindings + global input callbacks. Loaded once from game.lua.

local function bind_movement()
    input.bind("move_up",    "up");    input.bind("move_up",    "w")
    input.bind("move_down",  "down");  input.bind("move_down",  "s")
    input.bind("move_left",  "left");  input.bind("move_left",  "a")
    input.bind("move_right", "right"); input.bind("move_right", "d")
    input.bind("fire", "space")
end

local function register_global_callbacks()
    -- Wheel-delta trace. Replace with camera zoom once a camera binding exists.
    input.on_mouse_wheel(function(dx, dy)
        if dx ~= 0 or dy ~= 0 then log("wheel " .. dx .. "," .. dy) end
    end)
end

-- Action bindings are wiped by InputSystem.ResetLuaState on every StopScene/LoadScene.
-- Callbacks are wiped too — guard with a flag scoped to the Lua state (which IS preserved
-- across scene loads) so re-installing actions after reload_scene() doesn't double-register.
local callbacks_registered = false

input_map = {
    install = function()
        bind_movement()
        if not callbacks_registered then
            register_global_callbacks()
            callbacks_registered = true
        end
    end
}

return input_map
