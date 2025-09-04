-- In a perfect world, I would actually structure these requires like 
-- "real Lua" with returns and better encapsulation--instead of basically
-- just including them as globals. But alas, no matter what I try picotool
-- ends up taking a big shit when I try to require sibling/sister files so
-- I will leave as globals.

-- Global Utils
require("utils/log")

-- Global Component
require("components/input_controller")
require("components/mover")
require("components/patrol")
require("components/spawner")
require("components/sprite")

-- Global Entities: `Entity` base, `Player` contructor, etc.
require("entities/base/entity")
require("entities/player")
require("entities/enemy")
require("entities/enemy_spawner")
require("entities/fruit")
require("entities/fruit_spawner")

-- Game world / entities list
require("world")


-- Main entry point for the game
function _init()
    log.print("=== Game Started ===")

    -- Create some entities
    player = Player.new({
        x = 55,
        y = 55
    })
    world:add(player)

    enemies = EnemySpawner.new()
    world:add(enemies)
    
    fruits = FruitSpawner.new()
    world:add(fruits)
end

-- Core loop for game updates
function _update()
    for e in all(world.entities) do 
        e:update()
    end
end

-- Core loop for drawing game
function _draw()
    cls(1)
    
    for e in all(world.entities) do
        e:draw()
    end
end

