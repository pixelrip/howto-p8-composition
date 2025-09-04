-- Patrol Component
-- Moves an entity back and forth along a specified axis
-- Requires the owner to have a "Mover" component

Patrol = {}
Patrol.__index = Patrol

function Patrol.new(owner, opts)
    local self = setmetatable({}, Patrol)

    self.owner = owner
    self.axis = opts.axis or "x"
    self.direction = 1

    return self
end

function Patrol:init()
    -- Set the initial direction on the mover component
    local mover = self.owner:get_component(Mover)

    if (mover) then
        if self.axis == "x" then 
            mover.dx = self.direction
        else
            mover.dy = self.direction
        end
    end
end

function Patrol:update()
    local mover = self.owner:get_component(Mover)
    if (not mover) then return end

    local _x = self.owner.x
    local _y = self.owner.y
    local _w = self.owner.w
    local _h = self.owner.h
    local _max_x = 128 - _w
    local _max_y = 128 - _h

    -- Change direction at edge of screen
    if (_x >= _max_x or _y >= _max_y) then
        self.direction = -1
    elseif (_x <= 0 or _y <=0) and (self.direction == -1) then
        self.direction = 1
    end

    -- Update the movers direction
    if self.axis == "x" then
        mover.dx = self.direction
        mover.dy = 0
    else 
        mover.dy = self.direction
        mover.dx = 0
    end
end

