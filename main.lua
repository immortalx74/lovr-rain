local rain = require "rain"
lovr.graphics.setBackgroundColor( 0.3, 0.4, 0.85 )

-- Create a new rain instance
-- First 2 parameters (position & size) define an imaginary plane where rain drops from.
-- Third parameter defines the ground's Y value. Set it a little higher than the actual ground to avoid z-fighting.
local r = rain:new( vec3( 0, 2, -1 ), vec2( 3.6, 3.6 ), 0.001 )

function lovr.draw( pass )
	pass:setColor( 0.2, 0.3, 0.5 )
	pass:plane( 0, 0, 0, 6, 6, math.pi / 2, 1, 0, 0 )
	r:draw( pass )
end
