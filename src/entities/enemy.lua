-- Enemy Class
Enemy = {}
Enemy.__index = Enemy

-- Extend the entity class
setmetatable(Enemy,{__index = Entity})

-- Enemy Constants
Enemy.W = 10
Enemy.H = 9
Enemy.SPEED = 1
Enemy.SPRITE_SX = 25
Enemy.SPRITE_SY = 0
Enemy.SPRITE_T = 11


-- Enemy Constructor
function Enemy.new(opts)

    -- Create the base entity:
    local self = Entity.new({
        x = opts.x or 0,
        y = opts.y or 0,
        w = Enemy.W,
        h = Enemy.H
    })
    setmetatable(self, Enemy)

    -- Set Enemy Properties
    self.speed = opts.speed or Enemy.SPEED

    -- Compose behavior with components
    self:add_component(Sprite.new(self, {
        sx = Enemy.SPRITE_SX,
        sy = Enemy.SPRITE_SY,
        t = Enemy.SPRITE_T
    }))
    self:add_component(Mover.new(self, {
        speed = self.speed
    }))
    self:add_component(Patrol.new(self, {
        axis = opts.axis or 'x'
    }))

    return self
end

