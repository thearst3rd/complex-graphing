-- A simple way to visualize graphing numbers in the complex plane
-- by thearst3rd

require( "complex" )

function love.load()
	
	-- Create table for the input plane
	inputSpace = {}
	
	--snapAmount = .15
	
	-- Data for displaying on screen
	inputSpace.x1 = 50
	inputSpace.y1 = 300
	inputSpace.w = 300
	inputSpace.h = 300
	inputSpace.x2 = inputSpace.x1 + inputSpace.w
	inputSpace.y2 = inputSpace.y1 + inputSpace.h
	inputSpace.tickSize = 10 	-- Ticks will be 2x this length - this length is in each direction
	
	-- Actual properties of graph
	inputSpace.rMin = -5
	inputSpace.rMax = 5
	inputSpace.rStep = 1
	inputSpace.iMin = -5
	inputSpace.iMax = 5
	inputSpace.iStep = 1
	
	-- Create table for the second input plane
	inputSpace2 = {}
	
	-- Data for displaying on screen
	inputSpace2.x1 = 420
	inputSpace2.y1 = 300
	inputSpace2.w = 300
	inputSpace2.h = 300
	inputSpace2.x2 = inputSpace2.x1 + inputSpace2.w
	inputSpace2.y2 = inputSpace2.y1 + inputSpace2.h
	inputSpace2.tickSize = 10 	-- Ticks will be 2x this length - this length is in each direction
	
	-- Actual properties of graph
	inputSpace2.rMin = -5
	inputSpace2.rMax = 5
	inputSpace2.rStep = 1
	inputSpace2.iMin = -5
	inputSpace2.iMax = 5
	inputSpace2.iStep = 1
	
	
	-- Create table for the output plane
	outputSpace = {}
	
	-- Data for displaying on screen
	outputSpace.x1 = 800
	outputSpace.y1 = 250
	outputSpace.w = 400
	outputSpace.h = 400
	outputSpace.x2 = outputSpace.x1 + outputSpace.w
	outputSpace.y2 = outputSpace.y1 + outputSpace.h
	outputSpace.tickSize = 10 	-- Ticks will be 2x this length - this length is in each direction
	
	-- Actual properties of graph
	outputSpace.rMin = -8
	outputSpace.rMax = 8
	outputSpace.rStep = 1
	outputSpace.iMin = -8
	outputSpace.iMax = 8
	outputSpace.iStep = 1
	
	
	-- These are the actual input and output points we will use
	input = 1*math.i
	input2 = 2 + math.i*0
	output = 0*math.i
	
	-- #### PROGRAM SPECIFIC STUFFFFF ####
	font24 = love.graphics.newFont( 24 )
	font32 = love.graphics.newFont( 32 )
	font82 = love.graphics.newFont( 82 )
	totalTime = 0
	
	polarCoords = true
	
end


function inRange( val, low, up )
	if low > up then up, low = low, up end
	return val >= low and val <= up
end

function rangeConvert( x, r1Low, r1High, r2Low, r2High )
	return ( r2High - r2Low ) / ( r1High - r1Low ) * ( x - r1Low ) + r2Low
end

function drawGraph( point, space )
	
	love.graphics.setFont( font24 )
	local xx, yy
	
	-- Draw main rectangle
	love.graphics.rectangle( "line", space.x1, space.y1, space.w, space.h )
	
	-- Draw imaginary axis
	if inRange( 0, space.rMin, space.rMax ) then
		xx = rangeConvert( 0, space.rMin, space.rMax, space.x1, space.x2 )
		love.graphics.line( xx, space.y1, xx, space.y2 )
	else
		xx = 0 > space.rMax and space.x2 or space.x1
	end
	love.graphics.printf( space.iMax .. "i", xx-100, space.y1 - 10 - font24:getHeight(), 200, "center" )
	love.graphics.printf( space.iMin .. "i", xx-100, space.y2 + 10, 200, "center" )
	
	-- Draw real axis
	if inRange( 0, space.iMin, space.iMax ) then
		yy = rangeConvert( 0, space.iMax, space.iMin, space.y1, space.y2 )
		love.graphics.line( space.x1, yy, space.x2, yy )
	else
		yy = 0 > space.iMax and space.x1 or space.x2
	end
	love.graphics.printf( space.rMin, space.x1 - 110, yy - font24:getHeight()/2, 100, "right" )
	love.graphics.printf( space.rMax, space.x2 + 10, yy - font24:getHeight()/2, 100, "left" )
	
	-- Draw ticks
	local start = space.iStep
	while not inRange( start, space.iMin, space.iMax ) and start <= space.iMax do start = start + space.iStep end
	for i=start, space.iMax-( space.iMax % space.iStep == 0 and space.iStep or 0 ), space.iStep do
		love.graphics.line( xx - space.tickSize, rangeConvert( i, space.iMin, space.iMax, space.y2, space.y1 ), xx + space.tickSize, rangeConvert( i, space.iMin, space.iMax, space.y2, space.y1 ) )
	end
	local start = -space.iStep
	while not inRange( start, space.iMin, space.iMax ) and start >= space.iMax do start = start - space.iStep end
	for i=start, space.iMin+( space.iMin % space.iStep == 0 and space.iStep or 0 ), -space.iStep do
		love.graphics.line( xx - space.tickSize, rangeConvert( i, space.iMin, space.iMax, space.y2, space.y1 ), xx + space.tickSize, rangeConvert( i, space.iMin, space.iMax, space.y2, space.y1 ) )
	end
	
	local start = space.rStep
	while not inRange( start, space.rMin, space.rMax ) and start <= space.rMax do start = start + space.rStep end
	for i=start, space.rMax-( space.rMax % space.rStep == 0 and space.rStep or 0 ), space.rStep do
		love.graphics.line( rangeConvert( i, space.rMin, space.rMax, space.x1, space.x2 ), yy - space.tickSize, rangeConvert( i, space.rMin, space.rMax, space.x1, space.x2 ), yy + space.tickSize )
	end
	local start = -space.rStep
	while not inRange( start, space.rMin, space.rMax ) and start >= space.rMax do start = start - space.rStep end
	for i=start, space.rMin+( space.rMin % space.rStep == 0 and space.rStep or 0 ), -space.rStep do
		love.graphics.line( rangeConvert( i, space.rMin, space.rMax, space.x1, space.x2 ), yy - space.tickSize, rangeConvert( i, space.rMin, space.rMax, space.x1, space.x2 ), yy + space.tickSize )
	end
	
	-- Draw point
	if inRange( point.r, space.rMin, space.rMax ) and inRange( point.i, space.iMin, space.iMax ) then
		love.graphics.circle( "fill", rangeConvert( point.r, space.rMin, space.rMax, space.x1, space.x2 ), rangeConvert( point.i, space.iMin, space.iMax, space.y2, space.y1 ), 6 )
	end
	
