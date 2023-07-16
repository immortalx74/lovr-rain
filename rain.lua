local rain = {}

math.randomseed( lovr.timer.getTime() )
local intensity = 4
local frequency = 0.05
local droplet_length = 0.05
local speed = 4
local pool_lifetime = 0.8
local expand_rate = 0.12

local function rand_real( a, b )
	return math.random() * (b - a) + a
end

function rain:new( position, size, ground )
	local obj = {}
	setmetatable( obj, { __index = self } )

	obj.position = lovr.math.newVec3( position )
	obj.size = lovr.math.newVec2( size )
	obj.ground = ground
	obj.time_last = lovr.timer.getTime()
	obj.time_elapsed = 0
	obj.droplets = {}
	obj.pools = {}

	return obj
end

function rain:draw( pass )
	pass:setColor( 0.1, 0.1, 0.1 )
	-- pass:plane( self.position, self.size, math.pi / 2, 1, 0, 0 )
	pass:setColor( 0.7, 0.7, 0.7 )

	local dt = lovr.timer.getDelta()
	local time_now = lovr.timer.getTime()

	local count = #self.droplets
	for i = count, 1, -1 do
		if self.droplets[ i ].y <= self.ground + droplet_length then
			self.droplets[ i ].y = self.ground
			local t = { position = self.droplets[ i ], time_started = time_now, radius = rand_real( 0.01, 0.03 ) }
			table.insert( self.pools, i, t )
			table.remove( self.droplets, i )
		else
			self.droplets[ i ].y = self.droplets[ i ].y - (speed * dt)
			local v2 = vec3( self.droplets[ i ].x, self.droplets[ i ].y - droplet_length, self.droplets[ i ].z )
			pass:line( self.droplets[ i ], v2 )
		end
	end

	local count = #self.pools
	for i = count, 1, -1 do
		if self.pools[ i ] then
			local col = 1 - self.pools[ i ].radius * 5
			pass:setColor( col, col, col )

			pass:circle( self.pools[ i ].position, self.pools[ i ].radius, quat( math.pi / 2, 1, 0, 0 ), "line" )
			self.pools[ i ].radius = self.pools[ i ].radius + (expand_rate * dt)
			if time_now > self.pools[ i ].time_started + pool_lifetime then
				table.remove( self.pools, i )
			end
		end
	end

	if self.time_elapsed >= frequency then
		for i = 1, intensity do
			self.time_elapsed = 0
			self.time_last = time_now
			local x = rand_real( self.position.x - (self.size.x / 2), self.position.x + (self.size.x / 2) )
			local y = rand_real( self.position.z + (self.size.y / 2), self.position.z - (self.size.y / 2) )
			table.insert( self.droplets, lovr.math.newVec3( x, self.position.y, y ) )
		end
	end

	self.time_elapsed = time_now - self.time_last
end

return rain
