-- Sprite Component

Sprite = {}
Sprite.__index = Sprite

function Sprite.new(owner, opts)
    local self = setmetatable({}, Sprite)

    self.owner = owner
    self.w = owner.w
    self.h = owner.h
    self.sx = opts.sx
    self.sy = opts.sy
    self.t = opts.t or 0 --transparent color
    self.flip_x = opts.flip_x or false
    self.flip_y = opts.flip_y or false

    return self
end

function Sprite:draw()
    palt(0,false)
    palt(self.t, true)
    sspr(self.sx, self.sy, self.w, self.h, self.owner.x, self.owner.y, self.w, self.h, self.flip_x, self.flip_y)
    palt()
end