end

-- Function the complex number takes and spits out
--function f( z )
	--return z^2
--end

function love.update( dt )
	
	local mx, my = love.mouse.getPosition()
	local md = love.mouse.isDown( 1 )
	
	snapAmount = love.keyboard.isDown( "lalt" ) and 0 or 0.15
	
	local addX = rangeConvert( snapAmount, 0, inputSpace.rMax - inputSpace.rMin, 0, inputSpace.w )
	local addY = rangeConvert( snapAmount, 0, inputSpace.iMax - inputSpace.iMin, 0, inputSpace.h )
	if inRange( mx, inputSpace.x1 - addX, inputSpace.x2 + addX ) and inRange( my, inputSpace.y1 - addY, inputSpace.y2 + addY ) and md then
		input.r = ( rangeConvert( mx, inputSpace.x1, inputSpace.x2, inputSpace.rMin, inputSpace.rMax ) )
		if input.r - math.floor( input.r ) < snapAmount then input.r = math.floor( input.r )
		elseif input.r - math.floor( input.r ) > 1 - snapAmount then input.r = math.ceil( input.r ) end
		input.i = ( rangeConvert( my, inputSpace.y1, inputSpace.y2, inputSpace.iMax, inputSpace.iMin ) )
		if input.i - math.floor( input.i ) < snapAmount then input.i = math.floor( input.i )
		elseif input.i - math.floor( input.i ) > 1 - snapAmount then input.i = math.ceil( input.i ) end
	end
	local addX = rangeConvert( snapAmount, 0, inputSpace2.rMax - inputSpace2.rMin, 0, inputSpace2.w )
	local addY = rangeConvert( snapAmount, 0, inputSpace2.iMax - inputSpace2.iMin, 0, inputSpace2.h )
	if inRange( mx, inputSpace2.x1 - addX, inputSpace2.x2 + addX ) and inRange( my, inputSpace2.y1 - addY, inputSpace2.y2 + addY ) and md then
		input2.r = ( rangeConvert( mx, inputSpace2.x1, inputSpace2.x2, inputSpace2.rMin, inputSpace2.rMax ) )
		if input2.r - math.floor( input2.r ) < snapAmount then input2.r = math.floor( input2.r )
		elseif input2.r - math.floor( input2.r ) > 1 - snapAmount then input2.r = math.ceil( input2.r ) end
		input2.i = ( rangeConvert( my, inputSpace2.y1, inputSpace2.y2, inputSpace2.iMax, inputSpace2.iMin ) )
		if input2.i - math.floor( input2.i ) < snapAmount then input2.i = math.floor( input2.i )
		elseif input2.i - math.floor( input2.i ) > 1 - snapAmount then input2.i = math.ceil( input2.i ) end
	end
	
	-- Get rid of -0's, they're dumb
	if input.r == -0 then input.r = 0 end
	if input.i == -0 then input.i = 0 end
	if input2.r == -0 then input2.r = 0 end
	if input2.i == -0 then input2.i = 0 end
	
	output = input ^ input2
	
	totalTime = totalTime + dt
	
end

function love.draw()
	
	-- Print big headers
	love.graphics.setFont( font82 )
	love.graphics.printf( "INPUT", ( inputSpace.x1 + inputSpace2.x1 ) / 2, 16, inputSpace.w, "center" )
	love.graphics.printf( "OUTPUT", outputSpace.x1, 16, outputSpace.w, "center" )
	
	-- Print input and output values
	love.graphics.setFont( font32 )
	love.graphics.print( "z = " .. tostring( input ) .. ( polarCoords and "\n" .. input:polar() or "" ), inputSpace.x1 + 10, inputSpace.y1 - 10 - font32:getHeight()*3 )
	love.graphics.print( "w = " .. tostring( input2 ) .. ( polarCoords and "\n" .. input2:polar() or "" ), inputSpace2.x1 + 10, inputSpace2.y1 - 10 - font32:getHeight()*3 )
	love.graphics.print( "z^w = " .. tostring( output ) .. ( polarCoords and "\n" .. output:polar() or "" ), outputSpace.x1 + 10, outputSpace.y1 - 10 - font32:getHeight()*3 )
	
	-- Actually draw graphs
	drawGraph( input, inputSpace )
	drawGraph( input2, inputSpace2 )
	drawGraph( output, outputSpace )
	
end
