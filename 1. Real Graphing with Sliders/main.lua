-- A simple way to visualize graphing numbers
-- This is to accompany the complex graphing system
-- by thearst3rd

function math.round( value )
	return value % 1 >= .5 and math.ceil( value ) or math.floor( value )
end


function love.load()
	
	-- Create table for the input plane
	inputSpace = {}
	
	-- Data for displaying on screen
	inputSpace.x1 = 150
	inputSpace.y = 200
	inputSpace.w = 400
	inputSpace.x2 = inputSpace.x1 + inputSpace.w
	inputSpace.tickSize = 10 	-- Ticks will be 2x this length - this length is in each direction
	
	-- Actual properties of graph
	inputSpace.min = -5
	inputSpace.max = 5
	inputSpace.step = 1
	
	-- Create table for the input plane
	inputSpace2 = {}
	
	-- Data for displaying on screen
	inputSpace2.x1 = 730
	inputSpace2.y = 200
	inputSpace2.w = 400
	inputSpace2.x2 = inputSpace2.x1 + inputSpace2.w
	inputSpace2.tickSize = 10 	-- Ticks will be 2x this length - this length is in each direction
	
	-- Actual properties of graph
	inputSpace2.min = -5
	inputSpace2.max = 5
	inputSpace2.step = 1
	
	
	-- Create table for the output plane
	outputSpace = {}
	
	-- Data for displaying on screen
	outputSpace.x1 = 340
	outputSpace.y = 600
	outputSpace.w = 600
	outputSpace.x2 = outputSpace.x1 + outputSpace.w
	outputSpace.tickSize = 10 	-- Ticks will be 2x this length - this length is in each direction
	
	-- Actual properties of graph
	outputSpace.min = -4
	outputSpace.max = 16
	outputSpace.step = 2
	
	
	-- These are the actual input and output points we will use
	input = 1
	input2 = 2
	output = 0
	
	-- #### PROGRAM SPECIFIC STUFFFFF ####
	font24 = love.graphics.newFont( 24 )
	font32 = love.graphics.newFont( 32 )
	font82 = love.graphics.newFont( 82 )
	totalTime = 0
	
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
	
	-- Draw axis
	love.graphics.line( space.x1, space.y, space.x2, space.y )
	love.graphics.printf( space.min, space.x1 - 110, space.y - font24:getHeight()/2, 100, "right" )
	love.graphics.printf( space.max, space.x2 + 10, space.y - font24:getHeight()/2, 100, "left" )
	
	-- Draw bigger 0 Tick
	love.graphics.setLineWidth( 3 )
	if inRange( 0, space.min, space.max ) then
		love.graphics.line( rangeConvert( 0, space.min, space.max, space.x1, space.x2 ), space.y - space.tickSize*1.75, rangeConvert( 0, space.min, space.max, space.x1, space.x2 ), space.y + space.tickSize*1.75 )
	end
	
	-- Draw ticks
	love.graphics.setLineWidth( 1 )
	local start = space.step
	while not inRange( start, space.min, space.max ) and start <= space.max do start = start + space.step end
	for i=start, space.max-( space.max % space.step == 0 and space.step or 0 ), space.step do
		love.graphics.line( rangeConvert( i, space.min, space.max, space.x1, space.x2 ), space.y - space.tickSize, rangeConvert( i, space.min, space.max, space.x1, space.x2 ), space.y + space.tickSize )
	end
	local start = -space.step
	while not inRange( start, space.min, space.max ) and start >= space.max do start = start - space.step end
	for i=start, space.min+( space.min % space.step == 0 and space.step or 0 ), -space.step do
		love.graphics.line( rangeConvert( i, space.min, space.max, space.x1, space.x2 ), space.y - space.tickSize, rangeConvert( i, space.min, space.max, space.x1, space.x2 ), space.y + space.tickSize )
	end

	-- Draw Arrows
	love.graphics.line( space.x1, space.y, space.x1+space.tickSize, space.y+space.tickSize )
	love.graphics.line( space.x1, space.y, space.x1+space.tickSize, space.y-space.tickSize )
	love.graphics.line( space.x2, space.y, space.x2-space.tickSize, space.y+space.tickSize )
	love.graphics.line( space.x2, space.y, space.x2-space.tickSize, space.y-space.tickSize )
	
	-- Draw point
	if inRange( point, space.min, space.max ) then
		love.graphics.circle( "fill", rangeConvert( point, space.min, space.max, space.x1, space.x2 ), space.y, 6 )
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
	
	local addX = rangeConvert( snapAmount, 0, inputSpace.max - inputSpace.min, 0, inputSpace.w ) - 1
	if inRange( mx, inputSpace.x1 - addX, inputSpace.x2 + addX ) and inRange( my, inputSpace.y - 20, inputSpace.y + 20 ) and md then
		input = ( rangeConvert( mx, inputSpace.x1, inputSpace.x2, inputSpace.min, inputSpace.max ) )
		if input - math.floor( input ) < snapAmount then input = math.floor( input )
		elseif input - math.floor( input ) > 1 - snapAmount then input = math.ceil( input ) end
	end
	local addX = rangeConvert( snapAmount, 0, inputSpace2.max - inputSpace2.min, 0, inputSpace2.w ) - 1
	if inRange( mx, inputSpace2.x1 - addX, inputSpace2.x2 + addX ) and inRange( my, inputSpace2.y - 20, inputSpace2.y + 20 ) and md then
		input2 = ( rangeConvert( mx, inputSpace2.x1, inputSpace2.x2, inputSpace2.min, inputSpace2.max ) )
		if input2 - math.floor( input2 ) < snapAmount then input2 = math.floor( input2 )
		elseif input2 - math.floor( input2 ) > 1 - snapAmount then input2 = math.ceil( input2 ) end
	end
	
	-- Gets rid of -0's
	if input == -0 then input = 0 end
	if input2 == -0 then input2 = 0 end
	
	output = input ^ input2
	
	totalTime = totalTime + dt
	
end

function love.draw()
	
	-- Print big headers
	love.graphics.setFont( font82 )
	love.graphics.printf( "INPUT", ( inputSpace.x1 + inputSpace2.x1 ) / 2, 16, inputSpace.w, "center" )
	love.graphics.printf( "OUTPUT", outputSpace.x1, 400, outputSpace.w, "center" )
	
	-- Print input and output values
	love.graphics.setFont( font32 )
	love.graphics.print( "x1 = " .. tostring( math.round( input*1000 ) / 1000 ), inputSpace.x1 + 10, inputSpace.y - 10 - font32:getHeight()*2 )
	love.graphics.print( "x2 = " .. tostring( math.round( input2*1000 ) / 1000 ), inputSpace2.x1 + 10, inputSpace2.y - 10 - font32:getHeight()*2 )
	love.graphics.print( "x1^x2 = " .. tostring( math.round( output*1000 ) / 1000 ), outputSpace.x1 + 10, outputSpace.y - 10 - font32:getHeight()*2 )
	
	-- Actually draw graphs
	drawGraph( input, inputSpace )
	drawGraph( input2, inputSpace2 )
	drawGraph( output, outputSpace )
	
end
