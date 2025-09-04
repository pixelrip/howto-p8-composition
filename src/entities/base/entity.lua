-- Base Entity Class

Entity = {}
Entity.__index = Entity

function Entity.new(opts)
    local opts = opts or {}
    local self = setmetatable({}, Entity)
    
    -- Core Properties
    -- Some invisible entities like the EnemySpawner don't 
    -- actually need them.
    
    self.x = opts.x or 0
    self.y = opts.y or 0
    self.w = opts.w or 0
    self.h = opts.h or 0

    -- Component host fields
    self.components = {}
    self._updateables = {}
    self._drawables = {}

    return self
end

function Entity:add_component(c)
    c.owner = self

    add(self.components, c)

    -- The component's __index points to its "class"
    local component_type = getmetatable(c).__index
    self.components[component_type] = c

    if c.init then c:init() end
    if c.update then add(self._updateables, c) end
    if c.draw then add(self._drawables, c) end
end

-- Allow components to get other components
function Entity:get_component(component_type)
    return self.components[component_type]
end

function Entity:update()
    for c in all(self._updateables) do c:update() end
end

function Entity:draw()
    for c in all(self._drawables) do c:draw() end
end

function Entity:destroy()
    for c in all(self.components) do
        if c.destroy then c:destroy() end
    end
end
