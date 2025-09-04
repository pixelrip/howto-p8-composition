-- Fruit Class
Fruit = {}
Fruit.__index = Fruit

-- Extend the entity class
setmetatable(Fruit, { __index = Entity })

-- Fruit Constants
local FRUITS = {
    cherry     = { SX = 35, SY = 0, W = 10, H = 10, T = 11, VAL = 100},
    strawberry = { SX = 45, SY = 0, W = 9, H = 10, T = 12, VAL = 200},
    orange     = { SX = 54, SY = 0, W = 9, H = 10, T = 12, VAL = 300},
    apple      = { SX = 63, SY = 0, W = 9, H = 10, T = 11, VAL = 500}
}

-- Fruit Constructor
function Fruit.new(opts)
    local kind = opts.kind or 'cherry'
    local cfg = FRUITS[kind]

    local self = Entity.new({
        x = opts.x or 0,
        y = opts.y or 0,
        w = cfg.W,
        h = cfg.H
    })

    setmetatable(self, Fruit)

    self:add_component(Sprite.new(self, {
        sx = cfg.SX,
        sy = cfg.SY,
        t = cfg.T
    }))

    return self
end

