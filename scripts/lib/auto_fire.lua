-- auto_fire.lua
-- Timer-driven fire_projectile loop. Replaces the engine-side ProjectileEmitSystem auto-fire.
-- Entity still needs a `projectile_emitter` component — Fire() reads it for damage/velocity/mask.

auto_fire = {
    -- Returns a `script` table. dx/dy = aim vector; 0,0 uses emitter's configured velocity.
    new = function(opts)
        opts = opts or {}
        local interval = opts.interval or 1.0
        return {
            interval = interval,
            timer    = opts.initial_delay or interval,
            dx       = opts.dx or 0,
            dy       = opts.dy or 0,
            on_update = function(self, entity, dt)
                self.timer = self.timer - dt
                if self.timer <= 0 then
                    fire_projectile(entity, self.dx, self.dy)
                    self.timer = self.interval
                end
            end
        }
    end,

    -- Wraps another on_update fn so an entity can combine custom logic with auto-fire.
    compose = function(opts, inner_update)
        local fire = auto_fire.new(opts)
        local on_fire_update = fire.on_update
        fire.on_update = function(self, entity, dt)
            inner_update(self, entity, dt)
            on_fire_update(self, entity, dt)
        end
        return fire
    end,
}

return auto_fire
