-- Very simple complex number library
-- by thearst3rd

-- Actual complex class
complex = {}
complex.__index = complex

-- ######## EXTEND SOME LUA FUNCTIONS AND TABLES ########

__type = type
function type( x )
	return getmetatable( x ) == complex and "complex" or __type( x )
end

math.i = setmetatable( { r=0, i=1 }, complex )
math.e = math.exp( 1 )

function math.round( n )
	return n%1 >= .5 and math.ceil( n ) or math.floor( n )
end

__math = {} 	-- Table for storing old math functions
__math.abs = math.abs
__math.sqrt = math.sqrt
__math.log = math.log
__math.sin = math.sin
__math.cos = math.cos
__math.sinh = math.sinh
__math.cosh = math.cosh


-- ######## NEW COMPLEX FUNCTIONS ########

function complex.isComplex( n )
	local t = type( n )
	return t == "number" or t == "complex" 	-- All real numbers are also complex, the i part is just 0
end

function complex.new( r, i )
	return setmetatable( { r=r or 0, i=i or 0 }, complex )
end

function complex.toComplex( z )
	assert( complex.isComplex( z ) )
	if type( z ) == "number" then return setmetatable( { r=z, i=0 }, complex ) end
	return z
end

function complex.real( z )
	z = complex.toComplex( z )
	return z.r
end

function complex.imag( z )
	z = complex.toComplex( z )
	return z.i
end


function complex.sqrt( z )
	z = complex.toComplex( z )
	return z^(1/2)
end
function math.sqrt( x )
	if type( x ) == "number" then return __math.sqrt( x ) end
	return complex.sqrt( x )
end


function complex.magnitude( z )
	z = complex.toComplex( z )
	return __math.sqrt( z.r^2 + z.i^2 )
end
function math.abs( x )
	if type( x ) == "number" then return __math.abs( x ) end
	return complex.magnitude( x )
end


function complex.angle( z )
	z = complex.toComplex( z )
	return math.atan2( z.i, z.r )
end

function complex.polar( z )
	z = complex.toComplex( z )
	return math.round( 1000 * complex.magnitude( z ) ) / 1000 .. " < " .. math.round( complex.angle( z ) * 180000 / math.pi ) / 1000 .. "°"
end


function complex.log( z )
	z = complex.toComplex( z )
	local r = complex.magnitude( z )
	local t = complex.angle( z )
	--return __math.log( r ) + math.i*t
	return setmetatable( { r = __math.log( r ), i = t }, complex )
end
function math.log( x )
	if type( x ) == "number" then return __math.log( x ) end
	return complex.log( x )
end


function complex.sin( z )
	z = complex.toComplex( z )
	--return __math.sin( z.r ) * __math.cosh( z.i ) + math.i * __math.cos( z.r ) * __math.sinh( z.i )
	return setmetatable( { r = __math.sin( z.r ) * __math.cosh( z.i ), i = __math.cos( z.r ) * __math.sinh( z.i ) }, complex )
end
function math.sin( x )
	if type( x ) == "number" then return __math.sin( x ) end
	return complex.sin( x )
end


function complex.cos( z )
	z = complex.toComplex( z )
	return setmetatable( { r = __math.cos( z.r ) * __math.cosh( z.i ), i = -__math.sin( z.r ) * __math.sinh( z.i ) }, complex )
end
function math.cos( x )
	if type( x ) == "number" then return __math.cos( x ) end
	return complex.cos( x )
end


function complex.sinh( z )
	z = complex.toComplex( z )
	return __math.sinh( z.r ) * __math.cos( z.i ) + math.i * __math.cosh( z.r ) * __math.sin( z.i )
end
function math.sinh( x )
	if type( x ) == "number" then return __math.sinh( x ) end
	return complex.sinh( x )
end


function complex.cosh( z )
	z = complex.toComplex( z )
	return __math.cosh( z.r ) * __math.cos( z.i ) + math.i * __math.sinh( z.r ) * __math.sin( z.i )
end
function math.cosh( x )
	if type( x ) == "number" then return __math.cosh( x ) end
	return complex.cosh( x )
end

-- ######## METATABLE FUNCTIONS ########

function complex.__tostring( zz )
	local s = ""
	local z = { r = math.round( 100000*zz.r ) / 100000, i = math.round( 100000*zz.i ) / 100000 }
	if z.r ~= 0 then
		s = s .. z.r
	end
	if z.i > 0 then
		s = s .. ( z.r ~= 0 and "+" or "" ) .. ( z.i ~= 1 and z.i or "" ) .. "i"
	elseif z.i < 0 then
		s = s .. ( z.i ~= -1 and z.i or "-" ) .. "i"
	end
	if s == "" then s = "0" end
	return s
end

function complex.__unm( z )
	return setmetatable( { r = -z.r, i = -z.i }, complex )
end

function complex.__add( z1, z2 )
	z1 = complex.toComplex( z1 )
	z2 = complex.toComplex( z2 )
	return setmetatable( { r=z1.r + z2.r, i=z1.i + z2.i }, complex )
end

function complex.__sub( z1, z2 )
	z1 = complex.toComplex( z1 )
	z2 = complex.toComplex( z2 )
	return setmetatable( { r=z1.r - z2.r, i=z1.i - z2.i }, complex )
end

function complex.__mul( z1, z2 )
	z1 = complex.toComplex( z1 )
	z2 = complex.toComplex( z2 )
	return setmetatable( { r = z1.r*z2.r - z1.i*z2.i, i=z1.r*z2.i + z1.i*z2.r }, complex )
end

function complex.__div( z1, z2 )
	z1 = complex.toComplex( z1 )
	z2 = complex.toComplex( z2 )
	return setmetatable( { r = (z1.r*z2.r + z1.i*z2.i) / (z2.r^2 + z2.i^2), i = (z1.r*z2.i + z1.i*z2.r) / (z2.r^2 + z2.i^2) }, complex )
end

function complex.__pow( z1, z2 )
	z1 = complex.toComplex( z1 )
	z2 = complex.toComplex( z2 )
	
	local r = complex.magnitude( z1 )
	local t = complex.angle( z1 )
	local c = z2.r
	local d = z2.i
	
	if r == 0 and complex.magnitude( z2 ) ~= 0 then return setmetatable( { r=0, i=0 }, complex ) end
	
	--return r^c * math.e^( -d*t ) * ( __math.cos( d*__math.log( r ) + c*t ) + math.i*__math.sin( d*__math.log( r ) + c*t ) )
	local q = r^c * math.e^( -d*t )
	return setmetatable( { r = q * __math.cos( d*__math.log( r ) + c*t ), i = q * __math.sin( d*__math.log( r ) + c*t )}, complex )
end

function complex.__eq( z1, z2 )
	z1 = complex.toComplex( z1 )
	z2 = complex.toComplex( z2 )
	
	return z1.r == z2.r and z1.i == z2.i
end
