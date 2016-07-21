-- A simple library that allows for easy creation of click and drag sliders
-- Created by thearst3rd

-- This is the table that will hold the information of all the sliders
sliders = {}
sliderFont = love.graphics.newFont( 24 )

-- Some functions that will be used to ease the creation of the sliders

function inRange( val, low, up )
	if low > up then up, low = low, up end
	return val >= low and val <= up
end

function rangeConvert( x, r1Low, r1High, r2Low, r2High )
	return ( r2High - r2Low ) / ( r1High - r1Low ) * ( x - r1Low ) + r2Low
end

-- Creates a slider for further use. Returns slider ID
-- Arguments: x position, y position, width of slider, minimum value, maxiumum value,
-- starting value (0), step size of ticks (1), the snap amount (0.15) and the actual tick size (10 pixels)
function createSlider( x, y, width, min, max, default, step, snapAmount, tickSize )
	
	local slider = {}

	-- Create table for the input plane
	slider = {}

	-- Data for displaying on screen
	slider.x1 = x
	slider.y = y
	slider.w = width
	slider.x2 = x + width
	slider.tickSize = tickSize or 10 	-- Ticks will be 2x this length - this length is in each direction
	slider.step = step or 1
	slider.snapAmount = snapAmount or 0.15

	-- Actual properties of graph
	slider.min = min
	slider.max = max
	
	-- This is the stored value for the slider
	slider.value = default or 0
	
	table.insert( sliders, slider )
	return #sliders
	
end

-- This actually processes the user input to the slider. MUST be somewhere in the love.update() loop to work.
function updateSliders()
	
	local mx, my = love.mouse.getPosition()
	local md = love.mouse.isDown( 1 )
	
	for _, slider in pairs( sliders ) do
		local addX = rangeConvert( slider.snapAmount, 0, slider.max - slider.min, 0, slider.w ) - 1
		
		if inRange( mx, slider.x1 - addX, slider.x2 + addX ) and inRange( my, slider.y - 20, slider.y + 20 ) and md then
			slider.value = ( rangeConvert( mx, slider.x1, slider.x2, slider.min, slider.max ) )
			if slider.value - math.floor( slider.value ) < slider.snapAmount then
				slider.value = math.floor( slider.value )
			elseif slider.value - math.floor( slider.value ) > 1 - slider.snapAmount then
				slider.value = math.ceil( slider.value )
			end
			if slider.value == -0 then slider.value = 0 end
		end
	end
	
end

-- This function draws all the sliders to the screen. MUST be in the love.draw() loop or else your sliders will be invisible >:D
function drawSliders()
	
	love.graphics.setFont( sliderFont )
	
	for _, slider in pairs( sliders ) do
		-- Draw axis
		love.graphics.line( slider.x1, slider.y, slider.x2, slider.y )
		love.graphics.printf( slider.min, slider.x1 - 110, slider.y - sliderFont:getHeight()/2, 100, "right" )
		love.graphics.printf( slider.max, slider.x2 + 10, slider.y - sliderFont:getHeight()/2, 100, "left" )
		
		-- Draw bigger 0 Tick
		love.graphics.setLineWidth( 3 )
		if inRange( 0, slider.min, slider.max ) then
			love.graphics.line( rangeConvert( 0, slider.min, slider.max, slider.x1, slider.x2 ), slider.y - slider.tickSize*1.75, rangeConvert( 0, slider.min, slider.max, slider.x1, slider.x2 ), slider.y + slider.tickSize*1.75 )
		end
		
		-- Draw ticks
		love.graphics.setLineWidth( 1 )
		local start = slider.step
		--print( "Pre ticks" )
		while not inRange( start, slider.min, slider.max ) and start <= slider.max do start = start + slider.step end
		for i=start, slider.max-( slider.max % slider.step == 0 and slider.step or 0 ), slider.step do
			love.graphics.line( rangeConvert( i, slider.min, slider.max, slider.x1, slider.x2 ), slider.y - slider.tickSize, rangeConvert( i, slider.min, slider.max, slider.x1, slider.x2 ), slider.y + slider.tickSize )
		end
		local start = -slider.step
		while not inRange( start, slider.min, slider.max ) and start >= slider.max do start = start - slider.step end
		for i=start, slider.min+( slider.min % slider.step == 0 and slider.step or 0 ), -slider.step do
			love.graphics.line( rangeConvert( i, slider.min, slider.max, slider.x1, slider.x2 ), slider.y - slider.tickSize, rangeConvert( i, slider.min, slider.max, slider.x1, slider.x2 ), slider.y + slider.tickSize )
		end
		--print( "Post ticks" )

		-- Draw Arrows
		love.graphics.line( slider.x1, slider.y, slider.x1+slider.tickSize, slider.y+slider.tickSize )
		love.graphics.line( slider.x1, slider.y, slider.x1+slider.tickSize, slider.y-slider.tickSize )
		love.graphics.line( slider.x2, slider.y, slider.x2-slider.tickSize, slider.y+slider.tickSize )
		love.graphics.line( slider.x2, slider.y, slider.x2-slider.tickSize, slider.y-slider.tickSize )
		
		-- Draw point at value
		if inRange( slider.value, slider.min, slider.max ) then
			love.graphics.circle( "fill", rangeConvert( slider.value, slider.min, slider.max, slider.x1, slider.x2 ), slider.y, 6 )
		end
	end
	
end

-- Gets the value of a specific slider
function getSlider( id )
	return sliders[id].value
end

-- Manually set the value of a specific slider
function setSlider( id, value )
	sliders[id].value = value
end