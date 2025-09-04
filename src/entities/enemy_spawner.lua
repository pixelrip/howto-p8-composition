-- EnemySpawner Class
-- Creates an entity with a Spawner component

EnemySpawner = {}
EnemySpawner.__index = EnemySpawner

-- Extend the entity class
setmetatable(EnemySpawner, {__index = Entity})

function EnemySpawner.new()
    -- Create the base entity; no x/y/w/h required
    local self = Entity.new()
    setmetatable(self, EnemySpawner)

    -- Add the spawner component
    self:add_component(Spawner.new(self, {
        spawn_rate = 3,
        entity_type = Enemy,
        entity_options = function() return {
            x = flr(rnd(90)+10),
            y = flr(rnd(90)+10),
            speed = (rnd(2) + 0.5),
            axis = flr(rnd(2)) == 0 and "x" or "y" -- Coin flip
        } 
        end
    }))

    return self
end
