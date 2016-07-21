-- A simple way to visualize graphing numbers
-- This is to accompany the complex graphing system
-- by thearst3rd

require "sliders"

function f( x )
	return x^2
end
local fx = "x²"


-- ##### PROGRAM BEGINS #####

function math.round( value )
	return value % 1 >= .5 and math.ceil( value ) or math.floor( value )
end

function math.sign( x )
	if x < 0 then return -1 end
	return 1
end

function nDeriv( f, x, h ) 	-- h is delta x value to use
	h = h or 0.0001
	return ( f( x+h ) - f( x ) ) / h
end

function fnInt( f, a, b, h )
	h = math.abs( h or 0.01 )
	local sum = 0
	local i = a
	
	if a > b then h = -h end
	
	while i * math.sign( h ) < b * math.sign( h ) do
		sum = sum + f( i ) * h
		i = i+h
	end 
	
	sum = sum + f( i-h ) * ( b-i ) 
	return sum
end

math.e = math.exp( 1 )


function love.load()
	
	-- Create table for the graph
	graph = {}
	
	-- Propertes of the graph's display on screen
	graph.x1 = 600
	graph.y1 = love.graphics.getHeight()/2 - 500/2
	graph.w = 500
	graph.h = 500
	graph.x2 = graph.x1 + graph.w
	graph.y2 = graph.y1 + graph.h
	
	-- Domain and range of graph
	graph.dMin = -5
	graph.dMax = 5
	graph.rMin = -5
	graph.rMax = 5
	
	-- Step size
	graph.dStep = 1
	graph.rStep = 1
	graph.tickSize = 10
	
	-- Create input sliders
	slider1 = createSlider( 100, 200, 400, -10, 10, -5, 1 )
	slider2 = createSlider( 100, 250, 400, -10, 10, 5, 1 )
	
	slider3 = createSlider( 100, 400, 400, -10, 10, -5, 1 )
	slider4 = createSlider( 100, 450, 400, -10, 10, 5, 1 )
	
	-- #### PROGRAM SPECIFIC STUFFFFF ####
	fontSm = love.graphics.newFont( 24 )
	fontMd = love.graphics.newFont( 32 )
	fontBg = love.graphics.newFont( 64 )
	
end

function drawGraph( space )
	
	love.graphics.setFont( fontSm )
	
	-- Draw boundaries
	love.graphics.setLineWidth( 2 )
	love.graphics.rectangle( "line", space.x1, space.y1, space.w, space.h )
	
	-- Draw axes
	local xx, yy
	if inRange( 0, space.rMin, space.rMax ) then
		yy = rangeConvert( 0, space.rMin, space.rMax, space.y2, space.y1 )
		love.graphics.line( space.x1, yy, space.x2, yy )
	else
		yy = 0 < space.rMin and space.y2 or space.y1
	end
	
	if inRange( 0, space.dMin, space.dMax ) then
		xx = rangeConvert( 0, space.dMin, space.dMax, space.x1, space.x2 )
		love.graphics.line( xx, space.y1, xx, space.y2 )
	else
		xx = 0 < space.dMin and space.x1 or space.x2
	end
	
	love.graphics.printf( space.dMin, space.x1 - 110, yy - fontSm:getHeight()/2, 100, "right" )
	love.graphics.printf( space.dMax, space.x2 + 10, yy - fontSm:getHeight()/2, 100, "left" )
	love.graphics.printf( space.rMin, xx-50, space.y2 + 3, 100, "center" )
	love.graphics.printf( space.rMax, xx-50, space.y1 - fontSm:getHeight() - 3, 100, "center" )
	
	-- Draw ticks
	love.graphics.setLineWidth( 1 )
	local start = space.dStep
	while not inRange( start, space.dMin, space.dMax ) and start <= space.dMax do start = start + space.dStep end
	for i=start, space.dMax-( space.dMax % space.dStep == 0 and space.dStep or 0 ), space.dStep do
		love.graphics.line( rangeConvert( i, space.dMin, space.dMax, space.x1, space.x2 ), yy - space.tickSize, rangeConvert( i, space.dMin, space.dMax, space.x1, space.x2 ), yy + space.tickSize )
	end
	local start = -space.dStep
	while not inRange( start, space.dMin, space.dMax ) and start >= space.dMax do start = start - space.dStep end
	for i=start, space.dMin+( space.dMin % space.dStep == 0 and space.dStep or 0 ), -space.dStep do
		love.graphics.line( rangeConvert( i, space.dMin, space.dMax, space.x1, space.x2 ), yy - space.tickSize, rangeConvert( i, space.dMin, space.dMax, space.x1, space.x2 ), yy + space.tickSize )
	end
	
	local start = space.rStep
	while not inRange( start, space.rMin, space.rMax ) and start <= space.rMax do start = start + space.rStep end
	for i=start, space.rMax-( space.rMax % space.rStep == 0 and space.rStep or 0 ), space.rStep do
		love.graphics.line( xx - space.tickSize, rangeConvert( i, space.rMin, space.rMax, space.y2, space.y1 ), xx + space.tickSize, rangeConvert( i, space.rMin, space.rMax, space.y2, space.y1 ) )
	end
	local start = -space.rStep
	while not inRange( start, space.rMin, space.rMax ) and start >= space.rMax do start = start - space.rStep end
	for i=start, space.rMin+( space.rMin % space.rStep == 0 and space.rStep or 0 ), -space.rStep do
		love.graphics.line( xx - space.tickSize, rangeConvert( i, space.rMin, space.rMax, space.y2, space.y1 ), xx + space.tickSize, rangeConvert( i, space.rMin, space.rMax, space.y2, space.y1 ) )
	end
	
