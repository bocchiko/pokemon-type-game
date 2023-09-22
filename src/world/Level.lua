Level = Class{}

function Level:init()
    self.tilewidth = 50
    self.tileheight = 50
    self.baseLayer = TileMap(self.tilewidth, self.tileheight)
    self.grassLayer = TileMap(self.tilewidth, self.tileheight)
    self.halfGrassLayer = TileMap(self.tilewidth, self.tileheight)

    self:createMaps()

    self.player = Player{
        animations = ENTITY['player'].animations,
        mapX = 10,
        mapY = 10,
        width = 16,
        height = 16
    }

    self.player.stateMachine = StateMachine{
        ['walk'] = function () return PlayerWalkState(self.player, self) end,
        ['idle'] = function () return PlayerIdleState(self.player) end
    }
    self.player.stateMachine:change('idle')

end


function Level:createMaps()

    for y = 1, self.tileHeight do
        table.insert(self.baseLayer.tiles, {})

        for x = 1, self.tileWidth do
            local id = TILE_IDS['grass'][math.random(#TILE_IDS['grass'])]

            table.insert(self.baseLayer.tiles[y], Tile(x, y, id))
        end
    end

    for y = 1, self.tileHeight do
        table.insert(self.grassLayer.tiles, {})
        table.insert(self.halfGrassLayer.tiles, {})

        for x = 1, self.tileWidth do
            local id = y > 10 and TILE_IDS['tall-grass'] or TILE_IDS['empty']

            table.insert(self.grassLayer.tiles[y], Tile(x, y, id))
        end
    end
end

function Level:update(dt)
    self.player:update(dt)
end

function Level:render()
    self.baseLayer:render()
    self.grassLayer:render()
    self.player:render()
end