-- demo_hud.lua
-- Installs a "< Hub" back-button and an ImGui info panel for every demo scene.
-- Usage: demo_hud.install("Scene Title", "Description text\nwith newlines")

demo_hud = {}

function demo_hud.install(title, body)
    hub_button.make({
        x          = 20, y = 20, w = 180, h = 48,
        label      = "< Hub",
        scene_path = "scripts/hub.lua",
        on_click   = function(self)
            self.is_active = false
            load_scene(self.scene_path)
        end,
    })

    local panel_title = title or "Demo"
    local panel_body  = body  or ""
    load_entity({
        components = {
            script = {
                on_debug_gui = function(self, entity)
                    if ImGui.Begin(panel_title) then
                        ImGui.TextWrapped(panel_body)
                    end
                    ImGui.End()
                end,
            }
        }
    })
end

return demo_hud
