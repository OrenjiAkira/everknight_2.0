
local player = module.entity:new {
  name = gamedata.name,
  __type = 'player'
}

function player:__init ()
  self.maxhp = 24
  self.locked = false
  self:unset_layer(2)
  self:set_layer(4)
end

function player:on_collision (somebody, h, v)
  if somebody:get_type() == 'monster' then
    if not somebody.invincible then
      local dmg = basic.dice.throw(2, somebody.attack)
      self:take_damage(dmg, somebody.pos)
    end
  elseif somebody:get_type() == 'collectable' or somebody:get_type() == 'money' then
    somebody:on_collision(self)
  elseif somebody:get_type() == 'obstacle' then
    self:stop(h, v)
  end
end

function player:on_death ()
  self:lock(2)
  basic.signal:emit('entity_slain', self)
  self.timer:after(1, function ()
    audio:silent()
    basic.signal:emit('gameover')
  end)
end

function player:lock (time)
  self.timer:after(time, function() self:unlock() end)
  self.locked = true
end

function player:unlock ()
  self.locked = false
end

function player:update ()
  module.entity.update(self) -- call entity update
  basic.signal:emit('check_player_position', self.pos)
end

function player:draw ()
  module.entity.draw(self) -- call entity draw
end

return player
