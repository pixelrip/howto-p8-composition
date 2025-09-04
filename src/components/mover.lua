-- Mover Component
-- Handles the actual movement of an entity

Mover = {}
Mover.__index = Mover

function Mover.new(owner, opts)
    local self = setmetatable({}, Mover)

    self.owner = owner
    self.speed = opts.speed or 1
    self.dx = 0
    self.dy = 0

    return self
end

function Mover:update()
    self.owner.x += self.dx * self.speed
    self.owner.y += self.dy * self.speed
end

