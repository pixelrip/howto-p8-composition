-- InputController Component
-- Reads player input and translates it into movement direction

InputController = {}
InputController.__index = InputController

function InputController.new(owner)
    local self = setmetatable({}, InputController)
    self.owner = owner
    return self
end

function InputController:update()
    -- This requires the owner to have a "mover" component
    local mover = self.owner:get_component(Mover)

    if (mover) then
        -- Reset direction each frame
        mover.dx = 0
        mover.dy = 0

        -- Check buttons and set direction
        if btn(0) then mover.dx = -1 end -- left
        if btn(1) then mover.dx = 1 end -- right
        if btn(2) then mover.dy = -1 end -- up
        if btn(3) then mover.dy = 1 end -- down

    end
end

