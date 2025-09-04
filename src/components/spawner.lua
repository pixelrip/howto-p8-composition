-- Spawner Component
-- Periodically spawns new entities

Spawner = {}
Spawner.__index = Spawner

function Spawner.new(owner, opts)
    local self = setmetatable({}, Spawner)

    self.owner = owner
    self.spawn_rate = opts.spawn_rate or 3 --seconds
    self.entity_type = opts.entity_type
    self.entity_options = opts.entity_options

    self.timer = self.spawn_rate

    return self
end

function Spawner:update()
    self.timer -= 1/30 -- FIX: Magic numbers (30FPS)

    if self.timer <= 0 then
        -- Support dynamic per-spawn options: if entity_options is a function,
        -- call it (passing this spawner) to get fresh opts; otherwise use table as-is.
        local opts = type(self.entity_options) == "function" and self.entity_options(self) or self.entity_options
        local new_entity = self.entity_type.new(opts)
        world:add(new_entity)

        self.timer = self.spawn_rate
    end
end
