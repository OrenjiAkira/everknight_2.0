
local room = basic.prototype:new {
  16, 10, 0,
  __type = 'room'
}

function room:__init ()
  self.width, self.height = self[1], self[2]
  self.tilemap = basic.matrix:new { self[1] + 4, self[2] + 4, self[3] }
  self:generate()
end

function room:generate ()
  -- currently generates empty by default
  for i, j, tile in self.tilemap:iterate() do
    if i < 3 or j < 3 or i > self.tilemap:get_height() - 2 or j > self.tilemap:get_width() - 2 then
      self.tilemap:set(i, j, 2)
    else
      self.tilemap:set(i, j, 1)
    end
  end
  self:filter()
end

function room:filter ()
  local patterns = require 'database.tilesets.patterns'
  local action_queue = {}
  -- first we find patterns in the tiles
  for _,pattern in ipairs(patterns) do
    local list = patterns.from_pattern_to_action(self.tilemap, pattern)
    for _,action in ipairs(list) do
      table.insert(action_queue, action)
    end
  end
  -- then we resolve the patterns' matches results
  for _,action in ipairs(action_queue) do
    self.tilemap:set(action[1], action[2], action[3])
  end
end

function room:open (side, offset)
  local sides = {
    left  = 2,
    right = 2 + self.width + 1,
    up    = 2,
    down  = 2 + self.height + 1,
  }
  if side == 'up' or side == 'down' then
    offset = offset < self.width and offset or self.width - 1
    self.tilemap:set(sides[side],     2 + offset,     1)
    self.tilemap:set(sides[side],     2 + offset + 1, 1)
    self.tilemap:set(sides[side] + 1, 2 + offset,     1)
    self.tilemap:set(sides[side] + 1, 2 + offset + 1, 1)
    self.tilemap:set(sides[side] - 1, 2 + offset,     1)
    self.tilemap:set(sides[side] - 1, 2 + offset + 1, 1)
  elseif side == 'left' or side == 'right' then
    offset = offset < self.height and offset or self.height - 1
    self.tilemap:set(2 + offset,     sides[side],     1)
    self.tilemap:set(2 + offset + 1, sides[side],     1)
    self.tilemap:set(2 + offset,     sides[side] - 1, 1)
    self.tilemap:set(2 + offset + 1, sides[side] - 1, 1)
    self.tilemap:set(2 + offset,     sides[side] + 1, 1)
    self.tilemap:set(2 + offset + 1, sides[side] + 1, 1)
  end
  self:filter()
end

function room:__tostring ()
  local str = ''
  for i, row in self.tilemap:iteraterows() do
    local s = '['
    for j, tile in ipairs(row) do
      if tile == 1 then
        s = s .. ' '
      else
        s = s .. '#'
      end
      --s = s .. tile
      s = s .. ' '
    end
    s = s .. ']\n'
    str = str .. s
  end
  return str
end

return room
