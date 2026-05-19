-- spinner.lua
-- Continuously rotate an entity. Demonstrates the new rotation/scale Lua bindings:
--   registry.get_rotation(entity).value    (radians; read/write)
--   registry.has_rotation(entity)
--   registry.get_scale(entity).value.x/.y  (read/write)
--
-- Attach via:
--   script = spinner.new({ speed = 2.0 })                 -- pure rotation
--   script = spinner.new({ speed = 1.5, pulse = 0.25 })   -- rotation + scale pulse

local function update(self, entity, dt)
    if registry.has_rotation(entity) then
        local rot = registry.get_rotation(entity)
        rot.value = rot.value + self.speed * dt
    end

    if self.pulse > 0 and registry.has_scale(entity) then
        self.elapsed = self.elapsed + dt
        local s = self.base_scale + math.sin(self.elapsed * self.speed) * self.pulse
        local scale = registry.get_scale(entity)
        scale.value.x = s
        scale.value.y = s
    end
end

spinner = {
    new = function(opts)
        opts = opts or {}
        return {
            speed      = opts.speed      or 1.0,
            pulse      = opts.pulse      or 0.0,
            base_scale = opts.base_scale or 1.0,
            elapsed    = 0.0,
            on_update  = update,
        }
    end,
    update = update,
}

return spinner
