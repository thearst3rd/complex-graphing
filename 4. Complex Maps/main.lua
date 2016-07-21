-- A program that animates a complex map of a function
-- by thearst3rd

-- ####### CUSTOMIZABLE STUFF ####### --

rows = 25
columns = rows

xSize = 350
ySize = xSize

domain = 1 	-- Always a square
rMin = -domain
rMax = domain
iMin = -domain
iMax = domain

totalTime = 3

-- Function that the map will draw
function f( z )
	return z^2
end
local fz = "z²"

-- ###### REAL CODE ###### --

require( "complex" )

function inRange( val, low, up )
	if low > up then up, low = low, up end
	return val >= low and val <= up
end

function rangeConvert( x, r1Low, r1High, r2Low, r2High )
	return ( r2High - r2Low ) / ( r1High - r1Low ) * ( x - r1Low ) + r2Low
end

function love.load()
	
	global = {}
	
	inputPoints = {}
	outputPoints = {}
	
	global.rMin = rMin
	global.rMax = rMax
	global.iMin = iMin
	global.iMax = iMax
	
	global.x1 = love.graphics.getWidth()/2 - xSize/2
	global.y1 = love.graphics.getHeight()/2 - ySize/2
	global.w = xSize
	global.h = ySize
	global.x2 = global.x1 + global.w
	global.y2 = global.y1 + global.h
	
	for i = 1, rows do
		inputPoints[i] = {}
		outputPoints[i] = {}
		for ii = 1, columns do
			inputPoints[i][ii] = rangeConvert( ii, 1, columns, global.rMin, global.rMax ) + rangeConvert( i, 1, rows, global.iMin, global.iMax )*math.i
			--inputPoints[i][ii] = f( inputPoints[i][ii] )
			--inputPoints[i][ii] = math.e^(math.i*rangeConvert( ii, 1, columns, 0, 2*math.pi )) * rangeConvert( i, 1, rows, 0, domain )
			outputPoints[i][ii] = f( inputPoints[i][ii] )
		end
	end
	
	fontSmall = love.graphics.newFont( 24 )
	fontBig = love.graphics.newFont( 48 )
	
	elapsedTime = 0
	started = 0
	
end

function love.update( dt )
	
	if love.keyboard.isDown( "space" ) then
		started = 1
		--elapsedTime = totalTime
	end
	
	if love.keyboard.isDown( "backspace" ) then
		started = -1
	end
	
	if love.keyboard.isDown( "r" ) then
		started = 0
		elapsedTime = 0
	end
	
	if love.keyboard.isDown( "escape" ) then
		love.event.quit()
	end
	
	elapsedTime = elapsedTime + dt * started
	if not inRange( elapsedTime, 0, totalTime ) then
		elapsedTime = elapsedTime > totalTime and totalTime or 0
	end
	
	phase = ( 1 - math.cos( math.pi*elapsedTime / totalTime ) ) / 2
	--phase = elapsedTime / totalTime
	
end

function love.draw()
	
	love.graphics.setFont( fontBig )
	if fz then love.graphics.print( "f(z) = " .. fz .. ( false and "\n" .. tostring( phase ) or "" ), 10, 10 ) end
	-- [[
	--love.graphics.rectangle( "line", global.x1, global.y1, global.w, global.h )
	local xx, yy
	if inRange( 0, global.rMin, global.rMax ) then
		yy = rangeConvert( 0, global.iMin, global.iMax, global.y2, global.y1 )
		love.graphics.line( 0, yy, love.graphics.getWidth(), yy )
	else
		yy = 0 < global.rMin and global.y2 or global.y1
	end
	
	if inRange( 0, global.iMin, global.iMax ) then
		xx = rangeConvert( 0, global.rMin, global.rMax, global.x1, global.x2 )
		love.graphics.line( xx, 0, xx, love.graphics.getHeight() )
	else
		xx = 0 < global.iMin and global.x1 or global.x2
	end
	love.graphics.line( global.x1, yy - 10, global.x1, yy + 10 )
	love.graphics.line( global.x2, yy - 10, global.x2, yy + 10 )
	love.graphics.line( xx - 10, global.y1, xx + 10, global.y1 )
	love.graphics.line( xx - 10, global.y2, xx + 10, global.y2 )
	
	love.graphics.setFont( fontSmall )
	love.graphics.printf( math.round( 100000*global.rMin )/100000, global.x1 - 125, yy - fontSmall:getHeight(), 120, "right" )
	love.graphics.printf( math.round( 100000*global.rMax )/100000, global.x2 + 5, yy - fontSmall:getHeight(), 120, "left" )
	love.graphics.printf( tostring( global.iMax*math.i ), xx + 5, global.y1 - fontSmall:getHeight() - 5, 120, "left" )
	love.graphics.printf( tostring( global.iMin*math.i ), xx + 5, global.y2 + 5, 120, "left" )
	--]]
	
	for i = 1, rows do
		for ii = 1, columns do
			local inputPoint = inputPoints[i][ii]
			local outputPoint = outputPoints[i][ii]
			local real = ( 1 - phase ) * inputPoint.r + phase * outputPoint.r
			local imag = ( 1 - phase ) * inputPoint.i + phase * outputPoint.i
			local x = rangeConvert( real, global.rMin, global.rMax, global.x1, global.x2 )
			local y = rangeConvert( imag, global.iMin, global.iMax, global.y2, global.y1 )
			--[[
			if inputPoint == -1 + 0*math.i then
				love.graphics.circle( "fill", x, y, 4 )
			end
			--]]
			
			if i < rows then
				local inputPoint2 = inputPoints[i+1][ii]
				local outputPoint2 = outputPoints[i+1][ii]
				local r2 = ( 1 - phase ) * inputPoint2.r + phase * outputPoint2.r
				local i2 = ( 1 - phase ) * inputPoint2.i + phase * outputPoint2.i
				local x2 = rangeConvert( r2, global.rMin, global.rMax, global.x1, global.x2 )
				local y2 = rangeConvert( i2, global.iMin, global.iMax, global.y2, global.y1 )
				love.graphics.line( x, y, x2, y2 )
			end
			if ii < columns then
				local inputPoint2 = inputPoints[i][ii+1]
				local outputPoint2 = outputPoints[i][ii+1]
				local r2 = ( 1 - phase ) * inputPoint2.r + phase * outputPoint2.r
				local i2 = ( 1 - phase ) * inputPoint2.i + phase * outputPoint2.i
				local x2 = rangeConvert( r2, global.rMin, global.rMax, global.x1, global.x2 )
				local y2 = rangeConvert( i2, global.iMin, global.iMax, global.y2, global.y1 )
				love.graphics.line( x, y, x2, y2 )
			end
		end
	end
	
end
