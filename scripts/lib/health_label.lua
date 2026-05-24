-- health_label.lua
-- Drives the health % text + colored bar overlay on a label child entity.
-- Mirrors the retired C++ DisplayHealthSystem.

local function color(r, g, b) return { r = r, g = g, b = b, a = 255 } end
local LOW    = color(255, 0,   0)
local MEDIUM = color(255, 255, 0)
local HIGH   = color(0,   255, 0)

local function health_color(pct)
    if pct > 0.66 then return HIGH end
    if pct > 0.33 then return MEDIUM end
    return LOW
end

local function update(self, entity, dt)
    local parent = registry.get_parent(entity)
    if not parent then return end
    if not registry.has_health(parent) then return end

    local health = registry.get_health(parent)
    if health.max_health <= 0 then return end

    local pct = health.current_health / health.max_health
    local amount = math.floor(pct * 100)

    local label = registry.get_text_label(entity)
    label.text = tostring(amount) .. "%"
    local c = health_color(pct)
    label.color.r, label.color.g, label.color.b, label.color.a = c.r, c.g, c.b, c.a

    local width = amount
    if registry.has_sprite(parent) then
        local sprite = registry.get_sprite(parent)
        local scale_x = 1.0
        if registry.has_scale(parent) then
            scale_x = registry.get_scale(parent).value.x
        end
        width = sprite.width * pct * scale_x
    end

    local sq = registry.get_square(entity)
    sq.width = width
    sq.color.r, sq.color.g, sq.color.b, sq.color.a = c.r, c.g, c.b, c.a
end

health_label = {
    new = function()
        return { on_update = update }
    end,
    update = update,
}

return health_label
