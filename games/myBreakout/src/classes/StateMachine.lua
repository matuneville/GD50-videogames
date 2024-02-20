--[[
    ##### State Machine #####
    
    State Machine class for the states changes and functionality
    through the execution of the videogame
    
    ---------------------
    - Created by Neville
    - 2024
]]

StateMachine = Class{}

-- StateMachine constructor
--
function StateMachine:init(states)
	self.empty = {
		render = function() end,
		update = function() end,
		enter = function() end,
		exit = function() end
	}
	self.states = states or {} -- return states or nothing if nil
	self.current = self.empty
end

-- Change from self.current to stateName, with enterParams parammeters
-- 
function StateMachine:change(stateName, enterParams)
	assert(self.states[stateName]) -- state must exist!
	self.current:exit()
	self.current = self.states[stateName]()
	self.current:enter(enterParams)
end

-- Update game in new frame with deltatime
--
function StateMachine:update(dt)
	self.current:update(dt)
end

-- Render (draw) on screen the last update
--
function StateMachine:render()
	self.current:render()
end
