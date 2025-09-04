-- FruitSpawner Class
-- Creates and entity with a Spawner component

FruitSpawner = {}
FruitSpawner.__index = FruitSpawner

-- Extend the entity class
setmetatable(FruitSpawner, {__index = Entity})

function FruitSpawner.new()
    -- Base entity
    local self = Entity.new()
    setmetatable(self, FruitSpawner)

    -- Fruit options
    -- FIX: don't love that this relies on knowing what fruit we have
    local fruit_kinds = {"cherry", "strawberry", "orange", "apple"} 

    -- Add a Spawner component
    self:add_component(Spawner.new(self, {
        spawn_rate = 6,
        entity_type = Fruit,
        entity_options = function() return {
            x = flr(rnd(90)+10),
            y = flr(rnd(90)+10),
            kind = fruit_kinds[flr(rnd(#fruit_kinds))+1]
        } 
        end
    }))

    return self
end

