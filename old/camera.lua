
local camera = basic.prototype:new {
  __type = 'camera'
}

function camera:__init()
  self.target = false
  self.pos = basic.vector:new {}
  self.width = globals.width * globals.unit
  self.height = globals.height * globals.unit
  self.limits = {}
  self:set_limits(0, 0, globals.width, globals.height)
end

function camera:set_limits (x, y, w, h)
  self.limits.top = y * globals.unit
  self.limits.left = x * globals.unit
  self.limits.right = w * globals.unit - self.width
  self.limits.bottom = h * globals.unit - self.height
end

function camera:set_target (body)
  self.target = body
end

function camera:checklimits ()
  self.pos.x = math.min(math.max(self.pos.x, self.limits.left), self.limits.right)
  self.pos.y = math.min(math.max(self.pos.y, self.limits.top), self.limits.bottom)
end

function camera:update()
  if self.target then
    local offset = basic.vector:new { self.width, self.height } / 2
    self.pos = self.target:get_pos() * globals.unit - offset
    self:checklimits()
  end
end

function camera:draw()
  if self.target then
    local translation = self.pos * -1
    translation:set(math.floor(.5 + translation.x), math.floor(.5 + translation.y))
    love.graphics.translate((translation):unpack())
  end
end

return camera
