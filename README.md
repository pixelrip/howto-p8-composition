# How To: Object Composition Pattern in Pico-8

This project uses a **Component-Based Architecture** that favors **composition** over **inheritance** to create flexible and reusable game entities. While it's inspired by ECS patterns, it takes an object-centric approach, where entities are objects that own their components, and components encapsulate both data and related logic. This differs from a data-oriented, 'pure' ECS where logic is handled by external systems and components are strictly data containers.

The code here expands on the examples in [How To: Inheritance in PICO-8](https://github.com/pixelrip/howto-p8-inheritance), which may provide additional useful context.

## Prerequisites

1. **Pico-8** - Install from [lexaloffle.com](https://www.lexaloffle.com/pico-8.php)
2. **Python 3.4+** - Required for picotool
3. **picotool** - Install from [GitHub](https://github.com/dansanderson/picotool)
3. **Git** (recommended) - For version control

## Quick Start
   ```bash
   ./scripts/build.sh
   ```
   
   Load `composition.p8` in Pico-8 and run it.


## Project Structure

```plaintext
project/
├── .vscode/               # VS Code settings
├── assets/                # Spritesheet and Audio Data
├── build/                 # Generated files (dev/prod builds)
├── scripts/               # Build automation
├── src/                   # Source code
│   ├── components/        # Behaviors for entities
│   ├── entities/          # Game objects (e.g., Player)
│   ├── utils/             # Helper functions (e.g., Logging)
│   ├── main.lua           # Entry point with _init, _update, _draw
│   └── world.lua          # Entity list
└── README.md              # Main project README
```

## How It Works

**Composition** examples almost always references LEGOs, for good reason. The idea is that you start with a simple base piece and snap on smaller, specialized bricks (so, "composition"). Each brick gives your creation a new ability. One brick might be a wheel that lets it move, another might be a shiny color that makes it look cool.

In this project, our "base piece" is an `Entity`, and the "specialized bricks" are called **Components**.

### What is an Entity?

An entity is any "thing" that exists in your game. The `player`, an `enemy`, a piece of `fruit`, etc. At its core, an entity is just a simple object that knows its `position` and `size` and holds a list of its components.

```Lua
-- An entity is a basic game object with position and size.
function Entity.new(opts)
    local self = {} -- Create a new, empty object

    -- Set its position and dimensions (or use defaults)
    self.x = opts.x or 0
    self.y = opts.y or 0
    self.w = opts.w or 0
    self.h = opts.h or 0

    -- Create empty lists to hold its components (its "abilities")
    self.components = {}
    self._updateables = {} -- components that need to do something every frame
    self._drawables = {}   -- components that need to be drawn every frame

    return self
end
```

An entity doesn't do much on its own. Its power comes from the components it owns.

### What is a Component?

A **component** is a reusable module that gives an entity a single, specific ability. It's a specialist. For example, we have components for:

- Drawing a sprite: `Sprite`
- Moving around: `Mover`
- Listening to player input: `InputController`
- Moving back and forth automatically: `Patrol`
- Creating other entities: `Spawner`

Let's look at the `Mover` component. Its one and only job is to change its owner's `x` and `y` coordinates based on its direction (`dx`, `dy`) and `speed`.

```Lua
-- The Mover component gives an entity the ability to move.
Mover = {}

function Mover.new(owner, opts)
    local self = {}

    self.owner = owner          -- A reference to the entity that owns this component
    self.speed = opts.speed or 1 -- How fast it moves
    self.dx = 0                 -- Its current direction on the x-axis (-1 for left, 1 for right)
    self.dy = 0                 -- Its current direction on the y-axis (-1 for up, 1 for down)

    return self
end

-- Every frame, the update function moves the owner.
function Mover:update()
    self.owner.x += self.dx * self.speed
    self.owner.y += self.dy * self.speed
end
```

By keeping components small and focused, we can mix and match them to create complex and varied game objects.

### The Base `Entity`: A Smart Container

The base `Entity` is designed to make working with components easy. When you add a component to an entity, the entity automatically hooks it into the main game loop.

The add_component function does a few clever things:

1. It stores the component.
2. It tells the component who its owner is.
3. It checks if the component has an update or draw function. If it does, the entity makes sure to call it every single frame, automatically!

```Lua
function Entity:add_component(c)
    -- Store this component in our list
    add(self.components, c)
    c.owner = self -- Tell the component who owns it

    -- If the component has an "update" function, add it to the list
    -- of things that need to be updated every frame.
    if c.update then
        add(self._updateables, c)
    end

    -- If the component has a "draw" function, add it to the list
    -- of things that need to be drawn every frame.
    if c.draw then
        add(self._drawables, c)
    end
end
```

This means our entities stay clean and simple. They don't need to know the details of how they move or draw—they just delegate that work to their components.

### The Player: Assembling an Entity

Now, let's see how we build the Player by composing it from components. A player needs to:

- Be visible on the screen (`Sprite` component).
- Be able to move (`Mover` component).
- Respond to button presses (`InputController` component).

So, in the `Player.new` constructor, we just create a new entity and snap on those three "bricks."

```Lua
function Player.new(opts)
    -- First, create a basic entity with a position and size.
    local self = Entity.new({
        x = opts.x or 0,
        y = opts.y or 0,
        w = Player.W,
        h = Player.H
    })

    -- Now, add the abilities (components) the player needs.

    -- 1. Give it a sprite so it's visible.
    self:add_component(Sprite.new(self, { ... }))

    -- 2. Give it a mover so it can change position.
    self:add_component(Mover.new(self, { speed = Player.SPEED }))

    -- 3. Give it an input controller so we can control the mover.
    self:add_component(InputController.new(self))

    return self
end
```

### The Enemy: Reusing Components for Different Behavior

Here's where composition gets really powerful. An `Enemy` is a lot like a `Player`: it also needs a `Sprite` to be seen and a `Mover` to move. But instead of being controlled by the player, it should move back and forth automatically.

So, we just swap one component! We replace `InputController` with a `Patrol` component.

```Lua
function Enemy.new(opts)
    -- Start with a base entity, just like the player.
    local self = Entity.new({ ... })

    -- Add the shared components.
    -- 1. Give it a sprite.
    self:add_component(Sprite.new(self, { ... }))

    -- 2. Give it a mover.
    self:add_component(Mover.new(self, { speed = self.speed }))

    -- And here's the difference:
    -- 3. Give it a patrol component for simple AI movement.
    self:add_component(Patrol.new(self, { axis = opts.axis or 'x' }))

    return self
end
```

We've created a totally different behavior just by mixing and matching our reusable components. We didn't have to duplicate any code for moving or drawing.

### Spawners: "Invisible" Entities

Not all entities need to be visible. The `EnemySpawner` is an entity that doesn't have a `position` or a `sprite`. Its only job is to own a `Spawner` component, which periodically creates new `Enemy` entities and adds them to the game world.

```Lua
function EnemySpawner.new()
    -- Create a base entity. No x, y, w, or h needed!
    local self = Entity.new()

    -- Add the one component it needs.
    self:add_component(Spawner.new(self, {
        spawn_rate = 3,      -- Create a new enemy every 3 seconds
        entity_type = Enemy, -- The type of entity to create
        entity_options = function()
            -- This function runs every time a new enemy is spawned,
            -- allowing us to randomize its starting position and speed.
            return {
                x = flr(rnd(90)+10),
                y = flr(rnd(90)+10),
                speed = (rnd(2) + 0.5),
                axis = flr(rnd(2)) == 0 and "x" or "y"
            }
        end
    }))

    return self
end
```

This shows the flexibility of the system. An entity can be a visible character, a collectible item, or even an invisible "manager" object that just performs a task. And because the Spawner component is reusable, we can create a `FruitSpawner` just by telling it to spawn `Fruit` entities instead of `Enemy` entities.

This component-based approach keeps your code organized, flexible, and easy to change. You can add new abilities or create new types of game objects without rewriting tons of code—just create a new component or assemble a new combination of existing ones.

## Bonus: What in the `world`?

So, we've created all these entities—the player, enemies, fruit, and even invisible spawners. But where do they all exist? And how does the game keep track of them all?

That's the job of the `world`.

### What is the world?

The `world` is a simple container, a big list that holds every active entity in our game. It's a central **registry** for all our game objects.

Its definition is incredibly simple. It's just an object with a list called `entities` and a function to add things to that list.

```Lua
-- src/world.lua

world = {
    entities = {} -- A list to hold all of our game objects
}

-- A function to add a new entity (e) to the list
function world:add(e)
    add(self.entities, e)
end
```

### Why Do We Use It?

By having one central place for all our entities, we decouple the creation of objects from the main game loop.

Spawners or level-setup code can create a new `Enemy` or `Fruit` and simply tell the `world` to manage it by calling `world:add(new_enemy)`. They don't need to know anything about how the game runs frame-by-frame.

The main game loop doesn't need to know where entities come from. Its job is simple: get the list of all entities from the `world` and tell each one to `update()` and `draw()`.

This separation keeps our code clean and organized.

### How Does It Work in the Game Loop?

You likely know by now PICO-8 has two special functions that run continuously: `_update()` (for game logic, 30 times a second) and `_draw()` (for rendering, also 30 times a second).

The world makes these functions incredibly tidy. We just loop through the `world.entities` list and call the appropriate method on each entity. The entity, in turn, will delegate the work to its components.

```Lua
-- src/main.lua

-- Core loop for game updates
function _update()
    -- Go through every entity 'e' in the world's list...
    for e in all(world.entities) do
        -- ...and tell it to update itself.
        e:update()
    end
end

-- Core loop for drawing game
function _draw()
    cls(1) -- Clear the screen first

    -- Go through every entity 'e' in the world's list...
    for e in all(world.entities) do
        -- ...and tell it to draw itself.
        e:draw()
    end
end
```

The world acts as the bridge between our entities and the main PICO-8 game loop, giving us a simple and powerful way to manage everything happening in our game.