end

function drawFunction( space, func )
	
	-- Draw function
	for i=space.x1, space.x2 do
		local x = rangeConvert( i, space.x1, space.x2, space.dMin, space.dMax )
		local y = func( x )
		if inRange( y, space.rMin, space.rMax ) then
			local yScreen = rangeConvert( y, space.rMin, space.rMax, space.y2, space.y1 )
			local xx = rangeConvert( i+1, space.x1, space.x2, space.dMin, space.dMax )
			local yy = func( xx )
			if inRange( yy, space.rMin, space.rMax ) then
				yyScreen = rangeConvert( yy, space.rMin, space.rMax, space.y2, space.y1 )
				love.graphics.line( i, yScreen, i+1, yyScreen )
			end
		end
	end
	
end

function love.update( dt )
	
	updateSliders()
	
	graph.dMin = getSlider( slider1 )
	graph.dMax = getSlider( slider2 )
	
	graph.rMin = getSlider( slider3 )
	graph.rMax = getSlider( slider4 )
	
end

function love.draw()
	
	-- Draw sliders
	drawSliders()
	
	-- Print big headers
	love.graphics.setFont( fontMd )
	love.graphics.print( "f(x) = " .. fx, 20, 10 )
	love.graphics.setColor( { 255, 0, 0 } )
	--[[ 	-- UNCOMMENT THIS TO SEE THE INTEGRAL OF THE FUNCTION
	love.graphics.print( "g(x) =     f(t) dt", 20, 70 )
	love.graphics.setFont( fontSm )
	love.graphics.print( " x\n\n0", 140, 47 )
	love.graphics.setFont( fontBg )
	love.graphics.print( "∫", 115, 47 )
	--]]
	--love.graphics.print( "g(x) = d/dx [f(x)]", 20, 60 ) 	-- UNCOMMENT THIS TO SEE THE DERIVATIVE OF THE FUNCTION
	
	-- Actually draw graph
	--drawFunction( graph, function( x ) return fnInt( f, 0, x ) end ) 	-- UNCOMMENT THIS LINE TO SEE THE INTEGRAL OF THE FUNCTION
	--drawFunction( graph, function( x ) return nDeriv( f, x ) end ) 	-- UNCOMMENT THIS LINE TO SEE THE DERIVATIVE OF THE FUNCTION
	love.graphics.setColor( { 255, 255, 255 } )
	drawFunction( graph, f )
	
	drawGraph( graph )
	
end
