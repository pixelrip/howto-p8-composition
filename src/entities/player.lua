-- Player Class
Player = {}
Player.__index = Player

-- Extend the entity class
setmetatable(Player,{__index = Entity})

-- Player Constants
Player.W = 17
Player.H = 13
Player.SPEED = 2
Player.SPRITE_SX = 8
Player.SPRITE_SY = 0
Player.SPRITE_T = 11

-- Constructor for Player
function Player.new(opts)

    -- Create the base entity:
    local self = Entity.new({
        x = opts.x or 0,
        y = opts.y or 0,
        w = Player.W,
        h = Player.H
    })
    setmetatable(self, Player)
    
    -- Set Player Properties
    self.speed = opts.speed or Player.SPEED

    -- Compose behavior with components
    -- Sprite
    self:add_component(Sprite.new(self, {
        sx = Player.SPRITE_SX,
        sy = Player.SPRITE_SY,
        t = Player.SPRITE_T
    }))
    
    -- Make it movable
    self:add_component(Mover.new(self, { 
        speed = Player.SPEED
    }))

    -- Player controls
    self:add_component(InputController.new(self))

    return self
end

