--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
    ['switch'] = {
        type = 'switch',
        texture = 'switches',
        frame = 2,
        width = 16,
        height = 16,
        solid = false,
        consumable = false,
        defaultState = 'unpressed',
        directions = 'up',
        projectile = false,
        dx = 0,
        dy = 0,
        states = {
            ['unpressed'] = {
                frame = 2
            },
            ['pressed'] = {
                frame = 1
            }
        }
    },
    ['pot'] = {
        type = 'pot',
        texture = 'tiles',
        frame = 14,
        width = 16, 
        height = 16,
        solid = true,
        consumable = false,
        defaultState = 'spawned',
        directions = 'up',
        projectile = true,
        dx = 64,
        dy = 64,
        range = 64,
        states = {
            ['spawned'] = {
                frame = 14
            },
            ['broken'] = {
                frame = 52
            }
        }

    },
    ['heart'] = {
        type = 'heart',
        texture = 'hearts',
        frame = 5,
        width = 16,
        height = 16,
        dx = 0,
        dy = 0,
        solid = false,
        consumable = true,
        projectile = false,
        defaultState = 'spawned',
        states = {
            ['spawned'] = {
                frame = 5
            }
        }
        
        --, onCollide function here?
    }
}